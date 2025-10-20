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
      _errorMessage = null;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Update user display name
        await result.user!.updateDisplayName(name);

        // Save user info in Firestore
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
        notifyListeners();
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      _handleError(e.code);
      return false;
    } catch (e) {
      _handleGenericError('Failed to sign up. Please try again.');
      return false;
    }
  }

  // 🔒 Sign In with Email & Password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      _handleError(e.code);
      return false;
    } catch (e) {
      _handleGenericError('Failed to sign in. Please try again.');
      return false;
    }
  }

  // 👋 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // 🔑 Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _errorMessage = null;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential result = await _auth.signInWithCredential(credential);

        if (result.user != null) {
          // Save user info in Firestore if new user
          if (result.additionalUserInfo?.isNewUser ?? false) {
            await _firestore.collection('users').doc(result.user!.uid).set({
              'name': result.user!.displayName ?? '',
              'email': result.user!.email ?? '',
              'createdAt': FieldValue.serverTimestamp(),
              'profileComplete': false,
              'safetyScore': 0,
              'modulesCompleted': 0,
              'totalModules': 5,
            }, SetOptions(merge: true));
          }

          _currentUser = result.user;
          notifyListeners();
          return true;
        }
      }

      return false;
    } catch (e) {
      _handleGenericError('Google sign in failed. Please try again.');
      return false;
    }
  }

  void _handleError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        _errorMessage = 'This email is already in use. Please try a different one.';
        break;
      case 'weak-password':
        _errorMessage = 'Password is too weak. Please choose a stronger password.';
        break;
      case 'invalid-email':
        _errorMessage = 'Invalid email address. Please check and try again.';
        break;
      case 'user-not-found':
        _errorMessage = 'No account found with this email. Please sign up first.';
        break;
      case 'wrong-password':
        _errorMessage = 'Incorrect password. Please try again.';
        break;
      case 'invalid-credential':
        _errorMessage = 'Invalid email or password. Please try again.';
        break;
      case 'too-many-requests':
        _errorMessage = 'Too many attempts. Please try again later.';
        break;
      case 'network-request-failed':
        _errorMessage = 'Network error. Check your internet connection.';
        break;
      default:
        _errorMessage = 'Authentication error. Please try again.';
    }
    notifyListeners();
  }

  void _handleGenericError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}