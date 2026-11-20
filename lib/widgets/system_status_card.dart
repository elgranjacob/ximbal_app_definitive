import 'package:flutter/material.dart';

class SystemStatusCard extends StatelessWidget {
  final String estado;

  const SystemStatusCard({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final bool listo = estado == "Listo";
    final bool detenido = estado == "Detenido";
    final bool sinConexion = estado == 'Sin conexión';

    final Color color = listo
        ? const Color(0xFFB08D44) // Oro
        : detenido
            ? const Color(0xFFE4E4E3) // Niebla
            : sinConexion
                ? const Color(0xFF6B6F75) // Gris (mismo de BatteryCard)
                : const Color(0xFFBE161A); // Rojo Llanta // Rojo Llanta

    final IconData icono = listo
        ? Icons.check_circle
        : detenido
            ? Icons.pause_circle
            : sinConexion
                ? Icons.bluetooth_disabled
                : Icons.error;

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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: Icon(
          icono,
          color: color,
          size: 34,
        ),
        title: const Text(
          'ESTADO DEL SISTEMA',
          style: TextStyle(
            color: Color(0xFFE4E4E3),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            estado.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.hexagon_outlined,
          color: Color(0xFFB08D44),
          size: 20,
        ),
      ),
    );
  }
}
