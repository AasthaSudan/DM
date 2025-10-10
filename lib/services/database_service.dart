import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  // Load user data from Firestore
  Future<void> loadUserData({required String uid}) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userData = doc.data();
      } else {
        // Initialize with default data if user document doesn't exist
        userData = {
          'safetyScore': 0,
          'modulesCompleted': 0,
          'rank': 'Beginner',
          'name': '',
          'email': '',
        };
        await _firestore.collection('users').doc(uid).set(userData!);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Update user profile info
  Future<void> updateUserProfile(Map<String, dynamic> data, {required String uid}) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      userData?.addAll(data);
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  // Increment modules completed and update safety score
  Future<void> updateProgress({required String uid, int modules = 0, int score = 0}) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) throw Exception("User not found");
        final currentData = snapshot.data()!;
        final newModules = (currentData['modulesCompleted'] ?? 0) + modules;
        final newScore = (currentData['safetyScore'] ?? 0) + score;
        transaction.update(docRef, {
          'modulesCompleted': newModules,
          'safetyScore': newScore,
        });
      });
    } catch (e) {
      print('Error updating progress: $e');
    }
  }
}
