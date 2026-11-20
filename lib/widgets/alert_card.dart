
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String? mensaje;

  const AlertCard({
    super.key,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    final bool hayAlerta = mensaje != null;

    final Color color = hayAlerta
        ? const Color(0xFFBE161A) // Rojo Llanta
        : const Color(0xFFB08D44); // Oro

    return Card(
      color: const Color(0xFF1B1E22), // Grafito
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: hayAlerta
              ? const Color(0xFFBE161A)
              : const Color(0xFF7A1418),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          hayAlerta
              ? Icons.notifications_active
              : Icons.notifications_none,
          color: color,
          size: 40,
        ),
        title: Text(
          hayAlerta ? 'ALERTA' : 'ALERTAS',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            mensaje ?? 'No hay alertas importantes',
            style: const TextStyle(
              color: Color(0xFFE4E4E3), // Niebla
              fontSize: 13,
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
