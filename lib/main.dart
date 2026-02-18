import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Prueba de commit

void main() => runApp(CitaDiaria());

class CitaDiaria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: FrasePage());
  }
}

class FrasePage extends StatefulWidget {
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
  ];
  Color _colorActual = Colors.white;

  final List<String> _frases = [
    "El código es poesía transmitida en un mundo digital.",
    "La mejor forma de aprender es construyendo proyectos reales.",
    "Cero Miedo",
    "Fallas el 100% de los tiros que no haces",
    "Te deseo éxito, suerte no, por que la suerte es para los mediocres.",
  ];

  String _fraseActual = "Presiona el botón para motivarte.";

  // Favoritos
  final List<String> _favoritos = [];
  bool get _esFavorita => _favoritos.contains(_fraseActual);

  // ✅ ACTIVIDAD 3.1: Agregar frases propias (FAB -> AlertDialog + TextField)
  Future<void> _mostrarDialogoNuevaFrase() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Añadir frase"),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Escribe tu frase...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final texto = controller.text.trim();
              if (texto.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("La frase no puede estar vacía."),
                    duration: Duration(seconds: 1),
                  ),
                );
                return;
              }

              setState(() {
                _frases.add(texto); // ✅ agrega a la lista de frases
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Frase añadida ✅"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text("Añadir"),
          ),
        ],
      ),
    );
  }

  // ✅ ACTIVIDAD 2.3: No repetir la misma frase consecutivamente
  void _generarNuevaFrase() {
    final random = Random();

    setState(() {
      if (_frases.isNotEmpty) {
        String nuevaFrase;

        if (_frases.length == 1) {
          nuevaFrase = _frases.first;
        } else {
          do {
            nuevaFrase = _frases[random.nextInt(_frases.length)];
          } while (nuevaFrase == _fraseActual);
        }

        _fraseActual = nuevaFrase;
      }

      _colorActual = _colores[random.nextInt(_colores.length)];
    });
  }

  // Favoritos: guardar sin duplicar
  void _guardarEnFavoritos() {
    if (_favoritos.contains(_fraseActual)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Esa frase ya está en favoritos ✅"),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() => _favoritos.add(_fraseActual));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Agregada a favoritos ❤️"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // ✅ ACTIVIDAD 2.2 + (para Actividad 3): navegar y traer lista actualizada al volver
  Future<void> _irAFavoritos() async {
    final updated = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesPage(favoritos: List.from(_favoritos)),
      ),
    );

    if (updated != null) {
      setState(() {
        _favoritos
          ..clear()
          ..addAll(updated);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorActual,
      appBar: AppBar(
        title: Text("Mi app de motivación", style: GoogleFonts.pacifico()),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _guardarEnFavoritos,
            icon: Icon(
              _esFavorita ? Icons.favorite : Icons.favorite_border,
              color: _esFavorita ? Colors.red : Colors.grey,
            ),
            tooltip: "Guardar en favoritos",
          ),
          IconButton(
            onPressed: _irAFavoritos,
            icon: const Icon(Icons.list_alt, color: Colors.black87),
            tooltip: "Ver favoritos",
          ),
        ],
      ),

      // ✅ ACTIVIDAD 3.1: FAB para agregar frase
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaFrase,
        child: const Icon(Icons.add),
        tooltip: "Añadir frase",
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white.withOpacity(0.92),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    _fraseActual,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pacifico(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generarNuevaFrase,
                child: const Text("Nueva frase"),
              ),
              const SizedBox(height: 12),
              Text(
                "Favoritos: ${_favoritos.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ ACTIVIDAD 3.2 + 3.3: ListView.builder + Dismissible
class FavoritesPage extends StatefulWidget {
  final List<String> favoritos;

  const FavoritesPage({super.key, required this.favoritos});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<String> _favoritosLocal;

  @override
  void initState() {
    super.initState();
    _favoritosLocal = List.from(widget.favoritos);
  }

  void _volver() {
    Navigator.pop(context, _favoritosLocal); // ✅ regresa la lista actualizada
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _volver();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mis Favoritos"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _volver, // ✅ asegura devolver lista al regresar
          ),
        ),
        body: _favoritosLocal.isEmpty
            ? const Center(child: Text("Aún no tienes frases guardadas."))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favoritosLocal.length,
                itemBuilder: (context, index) {
                  final frase = _favoritosLocal[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: ValueKey(frase), // ✅ clave única
                      direction: DismissDirection.endToStart, // ✅ swipe izquierda
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        final eliminada = frase;

                        setState(() {
                          _favoritosLocal.removeAt(index);
                        });

                        // opcional: deshacer
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Frase eliminada 🗑️"),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: "DESHACER",
                              onPressed: () {
                                setState(() {
                                  _favoritosLocal.insert(index, eliminada);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            frase,
                            style: GoogleFonts.pacifico(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
