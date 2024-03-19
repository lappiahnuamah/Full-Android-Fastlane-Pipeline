// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class OverlayModel {
  String title;
  String ?subtitle;
  String? leadingImage;
  Widget? trailing;

  OverlayModel({
    required this.title,
     this.subtitle,
    this.leadingImage,
    this.trailing,
  });
}
