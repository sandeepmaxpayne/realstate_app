import 'package:flutter/material.dart';

class Gradients {
  static LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.green,
      Color(0xFF23E9A6),
    ],
  );

  static LinearGradient curvesGradient1 = LinearGradient(
    colors: [
      Colors.orange,
      Color(0xFFF98A5D),
      Colors.deepOrange,
    ],
  );

  static LinearGradient curvesGradient2 = LinearGradient(
    colors: [
      Color(0xFF0DE6FE),
      Color(0xFF2DCBFE),
      Color(0xFF47B3FE),
    ],
  );

  static const LinearGradient curvesGradient3 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF88CEBC),
      Color(0xFF69C7C6),
    ],
  );

  static const Gradient headerOverlayGradient = LinearGradient(
    begin: Alignment(0.51436, 1.07565),
    end: Alignment(0.51436, -0.03208),
    stops: [
      0,
      0.17571,
      1,
    ],
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 8, 8, 8),
      Color.fromARGB(105, 45, 45, 45),
    ],
  );
}
