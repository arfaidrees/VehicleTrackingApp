import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'menu.dart';

class menustack extends StatelessWidget {
  menustack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Menu(),
          MapScreen(),
        ],
      ),
    );
  }
}