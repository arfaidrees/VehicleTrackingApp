
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & FAQs'),
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
                  const Icon(
                    Icons.help_outline,
                    size: 100,
                    color: Color(0xFF520521),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Need Assistance?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'We are here to help you with all your questions and issues.',
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

            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF520521),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),

            // FAQ 1
            ExpansionTile(
              title: const Text(
                'How can I track my vehicle on the map?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'You can track your vehicle\'s current location by opening the map feature in the app. Ensure your GPS is enabled and your vehicle is connected.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),

            // FAQ 2
            ExpansionTile(
              title: const Text(
                'Why is the location not updating?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Ensure your vehicle\'s tracking device is powered on and has a stable network connection. If the issue persists, contact our support team.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),

            // FAQ 3
            ExpansionTile(
              title: const Text(
                'Can I track multiple vehicles at once?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Yes, you can track multiple vehicles by selecting them from the map screen.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),

            // FAQ 4
            ExpansionTile(
              title: const Text(
                'What should I do if the app crashes?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Try restarting the app and ensure it is updated to the latest version. If the problem continues, contact our support team.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),

            const SizedBox(height: 20),

            // Contact Support
            const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF520521),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'If you didn\'t find the answer you were looking for, feel free to reach out to us at:',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Email: support@vehicletracker.com',
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
