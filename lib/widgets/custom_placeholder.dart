import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';

class CustomPlaceholder extends StatefulWidget {
  const CustomPlaceholder(
      {Key? key,
      required this.icon,
      this.message = '',
      this.textColor,
      required this.size,
      this.bgColor})
      : super(key: key);
  final double size;
  final IconData icon;
  final Color? bgColor;
  final Color? textColor;
  final String message;

  @override
  State<CustomPlaceholder> createState() => _CustomPlaceholderState();
}

class _CustomPlaceholderState extends State<CustomPlaceholder>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.bgColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animationController!,
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: const Color(0xFFAEB4B7),
                ),
              ),
              if (widget.message.isNotEmpty)
                SizedBox(
                  height: d.pSH(10),
                ),
              if (widget.message.isNotEmpty)
                Text(
                  widget.message,
                  style:
                      TextStyle(color: widget.textColor, fontSize: d.pSH(16)),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
