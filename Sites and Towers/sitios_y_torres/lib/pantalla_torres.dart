import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'pantalla_mapa.dart';
import 'PantallaMaquetaTorres.dart';

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
  List<Torre> torresFiltradas = [];
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
      torresFiltradas = lista;
      cargando = false;
    });
  }

  void filtrarTorres(String query) {
    final filtradas = torres.where((torre) =>
      torre.nombre.toLowerCase().contains(query.toLowerCase())
    ).toList();
    setState(() {
      torresFiltradas = filtradas;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: torresFiltradas.length,
              itemBuilder: (context, index) {
                final torre = torresFiltradas[index];
                return GestureDetector(
                  onTap: () {
                    final torreDetallada = crearTorreDetallada(
                      nombre: torre.nombre,
                      latitud: torre.latitud,
                      longitud: torre.longitud,
                      // Puedes agregar más datos si tienes
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaMaquetaTorres(torre: torreDetallada),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cell_tower,
                          size: 48,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(height: 8),
                        Text(
                          torre.nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
