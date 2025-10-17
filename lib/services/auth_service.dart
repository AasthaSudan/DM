// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  // 📋 Clear error manually (useful for UI)
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 🧾 Sign Up with Email & Password
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    try {
      _setLoading(true);

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await result.user!.updateDisplayName(name);

        // Use merge to avoid overwriting data accidentally
        await _firestore.collection('users').doc(result.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'profileComplete': false,
          'safetyScore': 0,
          'modulesCompleted': 0,
          'totalModules': 5,
        }, SetOptions(merge: true));

        _currentUser = result.user;
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      _handleError(e.code);
      return false;
    } catch (e) {
      _handleGenericError('Failed to sign up. Please try again.');
      return false;
    }
  }

  // 🔐 Sign In with Email & Password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = result.user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleError(e.code);
      return false;
    } catch (e) {
      _handleGenericError('Failed to sign in. Please try again.');
      return false;
    }
  }

  // 🧠 Sign In with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        final userDoc = await _firestore.collection('users').doc(result.user!.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(result.user!.uid).set({
            'name': result.user!.displayName ?? 'User',
            'email': result.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
            'profileComplete': false,
            'safetyScore': 0,
            'modulesCompleted': 0,
            'totalModules': 5,
          }, SetOptions(merge: true));
        }

        _currentUser = result.user;
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      _handleError(e.code);
      return false;
    } on Exception catch (e) {
      _handleGenericError('Google sign-in failed: ${e.toString()}');
      return false;
    }
  }

  // 🚪 Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to sign out. Try again.';
      notifyListeners();
    }
  }

  // 🔁 Password Reset
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleError(e.code);
      return false;
    } catch (e) {
      _handleGenericError('Failed to send password reset email');
      return false;
    }
  }

  // 🧱 Update user profile info
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (_currentUser != null) {
      await _firestore.collection('users').doc(_currentUser!.uid).update(updates);
      notifyListeners();
    }
  }

  // 🛠️ Utility: Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }

  // 🛠️ Utility: Handle Firebase errors
  void _handleError(String code) {
    _isLoading = false;
    _errorMessage = _getErrorMessage(code);
    notifyListeners();
  }

  // 🛠️ Utility: Handle generic errors
  void _handleGenericError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }

  // ⚠️ Error message mapper
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // ♻️ Dispose properly
  @override
  void dispose() {
    _googleSignIn.disconnect();
    super.dispose();
  }
}
