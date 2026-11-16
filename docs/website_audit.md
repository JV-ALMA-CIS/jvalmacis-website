# JV ALMA C.I.S Website — Existing-State Audit

| | |
|---|---|
| **Audit date** | 3 November 2026 |
| **Scope** | Source repository `jv_alma_cis` (branch `main`, commit `1657545`), local build output in `build/web`, Firebase configuration and security rules |
| **Type** | Analysis only. No application code, configuration, dependencies, assets or deployment settings were changed. |
| **Not covered** | Rendered site in a browser, live Firestore CMS content, Firebase console settings, the Cloud Run chat backend's source code, Google Analytics property, Play Store listings |

### How to read this report

- **Severity:** Critical, High, Medium or Low. *Critical* is reserved for issues that can cause harm now (security, legal, reputational), not for design preferences.
- **Confidence:**
  - **Confirmed:** established directly from code, config or a check that was run.
  - **Likely:** strongly implied by the code but not observed at runtime.
  - **Needs verification:** depends on facts outside the repository, such as live data, the console or the company's records.
- Findings have stable IDs (e.g. `SEC-1`) that the backlog in §12 refers to.
- **Defect / Strategic / Assumption** tags separate confirmed defects from recommendations and from things this audit had to assume.

### Important limitation: CMS content

The homepage hero, homepage CTA band, client logos, business-unit cards, navigation, contact details, footer tagline and logo are **loaded from Firestore at runtime**. The files `lib/admin/modules/*/…_model.dart` only hold the *fallback* defaults. If an administrator has edited content through the hidden admin portal, the live site may differ from what this report quotes. Every finding about those areas is marked *Needs verification* against the live site.

### Checks actually executed

| Check | Result |
|---|---|
| `flutter --version` | Flutter 3.44.8 stable, Dart 3.12.2 |
| `flutter analyze --no-pub` | **No issues found** |
| `flutter test --no-pub` | **1 test, passed** (`HomePage renders CMS fallback content and the nav drawer`) |
| `flutter pub outdated` | Read-only dependency report (see §6) |
| Static scans | Unimported Dart files, unused packages, asset references vs. files on disk, asset sizes, contents of the existing `build/web` |
| `git status` before/after | Clean before and after every check, so nothing in the project was modified |

No build, deploy, `pub get`/upgrade, migration or production call was performed. The site was **not** viewed in a browser, so visual and responsive findings come from the implementation and are marked accordingly.

---

## 1. Executive summary

The site is a Flutter **web** single-page application hosted on **Firebase Hosting** (project `alma-green-tech`, custom domain `www.jvalmacis.com` per `firebase.json` and `web/sitemap.xml`). The code is in better shape than its git history suggests. It has a coherent design-token layer (`lib/design/`), a small but sensible admin CMS behind Firebase Auth with an allow-list in the Firestore rules, CMS fallbacks so pages never render empty, a clean static analysis run and a passing smoke test.

The company's substance is genuinely strong and well documented on the deeper pages. There are named diplomatic and donor-funded projects (US Embassy, Italian, Portuguese and Swedish embassies, AICS/KVDA irrigation schemes), MoUs with KALRO and Moi University, NCA certificates, and four real software products with Play Store presence. **But the site does not present this well, and several issues need attention before any redesign:**

1. **Security (Critical):** the Firestore rules let anyone on the internet create documents in the `mail` collection. If the Trigger Email extension is active, as the contact form assumes, this makes the company's mail sender an **open email relay** (`SEC-1`). The contact form also injects visitor input unescaped into HTML email (`SEC-2`).
2. **The AI chat assistant has no company knowledge (High).** Its system prompt is a leftover placeholder ("Keep your full system prompt exactly as it was"). Visitors who ask about JV ALMA C.I.S get answers the model invents (`CHAT-1`). The backend is an unauthenticated public prompt endpoint (`CHAT-2`).
3. **The production web build ships 187 MB of outdated Android APKs** (`assets/apk/*.apk` from June 2025), and the deployable folder totals 262 MB (`PERF-1`).
4. **Privacy and consent (High):** Google Analytics loads on every visit with no consent mechanism. The Privacy Policy does not mention Google Analytics, the AI chat (data sent to Google Gemini) or the website contact form, even though the Cookies Policy says cookies are set "with your consent" (`LEGAL-1`). The Cookies Policy also contains a placeholder address, "P.O. Box 12345-00100" (`CONTENT-6`).
5. **Search visibility is very weak (High).** Every URL has the same title and description, there are no social-sharing or structured-data tags, the sitemap lists 3 of the 22 public routes and was last updated July 2025, and unknown URLs return a "404" page with HTTP 200 (`SEO-1`…`SEO-4`).
6. **Credibility claims need confirmation (High).** These include "ISO 9001:2015" (no ISO certificate is shown), "decades of experience" (the company was founded in 2017), "helping thousands of farmers", "native apps for iOS and Android" (only Play Store links exist), named-official testimonials from US Government staff, and government and corporate logos under "Our Valued Clients" (`CLAIM-1`…`CLAIM-4`).
7. **Positioning:** the homepage hero is a sentence fragment ("For Construction, Agribusiness, Oil & Gas Services, and IT Solutions") that never says *who* the company is or *what* it does for the visitor. The four digital products (Kilimo Mkononi, CoffeeCore, NyumbaSmart, AlmaWorks) sit two to three clicks deep and are not in the navigation (`POS-1`, `IA-1`).

None of these require a redesign to fix. The P0 items in §12 are small to medium pieces of work and should be done **before** redesign work starts, because some of them are live risks today.

---

## 2. Existing technology stack and architecture

### 2.1 Stack

| Layer | Technology | Evidence |
|---|---|---|
| Framework | Flutter (web target), Dart SDK `>=3.0.0 <4.0.0`; local toolchain Flutter 3.44.8 / Dart 3.12.2 | `pubspec.yaml`, `flutter --version` |
| State management | `flutter_riverpod` 2.6.1 (StreamProviders over Firestore) | `lib/admin/modules/*/…_provider.dart`, `lib/providers/chat_provider.dart` |
| Routing | Navigator 1.0 `onGenerateRoute` switch with path URL strategy | `lib/main.dart` |
| Backend services | Firebase Core, Auth (admin login), Cloud Firestore (CMS + contact submissions + mail queue), Storage (CMS images) | `pubspec.yaml`, `firestore.rules`, `storage.rules` |
| AI chat | Google Gemini via a Cloud Run proxy (`askgemini-…-uc.a.run.app`) | `lib/widgets/website_chat_service.dart:9` |
| Analytics | Google Analytics 4 via `gtag.js`, hard-coded in the HTML shell | `web/index.html` (head) |
| Fonts | `google_fonts`: Inter (theme), Poppins (footer), fetched at runtime | `lib/design/typography.dart`, `lib/widgets/footer.dart` |
| Icons | `lucide_icons_flutter`, custom `BrandIcons` | `lib/widgets/brand_icons.dart` |
| Hosting | Firebase Hosting, `public: build/web`, SPA rewrite `** → /index.html` | `firebase.json` |
| Version control | Git, remote `github.com/DeveloperJVKenya/JV-Alma-C.I.S`, 14 commits, all with generic messages ("All Changes Made") | `git log` |
| CI/CD | **None found** (no `.github/`, no workflow files). Deployment is manual (`firebase deploy`). | Repository root |

### 2.2 Directory structure

| Path | Purpose |
|---|---|
| `lib/main.dart` | App entry: Firebase init, `ProviderScope`, `MaterialApp` with `buildAppTheme()` and the route switch |
| `lib/pages/` | Top-level pages: home, about, business units, contact, news, careers, certificates, privacy, cookies, terms, delete-account, map |
| `lib/detail/{construction,agribusiness,oil,it}/` | Business-unit deep pages; `it/` holds product pages (CMMS/NyumbaSmart, AlmaWorks, CoffeeCore, Kilimo Mkononi landing/enterprise/education) |
| `lib/admin/` | **Admin CMS** (not mentioned in `CLAUDE.md`): auth gate, login, shell, editors for site settings, homepage and business units, image upload to Storage |
| `lib/design/` | Design tokens: `palette.dart`, `tokens.dart` (Space/Radii/Elevation/Motion), `typography.dart`, `app_theme.dart` |
| `lib/widgets/` | Mix of the newer token-based widgets (`app_buttons`, `app_card`, `section`, `reveal_on_scroll`, `hoverable`, `logo_marquee`, `cms_image`) and older widgets, several unused (see §6) |
| `web/` | HTML shell, manifest, `robots.txt`, `sitemap.xml`, icons |
| `assets/` | 394 MB on disk: images 16 MB, certificates 14 MB, news 1.7 MB, **videos 184 MB**, **apk 180 MB** |
| `test/widget_test.dart` | Single smoke test with CMS providers overridden |
| `y/` | Stray Firebase-init placeholder `index.html` / `404.html`, unused |
| `apk_archive/`, `lib.rar` | Archived APKs and a source archive, tracked in git |

### 2.3 Routing architecture

All routing lives in `lib/main.dart` (`onGenerateRoute` switch). `go_router` is a declared dependency but is not imported anywhere, and `lib/routing/router.dart` is empty. Navigation uses `Navigator.pushNamed` with route strings throughout the widgets. Unknown paths fall through to an unstyled `Scaffold` reading "404 - Page Not Found", with no header or footer.

### 2.4 Hosting and deployment (from repository config only)

- Firebase project `alma-green-tech` (`.firebaserc`). Firestore location `us-central1`.
- Hosting serves `build/web`. All paths rewrite to `/index.html`, so every URL, including nonexistent ones, returns HTTP 200.
- Cache headers: `index.html`, service worker and manifest set to no-store; JS/CSS/HTML set to `no-cache, must-revalidate`; `/assets/**` and fonts set to 1 year, immutable.
- Two redirects are configured: `fbclid` query stripping, and apex domain to `www`. See `HOST-1`: both are probably ineffective as written.
- Deployment is manual: `flutter build web` then `firebase deploy --only hosting`. There are no environment-specific configs (single Firebase project for everything).

