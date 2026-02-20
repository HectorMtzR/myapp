import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'favorites_page.dart';
import '../widgets/frase_card.dart';

class FrasePage extends StatefulWidget {
  const FrasePage({super.key});

  @override
  _FrasePageState createState() => _FrasePageState();
}

class _FrasePageState extends State<FrasePage> {
  final List<Color> _colores = [
    Colors.red,
    Colors.blue, 
    Colors.orange, 
    Colors.green, 
    Colors.purple, 
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.pink,
    ];
  Color _colorActual = Colors.indigo;
  
  final List<String> _frases = [

    "El código es poesía transmitida en un mundo digital.",

    "La mejor forma de aprender es construyendo proyectos reales.",

    "Cero Miedo",

    "Fallas el 100% de los tiros que no haces",

    "Te deseo éxito, suerte no, por que la suerte es para los mediocres.",

    "El código es como el humor. Cuando tienes que explicarlo, no es tan bueno.",

    "La simplicidad es la máxima sofisticación.",

    "El código limpio siempre gana.",

    "No te preocupes por el fracaso, preocúpate por las oportunidades que pierdes cuando ni siquiera lo intentas.",

    "El código es como un jardín: si no lo cuidas, se llena de maleza.",

    "La programación es el arte de convertir café en código.",

  ];

  String _fraseActual = "Presiona el botón para motivarte.";
  final List<String> _favoritos = [];

  bool get _esFavorita => _favoritos.contains(_fraseActual);

  Future<void> _mostrarDialogoNuevaFrase() async {
    final controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Añadir nueva frase"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Escribe tu frase aquí..."),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _frases.add(controller.text);
                  _fraseActual = controller.text; // Mostramos la nueva frase de una vez
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _generarNuevaFrase() {
    final random = Random();
    setState(() {
      String nueva;
      do {
        nueva = _frases[random.nextInt(_frases.length)];
      } while (nueva == _fraseActual && _frases.length > 1);
      _fraseActual = nueva;
      _colorActual = _colores[random.nextInt(_colores.length)];
    });
  }

  void _guardarEnFavoritos() {
    setState(() {
      if (_esFavorita) {
        _favoritos.remove(_fraseActual);
      } else {
        _favoritos.add(_fraseActual);
      }
    });
  }

  Future<void> _irAFavoritos() async {
    final updated = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => FavoritesPage(favoritos: List.from(_favoritos))),
    );
    if (updated != null) setState(() => _favoritos..clear()..addAll(updated));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorActual,
      appBar: AppBar(
        title: Text("Motivación", style: GoogleFonts.pacifico()),
        actions: [
          IconButton(
            icon: Icon(_esFavorita ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: _guardarEnFavoritos,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _irAFavoritos,
          ),
        ],
      ),
      // --- BOTÓN PARA AÑADIR ---
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaFrase,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FraseCard(frase: _fraseActual),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generarNuevaFrase, 
              child: const Text("Nueva frase")
            ),
          ],
        ),
      ),
    );
  }
}