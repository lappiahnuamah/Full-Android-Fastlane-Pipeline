import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  final int _correctAnswerIndex = 1;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleAnswer(int index) {
    if (index == _correctAnswerIndex) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                double offset = 0;
                if (index != _correctAnswerIndex &&
                    _shakeController.isAnimating) {
                  offset = _shakeAnimation.value;
                }

                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: GestureDetector(
                    onTap: () => _handleAnswer(index),
                    child: AnimatedBuilder(
                      animation: _scaleController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: index == _correctAnswerIndex &&
                                  _scaleController.isAnimating
                              ? _scaleAnimation.value
                              : 1.0,
                          child: child,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        color: Colors.blue,
                        child: Text(
                          'Answer ${index + 1}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
