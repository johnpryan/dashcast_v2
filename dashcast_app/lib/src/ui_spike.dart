import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(UiSpike());
}

class UiSpike extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black45,
        iconTheme: IconThemeData(color: Colors.black26),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'DashCast',
                    style: GoogleFonts.openSans().copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _PodcastRow(title: 'Recommended'),
              _PodcastRow(),
              _PodcastRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PodcastRow extends StatelessWidget {
  final String title;

  _PodcastRow({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended',
                style: GoogleFonts.openSans().copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                child: Text('See all'),
                onPressed: () {},
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 200),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, idx) {
              return ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 120),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Colors.grey,
                        margin: EdgeInsets.all(8),
                        child: Center(
                          child: Text('$idx'),
                        ),
                      ),
                    ),
                    Text('Podcast name'),
                  ],
                ),
              );
            },
            itemCount: 12,
          ),
        )
      ],
    );
  }
}
