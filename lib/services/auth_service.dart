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

  // Email & Password Sign Up
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await result.user!.updateDisplayName(name);

        // Create user document in Firestore
        await _firestore.collection('users').doc(result.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'profileComplete': false,
          'safetyScore': 0,
          'modulesCompleted': 0,
          'totalModules': 5,
        });

        _currentUser = result.user;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    }
  }

  // Email & Password Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = result.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // Check if user document exists
        final userDoc = await _firestore.collection('users').doc(result.user!.uid).get();

        if (!userDoc.exists) {
          // Create user document
          await _firestore.collection('users').doc(result.user!.uid).set({
            'name': result.user!.displayName ?? 'User',
            'email': result.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
            'profileComplete': false,
            'safetyScore': 0,
            'modulesCompleted': 0,
            'totalModules': 5,
          });
        }

        _currentUser = result.user;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to sign in with Google';
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Password Reset
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to send password reset email';
      notifyListeners();
      return false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'An error occurred. Please try again';
    }
  }
}