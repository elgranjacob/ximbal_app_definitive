
import 'package:flutter/material.dart';

class DrivingModeCard extends StatelessWidget {
  final String modo;
  final bool activo;

  const DrivingModeCard({
    super.key,
    required this.modo,
    required this.activo,
  });

  @override
  Widget build(BuildContext context) {
    final String estado = activo ? 'Activo' : 'Inactivo';

    final Color colorEstado = activo
        ? const Color(0xFFB08D44) // Oro
        : const Color(0xFFE4E4E3); // Niebla

    return Card(
      color: const Color(0xFF1B1E22), // Grafito
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF7A1418), // Burdeos
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.hexagon_outlined,
                  color: Color(0xFFB08D44),
                  size: 17,
                ),
                const SizedBox(width: 6),
                const Flexible(
                  child: Text(
                    'MODO DE CONDUCCIÓN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE4E4E3),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Icon(
              Icons.speed,
              size: 42,
              color: colorEstado,
            ),

            const SizedBox(height: 10),

            Text(
              modo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE4E4E3),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              estado.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorEstado,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
