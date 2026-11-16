# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter **web** marketing/corporate site for JV ALMA C.I.S (Kenya), showcasing the company's business units (Construction, Agribusiness, Oil & Gas, IT/Tech) plus an AI chat widget, careers, news, and legal pages. Backed by Firebase (Auth, Firestore, Hosting). No mobile-specific product features — treat this as a web app first.

## Commands

```
flutter pub get                     # install dependencies
flutter run -d chrome               # run locally in a browser
flutter analyze                     # static analysis (uses flutter_lints via analysis_options.yaml)
flutter test                        # run all tests
flutter test test/widget_test.dart  # run a single test file
flutter build web                   # production web build -> build/web (deployed via Firebase Hosting)
dart run tool/optimize_web_build.dart  # run after every web build: drops icon fonts the app never uses (~2.9 MB) so the first page draws sooner
firebase deploy --only hosting      # deploy build/web (requires firebase-tools + login)
```

There is a single test file (`test/widget_test.dart`); there is no separate integration/e2e suite.

## Architecture

- **Entry point / routing**: [lib/main.dart](lib/main.dart) builds `MaterialApp` directly with an inline `onGenerateRoute` switch statement mapping path strings (e.g. `/about`, `/it-division`, `/kilimo-mkononi`) to pages. `go_router` is a listed dependency and [lib/routing/router.dart](lib/routing/router.dart) exists but is **empty/unused** — all routing actually happens in `main.dart`. When adding a new page/route, add both the import and the `case` in `main.dart`'s switch.
- **Pages vs. detail views**: [lib/pages/](lib/pages/) holds top-level site pages (home, about, contact, careers, news, legal pages). [lib/detail/](lib/detail/) holds business-unit-specific deep pages, one subfolder per unit (`construction/`, `agribusiness/`, `oil/`, `it/`). The `it/` unit has the most sub-pages (CMMS, AlmaWorks, Coffee Core, Kilimo Mkononi landing/enterprise/education) since IT is a multi-product division. Project portfolios are shared: [lib/detail/portfolio/](lib/detail/portfolio/) holds the project model (`PortfolioProject`, `Portfolio`), the card carousel, the project page and the image viewer; each unit keeps its data in one file (`construction/construction_projects.dart`, `agribusiness/agribusiness_content.dart`) and registers its portfolio in `portfolios.dart`, which gives every project a `<unit route>/<slug>` page and tab title.
- **Design system**: [lib/design/](lib/design/) is a newer, self-contained design token layer — `palette.dart` (brand colors, business-unit accent colors, gradients), `tokens.dart` (`Space`/`Radii`/`Elevation`/`Motion` constants), `typography.dart`, and `app_theme.dart` (`buildAppTheme()`). **Note:** `main.dart` currently builds `ThemeData` inline rather than calling `buildAppTheme()` — the design system is not yet wired up as the app's actual theme. Prefer using `Palette`/`Space`/`Radii`/`Motion` tokens for any new/touched UI rather than hardcoded values or the older `screenHeight * 0.0x` viewport-relative sizing pattern still present in older widgets.
- **Reusable widgets**: [lib/widgets/](lib/widgets/) mixes older general-purpose widgets (`custom_button.dart`, `custom_card.dart`, `custom_widgets.dart`, `header.dart`, `footer.dart`) with newer ones built on the design tokens (`app_buttons.dart`, `app_card.dart`, `section.dart`, `page_hero.dart`, `reveal_on_scroll.dart`, `hoverable.dart`, `logo_marquee.dart`). Note there are two `responsive_utils.dart` files ([lib/responsive_utils.dart](lib/responsive_utils.dart) and [lib/widgets/responsive_utils.dart](lib/widgets/responsive_utils.dart)) — check which one a file imports before adding responsive logic.
- **Config**: Two separate `Config` classes exist — [lib/config.dart](lib/config.dart) (company contact info, social/partner URLs) and [lib/detail/config.dart](lib/detail/config.dart) (API URL, Unsplash key). They are unrelated despite the same class name; check the import path.
- **AI chat widget ("Ask ALMA")**: [lib/widgets/website_chat_widget.dart](lib/widgets/website_chat_widget.dart) is the UI; [lib/widgets/website_chat_service.dart](lib/widgets/website_chat_service.dart) posts `{message, history}` to `/api/chat`. That path is a Firebase Hosting rewrite to the `askAlma` Cloud Function in [functions/](functions/) (this project, `alma-green-tech`), which holds the system prompt, the Gemini call (`GEMINI_KEY` secret), input limits, an origin allowlist and per-visitor/daily rate limits (Firestore `chatRateLimits`). The pure logic is in `functions/chat.js` (tested with `cd functions && npm test`). Do not point the website at the Kilimo Mkononi app's `askGemini` function — it requires app sign-in and belongs to that app.
- **Firebase**: [lib/firebase_options.dart](lib/firebase_options.dart) is generated (`flutterfire configure`) — don't hand-edit. Firestore/Storage security rules live at repo root (`firestore.rules`, `storage.rules`); hosting config and SPA rewrite/redirect rules are in `firebase.json` (all paths rewrite to `index.html`, plus a `fbclid` redirect). The live site serves the apex domain `https://jvalmacis.com` (www redirects there, set in the Firebase console), so canonical URLs, the sitemap and structured data use the apex.
- **Search/SEO**: [web/index.html](web/index.html) holds the title, description, Open Graph tags, JSON-LD (`Organization` with social `sameAs`, `WebSite`), a per-route canonical script, and a loading screen (the logo centred on white with a progress bar) removed on Flutter's `flutter-first-frame` event, and a visually hidden plain-HTML outline of the site (`#site-shell`) for crawlers. Per-route tab titles come from [lib/routing/page_titles.dart](lib/routing/page_titles.dart). When adding a public route, also add it to `page_titles.dart`, the `PAGES` list in `web/index.html` and `web/sitemap.xml`.
- **Assets**: Registered per-directory in `pubspec.yaml` under `flutter.assets` (e.g. `assets/images/agribusiness/`, `assets/images/construction/`, `assets/news/`, `assets/certificates/`). When adding images for a new business unit or news item, add the folder to `pubspec.yaml` as well, not just the filesystem.
