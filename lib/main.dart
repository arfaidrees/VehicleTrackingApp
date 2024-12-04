import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            appId: "1:181059528753:android:663a256d76ef8842aa8d10"
        )
    );
    print("Firebase Initialized");
  } catch(e) {
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
  @override
  void initState() {
    super.initState();


    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      );
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/vta.png'),
      ),
    );
  }
}
