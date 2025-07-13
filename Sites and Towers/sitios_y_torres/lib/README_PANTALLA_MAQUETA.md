# Pantalla Maqueta de Sitios

## Descripción

La `PantallaMaquetaSitios` es una pantalla reutilizable que muestra información detallada de cualquier sitio de telecomunicaciones. Está diseñada para ser flexible y adaptarse a diferentes tipos de sitios con información variable.

## Características

- **Diseño Moderno**: Interfaz limpia con gradientes y sombras
- **Información Flexible**: Muestra información básica y adicional según el sitio
- **Estados Visuales**: Indicadores de estado (Activo, Mantenimiento, etc.)
- **Acciones Integradas**: Botones para ver en mapa, editar y compartir
- **Responsive**: Se adapta a diferentes tamaños de pantalla

## Cómo Usar

### 1. Crear un SitioDetallado

```dart
final sitioDetallado = crearSitioDetallado(
  nombre: 'Cemain Tampico',
  latitud: 22.234779,
  longitud: -97.868120,
  estado: 'Activo',
  tipo: 'Sitio de Telecomunicaciones',
  descripcion: 'Sitio principal de infraestructura',
  ultimaActualizacion: 'Hoy',
  informacionAdicional: {
    'Región': 'Tamaulipas',
    'Operador': 'HTV',
    'Tecnología': '4G/5G',
    'Altura': '30m',
    'Potencia': '1000W',
  },
);
```

### 2. Navegar a la Pantalla

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PantallaMaquetaSitios(sitio: sitioDetallado),
  ),
);
```

### 3. Función Helper

También puedes usar la función helper para navegación rápida:

```dart
navegarASitio(context, 'Cemain Tampico', 22.234779, -97.868120);
```

## Estructura de Datos

### SitioDetallado

```dart
class SitioDetallado {
  final String nombre;                    // Requerido
  final double latitud;                   // Requerido
  final double longitud;                  // Requerido
  final String? estado;                   // Opcional (default: 'Activo')
  final String? tipo;                     // Opcional (default: 'Sitio')
  final String? descripcion;              // Opcional
  final String? ultimaActualizacion;      // Opcional (default: 'Hoy')
  final Map<String, dynamic>? informacionAdicional; // Opcional
}
```

## Ejemplos de Uso

### Sitio Básico
```dart
crearSitioDetallado(
  nombre: 'Cemain Tampico',
  latitud: 22.234779,
  longitud: -97.868120,
)
```

### Torre Residencial
```dart
crearSitioDetallado(
  nombre: 'Torre Baltica',
  latitud: 22.336532,
  longitud: -97.825680,
  tipo: 'Torre Residencial',
  descripcion: 'Torre de telecomunicaciones en zona residencial',
  informacionAdicional: {
    'Altura': '45m',
    'Tipo de Torre': 'Monopolo',
    'Cobertura': '2km',
    'Tecnología': '4G LTE',
  },
)
```

### Sitio en Mantenimiento
```dart
crearSitioDetallado(
  nombre: 'Tampico Alto',
  latitud: 22.111869,
  longitud: -97.800390,
  estado: 'Mantenimiento',
  tipo: 'Sitio Rural',
  informacionAdicional: {
    'Último Mantenimiento': 'Hace 2 semanas',
    'Próximo Mantenimiento': 'En 2 semanas',
  },
)
```

## Componentes de la Pantalla

### 1. Header
- Icono de ubicación
- Nombre del sitio
- Descripción (opcional)
- Gradiente azul

### 2. Información Básica
- Nombre del sitio
- Última actualización

### 3. Estado y Tipo
- Tarjetas con estado (Activo/Mantenimiento)
- Tipo de sitio
- Iconos visuales

### 4. Coordenadas
- Latitud y longitud
- Formato decimal

### 5. Información Adicional
- Datos específicos del sitio
- Se muestra solo si hay información adicional

### 6. Botones de Acción
- Ver en Mapa
- Editar
- Compartir

## Personalización

### Colores
Los colores principales están definidos en:
- `Color(0xFF2196F3)` - Azul principal
- `Color(0xFF1976D2)` - Azul oscuro para gradientes

### Estados
- **Activo**: Verde
- **Mantenimiento**: Naranja
- **Inactivo**: Rojo (se puede agregar)

### Información Adicional
Puedes agregar cualquier campo personalizado en el `Map<String, dynamic>` de `informacionAdicional`.

## Integración con el Proyecto

La pantalla ya está integrada en `pantalla_sitios.dart`. Cuando el usuario toca un sitio en la lista, se crea automáticamente un `SitioDetallado` y se navega a la pantalla maqueta.

## Archivos Relacionados

- `PantallaMaquetaSitios.dart` - Pantalla principal
- `ejemplo_uso_maqueta.dart` - Ejemplos de uso
- `pantalla_sitios.dart` - Integración con la lista de sitios
- `MapsST/SITIOS.txt` - Datos de los sitios 