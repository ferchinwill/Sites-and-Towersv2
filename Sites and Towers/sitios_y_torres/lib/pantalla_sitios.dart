import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'pantalla_mapa.dart';
import 'PantallaMaquetaSitios.dart';

/// Clase que representa un sitio de telecomunicaciones
/// Contiene la información básica de ubicación y nombre del sitio
class Sitio {
  final String nombre; // Nombre del sitio (ej: "Sitio Central")
  final double latitud; // Coordenada de latitud para ubicación en mapa
  final double longitud; // Coordenada de longitud para ubicación en mapa

  /// Constructor de la clase Sitio
  /// Requiere nombre, latitud y longitud como parámetros obligatorios
  Sitio({required this.nombre, required this.latitud, required this.longitud});
}

/// Pantalla principal que muestra la lista de sitios en formato de cuadrícula
/// Esta pantalla carga los sitios desde un archivo de texto y los muestra como tarjetas
class PantallaSitios extends StatefulWidget {
  const PantallaSitios({super.key});

  @override
  State<PantallaSitios> createState() => _PantallaSitiosState();
}

/// Estado de la pantalla de sitios
/// Maneja la lógica de carga de datos y la interfaz de usuario
class _PantallaSitiosState extends State<PantallaSitios> {
  List<Sitio> sitios = [];
  List<Sitio> sitiosFiltrados = []; // Nueva lista para los sitios filtrados
  bool cargando = true;
  String busqueda = ""; // Texto actual de búsqueda
  final TextEditingController _controller = TextEditingController();

  /// Método que se ejecuta cuando el widget se inicializa
  /// Inicia la carga de sitios automáticamente
  @override
  void initState() {
    super.initState();
    cargarSitios(); // Carga los sitios al iniciar la pantalla
  }

  /// Carga los sitios desde el archivo SITIOS.txt
  /// El archivo debe estar en formato: "Nombre--latitud,longitud"
  /// Ejemplo: "Sitio Central--19.4326,-99.1332"
  Future<void> cargarSitios() async {
    // Lee el contenido del archivo de texto
    final contenido = await rootBundle.loadString('lib/MapsST/SITIOS.txt');

    // Divide el contenido en líneas individuales
    final lineas = contenido.split('\n');
    final List<Sitio> lista = [];

    // Procesa cada línea del archivo
    for (final linea in lineas) {
      // Busca líneas que contengan el separador "--"
      if (linea.contains('--')) {
        // Divide la línea en nombre y coordenadas
        final partes = linea.split('--');
        final nombre = partes[0].trim(); // Nombre del sitio

        // Divide las coordenadas en latitud y longitud
        final coords = partes[1].split(',');
        final lat = double.tryParse(coords[0].trim()); // Convierte a número
        final lng = double.tryParse(coords[1].trim()); // Convierte a número

        // Solo agrega el sitio si las coordenadas son válidas
        if (lat != null && lng != null) {
          lista.add(Sitio(nombre: nombre, latitud: lat, longitud: lng));
        }
      }
    }

    // Actualiza el estado con los sitios cargados
    setState(() {
      sitios = lista;
      sitiosFiltrados = lista; // Inicialmente muestra todos
      cargando = false; // Oculta el indicador de carga
    });
  }

  // Método para filtrar los sitios según el texto de búsqueda
  void filtrarSitios(String texto) {
    setState(() {
      busqueda = texto;
      if (texto.isEmpty) {
        sitiosFiltrados = sitios;
      } else {
        sitiosFiltrados = sitios
            .where((s) => s.nombre.toLowerCase().contains(texto.toLowerCase()))
            .toList();
      }
    });
  }

  /// Construye la interfaz de usuario de la pantalla
  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.grey[50], // Opcional, para que se vea más limpio
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                // Configuración de la cuadrícula: 3 columnas con espaciado
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columnas
                  mainAxisSpacing: 16, // Espacio vertical entre filas
                  crossAxisSpacing: 16, // Espacio horizontal entre columnas
                  childAspectRatio: 0.9, // Proporción ancho/alto de cada tarjeta
                ),
                itemCount: sitiosFiltrados.length, // Número total de sitios
                itemBuilder: (context, index) {
                  final sitio = sitiosFiltrados[index]; // Obtiene el sitio actual

                  // Cada sitio se muestra como una tarjeta táctil
                  return GestureDetector(
                    // Al tocar la tarjeta, navega a la pantalla de detalles
                    onTap: () {
                      // Crea un objeto con información detallada del sitio
                      final sitioDetallado = crearSitioDetallado(
                        nombre: sitio.nombre,
                        latitud: sitio.latitud,
                        longitud: sitio.longitud,
                        estado: 'Activo',
                        /* informacionAdicional: {
                          'Región': '',
                          'Operador': '',
                          'Tecnología': '',
                          'Altura': '30m',
                          'Potencia': '1000W',
                        },*/
                      );

                      // Navega a la pantalla de detalles del sitio
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PantallaMaquetaSitios(sitio: sitioDetallado),
                        ),
                      );
                    },
                    // Contenido visual de cada tarjeta de sitio
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icono de WiFi que representa el sitio
                        const Icon(Icons.wifi, size: 48, color: Colors.blue),
                        const SizedBox(height: 8), // Espacio entre icono y texto
                        // Nombre del sitio
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.black),
        onChanged: filtrarSitios,
      ),
    );
  }
}
