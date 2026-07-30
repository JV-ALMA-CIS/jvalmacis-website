import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'site_settings_model.dart';

final _doc = FirebaseFirestore.instance.collection('siteSettings').doc('main');

/// Consumers should fall back to [defaultSiteSettings] via `.valueOrNull`
/// while this is loading or if Firestore is unreachable.
final siteSettingsProvider = StreamProvider<SiteSettings>((ref) {
  return _doc.snapshots().map((snap) {
    if (!snap.exists) return defaultSiteSettings;
    return SiteSettings.fromMap(snap.data() ?? const {});
  });
});

final siteSettingsRepositoryProvider = Provider<SiteSettingsRepository>((ref) {
  return SiteSettingsRepository();
});

class SiteSettingsRepository {
  Future<void> save(SiteSettings settings) => _doc.set(settings.toMap());

  /// Writes the site's original hardcoded contact/nav/footer content as
  /// day-one content. No-ops if the doc already exists. Callable only by an
  /// authenticated admin — enforced by firestore.rules, not here.
  Future<void> seedDefaults() async {
    final snap = await _doc.get();
    if (snap.exists) return;
    await _doc.set(defaultSiteSettings.toMap());
  }
}
