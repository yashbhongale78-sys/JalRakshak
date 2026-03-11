// lib/data/services/auth_service.dart
// Handles all Firebase Authentication operations.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

/// Service class wrapping Firebase Authentication.
/// Handles sign-up, login, logout, and user profile management.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Stream of auth state changes ──────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns currently logged-in Firebase user (or null)
  User? get currentUser => _auth.currentUser;

  // ─── Sign Up ────────────────────────────────────────────────
  /// Creates a new user account and saves profile to Firestore.
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    required String village,
    required String district,
    required String state,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      // Create Firebase Auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Failed to create account');

      // Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // Build user model
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: normalizedEmail,
        phone: phone,
        role: role,
        village: village,
        district: district,
        state: state,
        createdAt: DateTime.now(),
      );

      // Save profile to Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return _recoverExistingAccount(
          email: normalizedEmail,
          password: password,
          name: name,
          phone: phone,
          role: role,
          village: village,
          district: district,
          state: state,
        );
      }

      // Re-throw with friendly message
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // ─── Sign In ────────────────────────────────────────────────
  /// Logs in an existing user with email and password.
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Login failed');

      // Fetch user profile from Firestore. Recover it if auth exists but the
      // profile document is missing, which otherwise drops the user back to
      // the login screen with no visible explanation.
      final profile = await getUserProfile(user.uid);
      if (profile != null) return profile;

      final recoveredProfile = _buildFallbackProfile(
        user,
        email: normalizedEmail,
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(recoveredProfile.toMap(), SetOptions(merge: true));

      return recoveredProfile;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel?> _recoverExistingAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    required String village,
    required String district,
    required String state,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('An account already exists with this email address.');
      }

      final existingProfile = await getUserProfile(user.uid);
      if (existingProfile != null) {
        return existingProfile;
      }

      final recoveredProfile = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        village: village,
        district: district,
        state: state,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(recoveredProfile.toMap(), SetOptions(merge: true));

      return recoveredProfile;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception(
          'This email is already registered. Try signing in or reset the password.',
        );
      }
      throw _handleAuthException(e);
    }
  }

  // ─── Get User Profile ───────────────────────────────────────
  /// Fetches user profile document from Firestore.
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.uid == uid) {
          return _buildFallbackProfile(
            currentUser,
            email: currentUser.email ?? '',
          );
        }
      }
      throw Exception('Failed to fetch user profile: $e');
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  UserModel _buildFallbackProfile(
    User user, {
    required String email,
  }) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? 'User',
      email: email,
      phone: user.phoneNumber ?? '',
      role: AppConstants.roleVillager,
      village: '',
      district: '',
      state: '',
      createdAt: DateTime.now(),
    );
  }

  // ─── Sign Out ───────────────────────────────────────────────
  /// Signs out the current user from Firebase Auth.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // ─── Password Reset ─────────────────────────────────────────
  /// Sends password reset email.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ─── Error Handling ─────────────────────────────────────────
  /// Converts Firebase auth error codes to user-friendly messages.
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('Password must be at least 6 characters long.');
      case 'email-already-in-use':
        return Exception(
            'An account already exists with this email address.');
      case 'user-not-found':
        return Exception('No account found with this email address.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'invalid-email':
        return Exception('Please enter a valid email address.');
      case 'user-disabled':
        return Exception(
            'This account has been disabled. Contact support.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please wait and try again.');
      case 'network-request-failed':
        return Exception(
            'Network error. Please check your internet connection.');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
}
