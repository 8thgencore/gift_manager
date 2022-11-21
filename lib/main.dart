import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/observer.dart';
import 'package:gift_manager/presentation/splash/view/splash_page.dart';
import 'package:gift_manager/presentation/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashPage(),
    );
  }
}
