import 'package:flutter/material.dart';
import 'package:content_generator/features/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Architect AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003AA0)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