### 2.5 External services and integrations

| Integration | Where | Notes |
|---|---|---|
| Firestore `siteSettings/main`, `homepage/main`, `businessUnits/*` | Public read, admin write | CMS content |
| Firestore `contacts` | Public create, admin read | Contact-form submissions |
| Firestore `mail` | **Public create** | Consumed by the Firebase "Trigger Email" extension (assumed from comments; extension config is not in the repo) |
| Firebase Storage | Public read, admin write | CMS images |
| Cloud Run `askgemini` | `website_chat_service.dart` | Gemini proxy; source code not in this repo |
| Google Analytics 4 | `web/index.html` | No custom events from the app |
| Google Play Store | CMMS, CoffeeCore, Kilimo Mkononi product pages | Outbound links `com.jvalmacis.cmms`, `com.jvalmacis.coffeecore`, `com.jvalmacis.kilimomkononi` |
| Google Maps | Contact page office cards | Outbound search URL |
| LinkedIn, Instagram | Footer, contact page, news page | X/Twitter URL exists in CMS settings but is not shown anywhere |
| External press | News page | Gourmet & Travel Magazine, ilPescara.it (Italian-language articles) |
| Unsplash | `lib/detail/config.dart` | **Hard-coded access key in an unused file** (see `SEC-5`) |

### 2.6 Documentation state

- `README.md` is the default Flutter template text.
- `CLAUDE.md` is useful but partly **out of date**. It says `lib/config.dart` exists (it does not) and that `main.dart` does not use `buildAppTheme()` (it now does). It also omits the entire `lib/admin/` CMS and the Firestore-driven content model.
- There are no architecture, deployment, CMS-operation or content-ownership documents.

---

## 3. Website sitemap and page inventory

### 3.1 Route map (from `lib/main.dart`)

```
/                          Home
├── /about                 About
├── /business-units        Business Units overview
│   ├── /construction-detail   Construction & Facility Management
│   │   └── /cmms              NyumbaSmart CMMS (product)
│   ├── /agribusiness          Agribusiness
│   │   ├── /kilimo-mkononi    (product, also linked from IT)
│   │   └── /coffee-core       (product, also linked from IT)
│   ├── /oil-gas               Oil & Gas Services (TIC East Africa)
│   └── /it-division           IT Division
│       ├── /alma-works        AlmaWorks (product)
│       ├── /cmms              NyumbaSmart CMMS
│       ├── /kilimo-mkononi    Kilimo Mkononi landing
│       │   ├── /kilimo-mkononi-enterprise
│       │   └── /kilimo-mkononi-education
│       └── /coffee-core       CoffeeCore
├── /news                  News & Updates
├── /careers               Careers
├── /certificates          Certificates & Compliance
├── /contact               Contact
├── /privacy-policy, /cookies, /terms, /delete-account   Legal
├── /map                   Unlinked; WebView map page (see TECH-3)
├── /portal-mgmt           Hidden admin CMS (Firebase Auth + admins allow-list)
└── *                      Unstyled 404 (HTTP 200)
```

### 3.2 Global elements

| Element | Implementation | Content (defaults) | Observations |
|---|---|---|---|
| Header | `lib/widgets/header.dart` (`AppScaffold`, `Header`, `AppDrawer`) | Logo (CMS or `assets/images/clients/jv.jpg`), nav items from CMS: Home, About Us, Business Units, News; "Contact Us" button. Careers and Contact appear in the drawer only. | Desktop at ≥1024 px, drawer below. No direct link to products, Certificates or Careers on desktop. The logo is a JPG kept in the `clients/` folder. |
| Mobile drawer | `AppDrawer` | All 6 nav items + "Contact Us" | Fine structurally. |
| Footer | `lib/widgets/footer.dart` | Logo, tagline, Quick Links (Business Units, Certificates, Careers), phone, email, both offices, LinkedIn, Instagram, legal links (Privacy, Cookies, Terms, Delete Account), back-to-top, copyright "© 2026" | Uses Poppins and hard-coded colours, unlike the token system. Shows a custom "hovered URL" overlay in the corner. |
| Chat widget | `WebsiteChatFab` in every `AppScaffold` | "ALMA Assistant · Online", 4 suggested questions | See `CHAT-1`…`CHAT-4`. |

### 3.3 Page inventory

| Route | Purpose | Current content | Primary action | Gaps |
|---|---|---|---|---|
| `/` | First impression, routing to units | Hero title (fragment) + "Contact Us"; 4 business-unit cards; "Our Valued Clients" logo marquee (KVDA, Sweden, Italy, USA, NAVFAC, Portugal, IADC, Total, ENI); CTA band "Ready to Collaborate?" | Contact Us | No company name or value proposition in the hero, no products, no proof points (projects, numbers), no news. The client strip mixes governments, agencies and companies with no context. |
| `/about` | Company story | "Our Story" (founded 2017, "in just seven years"), 4-step timeline (2017 construction, 2021 agribusiness, 2022 oil & gas, 2024 IT), Mission/Vision, 3 "Featured Work" image cards | None (no CTA) | No leadership/team, no legal entity details, no Italian heritage (which press coverage emphasises), no locations, no CTA. "Seven years" is out of date. |
| `/business-units` | Overview of divisions | Hero, 4 unit cards (CMS), "Why Choose Us" (4 generic claims incl. "Decades of experience") | Card click-through | Duplicates the homepage cards with longer text. No products, no projects. |
| `/construction-detail` | Construction & FM | Services (Construction Projects, Facility Management, CMMS Integration); 6 projects with client, period, description, testimonial and photos (US Embassy American Center, Rosslyn Ridge, US Medical Research Unit Kisumu, Italian Ambassador's residence, Portuguese Embassy consular section, Swedish Ambassador's residence); FM section linking to NyumbaSmart | Link to CMMS | The strongest credibility content on the site, but no CTA to request a quote/assessment. The URL slug is inconsistent (`-detail`). |
| `/agribusiness` | Agribusiness | Projects (Sigor Wei Wei/AICS–KVDA 2017–2020, Kapluk solar irrigation/AICS 2021–2023, Makueni/Greenland Farm, ENI technical services), capacity building, core services (soil health, data processing), KALRO and Moi University MoUs with named signatories, digitization links to Kilimo Mkononi and CoffeeCore | Product links | Strong content. No enquiry CTA for donors/NGOs/cooperatives. |
| `/oil-gas` | Oil & gas inspection | JV ALMA as shareholder with Brisma Africa in **TIC East Africa**; TIC group description (">500 employees"); services (inspection & integrity, NDE, regulatory compliance); certifications images; list of TIC subsidiaries in Tunisia, Gabon, Libya, Algeria, KSA with their phone numbers/emails | None for JV ALMA | The page mostly describes *another company's* group and contacts. The relationship (shareholding) is stated once and easy to miss. Visitors could read TIC's global presence and certifications as JV ALMA's (`CLAIM-3`). |
| `/it-division` | Software division | Intro, 4 product cards (AlmaWorks, NyumbaSmart, Kilimo Mkononi, CoffeeCore), technical capabilities (incl. "Native apps for iOS and Android"), CTA "Schedule a Demo" (→ /contact) and **"Request Info" (does nothing)** | Schedule a Demo | Stats block is commented out (10K+ users etc.). Custom software development as a *service* is not offered explicitly. |
| `/cmms` | NyumbaSmart product | Roles, features, security, screenshots, Play Store link | Get from Play Store | The product name appears as "NyumbaSmart - CMMS". The page is aimed at existing clients (the app needs JV Admin approval) rather than prospects. There is no "request a demo" option for facility owners. |
| `/alma-works` | AlmaWorks product | Roles, features, benefits; "currently used internally" | Contact Us | Honest positioning (internal tool), but the IT page presents it as a product. |
| `/coffee-core` | CoffeeCore | Roles, farmer benefits, features, Play Store link | Get from Play Store | No cooperative-facing enquiry path. |
| `/kilimo-mkononi` | Product landing | Enterprise vs Education cards (defined twice in code, for mobile/desktop), shared features, highlights | Explore edition | Typo "Filed Data input". |
| `/kilimo-mkononi-enterprise` | Enterprise edition | Features, description, Play Store link | Get from Play Store | — |
| `/kilimo-mkononi-education` | Education edition | Three-tier approval, quizzes, simulations; "Coming Soon to Schools" | Contact Us | Clear and honest status. |
| `/news` | News | 6 items. 4 internal items show a category instead of a date and open only an image dialog. 2 external Italian press articles (March 2026). Social follow block. | Open item | No article pages, dates or text, so nothing is indexable. Content is hard-coded (not in the CMS). |
| `/careers` | Recruitment | Intro, 3 core values, "No Open Positions at the Moment", CV to hr@jvalmacis.co.ke | Email CV | Not in the desktop header. Fine as an empty state. |
| `/certificates` | Compliance | Highlights (ISO 9001:2015, "Fully Compliant", "Internationally Recognized"); gallery of incorporation, KRA, business permit, NCA Building/Mechanical/Water certificates | View certificate | No ISO certificate in the gallery (`CLAIM-1`). One image is missing (`ASSET-1`). Duplicated titles for 2026/2028 versions. |
| `/privacy-policy` | Privacy | Kenya DPA 2019, ODPC registration (10 Mar 2026–10 Mar 2028), last updated 10 Jul 2026 | — | Focused on mobile apps. Does not cover website analytics, AI chat or the contact form (`LEGAL-1`). |
| `/cookies` | Cookies | Cookie categories, Firebase, in-app toggles | — | Placeholder P.O. Box (`CONTENT-6`). Implies consent that the website doesn't collect. |
| `/terms` | Terms | Version 1.0, Kenyan law | — | App-oriented. |
| `/delete-account` | Play Store deletion requirement | Email-based deletion process | Email support | Fine for Google Play policy purposes. |
| `/map` | Map | WebView-based map with empty address | — | Unlinked, probably broken on web (`TECH-3`). |
| `/portal-mgmt` | Admin CMS | Login → editors for Site settings, Homepage, Business units | — | Not linked publicly (intended). |

