// Esta es una prueba básica de widget en Flutter.
//
// Para interactuar con un widget en tu prueba, utiliza el WidgetTester
// que se encuentra en el paquete flutter_test. Por ejemplo, puedes enviar gestos de tap y scroll.
// También puedes usar WidgetTester para encontrar widgets hijos en el árbol de widgets,
// leer textos y verificar que los valores de las propiedades de los widgets sean correctos.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sitios_y_torres/main.dart';

void main() {
  testWidgets('Prueba básica de incremento de contador', (
    WidgetTester tester,
  ) async {
    // Construye la app y genera un frame.
    await tester.pumpWidget(const SitiosYTorresApp());

    // Verifica que el contador inicia en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toca el ícono de '+' y genera un nuevo frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador se ha incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
