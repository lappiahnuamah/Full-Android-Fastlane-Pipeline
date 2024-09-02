import 'package:flutter/material.dart';

class ScalingAnimationWidget extends StatefulWidget {
  final Widget child;

  const ScalingAnimationWidget({Key? key, required this.child})
      : super(key: key);
  @override
  _ScalingAnimationWidgetState createState() => _ScalingAnimationWidgetState();
}

class _ScalingAnimationWidgetState extends State<ScalingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation back and forth

    _animation = Tween<double>(begin: 0.92, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