### 3.4 Exists in code vs. reachable by visitors

| Item | In code | Reachable |
|---|---|---|
| `/map` | Yes | Only by typing the URL; likely errors on web |
| `/portal-mgmt` | Yes | By URL only (intended); protected by auth + rules |
| Projects page / References page | Commented out in `main.dart` | No |
| IT stats block (4 / 8+ / 10K+ / 100%) | Commented out in `it_division_detail.dart` | No |
| `PageHero`, `Subsection`, `BusinessUnitSection`, `CustomButton`, `custom_widgets`, `home_page_helper_widgets` | Yes | No (never imported) |
| X/Twitter link | In CMS model | Not rendered |
| Video assets (`company_video.mp4` bundled; four more on disk) | Assets present | No widget plays video (`video_player` unused) |
| APK files | Bundled into the web build | Downloadable by direct URL (`/assets/assets/apk/*.apk`) |

### 3.5 Assets

- **Logos:** company logo `assets/images/clients/jv.jpg` (JPG, no transparency; lives in the clients folder). Client logos are JPGs in `assets/images/clients/`.
- **Photography:** real project photos for construction, agribusiness and TIC; screenshots for products. This authentic material is a major asset (`STRENGTH-3`).
- **Certificates:** JPGs in use, plus **unused PDFs** bundled into the build because the whole folder is registered.
- **Heavy files:** `company_background.jpg` 2.6 MB (homepage hero, the LCP image), `agribusiness/data_processing.jpg` 4.2 MB, `certificates/jv_certificate.jpg` 4.2 MB, `community_empowerment_2.jpg` 1.8 MB, `kra_certificate.jpg` 1.8 MB, `business_permit.jpg` 2.0 MB.
- **Icons:** `web/icons/Icon-*.png` exist but the manifest points every size at `web/jv.png` (192×192). `index.html` references `/favicon.ico`, which does not exist.

---

## 4. Current messaging and business positioning

### 4.1 How the company describes itself today

| Location | Self-description |
|---|---|
| `<meta name="description">` (`web/index.html`) | "Est. 2017, JV ALMA C.I.S (11–50 employees) drives agritech, CMMS, and construction across four business units, with HQ in Nairobi and a Mombasa branch." |
| Homepage hero (CMS default) | "For Construction, Agribusiness, Oil & Gas Services, and IT Solutions" |
| Footer tagline | "Leading provider of construction, agribusiness, oil & gas services, and IT solutions across East Africa." |
| About hero | "Building Africa's future through excellence in construction, agribusiness, oil & gas services, and information technology" |
| About story | "…trusted multi-sector company… In just seven years, we have established ourselves as a leader…" |
| Mission | "To deliver exceptional infrastructure, services, and digital solutions that drive sustainable development across East Africa." |
| External press (News) | An Italian company from Abruzzo/Pescara building a digital agribusiness development model in Kenya |

### 4.2 Findings

**POS-1 — The value proposition is not clear in the first few seconds**
- Severity: **High** · Confidence: Confirmed for defaults, *Needs verification* for live CMS content · Type: Strategic
- Evidence: `defaultHomepageContent.heroTitle` in `lib/admin/modules/homepage/homepage_model.dart`; `_hero()` in `lib/pages/home_page.dart` renders only the title and one button.
- Impact: The hero headline is a fragment with no subject: it names sectors but not the company, the audience or the outcome. There is no supporting sentence and no proof point. Enterprise and institutional visitors cannot tell within five seconds whether JV ALMA is a contractor, a consultancy, a software house or a holding company.
- Recommendation: Agree a one-sentence positioning statement (see Questions Q1–Q3), then rewrite the hero as headline + supporting line + two CTAs (e.g. "Explore our work" / "Talk to us"), with one proof line (e.g. diplomatic missions served, hectares irrigated), *once figures are confirmed*.

**POS-2 — The relationship between the business areas is not explained**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: Four sibling cards on `/` and `/business-units`. Kilimo Mkononi and CoffeeCore appear under both Agribusiness and IT. NyumbaSmart appears under both Construction and IT.
- Impact: The real story is that field experience in construction and agriculture produced the software products. That is a differentiator, but the site presents four disconnected silos. Visitors interested in AgriTech have to discover the products inside Agribusiness or IT on their own.
- Recommendation: Decide the structure (Q4). One option is "Services" (Construction & FM, Agribusiness & Irrigation, Oil & Gas Inspection, Software Development) plus "Products" (Kilimo Mkononi, CoffeeCore, NyumbaSmart, AlmaWorks). Another is an AgriTech-first structure. This is a company decision.

**POS-3 — Products, services, industries and projects are mixed together**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: Projects are embedded inside unit pages (`_projects` lists in `construction_detail.dart`, `agribusiness_detail.dart`). Featured Work on `/about` repeats three of them. There is no projects index and no industries view.
- Impact: The best evidence (named embassy and donor projects) is hard to find and cannot be linked or shared individually.
- Recommendation: Introduce a Projects/Case Studies section with one page per project (client, scope, period, outcome, photos, testimonial *where permitted*).

**POS-4 — "Custom software development" is not offered as a service**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: `lib/detail/it/it_division_detail.dart` describes in-house products and "technical capabilities" but has no services offer, engagement model or "build for you" CTA.
- Impact: If bespoke development is a business line (background brief), the site currently generates no leads for it.
- Recommendation: Confirm whether it is offered externally (Q6). If so, add a service page with typical engagements and a demo/consultation CTA.

**POS-5 — Inconsistent messaging and naming across pages**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect (content)
- Evidence:
  - Geography: "East Africa" (footer, mission), "Africa" (About hero), "Kenya" (meta).
  - Division name: "IT Division" / "IT Solutions" (About Featured Work) / "Digital Solutions" (tagline) / "Technology Solutions" (Careers).
  - Product names: "KilimoMkononi" vs "Kilimo Mkononi"; "CoffeeCore" vs "Coffee Core"; "NyumbaSmart - CMMS" vs "CMMS" (route `/cmms`).
  - Company name: "JV ALMA C.I.S" / "JV Alma CIS Kenya" (CMS `companyName`) / "JV ALMA C.I.S Kenya" (copyright) / "JV Almacis" (press).
  - Unit name: "Construction" (cards) vs "Construction & Facility Management" (detail page).
- Impact: Weakens brand recognition and search consistency, especially for product names people will search for.
- Recommendation: Create a short naming and terminology sheet (company legal name, display name, unit names, product names, geography) and apply it everywhere.

**POS-6 — The site addresses audiences only implicitly**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: Every CTA leads to the same generic `/contact`. There are no audience-specific entry points: embassies and diplomatic clients, donors/development agencies (AICS), cooperatives, facility owners, schools, oil & gas operators, partners/investors.
- Impact: High-value institutional visitors get no tailored path and no idea of what an engagement looks like.
- Recommendation: Define primary audiences (Q5) and give each a journey (see §8.2) with an appropriate CTA.

**POS-7 — The Oil & Gas page sells another company**
- Severity: **Medium** · Confidence: Confirmed (content) / *Needs verification* (relationship) · Type: Strategic
- Evidence: `lib/detail/oil/oil_gas_services_detail.dart`. JV ALMA is described as a shareholder with Brisma Africa in TIC East Africa. Most of the page covers TIC Group's services, certifications, "Our Global Presence" map and the contacts of foreign subsidiaries.
- Impact: Visitors may be unsure who they are contracting with. Sending enquiries to TIC's email addresses bypasses JV ALMA, and "Our" language could be read as JV ALMA claiming TIC's footprint.
- Recommendation: Clarify the commercial relationship (Q8). Then state it plainly ("JV ALMA C.I.S is a shareholder in TIC East Africa…"), keep TIC's credentials clearly attributed to TIC, and decide whose contact details enquiries should use.

### 4.3 Claims requiring confirmation

Do not remove or change these without input from the company. Each needs evidence or a rewording.

| ID | Claim | Location | Issue | Severity |
|---|---|---|---|---|
| CLAIM-1 | "ISO 9001:2015 — Quality Management System certified" | `lib/pages/certificates_page.dart:106` | No ISO certificate in the gallery or `assets/certificates/` | **High** |
| CLAIM-2 | "Decades of experience" / "decades of expertise" | `business_units_page.dart` (`_whyChooseUs`), `construction_detail.dart:63`, `oil_gas_services_detail.dart:65` | Contradicts "Founded in 2017". It may refer to founders' personal experience; if so, say that. | **High** |
| CLAIM-3 | TIC Group global presence, ">500 employees", certifications | `oil_gas_services_detail.dart` | Attributed to TIC, but displayed under JV ALMA branding and "Our" headings | Medium |
| CLAIM-4 | Named testimonials from US Government / NAVFAC / RPSO staff and embassy officials | `construction_detail.dart` (`_projects`) | Confirm written permission. US Government staff are often restricted from appearing to endorse contractors, and the "Our Valued Clients" strip uses government and agency marks (USA, NAVFAC, Sweden, Italy, Portugal, KVDA) and corporate logos (Total, ENI, IADC). | **High** |
| CLAIM-5 | Kilimo Mkononi "helping thousands of farmers across Kenya" | `it_division_detail.dart:51` | No supporting figure | Medium |
| CLAIM-6 | "Native apps for iOS and Android" | `it_division_detail.dart:88` | Only Play Store links exist; no App Store links | Medium |
| CLAIM-7 | "Leading provider", "a leader", "most trusted partner" | Footer tagline, About | Superlatives without evidence | Low |
| CLAIM-8 | Testimonial attributed to "Piergiorgio Di Carmine JV ALMA C.I.S." for the American Center project | `construction_detail.dart:132` | A self-quote presented as a client testimonial | Medium |
| CLAIM-9 | ODPC registration valid 10 Mar 2026 – 10 Mar 2028 | `privacy_policy_page.dart:53-55` | Verify the registration number and dates | Low |
| CLAIM-10 | "Fully Compliant — All regulatory requirements met" | `certificates_page.dart:117` | Absolute claim | Low |
| CLAIM-11 | 2018 "Ongoing" Rosslyn Ridge, 2024 "Ongoing" Italian residence | `construction_detail.dart` | Status may be out of date | Low |

