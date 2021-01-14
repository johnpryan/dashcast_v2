import 'package:flutter/material.dart';

import 'api.dart';
import 'screens/home_screen.dart';

// Uri serverUri
//   = Uri.parse('http://localhost:8080/');

Uri serverUri
  = Uri.parse('http://35.212.136.55:8080/');

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
