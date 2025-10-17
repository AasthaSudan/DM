// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  // Personal Emergency Contacts
  List<Map<String, dynamic>> emergencyContacts = [];

  // ------------------- USER DATA -------------------
  Future<void> loadUserData({required String uid}) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        userData = doc.data();
      } else {
        userData = {
          'name': '',
          'email': '',
          'rank': 'Beginner',
          'safetyScore': 0,
          'modulesCompleted': 0,
          'totalModules': 5,
          'profileComplete': false,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await _firestore.collection('users').doc(uid).set(userData!, SetOptions(merge: true));
      }
    } catch (e) {
      print('⚠️ Error loading user data: $e');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data, {required String uid}) async {
    try {
      await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
      userData ??= {};
      userData!.addAll(data);
    } catch (e) {
      print('⚠️ Error updating user profile: $e');
    }
  }

  // ------------------- MODULE SCORES -------------------
  Future<int> getModuleScore(String uid, String module) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data() ?? {};
      final modulesCompleted = data['modulesCompleted'] ?? 0;
      final score = data['safetyScore'] ?? 0;
      // Example: map module type to a score portion
      return ((score / 5).round()); // Simple example
    } catch (e) {
      print('⚠️ Error getting module score: $e');
      return 0;
    }
  }

  // ------------------- EMERGENCY CONTACTS -------------------
  Future<void> loadEmergencyContacts({String uid = 'USER_ID'}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('emergencyContacts')
          .get();

      emergencyContacts = snapshot.docs
          .map((doc) => {
        'id': doc.id,
        'name': doc['name'] ?? '',
        'number': doc['number'] ?? '',
        'relationship': doc['relationship'] ?? '',
      })
          .toList();

      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading emergency contacts: $e');
    }
  }

  Future<void> addEmergencyContact(String name, String number, String relationship,
      {String uid = 'USER_ID'}) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('emergencyContacts')
          .add({'name': name, 'number': number, 'relationship': relationship});

      emergencyContacts.add({
        'id': docRef.id,
        'name': name,
        'number': number,
        'relationship': relationship,
      });

      notifyListeners();
    } catch (e) {
      print('⚠️ Error adding emergency contact: $e');
    }
  }

  Future<void> deleteEmergencyContact(String id, {String uid = 'USER_ID'}) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('emergencyContacts')
          .doc(id)
          .delete();

      emergencyContacts.removeWhere((c) => c['id'] == id);
      notifyListeners();
    } catch (e) {
      print('⚠️ Error deleting emergency contact: $e');
    }
  }
}
