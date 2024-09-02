import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AppUtils {
  static double getTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter.width;
  }

  static String capitalize(String input) {
    if (input.isEmpty) {
      return input; // Return the input string if it's empty
    }

    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  static RegExp phoneNumberRegex =
      RegExp(r'^(\+\d{1,3}\s?)?' // Optional country code
          r'(\d{3}[-\s]?\d{3}[-\s]?\d{4})' // Phone number with dashes or spaces
          r'(\s?x\d+)?$' // Optional extension
          );

  static RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

  static RegExp websiteRegex1 = RegExp(r'^(https?://)?' // Optional http(s)://
      r'([a-zA-Z0-9-]+\.){1,}' // Subdomain(s)
      r'([a-zA-Z]{2,})' // Domain name (e.g., .com, .org, .io)
      // r'(:[0-9]{2,5})?' // Optional port number
      r'(/[\w/#.-]*)?' // Optional path
      r'(\?[^\s]*)?' // Optional query parameters
      r'(#.*)?$' // Optional fragment identifier
      );
  static RegExp websiteRegex2 = RegExp(
      r'^(?:(\w+):\/\/)?(?:([-\w.]+)\.)?([-\w.]+)(?::(\d+))?(\/[^\s]*)?(?:\?([^\s]*))?(?:#([^\s]*))?$');

  static RegExp ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');

  static String obscurePartOfText(String text) {
    if (text.length > 30) {
      return text.substring(0, 30) + '...';
    } else {
      return text;
    }
  }

  static RegExp somePhoneNumberRegex = RegExp(
      r'^(\+1\s?)?' // Optional US country code (+1)
      r'^(\+233\s?)?' // Optional US country code (+1)
      r'\(?\d{3}\)?[-\s]?\d{3}[-\s]?\d{4}$' // Phone number with different separators
      );
}
