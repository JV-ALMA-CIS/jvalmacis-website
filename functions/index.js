// Cloud Functions for the JV ALMA C.I.S website (project alma-green-tech).
//
// askAlma — the website's "Ask ALMA" chat. Served on the site's own domain at
// /api/chat through a Firebase Hosting rewrite (see ../firebase.json).
//
// Before the first deploy (alma-green-tech must be on the Blaze plan):
//   firebase functions:secrets:set GEMINI_KEY --project alma-green-tech
//   firebase functions:secrets:set CHAT_IP_SALT --project alma-green-tech   (any long random string)
// Deploy:
//   firebase deploy --only functions,hosting --project alma-green-tech

"use strict";

const crypto = require("node:crypto");
const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

const chat = require("./chat");

initializeApp();

const GEMINI_KEY = defineSecret("GEMINI_KEY");
const CHAT_IP_SALT = defineSecret("CHAT_IP_SALT");

const MODEL = "gemini-2.5-flash";
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`;
const UPSTREAM_TIMEOUT_MS = 25000;

/** Rate-limit documents. Client access is denied by firestore.rules (no
 *  rule matches this collection); only this function (Admin SDK) uses it. */
const LIMITS_COLLECTION = "chatRateLimits";

function clientIp(req) {
  const forwarded = (req.headers["x-forwarded-for"] || "").split(",")[0].trim();
  return forwarded || req.ip || "unknown";
}

/**
 * Applies the per-visitor and site-wide limits in one transaction.
 * Returns null when allowed, or "visitor" / "daily" when a limit is hit.
 */
async function checkLimits(ipHash, now) {
  const db = getFirestore();
  const visitorRef = db.collection(LIMITS_COLLECTION).doc(`ip_${ipHash}`);
  const dailyRef = db.collection(LIMITS_COLLECTION).doc(`day_${chat.dayKey(now)}`);

  return db.runTransaction(async (tx) => {
    const [visitorSnap, dailySnap] = await Promise.all([tx.get(visitorRef), tx.get(dailyRef)]);

    const daily = dailySnap.exists ? dailySnap.get("count") || 0 : 0;
    if (daily >= chat.LIMITS.dailyRequests) return "daily";

    const visitor = chat.nextWindow(
      visitorSnap.exists ? visitorSnap.data() : null,
      now,
      chat.LIMITS.perVisitorRequests,
      chat.LIMITS.perVisitorWindowMs,
    );
    if (!visitor.allowed) return "visitor";

    // expireAt lets a Firestore TTL policy clean these documents up.
    tx.set(visitorRef, {
      ...visitor.next,
      expireAt: new Date(now + chat.LIMITS.perVisitorWindowMs),
    });
    tx.set(
      dailyRef,
      { count: FieldValue.increment(1), expireAt: new Date(now + 2 * 24 * 3600 * 1000) },
      { merge: true },
    );
    return null;
  });
}

async function callGemini(apiKey, body) {
  for (let attempt = 0; attempt < 2; attempt++) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), UPSTREAM_TIMEOUT_MS);
    try {
      const r = await fetch(GEMINI_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json", "x-goog-api-key": apiKey },
        body: JSON.stringify(body),
        signal: controller.signal,
      });
      if ((r.status === 429 || r.status === 503) && attempt === 0) {
        await new Promise((resolve) => setTimeout(resolve, 2000));
        continue;
      }
      const data = await r.json().catch(() => null);
      return { ok: r.ok, status: r.status, data };
    } finally {
      clearTimeout(timer);
    }
  }
  return { ok: false, status: 503, data: null };
}

exports.askAlma = onRequest(
  {
    region: "us-central1",
    secrets: [GEMINI_KEY, CHAT_IP_SALT],
    timeoutSeconds: 60,
    memory: "256MiB",
    maxInstances: 5,
    concurrency: 40,
  },
  async (req, res) => {
    const origin = req.headers.origin || "";
    if (origin && chat.isAllowedOrigin(origin)) {
      res.set("Access-Control-Allow-Origin", origin);
    }
    res.set("Vary", "Origin");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type");
    res.set("Cache-Control", "no-store");

    if (req.method === "OPTIONS") return res.status(204).send("");
    if (req.method !== "POST") return res.status(405).json({ error: "method_not_allowed" });
    if (!chat.isAllowedOrigin(origin)) return res.status(403).json({ error: "origin_not_allowed" });

    const input = chat.validateRequest(req.body);
    if (!input.ok) return res.status(400).json({ error: "invalid_request", message: input.error });

    const now = Date.now();
    const ipHash = crypto
      .createHash("sha256")
      .update(`${CHAT_IP_SALT.value()}:${clientIp(req)}`)
      .digest("hex")
      .slice(0, 32);

    try {
      const limited = await checkLimits(ipHash, now);
      if (limited === "visitor") return res.status(429).json({ error: "rate_limited" });
      if (limited === "daily") return res.status(503).json({ error: "daily_limit" });
    } catch (err) {
      logger.error("rate-limit check failed", { message: err.message });
      return res.status(503).json({ error: "unavailable" });
    }

    try {
      const result = await callGemini(GEMINI_KEY.value(), chat.buildGeminiRequest(input.message, input.history));
      const reply = result.ok ? chat.extractReply(result.data) : null;
      // Lengths only: visitors' questions are never written to the logs.
      logger.info("askAlma", {
        status: result.status,
        messageChars: input.message.length,
        historyTurns: input.history.length,
        replyChars: reply ? reply.length : 0,
      });
      if (!reply) return res.status(502).json({ error: "upstream_error" });
      return res.json({ reply });
    } catch (err) {
      logger.error("askAlma upstream failure", { message: err.message });
      return res.status(502).json({ error: "upstream_error" });
    }
  },
);
