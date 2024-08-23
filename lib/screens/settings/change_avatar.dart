import 'package:flutter/material.dart';
import 'package:savyminds/widgets/page_template.dart';

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({super.key});

  @override
  State<ChangeAvatar> createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: 'Change Avatar',
    );
  }
}
