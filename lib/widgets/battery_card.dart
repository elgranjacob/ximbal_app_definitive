import 'package:flutter/material.dart';

class BatteryCard extends StatelessWidget {
  final int? porcentaje;

  const BatteryCard({
    super.key,
    required this.porcentaje,
  });

  @override
  Widget build(BuildContext context) {
    final int? nivel = porcentaje?.clamp(0, 100);

    final Color color = nivel == null
        ? const Color(0xFF6B6F75) // Gris (sin datos)
        : nivel > 50
            ? const Color(0xFFB08D44) // Oro // Oro
            : nivel > 20
                ? const Color(0xFFBE161A) // Rojo Llanta
                : const Color(0xFF7A1418); // Burdeos

    final IconData icono = nivel == null
        ? Icons.battery_unknown
        : nivel > 80
            ? Icons.battery_full
            : nivel > 60
                ? Icons.battery_6_bar
                : nivel > 40
                    ? Icons.battery_4_bar
                    : nivel > 20
                        ? Icons.battery_2_bar
                        : Icons.battery_alert;

    return Card(
      color: const Color(0xFF1B1E22), // Grafito
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF7A1418),
          width: 1.1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.battery_charging_full,
                  color: Color(0xFFB08D44),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'BATERÍA',
                    style: TextStyle(
                      color: Color(0xFFE4E4E3),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.hexagon_outlined,
                  color: const Color(0xFFB08D44).withValues(alpha: 0.7),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 1.5708,
                      child: Icon(
                        icono,
                        size: 115,
                        color: color,
                      ),
                    ),
                    Text(
                      nivel == null ? '' : '$nivel%',
                      style: const TextStyle(
                        color: Color(0xFFE4E4E3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nivel == null
                  ? 'SIN DATOS'
                  : nivel > 50
                      ? 'NIVEL ÓPTIMO'
                      : nivel > 20
                          ? 'NIVEL BAJO'
                          : 'BATERÍA CRÍTICA',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
