import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'pantalla_mapa.dart';
import 'pantalla_sitios.dart';
import 'package:flutter/rendering.dart';

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

  const PantallaMaquetaSitios({super.key, required this.sitio});

  @override
  State<PantallaMaquetaSitios> createState() => _PantallaMaquetaSitiosState();
}

class _PantallaMaquetaSitiosState extends State<PantallaMaquetaSitios> {
  bool _cargando = false;

  @override //seccion de build aqui se muestra el header de la maqueta
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
                  //seccion de de orden de la los widgets mostrados en la pantalla 
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

  //seccion de header aqui se muestra el header de la card
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2196F3).withOpacity(0.9),
            const Color(0xFF1976D2).withOpacity(0.9),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Fondo desenfocado
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
          // Contenido del header
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
                //seccion de nombre del sitio aqui recoge el nombre del sitio y se muestra en el header
                Text(
                  widget.sitio.nombre, //aqui se muestra el nombre del sitio
                  style: const TextStyle(
                    //aqui se define el estilo del texto
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Estado debajo del nombre, alineado a la izquierda el texto y a la derecha el círculo
                if (widget.sitio.estado != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.sitio.estado!,
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
                        color: widget.sitio.estado == 'Activo'
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

  //seccion de informacion basica para su creacion de la card
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
          'Información del Sitio',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
        children: [
          const SizedBox(height: 12),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
        ],
      ),
    );
  }

  //seccion de card de inventario aqui se muestra el inventario del sitio
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
            color: Color.fromARGB(255, 0, 85, 154),
          ),
        ),
        children: [
          const SizedBox(height: 12),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
        ],
      ),
    );
  }

  //seccion de card de actividades tecnicas aqui se muestra las actividades tecnicas del sitio
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
            color: Color.fromARGB(255, 0, 85, 154),
          ),
        ),
        children: [
          const SizedBox(height: 12),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
          _buildInfoRow('texto', 'texto'),
        ],
      ),
    );
  }

  //seccion de Card de Mapa aqui se muestra el mapa y la ubicacion del sitio
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
                    initialCenter: LatLng(
                      widget.sitio.latitud,
                      widget.sitio.longitud,
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
                            widget.sitio.latitud,
                            widget.sitio.longitud,
                          ),
                          child: const Icon(
                            Icons.wifi,
                            color: Colors.blue,
                            size: 36,
                          ),
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
        ],
      ),
    );
  }

  //seccion de botones de accion aqui se muestra los botones de accion de la card
  /*Widget _buildBotonesAccion() {
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
          // boton de compartir y editas solo para administrador
          /*Row(
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
          ),*/
        ],
      ),
    );
  }*/

  //seccion de info row aqui se muestra la informacion de la card
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
