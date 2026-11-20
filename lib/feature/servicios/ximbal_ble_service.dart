import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ximbal_app_definitive/feature/servicios/ximbal_conection.dart';

import 'ble_constantes.dart';
import 'ximbal_telemetria.dart';

class XimbalBleService implements XimbalConexion{
  static const Duration _tiempoSinSenal = Duration(milliseconds: 1500);

  BluetoothDevice? _dispositivo;
  BluetoothCharacteristic? _comando;
  StreamSubscription<BluetoothConnectionState>? _subEstado;
  Timer? _vigilante;
  bool _haySenal = false;

  String? _ultimoError;

  @override
  String? get ultimoError => _ultimoError;

  final _telemetriaCtrl = StreamController<XimbalTelemetria>.broadcast();
  final _conectadoCtrl = StreamController<bool>.broadcast();
  final _senalCtrl = StreamController<bool>.broadcast();
  final StringBuffer _bufferJson = StringBuffer();

  @override
  Stream<XimbalTelemetria> get telemetria => _telemetriaCtrl.stream;

  @override
  Stream<bool> get conectado => _conectadoCtrl.stream;

  @override
  Stream<bool> get senal => _senalCtrl.stream;

  /// Busca el Ximbal, se conecta y empieza a escuchar la telemetría.
  /// Devuelve true si todo salió bien; si no, revisa [ultimoError].
  @override
  Future<bool> conectar() async {
    _ultimoError = null;
    try {
      // Cambio 2: revisar Bluetooth antes de escanear.
      if (!await FlutterBluePlus.isSupported) {
        _ultimoError = 'Este celular no es compatible con Bluetooth LE.';
        return false;
      }

      final estadoAdaptador = await FlutterBluePlus.adapterState
          .firstWhere((s) => s != BluetoothAdapterState.unknown)
          .timeout(const Duration(seconds: 3));

      if (estadoAdaptador != BluetoothAdapterState.on) {
        _ultimoError = 'Bluetooth apagado. Enciéndelo e inténtalo de nuevo.';
        return false;
      }

      // Cambio 1: cancelar el listener anterior.
      await _subEstado?.cancel();
      _subEstado = null;

      await FlutterBluePlus.startScan(
        withServices: [Guid(BleConstantes.servicio)],
        timeout: const Duration(seconds: 10),
      );

      final resultados = await FlutterBluePlus.scanResults
          .firstWhere((lista) => lista.isNotEmpty)
          .timeout(const Duration(seconds: 10));
      await FlutterBluePlus.stopScan();

      final dispositivo = resultados.first.device;
      await dispositivo.connect(
        license: License.nonprofit,
        timeout: const Duration(seconds: 15),
      );
      _dispositivo = dispositivo;

      _subEstado = dispositivo.connectionState.listen((estado) {
        final bool ok = estado == BluetoothConnectionState.connected;
        if (!ok) {
          _comando = null;
          _detenerVigilante(); // Cambio 3
          _bufferJson.clear();
        }
        _conectadoCtrl.add(ok);
      });

      final servicios = await dispositivo.discoverServices();
      final servicio = servicios.firstWhere(
        (s) => s.uuid == Guid(BleConstantes.servicio),
      );

      for (final c in servicio.characteristics) {
        if (c.uuid == Guid(BleConstantes.telemetria)) {
          await c.setNotifyValue(true);
          final sub = c.onValueReceived.listen(_procesarTelemetria);
          dispositivo.cancelWhenDisconnected(sub);
        } else if (c.uuid == Guid(BleConstantes.comando)) {
          _comando = c;
        }
      }
      return true;
    } on TimeoutException {
      await FlutterBluePlus.stopScan();
      _ultimoError = 'No se encontró el Ximbal. ¿Está encendido y cerca?';
      return false;
    } catch (_) {
      await FlutterBluePlus.stopScan();
      _ultimoError = 'No se pudo conectar con el Ximbal.';
      return false;
    }
  }

  void _procesarTelemetria(List<int> bytes) {
    _bufferJson.write(utf8.decode(bytes, allowMalformed: true));

    // Protección: si se acumula basura sin '\n', se descarta.
    if (_bufferJson.length > 1024) {
      _bufferJson.clear();
      return;
    }

    final String texto = _bufferJson.toString();
    final int fin = texto.indexOf('\n');
    if (fin == -1) return; // aún no llega el final del mensaje

    final String mensaje = texto.substring(0, fin);
    _bufferJson.clear();
    _bufferJson.write(
        texto.substring(fin + 1)); // lo que sobre es inicio del siguiente

    try {
      final json = jsonDecode(mensaje) as Map<String, dynamic>;
      _telemetriaCtrl.add(XimbalTelemetria.fromJson(json));
      _reiniciarVigilante();
    } catch (_) {
      // Mensaje dañado (por ejemplo, se perdió un trozo): se ignora.
    }
  }

  // Cambio 3: vigilante de señal.
  void _reiniciarVigilante() {
    _vigilante?.cancel();
    if (!_haySenal) {
      _haySenal = true;
      _senalCtrl.add(true);
    }
    _vigilante = Timer(_tiempoSinSenal, () {
      _haySenal = false;
      _senalCtrl.add(false);
    });
  }

  void _detenerVigilante() {
    _vigilante?.cancel();
    _vigilante = null;
    if (_haySenal) {
      _haySenal = false;
      _senalCtrl.add(false);
    }
  }

  @override
  Future<void> enviarComando(String comando) async {
    final c = _comando;
    if (c == null) return;
    await c.write(utf8.encode(comando));
  }

  @override
  Future<void> desconectar() async {
    await _dispositivo?.disconnect();
  }

  @override
  void dispose() {
    _vigilante?.cancel();
    _subEstado?.cancel();
    _telemetriaCtrl.close();
    _conectadoCtrl.close();
    _senalCtrl.close();
  }
}
