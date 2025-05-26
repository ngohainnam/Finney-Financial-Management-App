import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class to handle all user settings operations
class UserSettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Load user data from Firestore
  Future<Map<String, dynamic>> loadUserData() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .get();
          
      if (doc.exists) {
        return doc.data() ?? {};
      } else {
        // Create a new user document if it doesn't exist
        final defaultData = {
          'name': '',
          'phone': '',
          'address': '',
          'email': currentUser?.email ?? '',
          'textSize': 'Medium',
          'language': await getLanguagePreference(),
        };
        
        await _firestore
            .collection('users')
            .doc(currentUser?.uid)
            .set(defaultData);
            
        return defaultData;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      return {};
    }
  }
  
  // Save user data to Firestore
  Future<bool> saveUserData({
    required String name,
    required String phone,
    required String address,
    required String textSize,
    required String language,
  }) async {
    try {
      // Save language preference to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String languageCode = language == 'English' ? 'en' : 'bn';
      await prefs.setString('language', languageCode);
      
      // Update Firestore
      await _firestore.collection('users').doc(currentUser?.uid).set({
        'name': name,
        'phone': phone,
        'address': address,
        'email': currentUser?.email ?? '',
        'textSize': textSize,
        'language': language,
      }, SetOptions(merge: true));
      
      // Update app locale
      FlutterLocalization.instance.translate(languageCode);
      
      return true;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      return false;
    }
  }
  
  // Get language preference from SharedPreferences
  Future<String> getLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    return languageCode == 'en' ? 'English' : 'Bengali';
  }
  
  // Save security PIN
  Future<bool> saveSecurityPin(String pin) async {
    try {
      await _firestore.collection('users').doc(currentUser?.uid).set(
        {'pin': pin},
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      debugPrint('Error saving PIN: $e');
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}