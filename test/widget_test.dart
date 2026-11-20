import 'package:flutter_test/flutter_test.dart';

import 'package:ximbal_app_definitive/main.dart';

void main() {
  testWidgets('El dashboard arranca en estado desconectado',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Encabezado
    expect(find.text('XIMBAL'), findsOneWidget);
    expect(find.text('PANEL DE CONTROL'), findsOneWidget);

    // Sin conexión: estado, tarjeta de conexión y botón
    expect(find.text('SIN CONEXIÓN'), findsOneWidget);
    expect(find.text('Ximbal desconectado'), findsOneWidget);
    expect(find.text('Conectar'), findsOneWidget);
    expect(find.text('Desconectar'), findsNothing);

    // Sin datos todavía
    expect(find.text('SIN DATOS'), findsNWidgets(2)); // batería y autonomía
    expect(find.text('No hay alertas importantes'), findsOneWidget);
  });
}
