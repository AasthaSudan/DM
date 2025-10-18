// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  String? errorMessage;

  // --------------------------
  // Sign Up with Email/Password
  // --------------------------
  Future<bool> signUpWithEmail(
      String email, String password, String name) async {
    _setLoading(true);
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Update display name
      await userCred.user?.updateDisplayName(name);
      await userCred.user?.reload();

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e);
      return false;
    } catch (e) {
      _setError(e);
      return false;
    }
  }

  // --------------------------
  // Sign In with Email/Password
  // --------------------------
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e);
      return false;
    } catch (e) {
      _setError(e);
      return false;
    }
  }

  // --------------------------
  // Sign In with Google
  // --------------------------
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setError('Google sign-in cancelled');
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e);
      return false;
    } catch (e) {
      _setError(e);
      return false;
    }
  }

  // --------------------------
  // Reset Password
  // --------------------------
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e);
      return false;
    } catch (e) {
      _setError(e);
      return false;
    }
  }

  // --------------------------
  // Sign Out
  // --------------------------
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }

  // --------------------------
  // Private Helpers
  // --------------------------
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(Object e) {
    if (e is FirebaseAuthException) {
      errorMessage = '${e.code}: ${e.message}';
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
    } else {
      errorMessage = e.toString();
      debugPrint('Other exception: $e');
    }
    _setLoading(false);
  }

  // --------------------------
  // Current User
  // --------------------------
  User? get currentUser => _auth.currentUser;
}
