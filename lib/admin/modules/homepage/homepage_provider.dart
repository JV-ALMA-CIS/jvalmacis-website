import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'homepage_model.dart';

final _doc = FirebaseFirestore.instance.collection('homepage').doc('main');

/// Consumers should fall back to [defaultHomepageContent] via `.valueOrNull`
/// while this is loading or if Firestore is unreachable.
final homepageProvider = StreamProvider<HomepageContent>((ref) {
  return _doc.snapshots().map((snap) {
    if (!snap.exists) return defaultHomepageContent;
    return HomepageContent.fromMap(snap.data() ?? const {});
  });
});

final homepageRepositoryProvider = Provider<HomepageRepository>((ref) {
  return HomepageRepository();
});

class HomepageRepository {
  Future<void> save(HomepageContent content) => _doc.set(content.toMap());

  /// Writes the site's original hardcoded homepage content as day-one
  /// content. No-ops if the doc already exists. Callable only by an
  /// authenticated admin — enforced by firestore.rules, not here.
  Future<void> seedDefaults() async {
    final snap = await _doc.get();
    if (snap.exists) return;
    await _doc.set(defaultHomepageContent.toMap());
  }
}
