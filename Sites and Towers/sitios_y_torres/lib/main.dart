import 'package:flutter/material.dart';
import 'pantalla_sitios.dart';
import 'pantalla_mapa.dart';
import 'pantalla_torres.dart';

void main() {
  runApp(const SitiosYTorresApp());
}

// Pantalla de bienvenida
class PantallaBienvenida extends StatefulWidget {
  const PantallaBienvenida({super.key});

  @override
  State<PantallaBienvenida> createState() => _PantallaBienvenidaState();
}

class _PantallaBienvenidaState extends State<PantallaBienvenida> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('Imagenes/Htv.png', width: 180, height: 180),
            const SizedBox(height: 32),
            const Text(
              'Bienvenido a Sitios y Torres',
              style: TextStyle(
                fontSize: 32,
                color: Color.fromARGB(255, 1, 33, 59),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget principal de la aplicación
class SitiosYTorresApp extends StatelessWidget {
  const SitiosYTorresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sitios y Torres',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:
          const PantallaBienvenida(), // Mostramos primero la pantalla de bienvenida
      debugShowCheckedModeBanner: false,
    );
  }
}

// Pantalla de Login
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _pinController = TextEditingController();
  bool _cargando = false;
  String? _error;

  // Simulación de comprobación de PIN (esto se conectará a la base de datos real)
  Future<bool> _comprobarPin(String pin) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula espera de red
    // Aquí deberías consultar la base de datos real
    return pin == '12345';
  }

  void _login() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    bool exito = await _comprobarPin(_pinController.text);
    setState(() {
      _cargando = false;
    });
    if (exito) {
      // Si el login es exitoso, navega a la página principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
      );
    } else {
      setState(() {
        _error = 'PIN incorrecto';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('Imagenes/Htv.png', width: 120, height: 120),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese su PIN de 5 dígitos',
                ),
                keyboardType: TextInputType.number,
                maxLength: 5,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _login,
                  child: _cargando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Ingresar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página principal con navegación inferior
class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indiceSeleccionado = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de widgets para cada pantalla
  static final List<Widget> _pantallas = <Widget>[
    PantallaInicio(),
    PantallaSitios(),
    PantallaTorres(),
    PantallaMapa(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  ///Funcion para el drawer de la pantalla principal del side bar
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('Imagenes/Htv.png', width: 60, height: 60),
                const SizedBox(height: 10),
                const Text(
                  'Sitios y Torres',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Sistema de Gestión',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_add, color: Color(0xFF2196F3)),
            title: const Text('Tus Actividades'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaLogin()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Drawer lateral derecho para búsqueda/filtro
  Widget _buildSearchDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buscar o Filtrar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Buscar...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                // Aquí puedes agregar lógica para filtrar resultados
              ),
              // Puedes agregar más filtros aquí si lo deseas
            ],
          ),
        ),
      ),
    );
  }

  ///Funcion para la barra de navegacion inferior
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2196F3).withOpacity(0.9),
                const Color.fromARGB(255, 3, 60, 117).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context),
      endDrawer: _buildSearchDrawer(context),
      body: _pantallas[_indiceSeleccionado],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Sitios'),
          BottomNavigationBarItem(
            icon: Icon(Icons.cell_tower),
            label: 'Torres',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        ],
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Pantallas base (solo muestran texto por ahora)
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header con logo y título
            Row(
              children: [
                Image.asset('Imagenes/Htv.png', width: 60, height: 60),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido Jorge Duran',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                   
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Tarjetas de estadísticas rápidas
            const Text(
              'Resumen del Sistema',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Sitios',
                    '55',
                    Icons.wifi,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Torres',
                    '23',
                    Icons.cell_tower,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 32),
            // Acciones rápidas
            const Text(
              'Acciones Rápidas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildActionCard(
              context,
              'Ver Mapa',
              'Explora sitios y torres en el mapa',
              Icons.map,
              Colors.blue,
              () {
                final paginaPrincipal = context
                    .findAncestorStateOfType<_PaginaPrincipalState>();
                if (paginaPrincipal != null) {
                  paginaPrincipal._onItemTapped(3);
                }
              },
            ),
            const SizedBox(height: 12),

            _buildActionCard(
              context,
              'Gestionar Sitios',
              'Administra los sitios de la red',
              Icons.wifi,
              Colors.green,
              () {
                final paginaPrincipal = context
                    .findAncestorStateOfType<_PaginaPrincipalState>();
                if (paginaPrincipal != null) {
                  paginaPrincipal._onItemTapped(1);
                }
              },
            ),
            const SizedBox(height: 12),

            _buildActionCard(
              context,
              'Gestionar Torres',
              'Administra las torres del sistema',
              Icons.location_city,
              Colors.purple,
              () {
                final paginaPrincipal = context
                    .findAncestorStateOfType<_PaginaPrincipalState>();
                if (paginaPrincipal != null) {
                  paginaPrincipal._onItemTapped(2);
                }
              },
            ),
            const SizedBox(height: 32),

            // Información del sistema
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del Sistema',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Última actualización: Hace 5 minutos\n'
                    '• Estado del sistema: Operativo\n'
                    '• Versión de la app: 1.0.0',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
