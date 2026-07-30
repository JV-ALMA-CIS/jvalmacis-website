import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Whether the signed-in user has an `admins/{uid}` Firestore doc.
///
/// This lookup — mirrored by firestore.rules — is the actual access-control
/// check. The /portal-mgmt route itself is only obscure, not a security
/// boundary.
final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return false;
  final doc = await FirebaseFirestore.instance.collection('admins').doc(user.uid).get();
  return doc.exists;
});

final adminAuthControllerProvider = Provider<AdminAuthController>((ref) {
  return AdminAuthController();
});

class AdminAuthController {
  /// Returns an error message on failure, or null on success.
  Future<String?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Sign-in failed.';
    }
  }

  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
