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
  String _role = 'student';
  bool _profileComplete = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get role => _role;
  bool get profileComplete => _profileComplete;

  AuthService() {
    _auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      if (_currentUser != null) {
        await _fetchUserData();
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  // Fetch Role + Profile Status
  Future<void> _fetchUserData() async {
    if (_currentUser == null) return;
    final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      _role = data['role'] ?? 'student';
      _profileComplete = data['profileComplete'] ?? false;
    }
  }

  // Sign Up
  Future<bool> signUpWithEmail(String email, String password, String name, {String role = 'student'}) async {
    try {
      _setLoading(true);
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (result.user != null) {
        await result.user!.updateDisplayName(name);
        await _firestore.collection('users').doc(result.user!.uid).set({
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'profileComplete': false,
          'safetyScore': 0,
          'modulesCompleted': 0,
          'totalModules': 5,
        });
        _currentUser = result.user;
        _role = role;
        _profileComplete = false;
        return true;
      }
      return false;
    } catch (e) {
      _handleFirebaseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _currentUser = result.user;
      await _fetchUserData();
      return true;
    } catch (e) {
      _handleFirebaseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      UserCredential result = await _auth.signInWithCredential(credential);
      _currentUser = result.user;

      if (result.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'name': result.user!.displayName ?? '',
          'email': result.user!.email ?? '',
          'role': 'student',
          'profileComplete': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await _fetchUserData();
      return true;
    } catch (e) {
      _handleGenericError("Google Sign-In failed!");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
    _role = 'student';
    _profileComplete = false;
    notifyListeners();
  }

  // Helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _handleFirebaseError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'This email is already in use.';
          break;
        case 'weak-password':
          _errorMessage = 'Password is too weak.';
          break;
        case 'wrong-password':
          _errorMessage = 'Incorrect password.';
          break;
        default:
          _errorMessage = 'Authentication failed. Try again.';
      }
    }
    notifyListeners();
  }

  void _handleGenericError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
