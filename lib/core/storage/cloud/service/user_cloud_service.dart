import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/core/storage/cloud/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:finney/core/network/connectivity_service.dart';

class UserCloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectivityService _connectivityService;
  
  // Constructor that accepts connectivity service
  UserCloudService({
    required ConnectivityService connectivityService,
  }) : _connectivityService = connectivityService;
  
  // Check internet connectivity
  Future<void> _checkConnectivity() async {
    if (!_connectivityService.isConnected) {
      throw Exception('No internet connection available. Please check your connection and try again.');
    }
  }
  
  // Get current Firebase user
  User? get currentUser => _auth.currentUser;
  
  // User document reference
  DocumentReference get _userDocument {
    User? user = currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return _firestore.collection('users').doc(user.uid);
  }
  
  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    try {
      await _checkConnectivity();
      
      DocumentSnapshot doc = await _userDocument.get();
      
      if (!doc.exists) {
        return null;
      }
      
      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      rethrow;
    }
  }
  
  // Set or update the current user data
  Future<void> setCurrentUser(UserModel user) async {
    try {
      await _checkConnectivity();
      
      await _userDocument.set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error setting current user: $e');
      rethrow;
    }
  }
  
  // Get a stream of the current user data
  Stream<UserModel?> streamCurrentUser() {
    try {
      if (!_connectivityService.isConnected) {
        return Stream.error('No internet connection available.');
      }
      
      return _userDocument.snapshots().map((doc) {
        if (!doc.exists) {
          return null;
        }
        
        return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      });
    } catch (e) {
      debugPrint('Error streaming current user: $e');
      return Stream.error(e);
    }
  }
  
  // Update specific user fields
  Future<void> updateUser(Map<String, dynamic> data) async {
    try {
      await _checkConnectivity();
      
      await _userDocument.update(data);
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }
  
  // Update user name
  Future<void> updateUserName(String name) async {
    try {
      await _checkConnectivity();
      
      await _userDocument.update({'name': name});
      
      // Also update Auth display name for consistency
      if (currentUser != null) {
        await currentUser!.updateDisplayName(name);
      }
    } catch (e) {
      debugPrint('Error updating user name: $e');
      rethrow;
    }
  }
  
  // Update user phone number
  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      await _checkConnectivity();
      
      await _userDocument.update({'phoneNumber': phoneNumber});
    } catch (e) {
      debugPrint('Error updating phone number: $e');
      rethrow;
    }
  }
  
  // Update user photo URL
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await _checkConnectivity();
      
      await _userDocument.update({'photoUrl': photoUrl});
      
      // Also update Auth photo URL for consistency
      if (currentUser != null) {
        await currentUser!.updatePhotoURL(photoUrl);
      }
    } catch (e) {
      debugPrint('Error updating photo URL: $e');
      rethrow;
    }
  }
  
  // Update user preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    try {
      await _checkConnectivity();
      
      await _userDocument.update({'preferences': preferences});
    } catch (e) {
      debugPrint('Error updating preferences: $e');
      rethrow;
    }
  }
  
  // Update a single preference
  Future<void> updatePreference(String key, dynamic value) async {
    try {
      await _checkConnectivity();
      
      UserModel? user = await getCurrentUser();
      if (user == null) {
        throw Exception('User not found');
      }
      
      Map<String, dynamic> preferences = user.preferences ?? {};
      preferences[key] = value;
      
      await _userDocument.update({'preferences': preferences});
    } catch (e) {
      debugPrint('Error updating preference: $e');
      rethrow;
    }
  }
  
  // Delete user account and data
  Future<void> deleteUser(String password) async {
    try {
      await _checkConnectivity();
      
      // First reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      
      await currentUser!.reauthenticateWithCredential(credential);
      
      // Delete user data from Firestore
      await _userDocument.delete();
      
      // Delete user authentication
      await currentUser!.delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
  
  // Check if user email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;
  
  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _checkConnectivity();
      
      await currentUser?.sendEmailVerification();
    } catch (e) {
      debugPrint('Error sending email verification: $e');
      rethrow;
    }
  }
  
  // Change user email
  Future<void> changeEmail(String newEmail, String password) async {
    try {
      await _checkConnectivity();
      
      // Reauthenticate the user first
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      
      await currentUser!.reauthenticateWithCredential(credential);
      
      // Update email in Auth
      await currentUser!.verifyBeforeUpdateEmail(newEmail);
      
      // Update email in Firestore
      await _userDocument.update({'email': newEmail});
    } catch (e) {
      debugPrint('Error changing email: $e');
      rethrow;
    }
  }
  
  // Change user password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _checkConnectivity();
      
      // Reauthenticate the user first
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );
      
      await currentUser!.reauthenticateWithCredential(credential);
      
      // Update password
      await currentUser!.updatePassword(newPassword);
    } catch (e) {
      debugPrint('Error changing password: $e');
      rethrow;
    }
  }
  
  // Create a new user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email, 
    String password,
    String name,
  ) async {
    try {
      await _checkConnectivity();
      
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(name);
      
      // Create initial user data in Firestore
      UserModel newUser = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
      );
      
      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toMap());
      
      return credential;
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }
  
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _checkConnectivity();
      
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _checkConnectivity();
      
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _checkConnectivity();
      
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error resetting password: $e');
      rethrow;
    }
  }
}