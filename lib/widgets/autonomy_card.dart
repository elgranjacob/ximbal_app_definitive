import 'package:flutter/material.dart';

/// Muestra cuántas horas le quedan a la batería (campo `auth` de la placa).
class AutonomyCard extends StatelessWidget {
  /// Horas restantes de batería. null = sin datos.
  final double? horas;

  const AutonomyCard({
    super.key,
    required this.horas,
  });

  /// Devuelve el valor grande y su unidad, p. ej. ('2:30', 'HORAS RESTANTES').
  (String, String) _formatear(double? h) {
    if (h == null) return ('--', 'SIN DATOS');

    final int minutosTotales = (h * 60).round();
    final int horasEnteras = minutosTotales ~/ 60;
    final int minutos = minutosTotales % 60;

    if (horasEnteras == 0) return ('$minutos', 'MINUTOS RESTANTES');
    return (
      '$horasEnteras:${minutos.toString().padLeft(2, '0')}',
      'HORAS RESTANTES',
    );
  }

  @override
  Widget build(BuildContext context) {
    final (String valor, String unidad) = _formatear(horas);
    final bool sinDatos = horas == null;

    const Color gris = Color(0xFF6B6F75);
    const Color oro = Color(0xFFB08D44);
    const Color niebla = Color(0xFFE4E4E3);

    return Card(
      color: const Color(0xFF1B1E22), // Grafito
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFF7A1418), // Burdeos
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hexagon_outlined,
                  color: oro,
                  size: 17,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'AUTONOMÍA',
                    style: TextStyle(
                      color: niebla,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.battery_charging_full,
              size: 40,
              color: sinDatos ? gris : oro,
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valor,
                style: TextStyle(
                  color: sinDatos ? gris : niebla,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              unidad,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: sinDatos ? gris : oro,
                fontSize: 10,
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
