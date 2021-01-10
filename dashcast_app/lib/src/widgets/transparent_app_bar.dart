import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black45,
      iconTheme: IconThemeData(color: Colors.black45),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