---

## 5. Design and user-experience audit

> These findings come from source code, not a rendered inspection. Items marked *Likely* should be checked in a browser at 375 px, 768 px, 1024 px and 1440 px.

**UX-1 — Two design generations coexist**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect (consistency)
- Evidence:
  - Newer pages use `Palette`/`Space`/`AppCard`/`SectionWrapper`.
  - `lib/widgets/footer.dart` uses `GoogleFonts.poppins` and hard-coded hex colours, while the theme uses Inter (`lib/design/typography.dart`).
  - The codebase has 91 `Color(0x…)` literals and 22 viewport-relative sizes (`screenWidth * 0.x`).
  - Breakpoints differ: 600 (pages), 768/1024 (header), 640/1000 (card grids).
- Impact: Visible font mismatch between body and footer. Small layout jumps between breakpoints. Changes take longer to make.
- Recommendation: Finish migrating to tokens. Define one breakpoint set in `tokens.dart` and use one font family (or an intentional pairing documented in `typography.dart`).

**UX-2 — The homepage lacks depth and proof**
- Severity: **High** · Confidence: Confirmed · Type: Strategic
- Evidence: `home_page.dart` has five blocks: hero, units, logos, CTA band, footer.
- Impact: No projects, products, numbers, news or "how we work" content. Visitors must click into units to find any evidence.
- Recommendation: Add featured projects, a products band, key confirmed figures and latest news. Keep it short.

**IA-1 — Products are hidden in the information architecture**
- Severity: **High** · Confidence: Confirmed (defaults) · Type: Strategic
- Evidence: The CMS default navigation (`site_settings_model.dart`) has Home, About Us, Business Units, News (+ Careers, Contact in the drawer). Products are reached via Business Units → IT Division or Agribusiness → product.
- Impact: Kilimo Mkononi and CoffeeCore are the most distinctive offerings but take 2–3 clicks to reach. Careers and Certificates are not in the desktop header.
- Recommendation: Add a "Products" (or "Solutions") menu, possibly a dropdown for units and products. Add Certificates and Projects to the navigation or the About section.

**UX-3 — Dead or weak calls to action**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect
- Evidence:
  - `it_division_detail.dart:553-560`: "Request Info" has an empty `onPressed` with the comment `// Navigate to case studies or docs`.
  - About, Business Units, Construction, Agribusiness and Oil & Gas pages have no enquiry CTA.
  - Every CTA leads to the same generic form, which has no topic or unit selector.
- Impact: Lost enquiries, and a broken interaction on the IT page.
- Recommendation: Remove or wire up "Request Info". Add a contextual CTA at the end of every unit and product page, pre-selecting the topic on the contact form.

**UX-4 — Mission/Vision cards stay side by side on phones**
- Severity: **Low** · Confidence: Likely · Type: Defect
- Evidence: `about_page.dart` `_buildMissionVisionSection` always uses a `Row` with two `Expanded` children; only the gap changes on mobile.
- Impact: Two narrow cards (roughly 150 px wide each) on a 360 px phone. The text will wrap heavily.
- Recommendation: Stack the cards below 600 px, as other sections already do.

**UX-5 — The 404 experience**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect
- Evidence: `main.dart` `default:` case renders a bare `Scaffold` with an AppBar, no header, footer or links.
- Impact: Dead end. Mistyped or old URLs (e.g. from previous site versions or press links) lose the visitor.
- Recommendation: Use `AppScaffold` with search/nav suggestions, and see `SEO-3` for the HTTP status.

**UX-6 — Raw error text shown to visitors**
- Severity: **Low** · Confidence: Confirmed · Type: Defect
- Evidence: `header.dart`, `footer.dart` and `news_page.dart` show `SnackBar(content: Text('Navigation error: $e'))` / `'Could not launch $url'` / `'Error: $e'`.
- Impact: Technical exception text could be shown to visitors.
- Recommendation: Show friendly messages and log details.

**UX-7 — The News page offers no readable content**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: `news_page.dart` lines ~120-180. Four of six items have a category ("Project Highlight", "Partnership") in the date field. Tapping an internal item opens only an image dialog.
- Impact: The news section looks inactive and adds no SEO value. The two most recent items are in Italian with no English summary on site.
- Recommendation: Create dated article pages (title, date, summary, body, image, source), ideally managed in the CMS.

**UX-8 — Branding assets**
- Severity: **Low** · Confidence: Confirmed · Type: Defect
- Evidence: Logo is a JPG (`assets/images/clients/jv.jpg`); the manifest uses `jv.png` (192×192) for all four icon entries including 512×512 and maskable; `index.html` references a non-existent `/favicon.ico`; the purpose-made `web/icons/Icon-*.png` files are unused.
- Impact: Blurry or ill-fitting icons on install/share, a 404 for the favicon, and a logo with a background box on dark surfaces.
- Recommendation: Get a vector or transparent PNG logo from the company (Q12), and point the manifest at the correctly sized icons.

**A11Y-1 — Accessibility of a canvas-rendered site**
- Severity: **Medium** · Confidence: Likely / *Needs verification* · Type: Defect
- Evidence:
  - Flutter web renders to canvas. Accessibility relies on Flutter's semantics tree, which is enabled when assistive technology requests it.
  - Explicit `semanticLabel`s: 18; `Semantics(` widgets: 12 (10 of them on the Oil & Gas page).
  - Chat close button is a bare `GestureDetector` (`website_chat_widget.dart:468`) with no label or focus.
  - Nav items use `GestureDetector` inside `_NavItem` (`header.dart`). Keyboard focus/activation is not obvious.
  - Footer link colours (`#94A3B8` on dark) need contrast checking.
- Impact: Screen-reader and keyboard users may not be able to operate navigation or the chat, and text in images (certificates, news clippings) is not accessible.
- Recommendation: Run a Lighthouse/axe pass with semantics enabled. Make all interactive elements focusable buttons or links with labels. Check contrast ratios. Provide text alternatives for image-only content.

**A11Y-2 — Motion**
- Severity: **Low** · Confidence: Confirmed (positive) · Type: Strength
- Evidence: `Motion.reduced(context)` is respected in hero, nav, entrance animations.
- Recommendation: Keep this. Confirm the logo marquee also pauses under reduced motion.

---

## 6. Technical quality and maintainability

**Overall:** `flutter analyze` is clean and the smoke test passes. The CMS layer (models → providers → repositories) is clear and well commented. The main debt is leftover code, unused dependencies, bundled binaries and the lack of CI.

**TECH-1 — Unused code**
- Severity: **Low** · Confidence: Confirmed · Type: Defect (maintainability)
- Evidence: Never imported: `lib/routing/router.dart` (empty), `lib/detail/config.dart`, `lib/widgets/business_unit_section.dart`, `custom_button.dart`, `custom_widgets.dart`, `home_page_helper_widgets.dart`, `page_hero.dart`, `subsection.dart`. There are also two `ResponsiveUtils` classes (`lib/responsive_utils.dart`, `lib/widgets/responsive_utils.dart`) and commented-out routes and stats.
- Recommendation: Remove after confirming, or adopt `PageHero` (the unused token-based hero) to unify the many hand-built page heroes.

**TECH-2 — Unused and outdated dependencies**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect
- Evidence:
  - Unused (no imports): `go_router`, `fl_chart`, `flutter_map`, `latlong2`, `video_player`, `carousel_slider`, `flutter_animate`, `path_provider`, `logger`, `font_awesome_flutter`, `cupertino_icons`.
  - Behind by a major version (`flutter pub outdated`): `cloud_firestore` 5.6→7.1, `firebase_core` 3.15→5.1, `firebase_auth` 5.6→7.0, `firebase_storage` 12.4→14.0, `flutter_riverpod` 2.6→3.4, `file_picker` 10→13, `google_fonts` 6→9, `flutter_lints` 4→6.
- Impact: Larger dependency surface and slower builds. Unused packages don't add to the JS bundle after tree-shaking, but they do add maintenance and upgrade friction. The Firebase major versions will eventually stop receiving fixes.
- Recommendation: Remove unused packages first, then plan a separate, tested upgrade of the Firebase and Riverpod majors. Riverpod 3 has breaking API changes.

**TECH-3 — `/map` route is likely broken on web**
- Severity: **Low** · Confidence: Likely · Type: Defect
- Evidence: `lib/pages/map_page.dart` uses `webview_flutter` with WebKit/Android creation params and is routed with `address: ''`. There is no web WebView implementation dependency.
- Impact: The route is unlinked, but anyone who reaches it probably sees an error.
- Recommendation: Remove the route and page (the contact page already opens Google Maps), or replace it with an embedded map.

**TECH-4 — Hard-coded content outside the CMS**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: Projects, testimonials, news, certificates, careers, legal text and product pages are all `const` lists or strings in Dart. Only the homepage, site settings and business-unit cards are CMS-managed.
- Impact: Every content change needs a developer, a build and a deploy. This is a likely reason news and figures are out of date.
- Recommendation: Decide which content types the company will update itself (Q13), then extend the existing CMS pattern (it is a good one) to News, Projects and Careers first.

**TECH-5 — Single smoke test, no CI**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect (process)
- Evidence: `test/widget_test.dart` (1 test); no `.github/workflows`; generic commit messages.
- Impact: Regressions such as dead buttons, missing assets or broken routes are not caught automatically. Deployments cannot be traced to changes.
- Recommendation: Add a CI job running `flutter analyze`, `flutter test` and `flutter build web`. Add route smoke tests (every route renders), an asset-existence test, and a Firestore rules test with the emulator. Use descriptive commit messages.

