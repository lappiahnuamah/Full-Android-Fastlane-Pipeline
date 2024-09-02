import 'package:flutter/material.dart';

class IncreasingNumberAnimation extends StatefulWidget {
  final int from;
  final int to;

  final TextStyle? style;
  final int? duration;

  IncreasingNumberAnimation(
      {required this.from, required this.to, this.style, this.duration});

  @override
  _IncreasingNumberAnimationState createState() =>
      _IncreasingNumberAnimationState();
}

class _IncreasingNumberAnimationState extends State<IncreasingNumberAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration ?? 3),
      vsync: this,
    );

    _animation =
        IntTween(begin: widget.from, end: widget.to).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_animation.value}',
      style: widget.style ?? TextStyle(fontSize: 48),
    );
  }
}
