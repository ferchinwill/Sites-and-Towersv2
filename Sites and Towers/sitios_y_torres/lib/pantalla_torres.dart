import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'pantalla_mapa.dart';

class Torre {
  final String nombre;
  final double latitud;
  final double longitud;
  Torre({required this.nombre, required this.latitud, required this.longitud});
}

class PantallaTorres extends StatefulWidget {
  const PantallaTorres({super.key});
  @override
  State<PantallaTorres> createState() => _PantallaTorresState();
}

class _PantallaTorresState extends State<PantallaTorres> {
  List<Torre> torres = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarTorres();
  }

  Future<void> cargarTorres() async {
    final contenido = await rootBundle.loadString('lib/MapsST/TORRES.txt');
    final lineas = contenido.split('\n');
    final List<Torre> lista = [];
    for (final linea in lineas) {
      if (linea.contains('--')) {
        final partes = linea.split('--');
        final nombre = partes[0].trim();
        final coords = partes[1].split(',');
        final lat = double.tryParse(coords[0].trim());
        final lng = double.tryParse(coords[1].trim());
        if (lat != null && lng != null) {
          lista.add(Torre(nombre: nombre, latitud: lat, longitud: lng));
        }
      }
    }
    setState(() {
      torres = lista;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: torres.length,
        itemBuilder: (context, index) {
          final torre = torres[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaMapa(torreSeleccionada: torre),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cell_tower,
                  size: 48,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 8),
                Text(
                  torre.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
