import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _emergencyContacts = [];
  bool _isLoading = false;
  String? _errorMessage;

  StreamSubscription? _userDataSubscription;
  StreamSubscription? _emergencyContactsSubscription;

  Map<String, dynamic>? get userData => _userData;
  List<Map<String, dynamic>> get emergencyContacts => _emergencyContacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isProfileComplete => _userData?['profileComplete'] ?? false;
  int get safetyScore => _userData?['safetyScore'] ?? 0;
  int get modulesCompleted => _userData?['modulesCompleted'] ?? 0;
  int get totalModules => _userData?['totalModules'] ?? 5;
  String get userRank => _userData?['rank'] ?? 'Beginner';
  double get completionPercentage =>
      totalModules > 0 ? (modulesCompleted / totalModules * 100) : 0.0;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ---------------- USER DATA ----------------
  Future<void> loadUserData({required String uid}) async {
    try {
      _setLoading(true);
      await _userDataSubscription?.cancel();

      _userDataSubscription =
          _firestore.collection('users').doc(uid).snapshots().listen(
                (snapshot) {
              if (snapshot.exists && snapshot.data() != null) {
                _userData = snapshot.data();
              } else {
                _userData = _getDefaultUserData();
              }
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _setError('Failed to load user data: ${error.toString()}');
            },
          );
    } catch (e) {
      _setError('Error loading user data: ${e.toString()}');
    }
  }

  Map<String, dynamic> _getDefaultUserData() {
    return {
      'name': '',
      'email': '',
      'rank': 'Beginner',
      'safetyScore': 0,
      'modulesCompleted': 0,
      'totalModules': 5,
      'profileComplete': false,
      'createdAt': FieldValue.serverTimestamp(),
      'emergencyContactsCount': 0,
      'badgesEarned': {}, // module: badge
      'completedCourses': {}, // module: score or completion
      'streakDays': 0,
    };
  }

  Future<bool> updateUserProfile(
      Map<String, dynamic> data, {
        required String uid,
      }) async {
    try {
      _setLoading(true);
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true));

      _userData ??= {};
      _userData!.addAll(data);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    }
  }

  // ---------------- PROGRESS ----------------
  Future<bool> updateProgress({
    required String uid,
    int modulesIncrement = 0,
    int scoreIncrement = 0,
    String? moduleId,
    String? badge, // optional badge earned for this module
  }) async {
    try {
      _setLoading(true);
      final docRef = _firestore.collection('users').doc(uid);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) throw Exception("User document not found");

        final currentData = snapshot.data() ?? {};
        final currentModules = currentData['modulesCompleted'] ?? 0;
        final currentScore = currentData['safetyScore'] ?? 0;
        final completedCourses = Map<String, dynamic>.from(currentData['completedCourses'] ?? {});
        final badgesEarned = Map<String, dynamic>.from(currentData['badgesEarned'] ?? {});

        final newModules = currentModules + modulesIncrement;
        final newScore = currentScore + scoreIncrement;
        final newRank = _calculateRank(newScore);

        if (moduleId != null) {
          completedCourses[moduleId] = scoreIncrement; // store module completion score
          if (badge != null) badgesEarned[moduleId] = badge; // store badge
        }

        final updateData = {
          'modulesCompleted': newModules,
          'safetyScore': newScore,
          'rank': newRank,
          'completedCourses': completedCourses,
          'badgesEarned': badgesEarned,
          'lastActiveDate': FieldValue.serverTimestamp(),
        };

        transaction.update(docRef, updateData);
        _userData ??= {};
        _userData!.addAll(updateData);
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update progress: ${e.toString()}');
      return false;
    }
  }

  String _calculateRank(int score) {
    if (score >= 500) return 'Master';
    if (score >= 300) return 'Expert';
    if (score >= 150) return 'Advanced';
    if (score >= 50) return 'Intermediate';
    return 'Beginner';
  }

  // ---------------- MODULE SCORE & BADGES ----------------
  Future<int> getModuleScore(String uid, String module) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final completedCourses = Map<String, dynamic>.from(data['completedCourses'] ?? {});
        return completedCourses[module] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error fetching module score: $e');
      return 0;
    }
  }

  Future<String?> getModuleBadge(String uid, String module) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final badges = Map<String, dynamic>.from(data['badgesEarned'] ?? {});
        return badges[module];
      }
      return null;
    } catch (e) {
      print('Error fetching badge: $e');
      return null;
    }
  }

  // ---------------- EMERGENCY CONTACTS ----------------
  Future<void> loadEmergencyContacts(String uid) async {
    try {
      await _emergencyContactsSubscription?.cancel();
      _emergencyContactsSubscription = _firestore
          .collection('users')
          .doc(uid)
          .collection('emergency_contacts')
          .orderBy('createdAt', descending: false)
          .snapshots()
          .listen(
            (snapshot) {
          _emergencyContacts = snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
          notifyListeners();
        },
        onError: (error) {
          _setError('Failed to load emergency contacts: ${error.toString()}');
        },
      );
    } catch (e) {
      _setError('Error loading emergency contacts: ${e.toString()}');
    }
  }

  Future<bool> addEmergencyContact(String uid, Map<String, dynamic> contact) async {
    try {
      if (!_validateEmergencyContact(contact)) {
        _setError('Invalid contact data');
        return false;
      }
      _setLoading(true);
      contact['createdAt'] = FieldValue.serverTimestamp();
      contact['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('emergency_contacts')
          .add(contact);

      _emergencyContacts.add({'id': docRef.id, ...contact});
      await _firestore.collection('users').doc(uid).update({
        'emergencyContactsCount': FieldValue.increment(1),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add emergency contact: ${e.toString()}');
      return false;
    }
  }

  Future<bool> deleteEmergencyContact(String uid, String contactId) async {
    try {
      _setLoading(true);

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('emergency_contacts')
          .doc(contactId)
          .delete();

      _emergencyContacts.removeWhere((c) => c['id'] == contactId);

      await _firestore.collection('users').doc(uid).update({
        'emergencyContactsCount': FieldValue.increment(-1),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete emergency contact: ${e.toString()}');
      return false;
    }
  }

  bool _validateEmergencyContact(Map<String, dynamic> contact) {
    if (contact['name'] == null || contact['name'].toString().isEmpty) return false;
    if (contact['phone'] == null || contact['phone'].toString().isEmpty) return false;
    if (contact['relationship'] == null || contact['relationship'].toString().isEmpty) return false;
    return true;
  }

  Future<bool> updateDailyStreak(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final data = snapshot.data() ?? {};

        final lastActive = (data['lastActiveDate'] as Timestamp?)?.toDate();
        final now = DateTime.now();

        int currentStreak = data['streakDays'] ?? 0;

        if (lastActive != null) {
          final daysDiff = now.difference(lastActive).inDays;
          if (daysDiff == 0) return;
          if (daysDiff == 1) currentStreak++; else currentStreak = 1;
        } else {
          currentStreak = 1;
        }

        transaction.update(docRef, {
          'streakDays': currentStreak,
          'lastActiveDate': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      _setError('Failed to update streak: ${e.toString()}');
      return false;
    }
  }

  Future<void> clearData() async {
    await _userDataSubscription?.cancel();
    await _emergencyContactsSubscription?.cancel();
    _userDataSubscription = null;
    _emergencyContactsSubscription = null;
    _userData = null;
    _emergencyContacts = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    _emergencyContactsSubscription?.cancel();
    super.dispose();
  }
}
