import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'business_unit_model.dart';

const _collectionName = 'businessUnits';

/// All business units, ordered for display. Consumers should fall back to
/// [defaultBusinessUnits] via `.valueOrNull` while this is loading or if
/// Firestore is unreachable, so the public site never shows a blank state.
final businessUnitsProvider = StreamProvider<List<BusinessUnit>>((ref) {
  return FirebaseFirestore.instance
      .collection(_collectionName)
      .orderBy('order')
      .snapshots()
      .map((snap) => snap.docs.map(BusinessUnit.fromDoc).toList());
});

final businessUnitsRepositoryProvider = Provider<BusinessUnitsRepository>((ref) {
  return BusinessUnitsRepository();
});

class BusinessUnitsRepository {
  final _col = FirebaseFirestore.instance.collection(_collectionName);

  Future<String> create(BusinessUnit unit) async {
    final ref = await _col.add(unit.toMap());
    return ref.id;
  }

  Future<void> update(BusinessUnit unit) {
    return _col.doc(unit.id).update(unit.toMap());
  }

  Future<void> delete(String id) => _col.doc(id).delete();

  Future<int> nextOrder() async {
    final snap = await _col.orderBy('order', descending: true).limit(1).get();
    if (snap.docs.isEmpty) return 0;
    return (snap.docs.first.data()['order'] as int? ?? 0) + 1;
  }

  Future<void> swapOrder(List<BusinessUnit> units, int i, int j) async {
    final batch = FirebaseFirestore.instance.batch();
    batch.update(_col.doc(units[i].id), {'order': units[j].order});
    batch.update(_col.doc(units[j].id), {'order': units[i].order});
    await batch.commit();
  }

  /// Writes the site's original hardcoded business units as day-one
  /// content. No-ops if the collection already has data. Callable only by
  /// an authenticated admin — enforced by firestore.rules, not here.
  Future<void> seedDefaults() async {
    final existing = await _col.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final unit in defaultBusinessUnits) {
      batch.set(_col.doc(), unit.toMap());
    }
    await batch.commit();
  }
}
