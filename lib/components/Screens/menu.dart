import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Profile.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rowsData = [
      {'text': 'Profile', 'icon': Icons.person_outline},
      {'text': 'Setting', 'icon': Icons.settings},
      {'text': 'Help', 'icon': Icons.help_center_outlined},
    ];

    return Container(
      color: const Color(0xFF520521),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Header with Avatar and Menu Title
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/vta.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 120, width: 10),
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Menu Items
            Column(
              children: rowsData.map((rowData) {
                return Column(
                  children: [
                    NewRow(
                      text: rowData['text'],
                      icon: rowData['icon'],
                      onTap: () {
                        switch (rowData['text']) {
                          case 'Profile':
                            Get.to(ProfilePage());
                            break;
                          case 'Setting':
                            Get.to(Settings());
                            break;
                          case 'Help':
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Help is not implemented yet!')),
                            );
                            break;
                          default:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${rowData['text']} is not implemented yet!')),
                            );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),

            // Logout Row
            Row(
              children: <Widget>[
                Icon(
                  Icons.logout,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  NewRow({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
