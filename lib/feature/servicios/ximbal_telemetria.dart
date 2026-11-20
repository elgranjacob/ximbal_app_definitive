class XimbalTelemetria {
  final int bateria;
  final double? autonomiaHoras;
  final String estado;
  final String modo;
  final double voltaje;
  final double corriente;
  final double potencia;

  const XimbalTelemetria({
    required this.bateria,
    required this.autonomiaHoras,
    required this.estado,
    required this.modo,
    required this.voltaje,
    required this.corriente,
    required this.potencia,
  });

  factory XimbalTelemetria.fromJson(Map<String, dynamic> json) {
    final double auth = (json['auth'] as num?)?.toDouble() ?? -1;

    return XimbalTelemetria(
      bateria: (json['soc'] as num?)?.toInt() ?? 0,
      autonomiaHoras: auth < 0 ? null : auth, // -1 = sin datos
      estado: json['estado'] as String? ?? 'IDLE',
      modo: json['modo'] as String? ?? 'SLOW',
      voltaje: (json['v'] as num?)?.toDouble() ?? 0,
      corriente: (json['i'] as num?)?.toDouble() ?? 0,
      potencia: (json['p'] as num?)?.toDouble() ?? 0,
    );
  }
}