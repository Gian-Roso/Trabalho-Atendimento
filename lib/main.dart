import 'package:Baquadrix/core/di/injection.dart';
import 'package:Baquadrix/modules/splash/splash_view.dart';
import 'package:flutter/material.dart';


void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baguadrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}