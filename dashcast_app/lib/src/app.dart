import 'package:flutter/material.dart';

import 'api.dart';
import 'screens/home_screen.dart';

// final serverUri = Uri.parse('http://localhost:8080');
final serverUri = Uri.parse('https://dashcast.net/');

class DashcastApp extends StatefulWidget {
  @override
  _DashcastAppState createState() => _DashcastAppState();
}

class _DashcastAppState extends State<DashcastApp> {
  DashcastApi api;

  void initState() {
    super.initState();

    api = DashcastApi(serverUri);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(api: api),
    );
  }
}
