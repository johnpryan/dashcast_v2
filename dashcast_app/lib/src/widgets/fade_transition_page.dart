import 'package:flutter/material.dart';

class FadeTransitionPage extends Page {
  final Widget child;

  FadeTransitionPage({
    Key key,
    this.child,
  }) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
