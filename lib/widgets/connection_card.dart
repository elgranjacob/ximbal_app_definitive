
import 'package:flutter/material.dart';

class ConnectionCard extends StatelessWidget {
  final bool conectado;
  final VoidCallback onPressed;
  final VoidCallback onDesconectar;
  final bool conectando;

  const ConnectionCard({
    super.key,
    required this.conectado,
    required this.onPressed,
    required this.onDesconectar,
    this.conectando = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorEstado = conectado
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
                    'CONEXIÓN',
                    style: TextStyle(
                      color: Color(0xFFE4E4E3),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Icon(
              Icons.bluetooth,
              size: 40,
              color: conectado
                  ? const Color(0xFFB08D44)
                  : const Color(0xFF7A1418),
            ),

            const SizedBox(height: 8),

            Text(
              conectado ? 'Ximbal conectado' : 'Ximbal desconectado',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorEstado,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: conectando
                    ? null
                    : conectado
                        ? onDesconectar
                        : onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFBE161A),
                  foregroundColor: const Color(0xFFE4E4E3),
                  disabledBackgroundColor: const Color(0xFF7A1418),
                  disabledForegroundColor: const Color(0xFFE4E4E3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  // Sin margen táctil extra invisible: evita desbordes en la
                  // tarjeta de altura fija (p. ej. con fuentes grandes).
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  conectado
                      ? 'Desconectar'
                      : conectando
                          ? 'Buscando...'
                          : 'Conectar',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
