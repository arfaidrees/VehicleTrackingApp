import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Location/location.dart';
import 'components/Screens/Navi.dart';
import 'components/Screens/welcome_page.dart';

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
    _timer = Timer(const Duration(seconds: 2), () async {
      if (user != null) {
        final locationcontroller = Get.put(LocationController());
        await locationcontroller.getCurrentLocation();
        await locationcontroller.initFirebaseAndLocation();
        Get.off(menustack());
      } else {
        Get.off(const WelcomeScreen());
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
      backgroundColor: const Color(0xffEEF1F3),
      body: Center(
        child: Image.asset('assets/images/vta.png'),
      ),
    );
  }
}
