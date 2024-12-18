import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vehicle_tracking_app/components/Screens/login_page.dart';

class FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user with email, password, name, and contact number
  Future<String?> createUserWithEmailAndPassword(String email, String password,
      String name, String contact, String profileURL) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await setupProfile(user.uid, name, email, contact, profileURL);
      }
      return null; // No error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use.';
      } else if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else {
        return 'An error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // Login with email and password
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // No error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else {
        return 'An error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // Profile setup to save details in Firestore collection as ProfileData
  Future<void> setupProfile(String userId, String username, String email,
      String contact, String profileUrl) async {
    try {
      await _firestore.collection('ProfileData').doc(userId).set({
        'username': username,
        'email': email,
        'contact': contact,
        'profileUrl': profileUrl,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up profile: $e');
      }
    }
  }

  // Fetch profile data from Firestore
  Future<Map<String, dynamic>?> getProfileData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('ProfileData').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile data: $e');
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.off(const LoginPage());
    } catch (e) {
      Get.snackbar('Info', e.toString());
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }

  // Forgot password
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return 'An error occurred: ${e.message}';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
}
