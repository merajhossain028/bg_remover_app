import 'package:bg_remover/view/bg_remove_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Remove',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BackgroundRemoveScreen(),
    );
  }
}
