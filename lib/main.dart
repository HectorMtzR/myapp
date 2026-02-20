import 'package:flutter/material.dart';
import 'screens/homePage.dart';

void main() => runApp(const CitaDiaria());

class CitaDiaria extends StatelessWidget {
  const CitaDiaria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const FrasePage(),
    );
  }
}