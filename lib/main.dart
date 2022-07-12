import 'package:flutter/material.dart';
import 'package:gift_manager/presentation/login/view/login_page.dart';
import 'package:gift_manager/presentation/theme/dark_theme.dart';
import 'package:gift_manager/presentation/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const LoginPage(),
    );
  }
}
