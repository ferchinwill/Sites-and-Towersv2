import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'pantalla_mapa.dart';
import 'pantalla_torres.dart';
import 'package:flutter/rendering.dart';

class TorreDetallada {
  final String nombre;
  final double latitud;
  final double longitud;

  final String? estado;
  final String? tipo;
  final String? descripcion;
  final String? ultimaActualizacion;
  final Map<String, dynamic>? informacionAdicional;

  TorreDetallada({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    this.estado,
    this.tipo,
    this.descripcion,
    this.ultimaActualizacion,
    this.informacionAdicional,
  });
}

class PantallaMaquetaTorres extends StatefulWidget {
  final TorreDetallada torre;

  const PantallaMaquetaTorres({super.key, required this.torre});

  @override
  State<PantallaMaquetaTorres> createState() => _PantallaMaquetaTorresState();
}

class _PantallaMaquetaTorresState extends State<PantallaMaquetaTorres> {
  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.torre.nombre),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _cargando = true;
              });
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _cargando = false;
                });
              });
            },
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildInfoBasica(),
                  _buildInventario(),
                  _buildActividadesTecnicas(),
                  _buildCoordenadas(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
           const Color(0xFF2196F3).withOpacity(0.9),     // Azul claro
           const Color.fromARGB(255, 3, 60, 117).withOpacity(0.9), // Azul oscuro
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.asset(
                  'Imagenes/imageheader.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'Imagenes/SiteImagen.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.torre.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.torre.estado != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.torre.estado!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle,
                        color: widget.torre.estado == 'Activo'
                            ? Colors.green
                            : Colors.orange,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBasica() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: const Text(
          'Información de la Torre',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        children: [
          const SizedBox(height: 12),
          _buildInfoRow('Tipo', widget.torre.tipo ?? 'Desconocido'),
          _buildInfoRow('Descripción', widget.torre.descripcion ?? 'No disponible'),
          _buildInfoRow('Última actualización', widget.torre.ultimaActualizacion ?? 'No disponible'),
        ],
      ),
    );
  }

  Widget _buildInventario() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: const Text(
          'Información de inventario',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        children: [
          const SizedBox(height: 12),
          _buildInfoRow('Inventario', widget.torre.informacionAdicional?['inventario']?.toString() ?? 'No disponible'),
        ],
      ),
    );
  }

  Widget _buildActividadesTecnicas() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: const Text(
          'Actividades Técnicas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        children: [
          const SizedBox(height: 12),
          _buildInfoRow('Actividades', widget.torre.informacionAdicional?['actividades']?.toString() ?? 'No disponible'),
        ],
      ),
    );
  }

  Widget _buildCoordenadas() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ubicación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaMapa(
                        torreSeleccionada: Torre(
                          nombre: widget.torre.nombre,
                          latitud: widget.torre.latitud,
                          longitud: widget.torre.longitud,
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.map,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Abrir',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    widget.torre.latitud,
                    widget.torre.longitud,
                  ),
                  initialZoom: 16,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.innova.sitiostorres',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 60.0,
                        height: 60.0,
                        point: LatLng(
                          widget.torre.latitud,
                          widget.torre.longitud,
                        ),
                        child: const Icon(
                          Icons.cell_tower,
                          color: Colors.deepPurple,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Función helper para crear una TorreDetallada desde datos básicos
TorreDetallada crearTorreDetallada({
  required String nombre,
  required double latitud,
  required double longitud,
  String? estado,
  String? tipo,
  String? descripcion,
  String? ultimaActualizacion,
  Map<String, dynamic>? informacionAdicional,
}) {
  return TorreDetallada(
    nombre: nombre,
    latitud: latitud,
    longitud: longitud,
    estado: estado ?? 'Activo',
    tipo: tipo ?? 'Torre',
    descripcion: descripcion,
    ultimaActualizacion: ultimaActualizacion ?? 'Hoy',
    informacionAdicional: informacionAdicional,
  );
}
