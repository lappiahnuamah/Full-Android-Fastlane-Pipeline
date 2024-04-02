import 'package:flutter/material.dart';

Future nextScreen(context, page) async {
  return await Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
}

Future nextScreenReplace(context, page) async {
  return await Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
