import 'package:flutter/material.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'PEOPLE',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
