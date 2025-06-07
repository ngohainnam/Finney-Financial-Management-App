import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/common/snack_bar.dart';
import '../../../core/storage/storage_manager.dart';
import '../../../core/storage/cloud/models/user_model.dart';

class GoogleSignInService {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out from any previous Google accounts first
      await googleSignIn.signOut(); 

      // Start the Google sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in flow

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a credential for Firebase from the tokens
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Optional: Save user data to Firestore to ensure it exists
      User? user = userCredential.user;
      if (user != null) {
        // Use the StorageManager's userCloudService to ensure the user exists in Firestore
        final userService = StorageManager().userCloudService;
        
        // Create a UserModel instance from Firebase user data
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Unknown',
        );
        
        // Save the user to Firestore
        await userService.setCurrentUser(userModel);
      }
    } catch (error) {
      AppSnackBar.showError(context, message: 'Google Sign-In failed.');
    }
  }
}