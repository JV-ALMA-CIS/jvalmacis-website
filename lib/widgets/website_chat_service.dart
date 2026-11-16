// lib/widgets/website_chat_service.dart
//
// Client for the website's own chat endpoint, askAlma (functions/index.js),
// served on the site's domain at /api/chat. The assistant's instructions,
// the model and all limits live on the server; this client sends only the
// visitor's question and a short history.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Where the chat endpoint lives. Relative by default, so it resolves to
/// /api/chat on whichever domain served the site. Override for local
/// development, e.g. against the Functions emulator:
///   flutter run -d chrome --dart-define=CHAT_ENDPOINT=http://127.0.0.1:5001/alma-green-tech/us-central1/askAlma
const String _chatEndpoint = String.fromEnvironment('CHAT_ENDPOINT', defaultValue: '/api/chat');

/// Matches the server's history limit (functions/chat.js).
const int _maxHistoryTurns = 12;

const String _contactLine = 'Please email support@jvalmacis.co.ke or use the Contact page.';

// ─── Text cleanup ──────────────────────────────────────────────────────────

/// Turns the model's Markdown into plain text for the chat bubble: drops
/// bold/italic markers and heading hashes, turns list markers into bullets,
/// and collapses blank lines. Leaves URLs intact (the previous version
/// removed every "//", which broke links such as https://…).
String cleanAiResponse(String text) {
  if (text.isEmpty) return text;
  return text
      .replaceAll(RegExp(r'\*\*|__'), '')
      .replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '')
      .replaceAll(RegExp(r'^\s*[-*]\s+', multiLine: true), '• ')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

// ─── Data Model ────────────────────────────────────────────────────────────

class ChatMessage {
  final String role;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, String> toRequestTurn() => {
        'role': role == 'assistant' ? 'assistant' : 'user',
        'text': text,
      };
}

// ─── Service ───────────────────────────────────────────────────────────────

class WebsiteChatService {
  WebsiteChatService({http.Client? client, Uri? endpoint})
      : _client = client ?? http.Client(),
        _endpoint = endpoint ?? Uri.base.resolve(_chatEndpoint);

  final http.Client _client;
  final Uri _endpoint;

  /// Sends [userMessage] with the recent [history] and returns the reply,
  /// or a short explanation the visitor can act on when there is none.
  Future<String> sendMessage({
    required String userMessage,
    required List<ChatMessage> history,
  }) async {
    final recent = history.length > _maxHistoryTurns
        ? history.sublist(history.length - _maxHistoryTurns)
        : history;

    try {
      final res = await _client
          .post(
            _endpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': userMessage,
              'history': [for (final m in recent) m.toRequestTurn()],
            }),
          )
          .timeout(const Duration(seconds: 45));

      if (res.statusCode == 200) {
        final reply = (jsonDecode(res.body) as Map<String, dynamic>)['reply'];
        if (reply is String && reply.trim().isNotEmpty) return reply.trim();
      }
      return switch (res.statusCode) {
        429 => "You've asked a lot of questions in a short time. Please wait a few minutes "
            'and try again. $_contactLine',
        400 => 'Please keep your question under 500 characters and try again.',
        503 => 'The assistant is not available right now. $_contactLine',
        _ => "I couldn't get an answer just now. $_contactLine",
      };
    } on TimeoutException {
      return 'The assistant took too long to reply. $_contactLine';
    } catch (_) {
      return "I couldn't connect just now. $_contactLine";
    }
  }
}
