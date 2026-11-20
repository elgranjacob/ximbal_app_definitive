
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int> onSeleccionar;

  const BottomNavigation({
    super.key,
    required this.indiceActual,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color(0xFF1B1E22), // Grafito
      indicatorColor: const Color(0xFF7A1418), // Burdeos
      elevation: 0,
      selectedIndex: indiceActual,
      onDestinationSelected: onSeleccionar,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            color: Color(0xFFE4E4E3),
          ),
          selectedIcon: Icon(
            Icons.home,
            color: Color(0xFFE4E4E3),
          ),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.menu_book_outlined,
            color: Color(0xFFE4E4E3),
          ),
          selectedIcon: Icon(
            Icons.menu_book,
            color: Color(0xFFE4E4E3),
          ),
          label: 'Guía',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.notifications_outlined,
            color: Color(0xFFE4E4E3),
          ),
          selectedIcon: Icon(
            Icons.notifications,
            color: Color(0xFFE4E4E3),
          ),
          label: 'Alertas',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.speed_outlined,
            color: Color(0xFFE4E4E3),
          ),
          selectedIcon: Icon(
            Icons.speed,
            color: Color(0xFFE4E4E3),
          ),
          label: 'Conducción',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.show_chart,
            color: Color(0xFFE4E4E3),
          ),
          label: 'Historial',
        ),
      ],
    );
  }
}
