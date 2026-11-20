import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ximbal_app_definitive/widgets/alert_card.dart';
import 'package:ximbal_app_definitive/widgets/autonomy_card.dart';
import 'package:ximbal_app_definitive/widgets/battery_card.dart';
import 'package:ximbal_app_definitive/widgets/bottom_navigation.dart';
import 'package:ximbal_app_definitive/widgets/driving_mode_card.dart';
import 'package:ximbal_app_definitive/widgets/system_status_card.dart';
import 'package:ximbal_app_definitive/widgets/connection_card.dart';
import 'package:ximbal_app_definitive/feature/servicios/ximbal_ble_service.dart';
import 'package:ximbal_app_definitive/feature/servicios/ximbal_telemetria.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final XimbalBleService _ble = XimbalBleService();
  StreamSubscription<bool>? _subConectado;

  bool _conectado = false;
  bool _conectando = false;
  StreamSubscription<XimbalTelemetria>? _subTelemetria;
  StreamSubscription<bool>? _subSenal;

  XimbalTelemetria? _datos;
  bool _haySenal = false;

  static const int _umbralBateriaBaja = 20;  bool _conexionPerdida = false;

  /// true mientras el usuario pidió desconectar, para no mostrarlo como
  /// "conexión perdida".
  bool _desconexionManual = false;

  @override
  void initState() {
    super.initState();
    _subConectado = _ble.conectado.listen((valor) {
      if (!mounted) return;
      setState(() {
        if (_conectado && !valor && !_desconexionManual) {
          _conexionPerdida = true; // se cortó
        }
        if (valor) _conexionPerdida = false; // reconectó
        if (!valor) {
          _datos = null; // datos viejos fuera
          _desconexionManual = false;
        }
        _conectado = valor;
      });
    });
    _subTelemetria = _ble.telemetria.listen((t) {
      if (!mounted) return;
      setState(() => _datos = t);
    });

    _subSenal = _ble.senal.listen((valor) {
      if (!mounted) return;
      setState(() => _haySenal = valor);
    });
  }

  @override
  void dispose() {
    _subConectado?.cancel();
    _subTelemetria?.cancel();
    _subSenal?.cancel();
    _ble.desconectar();
    _ble.dispose();
    super.dispose();
  }

  Future<void> _conectar() async {
    if (_conectando) return;
    setState(() => _conectando = true);

    final bool ok = await _ble.conectar();

    if (!mounted) return;
    setState(() => _conectando = false);

    _mostrarMensaje(
      ok ? 'Ximbal conectado' : (_ble.ultimoError ?? 'No se pudo conectar.'),
    );
  }

  Future<void> _desconectar() async {
    _desconexionManual = true;
    try {
      await _ble.desconectar();
      if (!mounted) return;
      _mostrarMensaje('Ximbal desconectado');
    } catch (_) {
      _desconexionManual = false;
      if (!mounted) return;
      _mostrarMensaje('No se pudo desconectar.');
    }
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  /// Los datos solo son válidos si hay conexión Y siguen llegando paquetes.
  bool get _datosVigentes => _conectado && _haySenal;

  String _textoEstado(XimbalTelemetria? d) {
    if (d == null) return 'Sin conexión';
    if (d.estado == 'LOCKED') return 'Detenido';
    return 'Listo';
  }

  String _textoModo(XimbalTelemetria? d) => switch (d?.modo) {
        'SLOW' => 'Lento',
        'FAST' => 'Rápido',
        'REVERSE' => 'Reversa',
        _ => '--',
      };
  
  String? _alertaActual(XimbalTelemetria? d) {
  if (_conexionPerdida) {
    return 'Se perdió la conexión con Ximbal.';
  }
  if (_conectado && !_haySenal && _datos != null) {
    return 'Ximbal no envía datos. Revisa que esté encendido.';
  }
  if (d == null) return null;

  if (d.estado == 'LOCKED') {
    return 'Sistema bloqueado. Mueve el joystick hacia arriba para desbloquear.';
  }
  if (d.bateria < _umbralBateriaBaja) {
    return 'Batería baja (${d.bateria}%). Carga tu Ximbal pronto.';
  }
  return null;
}

  @override
  Widget build(BuildContext context) {
    final XimbalTelemetria? datos = _datosVigentes ? _datos : null;

    const Color carbono = Color(0xFF0A0D11);
    const Color grafito = Color(0xFF1B1E22);
    const Color rojoLlanta = Color(0xFFBE161A);
    const Color oro = Color(0xFFB08D44);
    const Color niebla = Color(0xFFE4E4E3);

    return Scaffold(
      backgroundColor: carbono,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Encabezado de Ximbal
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: rojoLlanta,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'XIMBAL',
                          style: TextStyle(
                            color: niebla,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'PANEL DE CONTROL',
                          style: TextStyle(
                            color: oro,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Aquí irá la navegación a ajustes.
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: grafito,
                      foregroundColor: niebla,
                    ),
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Ajustes',
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Estado general del sistema
              SystemStatusCard(estado: _textoEstado(datos)),

              const SizedBox(height: 16),

              // Batería y autonomía
              SizedBox(
                height: 210,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: BatteryCard(porcentaje: datos?.bateria),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: AutonomyCard(horas: datos?.autonomiaHoras),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Conexión Bluetooth y modo de conducción
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ConnectionCard(
                          conectado: _conectado,
                          conectando: _conectando,
                          onPressed: _conectar,
                          onDesconectar: _desconectar),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DrivingModeCard(
                        modo: _textoModo(datos),
                        activo: datos != null,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Alertas importantes
              AlertCard(mensaje: _alertaActual(datos)),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      // Navegación inferior
      bottomNavigationBar: BottomNavigation(
        indiceActual: 0,
        onSeleccionar: (indice) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pantalla pendiente'),
            ),
          );
        },
      ),
    );
  }
}
