// lib/features/auth/providers/auth_provider.dart
// Riverpod providers for authentication state management.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';

// ─── Service Provider ──────────────────────────────────────────────────────
/// Provides a single instance of AuthService throughout the app.
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// ─── Auth State Notifier ───────────────────────────────────────────────────

/// Holds and manages the authentication state.
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    // Initialize by checking if a user is already logged in
    _init();
  }

  /// Check for existing session on app start.
  Future<void> _init() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser != null) {
        final userModel = await _authService.getUserProfile(firebaseUser.uid);
        state = AsyncValue.data(userModel);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Sign up a new user.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    required String village,
    required String district,
    required String state,
  }) async {
    this.state = const AsyncValue.loading();
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
        village: village,
        district: district,
        state: state,
      );
      this.state = AsyncValue.data(user);
    } catch (e, stack) {
      this.state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Log in an existing user.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    this.state = const AsyncValue.loading();
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );
      this.state = AsyncValue.data(user);
    } catch (e, stack) {
      this.state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Sign out and clear state.
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      this.state = const AsyncValue.data(null);
    } catch (e, stack) {
      this.state = AsyncValue.error(e, stack);
    }
  }
}

/// The main auth state provider. Use this throughout the app.
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Convenience provider — returns the current UserModel or null.
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).valueOrNull;
});

/// Returns true if a user is logged in.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
