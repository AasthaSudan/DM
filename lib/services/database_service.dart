import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  String _role = 'student'; // default role

  // Emergency contacts cache
  List<Map<String, dynamic>> _emergencyContacts = [];
  List<Map<String, dynamic>> get emergencyContacts => _emergencyContacts;

  String get role => _role;

  // ------------------- USER DATA -------------------

  // 🧠 Load user data from Firestore
  Future<void> loadUserData({required String uid}) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        userData = doc.data();
        _role = userData?['role'] ?? 'student';
      } else {
        userData = {
          'name': '',
          'email': '',
          'role': 'student',
          'rank': 'Beginner',
          'safetyScore': 0,
          'modulesCompleted': 0,
          'totalModules': 5,
          'profileComplete': false,
          'createdAt': FieldValue.serverTimestamp(),
        };
        _role = 'student';
        await _firestore.collection('users').doc(uid).set(userData!, SetOptions(merge: true));
      }
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading user data: $e');
    }
  }

  // ✏️ Update user profile info
  Future<void> updateUserProfile(Map<String, dynamic> data, {required String uid}) async {
    try {
      await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
      userData ??= {};
      userData!.addAll(data);
      if (data.containsKey('role')) _role = data['role'];
      notifyListeners();
    } catch (e) {
      print('⚠️ Error updating user profile: $e');
    }
  }

  // 🧮 Update modules completed and safety score
  Future<void> updateProgress({required String uid, int modules = 0, int score = 0}) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) throw Exception("User not found");
        final currentData = snapshot.data() ?? {};

        final newModules = (currentData['modulesCompleted'] ?? 0) + modules;
        final newScore = (currentData['safetyScore'] ?? 0) + score;
        final newRank = _calculateRank(newScore);

        transaction.update(docRef, {
          'modulesCompleted': newModules,
          'safetyScore': newScore,
          'rank': newRank,
        });

        userData ??= {};
        userData!.addAll({
          'modulesCompleted': newModules,
          'safetyScore': newScore,
          'rank': newRank,
        });
      });
      notifyListeners();
    } catch (e) {
      print('⚠️ Error updating progress: $e');
    }
  }

  // 🏅 Calculate user rank based on safety score
  String _calculateRank(int score) {
    if (score >= 100) return 'Expert';
    if (score >= 60) return 'Advanced';
    if (score >= 30) return 'Intermediate';
    return 'Beginner';
  }

  // ♻️ Refresh local user data from Firestore
  Future<void> refreshUserData({required String uid}) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        userData = snapshot.data();
        _role = userData?['role'] ?? 'student';
        notifyListeners();
      }
    } catch (e) {
      print('⚠️ Error refreshing user data: $e');
    }
  }

  // ------------------- EMERGENCY CONTACTS -------------------

  Future<void> loadEmergencyContacts(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).collection('emergency_contacts').get();

      _emergencyContacts = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading emergency contacts: $e');
    }
  }

  Future<void> addEmergencyContact(String uid, Map<String, dynamic> contact) async {
    try {
      final docRef = await _firestore.collection('users').doc(uid).collection('emergency_contacts').add(contact);
      _emergencyContacts.add({'id': docRef.id, ...contact});
      notifyListeners();
    } catch (e) {
      print('⚠️ Error adding emergency contact: $e');
    }
  }

  Future<void> deleteEmergencyContact(String uid, String contactId) async {
    try {
      await _firestore.collection('users').doc(uid).collection('emergency_contacts').doc(contactId).delete();
      _emergencyContacts.removeWhere((c) => c['id'] == contactId);
      notifyListeners();
    } catch (e) {
      print('⚠️ Error deleting emergency contact: $e');
    }
  }

  // ------------------- MODULE SCORES -------------------

  Future<int> getModuleScore(String uid, String moduleId) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).collection('modules').doc(moduleId).get();
      return doc.data()?['score'] ?? 0;
    } catch (e) {
      print('⚠️ Error getting module score: $e');
      return 0;
    }
  }

  Future<void> updateModuleScore(String uid, String moduleId, int score) async {
    try {
      await _firestore.collection('users').doc(uid).collection('modules').doc(moduleId).set({'score': score}, SetOptions(merge: true));
      notifyListeners();
    } catch (e) {
      print('⚠️ Error updating module score: $e');
    }
  }
}
