import 'package:flutter/material.dart';

class BlinkAnimation extends StatefulWidget {
  const BlinkAnimation({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _BlinkAnimationState createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<BlinkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Step 2: Initialize the AnimationController and Animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true); // Repeats the animation indefinitely

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
