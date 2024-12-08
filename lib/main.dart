import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_tracking_app/components/Screens/map_screen.dart';

import 'components/Screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBXlKJr66TJV19ZTKM9upt7zc_kjYMgoXA",
            authDomain: "location-e5cc0.firebaseapp.com",
            projectId: "vehicle-tracking-app-b0f9c",
            messagingSenderId: "181059528753",
            appId: "1:181059528753:android:663a256d76ef8842aa8d10"));
    print("Firebase Initialized");
  } catch (e) {
    print("Initialize failed: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    _timer = Timer(const Duration(seconds: 2), () {
      if (user != null) {
        Get.off(MapScreen());
      } else {
        Get.off(const LoginPage());
      }
    });
    checkFirebaseConnection();
  }

  void checkFirebaseConnection() async {
    try {
      await FirebaseFirestore.instance.collection('users').get();
      print('Firebase Firestore is connected');
    } catch (e) {
      print('Failed to connect to Firestore: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/vta.png'),
      ),
    );
  }
}
