import 'package:flutter/material.dart';

/// Widget that centers a ScrollView with a max width and displays a scrollbar.
class CenterScrollable extends StatelessWidget {
  final double width;
  final Widget child;

  CenterScrollable({
    this.width = 640,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width),
          child: child,
        ),
      ),
    );
  }
}
