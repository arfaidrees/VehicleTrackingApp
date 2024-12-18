// ProfilePage.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Repository/firebaseRepository.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  String username = "USERNAME";
  String email = "EMAILS";
  String contact = "CONTACT";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic>? data =
      await _firebaseRepository.getProfileData(user.uid);
      if (data != null) {
        setState(() {
          username = data['username'] ?? "USERNAME";
          email = data['email'] ?? "EMAILS";
          contact = data['contact'] ?? "CONTACT";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage:
                    const AssetImage('assets/images/default.png'),
                    onBackgroundImageError: (error, stackTrace) => const Icon(
                      Icons.person,
                      size: 140,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Name
                  ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFF520521)),
                    title: Text(
                      'Name',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      username,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(color: Colors.grey),

                  // Email
                  ListTile(
                    leading: const Icon(Icons.email, color: Color(0xFF520521)),
                    title: Text(
                      'Email',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      email,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(color: Colors.grey),

                  // Contact
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF520521)),
                    title: Text(
                      'Contact',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      contact,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
