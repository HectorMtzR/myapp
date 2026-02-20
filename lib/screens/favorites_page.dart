import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    Navigator.pop(context, _favoritosLocal);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope( // Nota: WillPopScope está deprecado en versiones nuevas, usa PopScope
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _volver();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mis Favoritos"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _volver,
          ),
        ),
        body: _favoritosLocal.isEmpty
            ? const Center(child: Text("Aún no tienes frases guardadas."))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favoritosLocal.length,
                itemBuilder: (context, index) {
                  final frase = _favoritosLocal[index];
                  return Dismissible(
                    key: ValueKey(frase),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red.shade400,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      setState(() => _favoritosLocal.removeAt(index));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(frase, style: GoogleFonts.pacifico()),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}