**TECH-6 — Stale project documentation**
- Severity: **Low** · Confidence: Confirmed · Type: Defect
- Evidence: `CLAUDE.md` references a missing `lib/config.dart`, claims `buildAppTheme()` is unused (`main.dart` uses it), and omits `lib/admin/`. `README.md` is the template.
- Recommendation: Update both, and add a CMS operations note (how admins are created, seeding, image uploads).

**TECH-7 — Repository hygiene**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect
- Evidence:
  - Git object store is about **325 MB**.
  - Tracked binaries: `assets/apk/*.apk` (~187 MB), `apk_archive/*.apk` (duplicates), `assets/videos/*.mp4` (184 MB, including `oil_gas_video.mp4` at 133 MB), `lib.rar`.
  - Stray `y/` folder (Firebase init placeholders), `pglite-debug.log`, `flutter_run.log` in the root.
- Impact: Slow clones and pushes (GitHub warns at 50 MB and rejects files over 100 MB, so `oil_gas_video.mp4` may already be a problem on push). Risk of deploying stale binaries.
- Recommendation: Move APKs and source videos out of the repo (Play Store / object storage / Git LFS) and delete the strays. History rewriting is a separate, deliberate decision; *do not* do it as part of routine work.

**TECH-8 — Logging in production**
- Severity: **Low** · Confidence: Confirmed · Type: Defect
- Evidence: 37 `developer.log` calls (e.g. on every header and drawer build); `print` in `website_chat_service.dart`.
- Recommendation: Strip or gate them behind `kDebugMode`.

---

## 7. SEO, accessibility, performance and security observations

### 7.1 SEO

**SEO-1 — Every URL has the same title and description, and there are no sharing tags**
- Severity: **High** · Confidence: Confirmed · Type: Defect
- Evidence: `web/index.html` has one static `<title>JV ALMA C.I.S</title>` and one meta description. There is no route-specific title handling in Dart (no `Title` widget or `setApplicationSwitcherDescription`). There are no `og:*`, `twitter:*` or `<link rel="canonical">` tags.
- Impact: Links shared on LinkedIn or WhatsApp show no image and the same text for every page. Search results cannot distinguish pages.
- Recommendation: At minimum, set per-route document titles from Dart and add default Open Graph tags plus a share image to `index.html`. For real per-page metadata see `SEO-5`.

**SEO-2 — Sitemap is incomplete and stale**
- Severity: **High** · Confidence: Confirmed · Type: Defect
- Evidence: `web/sitemap.xml` lists `/`, `/contact`, `/careers` only, `lastmod 2025-07-22`. 19 other public routes are missing, including all business units and products.
- Recommendation: List all public routes and generate the sitemap at build time.

**SEO-3 — Soft 404s**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect
- Evidence: `firebase.json` rewrites `**` to `/index.html`, so every path returns HTTP 200, and Flutter then shows "404 - Page Not Found".
- Impact: Search engines may index junk URLs as duplicates of the homepage.
- Recommendation: Add a `noindex` meta for unknown routes, or restrict rewrites to known routes and serve a real `404.html`.

**SEO-4 — No structured data**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: No JSON-LD in `web/index.html`.
- Recommendation: Add `Organization` and `LocalBusiness` (Nairobi and Mombasa offices), and `SoftwareApplication` for the apps, once the company has confirmed the facts.

**SEO-5 — Canvas rendering limits indexability (architectural)**
- Severity: **High** · Confidence: Likely · Type: Strategic
- Evidence: Flutter web renders text to canvas with no HTML text content or `<noscript>` fallback in `index.html`. Google can execute JavaScript but sees no semantic headings or links, and other crawlers and link-preview bots see an empty page.
- Impact: This is the biggest structural limit on organic discovery for "irrigation contractor Kenya", "CMMS Kenya", "coffee cooperative app" and similar searches.
- Recommendation: This is the key architecture decision for the update (Q14). Options:
  - (a) Keep Flutter for the app-like parts and build marketing/content pages as static or SSR HTML (e.g. a static site generator), served from the same Firebase Hosting.
  - (b) Stay fully Flutter and add pre-rendered HTML snapshots or a `<noscript>` content layer per route.
  - (c) Accept the limitation.

  This audit recommends evaluating (a), but the decision depends on budget and team skills.

**SEO-6 — The `keywords` meta is ignored by major search engines**
- Severity: **Low** · Confidence: Confirmed · Type: Strategic
- Recommendation: No action needed. Put the effort into page content instead.

### 7.2 Performance

**PERF-1 — APKs and unused media are shipped in the web build**
- Severity: **High** · Confidence: Confirmed (local `build/web` inspected) · Type: Defect
- Evidence:
  - `pubspec.yaml` registers `assets/apk/` and `assets/videos/company_video.mp4`.
  - The current `build/web` is **262 MB** and contains `assets/assets/apk/CoffeeCore.apk` (94 MB), `KilimoMkononi.apk` (93 MB) and `company_video.mp4` (6.5 MB). Nothing plays the video.
  - Certificate PDFs (~4 MB) are bundled but unused.
- Impact:
  - Every deploy uploads about 190 MB of unused binaries.
  - **Outdated APKs (June 2025) are publicly downloadable by direct URL**, outside Play Store signing and update channels.
  - Firebase Hosting storage/bandwidth costs and possible policy concerns about hosting APKs.
  - These files are not downloaded by visitors unless requested, so page load is not directly affected.
- Recommendation: Move the 5 screenshot JPGs out of `assets/apk/` into an images folder, unregister the APKs, video and PDFs, rebuild, and confirm the APKs are gone from the deployed site. Check whether old APK URLs are linked anywhere externally.

**PERF-2 — Heavy images, no responsive variants**
- Severity: **Medium** · Confidence: Confirmed · Type: Defect
- Evidence: The hero image `company_background.jpg` is 2.6 MB. Several images are 1.8–4.2 MB (see §3.5). There are no WebP/AVIF files and no resolution variants.
- Impact: Slow first paint on Kenyan mobile networks; the hero is the largest contentful element.
- Recommendation: Re-encode to WebP at a maximum of ~1920 px (hero) and ~1200 px (content), targeting under 300 KB each. Use Flutter's resolution-aware asset variants.

**PERF-3 — Flutter web startup cost**
- Severity: **Medium** · Confidence: Likely · Type: Strategic
- Evidence: `main.dart.js` is 3.4 MB (before compression) plus the CanvasKit/Skwasm runtime. `main()` awaits `Firebase.initializeApp` before the first frame. Google Fonts are fetched at runtime from Google's servers. There is no loading indicator in `index.html`, so visitors see a blank white page while it loads.
- Recommendation: Add a branded loading placeholder in `index.html`, bundle the fonts locally, and measure with Lighthouse on a throttled mobile profile.

**PERF-4 — Caching**
- Severity: **Low** · Confidence: Confirmed · Type: Observation
- Evidence: Assets are cached for a year as immutable, but filenames are not content-hashed. A replaced image at the same path (e.g. a new certificate scan) may stay stale in browsers for up to a year.
- Recommendation: When replacing an asset, change its filename, or shorten the cache lifetime for `/assets/**`.

### 7.3 Security

> Firebase web API keys and project IDs in `lib/firebase_options.dart` are designed to be public and are **not** treated as secrets here. Security depends on the rules.

**SEC-1 — Open email relay through the `mail` collection**
- Severity: **Critical** · Confidence: Confirmed (rules) / *Needs verification* (that the Trigger Email extension is installed and these rules are deployed) · Type: Defect
- Evidence:
  - `firestore.rules`, `match /mail/{docId} { allow create: if true; }`, with no validation of `to`, `message`, size or sender.
  - `lib/pages/contact_page.dart` `_submitForm()` writes `{to: [...], message: {subject, html}, replyTo}` from the browser.
- Impact: Anyone can use the public Firebase config to write a `mail` document with **any recipients and any HTML body**. The extension will then send it through the company's SMTP account. This enables spam and phishing under the company's sending reputation, can get the domain blocklisted, and can cost money.
- Recommendation (P0):
  1. Stop writing `mail` documents from the client. Deny client create on `/mail`.
  2. Have a Cloud Function triggered on new `contacts` documents build the email server-side, with fixed recipients.
  3. Add schema and size validation for `contacts` in the rules.
  4. Enable App Check.
  5. Check the extension's send logs for abuse.

**SEC-2 — HTML injection into notification emails**
- Severity: **High** · Confidence: Confirmed · Type: Defect
- Evidence: `contact_page.dart` `_submitForm()` interpolates name, email, phone, subject and message into `emailHtml` without escaping.
- Impact: A submitter can insert links, images or misleading markup into the email staff receive, which can be used for phishing staff.
- Recommendation: This is resolved by `SEC-1`'s server-side email. Escape all fields there, or send plain text.

**SEC-3 — No spam/abuse protection on public writes**
- Severity: **High** · Confidence: Confirmed · Type: Defect
- Evidence: `contacts` allows `create: if true` with no field or size constraints. There is no App Check, CAPTCHA, honeypot or rate limit (grep found no `firebase_app_check` or reCAPTCHA).
- Impact: Spam floods, unbounded Firestore writes and storage cost.
- Recommendation: Enable App Check with reCAPTCHA Enterprise, use rules to validate keys, types and lengths, add a honeypot field, and rate-limit server-side.

**SEC-4 — Public AI endpoint (see CHAT-2)**
- Severity: **High** · Confidence: Likely

**SEC-5 — Hard-coded third-party key in source and git history**
- Severity: **Medium** · Confidence: Confirmed (non-placeholder value present; not printed here) / *Needs verification* (whether the key is still active) · Type: Defect
- Evidence: `lib/detail/config.dart` contains an Unsplash access key. The file is unused.
- Impact: The key is exposed in the repository and its history.
- Recommendation: Revoke or rotate the key in the Unsplash dashboard, then delete the file. Rotating is enough; history does not need rewriting once the key is revoked.

