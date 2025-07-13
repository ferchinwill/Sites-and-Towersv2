import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'pantalla_mapa.dart';
import 'pantalla_sitios.dart';

class SitioDetallado {
  final String nombre;
  final double latitud;
  final double longitud;
  final String? estado;
  final String? tipo;
  final String? descripcion;
  final String? ultimaActualizacion;
  final Map<String, dynamic>? informacionAdicional;

  SitioDetallado({
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

class PantallaMaquetaSitios extends StatefulWidget {
  final SitioDetallado sitio;
  
  const PantallaMaquetaSitios({
    super.key,
    required this.sitio,
  });

  @override
  State<PantallaMaquetaSitios> createState() => _PantallaMaquetaSitiosState();
}

class _PantallaMaquetaSitiosState extends State<PantallaMaquetaSitios> {
  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sitio.nombre),
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
                  // Header con imagen y información principal
                  _buildHeader(),
                  
                  // Información básica
                  _buildInfoBasica(),
                  
                  // Estado y tipo
                  _buildEstadoTipo(),
                  
                  // Coordenadas
                  _buildCoordenadas(),
                  
                  // Información adicional
                  if (widget.sitio.informacionAdicional != null)
                    _buildInfoAdicional(),
                  
                  // Botones de acción
                  _buildBotonesAccion(),
                ],
              ),
            ),
    );
  }
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
      ),
      child: Padding(
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
              child: const Icon(
                Icons.location_on,
                size: 40,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.sitio.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.sitio.descripcion != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.sitio.descripcion!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Básica',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Nombre', widget.sitio.nombre),
          if (widget.sitio.ultimaActualizacion != null)
            _buildInfoRow('Última Actualización', widget.sitio.ultimaActualizacion!),
        ],
      ),
    );
  }

  Widget _buildEstadoTipo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildEstadoCard(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTipoCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoCard() {
    return Container(
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
        children: [
          Icon(
            Icons.circle,
            color: widget.sitio.estado == 'Activo' ? Colors.green : Colors.orange,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Estado',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.sitio.estado ?? 'N/A',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipoCard() {
    return Container(
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
        children: [
          const Icon(
            Icons.category,
            color: Color(0xFF2196F3),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Tipo',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.sitio.tipo ?? 'N/A',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          const Text(
            'Ubicación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 12),
          // Vista previa real del mapa
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaMapa(
                    sitioSeleccionado: Sitio(
                      nombre: widget.sitio.nombre,
                      latitud: widget.sitio.latitud,
                      longitud: widget.sitio.longitud,
                    ),
                  ),
                ),
              );
            },
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(widget.sitio.latitud, widget.sitio.longitud),
                    initialZoom: 16,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.innova.sitiostorres',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 60.0,
                          height: 60.0,
                          point: LatLng(widget.sitio.latitud, widget.sitio.longitud),
                          child: const Icon(Icons.wifi, color: Colors.blue, size: 36),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Información adicional de ubicación
          Row(
            children: [
              Expanded(
                child: _buildInfoRow('Latitud', '${widget.sitio.latitud.toStringAsFixed(6)}°'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoRow('Longitud', '${widget.sitio.longitud.toStringAsFixed(6)}°'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoAdicional() {
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
          const Text(
            'Información Adicional',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.sitio.informacionAdicional!.entries.map((entry) {
            return _buildInfoRow(entry.key, entry.value.toString());
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Acción para ver en mapa
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Abriendo ${widget.sitio.nombre} en el mapa'),
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text('Ver en Mapa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción para editar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Editando ${widget.sitio.nombre}'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción para compartir
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Compartiendo ${widget.sitio.nombre}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Función helper para crear un SitioDetallado desde datos básicos
SitioDetallado crearSitioDetallado({
  required String nombre,
  required double latitud,
  required double longitud,
  String? estado,
  String? tipo,
  String? descripcion,
  String? ultimaActualizacion,
  Map<String, dynamic>? informacionAdicional,
}) {
  return SitioDetallado(
    nombre: nombre,
    latitud: latitud,
    longitud: longitud,
    estado: estado ?? 'Activo',
    tipo: tipo ?? 'Sitio',
    descripcion: descripcion,
    ultimaActualizacion: ultimaActualizacion ?? 'Hoy',
    informacionAdicional: informacionAdicional,
  );
}

// Clase para dibujar elementos del mapa
class MapPainter extends CustomPainter {
  final double latitud;
  final double longitud;

  MapPainter({
    required this.latitud,
    required this.longitud,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibujar líneas de cuadrícula del mapa
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      double x = (size.width / 4) * i;
      double y = (size.height / 4) * i;
      
      // Líneas verticales
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
      
      // Líneas horizontales
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Dibujar carreteras principales
    final roadPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Carretera horizontal
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
    
    // Carretera vertical
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      roadPaint,
    );

    // Carretera secundaria
    final secondaryRoadPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.7),
      secondaryRoadPaint,
    );

    // Simular áreas verdes (parques)
    final parkPaint = Paint()
      ..color = Colors.green.shade300
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      18,
      parkPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      15,
      parkPaint,
    );

    // Simular edificios (rectángulos)
    final buildingPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    // Edificio 1
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, 20, 25),
      buildingPaint,
    );

    // Edificio 2
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.7, size.height * 0.6, 25, 20),
      buildingPaint,
    );

    // Edificio 3
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.1, 15, 30),
      buildingPaint,
    );

    // Simular agua (río o lago)
    final waterPaint = Paint()
      ..color = Colors.blue.shade300
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.7, 30, 15),
      waterPaint,
    );

    // Simular el sitio de telecomunicaciones (torre)
    final towerPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    // Base de la torre
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.45, size.height * 0.35, 10, 10),
      towerPaint,
    );

    // Torre
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.47, size.height * 0.25, 6, 20),
      towerPaint,
    );

    // Antena en la parte superior
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.15),
      Paint()
        ..color = const Color(0xFF2196F3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
