import 'package:flutter/material.dart';

class TextOnImage extends StatelessWidget {
  const TextOnImage({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Image(
          image: AssetImage(
            "assets/images/car.png",
          ),
          height: 150,
          width: 150,
        ),
      ],
    );
  }
}
