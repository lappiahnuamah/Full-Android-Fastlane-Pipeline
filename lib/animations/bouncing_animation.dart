import 'package:flutter/material.dart';

class BouncingAnimation extends StatefulWidget {
  const BouncingAnimation({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  _BouncingAnimationState createState() => _BouncingAnimationState();
}

class _BouncingAnimationState extends State<BouncingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );
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
        return Transform.translate(
          offset: Offset(0, 250 * (1 - _animation.value)),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