**SEC-6 — Admin portal hardening**
- Severity: **Low** · Confidence: Confirmed (design) / *Needs verification* (console settings) · Type: Strategic
- Evidence: `/portal-mgmt` uses email/password Firebase Auth. Access is controlled by `admins/{uid}` in the rules, which is correct, and the comments say so.
- Recommendation: Enable MFA for admin accounts, restrict authorized domains in Firebase Auth, and disable public self-sign-up if it is not needed.

**SEC-7 — Public documents**
- Severity: **Low** · Confidence: *Needs verification* · Type: Strategic
- Evidence: KRA tax compliance certificate, business permit and incorporation certificate are published at full resolution (`assets/certificates/`).
- Impact: These may expose the KRA PIN, registration numbers and signatures, which can help with impersonation or invoice fraud.
- Recommendation: Decide which documents to publish. Consider watermarked or reduced-resolution versions, or making some available on request.

### 7.4 Privacy, consent and analytics

**LEGAL-1 — Analytics without consent, and gaps in the policies**
- Severity: **High** · Confidence: Confirmed (implementation) / *Needs verification* (legal assessment, which should come from counsel) · Type: Defect
- Evidence:
  - `gtag.js` loads unconditionally in `web/index.html`.
  - There is no consent banner or code anywhere in `lib/`.
  - `privacy_policy_page.dart` has 0 mentions of Google Analytics, the chat assistant or Gemini.
  - `cookies_page.dart` says cookies are "placed on your device with your consent" and describes in-app (mobile) toggles only.
- Impact: Under the Kenya Data Protection Act 2019, the published policies do not match what the website actually does. The chat sends visitor messages to Google via a Cloud Run service with no notice.
- Recommendation: Add a consent banner that blocks analytics until accepted (or use Consent Mode). Update the policies to cover the website: analytics, AI chat processing and retention, contact-form data and recipients, cross-border transfer (Firestore is in `us-central1`). Add a short notice in the chat widget.

**ANALYTICS-1 — No conversion tracking**
- Severity: **Medium** · Confidence: Confirmed · Type: Strategic
- Evidence: There are no `gtag`/analytics calls from Dart. A single-page app with `pushNamed` records page views only if GA4 enhanced measurement catches history changes, which needs verification in GA.
- Impact: The company cannot measure enquiries, Play Store clicks, chat usage or which units attract interest.
- Recommendation: After consent is in place, track events for contact submit, Play Store clicks, CTA clicks and chat opened/sent.

### 7.5 AI chat assistant

**CHAT-1 — The system prompt is a placeholder**
- Severity: **High** · Confidence: Confirmed · Type: Defect
- Evidence: `lib/widgets/website_chat_service.dart`, `_systemPrompt` = `"You are ALMA, the official intelligent assistant for JV ALMA C.I.S... \n// (Keep your full system prompt exactly as it was)"`.
- Impact: The model has no facts about the company. Its answers about services, projects, prices, jobs or contact details will be **made up** and presented as official ("the official intelligent assistant"). This is a real reputational and legal risk.
- Recommendation (P0): Either disable the widget until fixed, or restore a reviewed system prompt that contains only company-approved facts and clear refusal and handover rules. Ideally keep the prompt server-side (see CHAT-2).

**CHAT-2 — Unauthenticated public prompt proxy**
- Severity: **High** · Confidence: Likely (backend source not in repo) · Type: Defect
- Evidence: The client posts `{prompt: <full text including system prompt>}` to `https://askgemini-…run.app` (`_callBackend`). The system prompt is assembled on the client, so the backend appears to accept arbitrary prompts.
- Impact: Anyone can use the endpoint as a free Gemini proxy, running up costs, and can override the "system prompt" from the client.
- Recommendation: Move the system prompt and conversation formatting server-side, accept only the user message and short history, add App Check/origin checks, rate limits and a budget alert. Review the Cloud Run service's own authentication settings.

**CHAT-3 — Response clean-up corrupts links**
- Severity: **Low** · Confidence: Confirmed · Type: Defect
- Evidence: `cleanAiResponse()` removes every `//` (`replaceAll(RegExp(r'/{2,}'), '')`), so "https://www.jvalmacis.com" becomes "https:www.jvalmacis.com". It also strips all `*` and `_`.
- Recommendation: Render a safe markdown subset instead of stripping.

**CHAT-4 — Always shows "Online"; no AI disclosure**
- Severity: **Low** · Confidence: Confirmed · Type: Defect
- Evidence: Static "JV ALMA C.I.S · Online" with a green dot (`website_chat_widget.dart:456`).
- Recommendation: State clearly that this is an AI assistant, add a privacy note, and offer a handover to email or the contact form.

### 7.6 Hosting

**HOST-1 — Redirect rules are probably ineffective**
- Severity: **Medium** · Confidence: *Needs verification* · Type: Defect
- Evidence: `firebase.json`.
  - `"source": "/:path*\\?fbclid=:fbclid"`: Firebase Hosting matches paths only, not query strings.
  - `"source": "https://jvalmacis.com{,/**}"`: sources are path patterns, not full URLs.
- Impact: The apex domain may not redirect to `www`, giving two hosts with the same content. The `fbclid` duplicates are not consolidated.
- Recommendation: Test with `curl -I https://jvalmacis.com/about` and a `?fbclid=` URL. Configure the apex→www redirect in the Firebase Hosting custom-domain settings (the supported way) and rely on canonical tags for query-string variants.

**HOST-2 — Single environment**
- Severity: **Low** · Confidence: Confirmed · Type: Strategic
- Evidence: One Firebase project (`alma-green-tech`) is used for the website and, judging by the policy text, the mobile apps' backend.
- Recommendation: Use a preview channel (`firebase hosting:channel:deploy`) for review before production. Consider whether the website CMS should share a project with app user data.

---

## 8. Existing features and integrations

### 8.1 Feature inventory

| Feature | Status | Notes |
|---|---|---|
| Multi-page marketing site with path URLs | Working | 22 public routes |
| Responsive header and drawer | Working (code) | 1024 px desktop threshold |
| CMS (site settings, homepage, business units) with fallbacks | Working (code); live use *needs verification* | Admin at `/portal-mgmt` |
| Image upload to Firebase Storage (admin) | Implemented | `image_upload_field.dart` |
| Contact form → Firestore + email | Implemented, **insecure** | SEC-1/2/3 |
| AI chat (Gemini) | Implemented, **misconfigured** | CHAT-1…4 |
| Google Analytics 4 | Page-level only | LEGAL-1, ANALYTICS-1 |
| Play Store deep links | Working (code) | CMMS, CoffeeCore, Kilimo Mkononi |
| Certificates gallery with viewer | Working apart from 1 missing image | ASSET-1 |
| News with external links | Partially working | UX-7 |
| Legal pages incl. account deletion | Present | App-oriented |
| Scroll-reveal animations, reduced-motion support | Working | Strength |
| Map page | Probably broken, unlinked | TECH-3 |

### 8.2 Primary visitor journeys

| Journey | Current path | Friction |
|---|---|---|
| Embassy/institutional client checking credibility | Home → Business Units → Construction → scroll to projects | No projects in the navigation. Certificates only in the footer. No "Request an assessment" CTA on the page. |
| Donor/development agency (e.g. irrigation programme) | Home → Agribusiness | Strong content, but no partnership CTA and no downloadable capability statement |
| Farmer/cooperative wanting an app | Home → Business Units → IT or Agribusiness → product → Play Store | Three or four steps. Products are not visible on the homepage. Swahili content is not offered (*question for the company*). |
| School interested in Kilimo Education | IT → Kilimo → Education → Contact | The generic form has no "school" context |
| Facility owner considering NyumbaSmart | Construction or IT → CMMS → Play Store | The app requires admin approval, so a prospect who installs it hits a wall. They need a "Request a demo" path. |
| Oil & gas operator | Business Units → Oil & Gas | Contacts point to TIC subsidiaries. Who to contact is unclear. |
| Job seeker | Footer/drawer → Careers | No openings; the email route is fine |
| Press/partner/investor | About / News | No leadership, company facts or press kit |

---

## 9. Missing, outdated, duplicated or uncertain content

| ID | Issue | Evidence | Severity | Confidence |
|---|---|---|---|---|
| CONTENT-1 | "In just seven years": 2017 + 7 = 2024; it is now 2026 | `about_page.dart` `_buildCompanyOverviewSection` | Medium | Confirmed |
| CONTENT-2 | No leadership/team section. The CEO is named only in MoU signatories and press. | `about_page.dart` | Medium | Confirmed |
| CONTENT-3 | News items without dates; latest internal news undated | `news_page.dart` | Medium | Confirmed |
| CONTENT-4 | Email addresses: the site shows `support@jvalmacis.co.ke`, the form sends to `hr@` and `info@jvalmacis.co.ke` (code comment: "← CHANGE TO HR'S ACTUAL EMAIL"), and the domain is `.com` for web vs `.co.ke` for email. Business enquiries going to HR is questionable. | `contact_page.dart` `_submitForm`, `site_settings_model.dart` | Medium | Confirmed / *Needs verification* for intent |
| CONTENT-5 | Phone: one number for everything; no per-office phone or WhatsApp | `site_settings_model.dart` | Low | Confirmed |
| CONTENT-6 | Placeholder address "P.O. Box 12345-00100" in the Cookies Policy | `cookies_page.dart:281` | **Medium** | Confirmed |
| CONTENT-7 | Typos and grammar: "Filed Data input" (`kilimo_mkononi_landing_page.dart:365`); "projects & Project Management" (`agribusiness_detail.dart:273`); "Customers trust us for. Characterize…" (`oil_gas_services_detail.dart:330`); "Renov," abbreviations in project titles; "Comprehensive solution across" (oil, line 65) | Various | Low | Confirmed |
| CONTENT-8 | Kilimo landing cards defined twice (mobile/desktop copies) and could drift | `kilimo_mkononi_landing_page.dart:107-198` | Low | Confirmed |
| CONTENT-9 | Featured Work card "US Embassy Renovation" vs project title "United States Embassy - American Center Renov" | `about_page.dart`, `construction_detail.dart` | Low | Confirmed |
| CONTENT-10 | Certificates: two "Mechanical Service Certificate" and two "Water Works Certificate" entries with identical titles (2026/2028 versions) | `certificates_page.dart:633-656` | Low | Confirmed |
| ASSET-1 | Missing file `assets/certificates/Building_Works_Certificate_2028.jpg` | `certificates_page.dart:652` | **Medium** | Confirmed |
| CONTENT-11 | Timeline says the IT Division was established in 2024, while the hidden stats block claims "8+ Years of Dev" | `about_page.dart`, `it_division_detail.dart` (commented) | Low | Confirmed |
| CONTENT-12 | No English summaries for the Italian press articles | `news_page.dart` | Low | Confirmed |
| CONTENT-13 | Legal pages are written for the mobile apps; the website itself (forms, chat, analytics) is barely covered | §7.4 | High | Confirmed |
| CONTENT-14 | Copyright text hard-coded "© 2026" in CMS default | `site_settings_model.dart` | Low | Confirmed |
| CONTENT-15 | Mombasa branch is listed, but no services are tied to it | `site_settings_model.dart` | Low | *Needs verification* |
| CONTENT-16 | No downloadable company profile or capability statement | Site-wide | Medium | Confirmed |
| CONTENT-17 | Sustainability, safety (HSE) and quality policies are referenced but not published | Site-wide | Low | Confirmed |

