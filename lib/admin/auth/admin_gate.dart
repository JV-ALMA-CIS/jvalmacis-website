import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_buttons.dart';
import '../shell/admin_shell.dart';
import 'admin_auth_provider.dart';
import 'admin_login_page.dart';

/// Gate for the /portal-mgmt route.
///
/// Deciding which UI to show here is a convenience, not the security
/// boundary — firestore.rules' `admins/{uid}` check is what actually
/// protects the data; this widget just mirrors that check for the UI.
class AdminGate extends ConsumerWidget {
  const AdminGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const _AdminLoading(),
      error: (e, _) => _AdminError(message: 'Auth error: $e'),
      data: (user) {
        if (user == null) return const AdminLoginPage();

        final isAdmin = ref.watch(isAdminProvider);
        return isAdmin.when(
          loading: () => const _AdminLoading(),
          error: (e, _) => _AdminError(message: 'Could not verify admin access: $e'),
          data: (allowed) => allowed ? const AdminShell() : const _NotAuthorized(),
        );
      },
    );
  }
}

class _AdminLoading extends StatelessWidget {
  const _AdminLoading();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _AdminError extends StatelessWidget {
  const _AdminError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      );
}

class _NotAuthorized extends ConsumerWidget {
  const _NotAuthorized();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Palette.n50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 40, color: Palette.danger),
              const SizedBox(height: Space.md),
              const Text('This account is not authorized for admin access.'),
              const SizedBox(height: Space.lg),
              SecondaryButton(
                text: 'Sign out',
                onPressed: () => ref.read(adminAuthControllerProvider).signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
