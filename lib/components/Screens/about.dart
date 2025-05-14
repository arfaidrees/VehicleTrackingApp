// AboutPage.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  const Text(
                    'Welcome to Our App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your one-stop solution for all your needs.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // About Content
            const Text(
              'About the App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF520521),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'This app is designed to provide seamless solutions to everyday challenges related to vehicle tracking. Whether you need to monitor the real-time location of your vehicles, enhance  management efficiency, or ensure the safety, we have it all covered.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),

            const SizedBox(height: 20),

            const Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF520521),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'To empower individuals and businesses with cutting-edge technology that simplifies vehicle tracking and improves overall operational efficiency',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),

            const SizedBox(height: 20),

            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF520521),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'Email: contact@vehicletracking.com',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 5),
            const Text(
              'Phone: +123 456 7890',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
