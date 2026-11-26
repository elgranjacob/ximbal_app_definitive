# Ximbal App

Aplicación móvil en **Flutter** que se conecta por **Bluetooth Low Energy (BLE)** a un vehículo eléctrico "Ximbal" para mostrar su telemetría en tiempo real y enviarle comandos.

## Funcionalidades
- Búsqueda y conexión BLE con el dispositivo `Ximbal`.
- Dashboard en tiempo real con:
  - Nivel de batería y alertas (nivel óptimo, bajo, crítico).
  - Autonomía estimada (horas/minutos restantes).
  - Voltaje, corriente y potencia.
  - Estado del sistema y modo de conducción.
- Envío de comandos al vehículo: `PING`, `DATA`, `SLOW`, `FAST`, `REVERSE`.

## Arquitectura
- `lib/feature/servicios/` — capa de comunicación:
  - `XimbalConexion`: interfaz abstracta (permite cambiar BLE por otra conexión o un simulador).
  - `XimbalBleService`: implementación con `flutter_blue_plus`, expone `Stream`s de telemetría, conexión y señal.
  - `XimbalTelemetria`: modelo que interpreta el JSON enviado por el dispositivo.
- `lib/widgets/` — tarjetas reutilizables del dashboard (batería, autonomía, alertas, modo de conducción…).
- `lib/screens/` — pantallas de la app.

## Tecnologías
Flutter · Dart · flutter_blue_plus (BLE)

## Ejecutar
```bash
flutter pub get
flutter run
```
> Requiere un dispositivo físico con Bluetooth y el hardware Ximbal (o un periférico BLE que exponga los mismos UUIDs).
