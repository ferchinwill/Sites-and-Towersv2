import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'pantalla_sitios.dart';
import 'pantalla_torres.dart';
import 'package:flutter/services.dart' show rootBundle;

class PantallaMapa extends StatefulWidget {
  final Sitio? sitioSeleccionado;
  final Torre? torreSeleccionada;
  const PantallaMapa({
    super.key,
    this.sitioSeleccionado,
    this.torreSeleccionada,
  });

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  List<Sitio> sitios = [];
  List<Torre> torres = [];
  bool cargando = true;
  late MapController mapController;
  LatLng? popupPosition;
  String? popupNombre;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    // Leer sitios
    final contenidoSitios = await rootBundle.loadString(
      'lib/MapsST/SITIOS.txt',
    );
    final lineasSitios = contenidoSitios.split('\n');
    final List<Sitio> listaSitios = [];
    for (final linea in lineasSitios) {
      if (linea.contains('--')) {
        final partes = linea.split('--');
        final nombre = partes[0].trim();
        final coords = partes[1].split(',');
        final lat = double.tryParse(coords[0].trim());
        final lng = double.tryParse(coords[1].trim());
        if (lat != null && lng != null) {
          listaSitios.add(Sitio(nombre: nombre, latitud: lat, longitud: lng));
        }
      }
    }
    // Leer torres
    final contenidoTorres = await rootBundle.loadString(
      'lib/MapsST/TORRES.txt',
    );
    final lineasTorres = contenidoTorres.split('\n');
    final List<Torre> listaTorres = [];
    for (final linea in lineasTorres) {
      if (linea.contains('--')) {
        final partes = linea.split('--');
        final nombre = partes[0].trim();
        final coords = partes[1].split(',');
        final lat = double.tryParse(coords[0].trim());
        final lng = double.tryParse(coords[1].trim());
        if (lat != null && lng != null) {
          listaTorres.add(Torre(nombre: nombre, latitud: lat, longitud: lng));
        }
      }
    }
    setState(() {
      sitios = listaSitios;
      torres = listaTorres;
      cargando = false;
    });
    // Centrar el mapa si hay selección
    if (widget.sitioSeleccionado != null) {
      mapController.move(
        LatLng(
          widget.sitioSeleccionado!.latitud,
          widget.sitioSeleccionado!.longitud,
        ),
        17.0,
      );
      setState(() {
        popupPosition = LatLng(
          widget.sitioSeleccionado!.latitud,
          widget.sitioSeleccionado!.longitud,
        );
        popupNombre = widget.sitioSeleccionado!.nombre;
      });
    } else if (widget.torreSeleccionada != null) {
      mapController.move(
        LatLng(
          widget.torreSeleccionada!.latitud,
          widget.torreSeleccionada!.longitud,
        ),
        17.0,
      );
      setState(() {
        popupPosition = LatLng(
          widget.torreSeleccionada!.latitud,
          widget.torreSeleccionada!.longitud,
        );
        popupNombre = widget.torreSeleccionada!.nombre;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    // Si hay selección, solo mostrar ese pin
    List<Marker> markers = [];
    if (widget.sitioSeleccionado != null) {
      final sitio = widget.sitioSeleccionado!;
      markers.add(
        Marker(
          width: 60.0,
          height: 60.0,
          point: LatLng(sitio.latitud, sitio.longitud),
          child: GestureDetector(
            onTap: () {
              setState(() {
                popupPosition = LatLng(sitio.latitud, sitio.longitud);
                popupNombre = sitio.nombre;
              });
            },
            child: const Icon(Icons.wifi, color: Colors.blue, size: 36),
          ),
        ),
      );
    } else if (widget.torreSeleccionada != null) {
      final torre = widget.torreSeleccionada!;
      markers.add(
        Marker(
          width: 60.0,
          height: 60.0,
          point: LatLng(torre.latitud, torre.longitud),
          child: GestureDetector(
            onTap: () {
              setState(() {
                popupPosition = LatLng(torre.latitud, torre.longitud);
                popupNombre = torre.nombre;
              });
            },
            child: const Icon(
              Icons.cell_tower,
              color: Colors.deepPurple,
              size: 36,
            ),
          ),
        ),
      );
    } else {
      // Vista general: todos los pines
      markers = [
        ...sitios.map(
          (sitio) => Marker(
            width: 60.0,
            height: 60.0,
            point: LatLng(sitio.latitud, sitio.longitud),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  popupPosition = LatLng(sitio.latitud, sitio.longitud);
                  popupNombre = sitio.nombre;
                });
              },
              child: const Icon(Icons.wifi, color: Colors.blue, size: 36),
            ),
          ),
        ),
        ...torres.map(
          (torre) => Marker(
            width: 60.0,
            height: 60.0,
            point: LatLng(torre.latitud, torre.longitud),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  popupPosition = LatLng(torre.latitud, torre.longitud);
                  popupNombre = torre.nombre;
                });
              },
              child: const Icon(
                Icons.cell_tower,
                color: Colors.deepPurple,
                size: 36,
              ),
            ),
          ),
        ),
      ];
    }
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: markers.isNotEmpty
              ? markers[0].point
              : LatLng(22.234779, -97.868120),
          initialZoom: 15.0,
          minZoom: 3,
          maxZoom: 19,
          onTap: (_, __) {
            setState(() {
              popupPosition = null;
              popupNombre = null;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.innova.sitiostorres',
          ),
          MarkerLayer(markers: markers),
          if (popupPosition != null && popupNombre != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 180,
                  height: 60,
                  point: popupPosition!,
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        popupNombre!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
