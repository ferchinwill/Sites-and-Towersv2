import 'package:flutter/material.dart';
import 'PantallaMaquetaSitios.dart';

// Ejemplo de cómo usar la pantalla maqueta con diferentes tipos de sitios
class EjemploUsoMaqueta extends StatelessWidget {
  const EjemploUsoMaqueta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplos de Sitios'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEjemploSitio(
            context,
            'Sitio Básico',
            'Cemain Tampico',
            22.234779,
            -97.868120,
            'Sitio de Telecomunicaciones',
            'Sitio principal de infraestructura',
          ),
          const SizedBox(height: 16),
          _buildEjemploSitio(
            context,
            'Torre Residencial',
            'Torre Baltica',
            22.336532,
            -97.825680,
            'Torre Residencial',
            'Torre de telecomunicaciones en zona residencial',
            informacionAdicional: {
              'Altura': '45m',
              'Tipo de Torre': 'Monopolo',
              'Cobertura': '2km',
              'Tecnología': '4G LTE',
              'Operador': 'HTV',
              'Estado': 'Operativo',
            },
          ),
          const SizedBox(height: 16),
          _buildEjemploSitio(
            context,
            'Sitio Industrial',
            'Cemain Altamira',
            22.403850,
            -97.908730,
            'Sitio Industrial',
            'Sitio de telecomunicaciones en zona industrial',
            informacionAdicional: {
              'Zona': 'Industrial',
              'Potencia': '2000W',
              'Tecnología': '5G NR',
              'Altura': '60m',
              'Tipo de Torre': 'Celosía',
              'Cobertura': '5km',
              'Mantenimiento': 'Mensual',
            },
          ),
          const SizedBox(height: 16),
          _buildEjemploSitio(
            context,
            'Sitio Rural',
            'Tampico Alto',
            22.111869,
            -97.800390,
            'Sitio Rural',
            'Sitio de telecomunicaciones en zona rural',
            estado: 'Mantenimiento',
            informacionAdicional: {
              'Zona': 'Rural',
              'Potencia': '500W',
              'Tecnología': '3G/4G',
              'Altura': '25m',
              'Tipo de Torre': 'Monopolo',
              'Cobertura': '3km',
              'Último Mantenimiento': 'Hace 2 semanas',
              'Próximo Mantenimiento': 'En 2 semanas',
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEjemploSitio(
    BuildContext context,
    String titulo,
    String nombre,
    double latitud,
    double longitud,
    String tipo,
    String descripcion, {
    String estado = 'Activo',
    Map<String, dynamic>? informacionAdicional,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              descripcion,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: estado == 'Activo' ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  estado,
                  style: TextStyle(
                    fontSize: 12,
                    color: estado == 'Activo' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    final sitioDetallado = crearSitioDetallado(
                      nombre: nombre,
                      latitud: latitud,
                      longitud: longitud,
                      estado: estado,
                      tipo: tipo,
                      descripcion: descripcion,
                      ultimaActualizacion: 'Hoy',
                      informacionAdicional: informacionAdicional,
                    );
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaMaquetaSitios(sitio: sitioDetallado),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Ver Detalles'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Función para navegar directamente a un sitio específico
void navegarASitio(BuildContext context, String nombre, double latitud, double longitud) {
  final sitioDetallado = crearSitioDetallado(
    nombre: nombre,
    latitud: latitud,
    longitud: longitud,
    estado: 'Activo',
    tipo: 'Sitio de Telecomunicaciones',
    descripcion: 'Sitio de infraestructura de telecomunicaciones',
    ultimaActualizacion: 'Hoy',
    informacionAdicional: {
      'Región': 'Tamaulipas',
      'Operador': 'HTV',
      'Tecnología': '4G/5G',
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
} 