See also §4.3 (claims requiring confirmation).

---

## 10. Strengths worth preserving

| ID | Strength | Evidence |
|---|---|---|
| STRENGTH-1 | **Clean codebase baseline:** analyzer clean, a passing test, and clear and honest code comments | `flutter analyze`, `flutter test` |
| STRENGTH-2 | **Design-token system** (`Palette`, `Space`, `Radii`, `Motion`, `AppType`) with business-unit accent colours and reduced-motion support | `lib/design/` |
| STRENGTH-3 | **Authentic, specific credibility content:** named projects with clients, periods, scope, photos; MoUs with KALRO and Moi University; NCA certificates; real product screenshots | `construction_detail.dart`, `agribusiness_detail.dart`, `certificates_page.dart` |
| STRENGTH-4 | **Sound CMS architecture:** Firestore models with typed `fromMap`/`toMap`, seed-from-defaults, fallback-to-defaults so pages never render empty, and admin allow-list enforced in rules (not just UI) | `lib/admin/`, `firestore.rules` |
| STRENGTH-5 | **Honest product status:** "Coming soon" for Kilimo Education, "used internally" for AlmaWorks, empty-state careers copy | Product pages |
| STRENGTH-6 | **Legal groundwork:** DPA-referenced privacy policy, terms, Play-compliant account-deletion page | `lib/pages/*_page.dart` |
| STRENGTH-7 | **Sensible hosting cache headers** for the HTML shell and service worker | `firebase.json` |
| STRENGTH-8 | **Clear brand differentiator in the material:** field experience → software products, and Italian–Kenyan cooperation (press coverage) | News, agribusiness pages |

---

## 11. Risks and dependencies to consider before updating

1. **Live risks exist now.** SEC-1 (mail relay), CHAT-1 (fabricating assistant) and PERF-1 (public stale APKs) should be fixed before, and independently of, any redesign.
2. **CMS live data is unknown.** Export the current `siteSettings`, `homepage` and `businessUnits` documents before changing models. Schema changes must stay backward-compatible, or include a migration that is reviewed and run deliberately.
3. **Architecture decision first (SEO-5).** Whether marketing pages stay in Flutter or move to HTML-first changes the scope of everything downstream. Make this decision in Phase 3, before visual design starts.
4. **Shared Firebase project.** The website and mobile apps appear to share `alma-green-tech`. Rule changes (e.g. to `/mail`) may affect the apps if they also send mail through the same extension. **Check with the app developers before tightening rules.**
5. **The chat backend lives outside this repo.** Fixing CHAT-2 needs access to the Cloud Run service source and deployment.
6. **Third-party approvals.** Testimonials, client and government logos, and TIC content may need written permission (CLAIM-3, CLAIM-4). This can block launch if left late.
7. **Dependency upgrades** (Firebase majors, Riverpod 3) are breaking changes. Do them in a dedicated, tested step, not mixed with content and design work.
8. **Repository size.** The 133 MB video and APKs may block pushes to GitHub or slow CI. Resolve this before introducing CI.
9. **Content ownership.** Without named owners for news, projects and careers, the new site will go stale the same way the current one has.
10. **Legal review.** Policy updates (LEGAL-1) need a qualified reviewer familiar with the Kenya DPA. This audit does not give legal advice.

---

## 12. Prioritized recommendations and update-planning backlog

Effort: **S** = small (one focused change), **M** = medium (several files or coordination), **L** = large (cross-cutting or new capability). No hour estimates are given; there is not enough evidence to support them.

### P0 — Critical issues to address before release (and ideally now)

| # | Area | Outcome | Rationale | Affected | Dependencies | Effort | Acceptance criteria |
|---|---|---|---|---|---|---|---|
| P0-1 | Technical / Security | Clients can no longer send arbitrary email | SEC-1, SEC-2 | `firestore.rules`, `contact_page.dart`, new Cloud Function | Confirm Trigger Email extension config; check app usage of `/mail` (Risk 4) | M | Client `create` on `/mail` denied (emulator rules test); a contact submission still notifies the agreed inbox; user input is escaped; extension logs reviewed for past abuse |
| P0-2 | Technical / Security | Contact form protected from spam | SEC-3 | `firestore.rules`, `main.dart`, contact form | P0-1 | M | App Check enforced on Firestore; rules validate field set, types and max lengths; honeypot present; scripted bulk writes rejected |
| P0-3 | Feature fix | Chat gives only approved answers, or is hidden | CHAT-1, CHAT-2 | `website_chat_service.dart`, Cloud Run service | Company supplies approved facts (Q15); access to backend | M | System prompt server-side; endpoint rejects requests without App Check/origin; rate limit and budget alert set; spot-check of 20 questions shows no invented facts |
| P0-4 | Technical | Web build contains no APKs, unused video or PDFs | PERF-1 | `pubspec.yaml`, `assets/apk/` (move screenshots) | None | S | `build/web` has no `.apk`/`.mp4`/unused `.pdf`; deployed `/assets/assets/apk/*.apk` returns 404; product screenshots still render |
| P0-5 | Content / Legal | Analytics only after consent; policies describe the website | LEGAL-1 | `web/index.html`, new consent UI, privacy and cookies pages | Legal review (Risk 10) | M | GA does not load before consent (verified in DevTools Network); policies mention analytics, AI chat, contact form, retention and transfers; placeholder P.O. Box replaced |
| P0-6 | Content | Unverifiable claims removed or evidenced | CLAIM-1, CLAIM-2, CLAIM-4 | Certificates, Business Units, Construction, Oil & Gas, Home logos | Company answers Q9–Q11 | S | Each claim in §4.3 is marked "confirmed with evidence" or reworded/removed; written permission on file for every named testimonial and logo kept |
| P0-7 | Technical / Security | Exposed third-party key revoked | SEC-5 | Unsplash dashboard, `lib/detail/config.dart` | Account access | S | Key revoked/rotated; file removed; no keys in `lib/` (grep) |

### P1 — High-impact improvements

| # | Area | Outcome | Rationale | Affected | Dependencies | Effort | Acceptance criteria |
|---|---|---|---|---|---|---|---|
| P1-1 | Content | Clear positioning and homepage hero | POS-1, UX-2 | Home (CMS), About | Phase 2 decisions | M | A first-time tester can state who JV ALMA is, what it offers and for whom within 5 s (5-person hallway test) |
| P1-2 | Design / IA | Products and projects reachable from main navigation | IA-1, POS-3 | Header, drawer, CMS nav | Phase 3 sitemap | M | Every product and the projects index is ≤ 2 clicks from home; Certificates and Careers discoverable from the header or About |
| P1-3 | SEO | Per-route titles, descriptions, OG tags, canonical | SEO-1 | `index.html`, routing | SEO-5 decision | M | Each public route has a unique title and description; LinkedIn post inspector shows correct preview |
| P1-4 | SEO | Complete sitemap; soft-404 fixed | SEO-2, SEO-3 | `web/sitemap.xml`, `firebase.json`, 404 page | — | S | Sitemap lists all public routes with current `lastmod`; unknown URL returns 404 or `noindex`; Search Console shows no soft-404 warnings |
| P1-5 | Technical | Architecture decision on HTML-first marketing pages | SEO-5, PERF-3 | Whole site | Phase 3 | S (decision) / L (execution) | Written decision record with chosen option and rationale |
| P1-6 | Design / Feature | Contextual enquiry CTAs with topic routing | UX-3, POS-6, CONTENT-4 | All unit and product pages, contact form | P0-1 | M | Every unit or product page ends with a CTA; the form carries a topic or unit; each topic reaches the agreed inbox; "Request Info" removed or wired up |
| P1-7 | Content | Oil & Gas relationship clarified | POS-7, CLAIM-3 | `oil_gas_services_detail.dart` | Q8 | S | The page states the relationship in the first paragraph; TIC credentials explicitly attributed; enquiry path agreed |
| P1-8 | Technical | CI pipeline with analyze, test, build | TECH-5 | New workflow | TECH-7 (repo size) | M | PRs show green checks; a failing test blocks merge |
| P1-9 | Technical | Images optimised | PERF-2 | `assets/images/`, certificates | — | S | No content image over 400 KB; hero under 300 KB; Lighthouse mobile LCP measured before and after |
| P1-10 | Technical | Hosting redirects verified/fixed | HOST-1 | Firebase console, `firebase.json` | Console access | S | `curl -I https://jvalmacis.com/x` → 301 to `https://www.jvalmacis.com/x` |

### P2 — Important enhancements

