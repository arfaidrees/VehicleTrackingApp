import 'package:flutter/material.dart';

import 'map_screen.dart';
import 'menu.dart';

class menustack extends StatelessWidget {
  menustack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF1F3),
      body: Stack(
        children: [
          Menu(),
          MapScreen(),
        ],
      ),
    );
  }
}
