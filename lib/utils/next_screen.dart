import 'package:flutter/material.dart';

Future nextScreen(context, page, [TransitionType? transitionType]) async {
  return await Navigator.of(context)
      .push(createRoute(page, transitionType ?? TransitionType.fade));
}

Future nextScreenReplace(
  context,
  page,
  [TransitionType? transitionType]
) async {
  
  return await Navigator.pushReplacement(
      context,createRoute(page, transitionType ?? TransitionType.fade));
}

Future nextScreenCloseOthers(context, page,[TransitionType? transitionType]) async {
  return await Navigator.pushAndRemoveUntil(
      context,
      createRoute(page, transitionType ?? TransitionType.fade),
      (Route<dynamic> route) => false);
}

enum TransitionType { slide, fade, scale, rotation, combined }

Route createRoute(Widget page, TransitionType transitionType) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.slide:
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        case TransitionType.fade:
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        case TransitionType.scale:
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        case TransitionType.rotation:
          return RotationTransition(
            turns: animation,
            child: child,
          );
        case TransitionType.combined:
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        default:
          return child;
      }
    },
  );
}
