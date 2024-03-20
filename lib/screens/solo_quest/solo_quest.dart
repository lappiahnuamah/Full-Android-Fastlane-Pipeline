import 'package:flutter/material.dart';

class SoloQuest extends StatefulWidget {
  const SoloQuest({super.key});

  @override
  State<SoloQuest> createState() => _SoloQuestState();
}

class _SoloQuestState extends State<SoloQuest> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Solo Quest'),
    );
  }
}
