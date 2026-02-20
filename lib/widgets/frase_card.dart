import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FraseCard extends StatelessWidget {
  final String frase;

  const FraseCard({super.key, required this.frase});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.92),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          frase,
          textAlign: TextAlign.center,
          style: GoogleFonts.pacifico(fontSize: 20, color: Colors.black87),
        ),
      ),
    );
  }
}