import 'package:flutter/material.dart';

class AppGradients {
  ////
  ///
  static final landingGradient = RadialGradient(
    center: Alignment(0.0, 0.0), // Center of the container
    radius: 1.0, // Define the size of the gradient
    colors: [
      Color(0xFFD9FFFD),
      Color(0xFFDEF9FB),
      Color(0xFFEEDCFF),
    ],
    stops: [0.0, 0.375, 1.0],
  );
}
