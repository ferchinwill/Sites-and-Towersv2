import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'pantalla_mapa.dart';
import 'PantallaMaquetaSitios.dart';

class Sitio {
  final String nombre;
  final double latitud;
  final double longitud;
  Sitio({required this.nombre, required this.latitud, required this.longitud});
}

class PantallaSitios extends StatefulWidget {
  const PantallaSitios({super.key});
  @override
  State<PantallaSitios> createState() => _PantallaSitiosState();
}

class _PantallaSitiosState extends State<PantallaSitios> {
  List<Sitio> sitios = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  Future<void> cargarSitios() async {
    final contenido = await rootBundle.loadString('lib/MapsST/SITIOS.txt');
    final lineas = contenido.split('\n');
    final List<Sitio> lista = [];
    for (final linea in lineas) {
      if (linea.contains('--')) {
        final partes = linea.split('--');
        final nombre = partes[0].trim();
        final coords = partes[1].split(',');
        final lat = double.tryParse(coords[0].trim());
        final lng = double.tryParse(coords[1].trim());
        if (lat != null && lng != null) {
          lista.add(Sitio(nombre: nombre, latitud: lat, longitud: lng));
        }
      }
    }
    setState(() {
      sitios = lista;
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
        itemCount: sitios.length,
        itemBuilder: (context, index) {
          final sitio = sitios[index];
          return GestureDetector(
            onTap: () {
              // Crear un SitioDetallado con información adicional
              final sitioDetallado = crearSitioDetallado(
                nombre: sitio.nombre,
                latitud: sitio.latitud,
                longitud: sitio.longitud,
                estado: 'Activo',
                tipo: 'Sitio de Telecomunicaciones',
                descripcion: 'Sitio de infraestructura de telecomunicaciones',
                ultimaActualizacion: 'Hoy',
                informacionAdicional: {
                  'Región': 'Tamaulipas',
                  'Operador': '',
                  'Tecnología': '',
                  'Altura': '30m',
                  'Potencia': '1000W',
                },
              );
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaMaquetaSitios(sitio: sitioDetallado),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi, size: 48, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  sitio.nombre,
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
