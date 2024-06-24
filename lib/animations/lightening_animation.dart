import 'package:flutter/material.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';

class StageLightingDemo extends StatefulWidget {
  const StageLightingDemo({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  _StageLightingDemoState createState() => _StageLightingDemoState();
}

class _StageLightingDemoState extends State<StageLightingDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
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
        return CustomPaint(
            painter: StageLightingPainter(_animation.value), child: child);
      },
      child: widget.child,
    );
  }
}

class StageLightingPainter extends CustomPainter {
  final double animationValue;

  StageLightingPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final gradient = LinearGradient(
      begin: Alignment(-1.5 + animationValue * 3, 0),
      end: Alignment(1.5 - animationValue * 3, 0),
      colors: [
        const Color(0xFFDEF9FB).withOpacity(0.7),
        const Color(0xFFEEDCFF).withOpacity(0.5),
        const Color(0xFFDEF9FB).withOpacity(0.7),
      ],
      stops: [0.0, 0.5, 1.0],
    );

    paint.shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