| # | Area | Outcome | Affected | Dependencies | Effort | Acceptance criteria |
|---|---|---|---|---|---|---|
| P2-1 | New feature | Projects/Case Studies section with one page per project | New pages, CMS model | P1-2, permissions (P0-6) | L | Each listed project has its own URL, title, summary, images, client (where permitted) |
| P2-2 | New feature | News as dated articles managed in the CMS | `news_page.dart`, CMS | P1-5 decision | M | Admin can publish an article without a deploy; each article has a URL and date |
| P2-3 | Content | Leadership/team and company facts on About | `about_page.dart` | Q7 | S | About shows leadership, legal name, registration, offices; "seven years" fixed |
| P2-4 | Content | Naming/terminology sheet applied site-wide | All pages | Phase 2 | S | grep shows one spelling per product and unit name |
| P2-5 | SEO | JSON-LD Organization/LocalBusiness/SoftwareApplication | `index.html` or per page | Confirmed facts | S | Rich Results Test passes |
| P2-6 | Feature | Conversion tracking events | Contact, Play Store links, chat | P0-5 consent | S | Events visible in GA4 DebugView |
| P2-7 | Design | Token migration of footer and older widgets; single breakpoint set | `footer.dart`, older pages | — | M | No `GoogleFonts.poppins`; `Color(0x` count reduced to agreed exceptions |
| P2-8 | Accessibility | Semantics, keyboard focus, contrast pass | Header, footer, chat, cards | — | M | Keyboard-only walkthrough completes all journeys in §8.2; contrast ≥ 4.5:1 for body text |
| P2-9 | Technical | Remove unused files and dependencies; update `CLAUDE.md`/README | TECH-1, TECH-2, TECH-6 | — | S | `flutter analyze` clean; unused packages removed; docs match code |
| P2-10 | Technical | Branded 404 and loading screen, favicon/manifest icons | UX-5, UX-8, PERF-3 | `index.html`, `main.dart`, `manifest.json` | — | S | No favicon 404; manifest icons are correct sizes; 404 page has header and footer |
| P2-11 | Content | Downloadable company profile/capability statement | New asset | Company material | M | PDF linked from About and contact pages |
| P2-12 | Feature | Product "Request a demo" paths for NyumbaSmart, CoffeeCore (cooperatives), Kilimo Education (schools) | Product pages | P1-6 | S | Each product page has a prospect-oriented CTA besides the Play Store link |
| P2-13 | Technical | Dependency major upgrades (Firebase, Riverpod) | `pubspec.yaml`, providers | CI (P1-8) | M | All tests pass on new majors; staged deploy via preview channel |

### P3 — Optional, later phase

| # | Area | Outcome | Effort |
|---|---|---|---|
| P3-1 | New feature | Swahili (and possibly Italian) language support for farmer/partner audiences | L |
| P3-2 | New feature | CMS for Projects, Careers, Certificates | M |
| P3-3 | Technical | Repository cleanup: move videos/APKs to LFS or storage; remove `y/`, `lib.rar`, logs | M |
| P3-4 | Design | Short video content (assets already exist) presented responsibly (poster image, lazy load, hosted externally) | M |
| P3-5 | Feature | Partner/investor page | S |
| P3-6 | Technical | Preview-channel deploy workflow and separate staging project | M |
| P3-7 | Security | Admin MFA and Auth hardening | S |
| P3-8 | Content | Published HSE, quality and sustainability policies | M |

### Backlog grouped by work type

- **Content:** P0-5 (policies), P0-6, P1-1, P1-7, P2-3, P2-4, P2-11, P3-1, P3-8
- **Design:** P1-2, P2-7, P2-8, P2-10, P3-4
- **Technical:** P0-1, P0-2, P0-4, P0-7, P1-5, P1-8, P1-9, P1-10, P2-9, P2-13, P3-3, P3-6, P3-7
- **SEO:** P1-3, P1-4, P2-5
- **New features:** P0-3 (chat fix), P1-6, P2-1, P2-2, P2-6, P2-12, P3-2, P3-5

---

## 13. Questions requiring input from the company

**Positioning and structure**
1. In one sentence, what is JV ALMA C.I.S? (e.g. a multi-sector contractor, an AgriTech company with engineering roots, a group of businesses)
2. Which business line should lead the website commercially for the next 12–24 months?
3. Is the Italian–Kenyan identity something to feature prominently?
4. Should the site be organised by **Services** + **Products**, by **Industries**, or keep four **Business Units**?
5. Who are the priority audiences, in order? (e.g. embassies and diplomatic missions, development agencies and donors, cooperatives, farmers, schools, facility owners, oil & gas operators, partners and investors, job seekers)
6. Is custom software development offered to external clients? If so, for what kinds of projects?
7. May leadership be shown (names, photos, bios)? Who?

**Claims and permissions**
8. What exactly is JV ALMA's relationship to TIC East Africa and Brisma Africa, and who should oil & gas enquiries go to?
9. Does the company hold ISO 9001:2015 certification? If so, please provide the certificate (issuer, number, expiry).
10. Is there written permission to publish each named testimonial and each client, government or agency logo (US Government/NAVFAC/RPSO, embassies of Italy, Portugal and Sweden, KVDA, Total, ENI, IADC)?
11. What verified figures can be published? (e.g. hectares irrigated, farmers reached, app downloads or active users, number of facilities managed, years of team experience)

**Brand and content**
12. Is there a master logo (vector/transparent), brand colours and a typeface guideline?
13. Who will own and update News, Projects and Careers, and how often?
14. Is organic search a key lead source? This drives the HTML-first vs Flutter decision (SEO-5).
15. What facts may the AI assistant state, and should it exist at all? What should it do when it cannot answer?
16. Which email address(es) should receive which kinds of enquiries? Is sending business enquiries to HR intended?
17. Which official documents (KRA, business permit, incorporation) are you comfortable publishing in full?
18. Which project statuses are current (e.g. Rosslyn Ridge "Ongoing" since 2018, Italian residence "Ongoing" since 2024)?
19. Are iOS versions of the apps available or planned?
20. Is Swahili content required for farmers and cooperatives?

**Operations**
21. Is the Firebase Trigger Email extension installed, and do the mobile apps also use the `mail` collection?
22. Who has access to the Cloud Run chat backend, the Firebase console, Google Analytics and Search Console?
23. Is there a legal adviser who can review the updated privacy and cookies policies?

---

## 14. Suggested next steps for the website update

### Immediately (independent of the redesign)
Complete **P0-1, P0-3, P0-4 and P0-7**. They reduce live risk and need no business decisions beyond Q15/Q16/Q21. Start P0-5 and P0-6 in parallel, since they depend on the company's answers.

### Phase 1 — Confirm findings and business priorities
- **Activities:** Walk through this report with decision-makers. Verify the *Needs verification* items (live CMS content, extension setup, redirects, rendered layout at 4 viewports, Lighthouse baseline). Answer Q8–Q11 and Q21–Q23.
- **Deliverables:** Annotated findings list (accepted, rejected, deferred). Baseline metrics: Lighthouse scores, GA traffic and top pages, current enquiry volume. P0 status.
- **Gate:** P0 items done or scheduled with owners. Business priorities ranked.

### Phase 2 — Target audiences, positioning, business-unit structure and content
- **Decisions:** Q1–Q7, Q12–Q13, Q20. Positioning statement. Naming sheet. Audience priority list. Which claims and figures are approved.
- **Deliverables:** Messaging framework (positioning, proof points per audience), content inventory with owner per page (keep / rewrite / remove / new), confirmed facts sheet (shared with the chat assistant).
- **Gate:** Signed-off positioning, facts sheet and permissions list.

### Phase 3 — Sitemap, user journeys and page requirements
- **Decisions:** Navigation model (§4.2 POS-2, IA-1). **Architecture decision (SEO-5 / P1-5).** Which content types are CMS-managed (Q13).
- **Deliverables:** Target sitemap with URL scheme (incl. redirects from current URLs such as `/construction-detail`). A journey map for each priority audience (§8.2 as starting point). A requirements sheet for each page template (purpose, content blocks, CTA, metadata, analytics events).
- **Gate:** Sitemap, URL and redirect plan, architecture decision record.

### Phase 4 — Visual direction and reusable UI components
- **Decisions:** Brand assets (Q12), typography (resolve the Inter/Poppins split), photography direction (the real project photos are an asset).
- **Deliverables:** Updated design tokens (single breakpoint set). Component list built on the existing `AppCard`/`SectionWrapper`/`PageHero` pattern: hero, project card, product card, CTA band, enquiry form, article layout, 404. Accessibility criteria (contrast, focus, semantics).
- **Gate:** Approved designs for each page template at mobile and desktop.

### Phase 5 — Prioritize implementation and technical improvements
- **Activities:** Sequence P1 → P2 items against the approved sitemap and designs. Set up CI (P1-8) and a preview channel *before* large changes. Do dependency upgrades (P2-13) separately from content and design work.
- **Deliverables:** Sprint plan or milestone plan. Migration plan for CMS data. Redirect map.
- **Gate:** Plan agreed; CI green on `main`.

### Phase 6 — Test, validate and prepare for release
- **Activities:**
  - Cross-browser and viewport testing at 375 / 768 / 1024 / 1440 px.
  - Keyboard and screen-reader pass.
  - Lighthouse (performance, SEO, accessibility) compared with the Phase 1 baseline.
  - Rules tests in the emulator.
  - Contact form end-to-end to each inbox.
  - Chat spot-checks against the facts sheet.
  - Consent behaviour checked in DevTools.
  - Broken-link and missing-asset scan.
  - Sitemap submitted to Search Console.
  - Redirects verified with `curl`.
- **Deliverables:** Test report, launch checklist, rollback plan (previous Hosting release), post-launch monitoring (GA events, Search Console coverage, enquiry volume).
- **Gate:** All P0 and agreed P1 items pass their acceptance criteria. Company sign-off on content and legal pages.

---

*End of report. This audit changed nothing in the application. The only file added is this report.*
