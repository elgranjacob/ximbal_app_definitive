import 'ximbal_telemetria.dart';

/// Contrato de conexión con el Ximbal (implementado por el servicio BLE).
/// Define los streams y acciones que la app usa para hablar con el vehículo.
abstract interface class XimbalConexion {
  Stream<XimbalTelemetria> get telemetria;
  Stream<bool> get conectado;
  Stream<bool> get senal;
  String? get ultimoError;

  Future<bool> conectar();
  Future<void> enviarComando(String comando);
  Future<void> desconectar();
  void dispose();
}