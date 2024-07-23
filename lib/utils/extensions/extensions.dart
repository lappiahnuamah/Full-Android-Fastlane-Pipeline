import 'dart:developer';

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHex() {
    return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

extension StringExtension on Map<int, bool> {
  String mapToString() {
    List<String> parts = [];
    this.forEach((key, value) {
      parts.add('$key=$value');
    });
    return parts.join('&');
  }
}

extension MapExtension on String {
  Map<int, dynamic> stringToMap() {
    Map<int, dynamic> map = {};
    List<String> pairs = this.split('&');
    for (var pair in pairs) {
      var keyValue = pair.split('=');
      if (keyValue.length == 2) {
        final newKeyValue = (keyValue[0]).replaceAll(RegExp(r'[^0-9]'), '');
        map[int.parse(newKeyValue)] = (keyValue[1] == 'true');
      }
    }
    return map;
  }
}
