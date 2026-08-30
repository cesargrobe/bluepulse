import 'package:bluepulse_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('apresenta o aviso experimental', (tester) async {
    await tester.pumpWidget(const BluePulseApp());

    expect(find.text('BluePulse'), findsOneWidget);
    expect(find.text('Uso experimental'), findsOneWidget);
    expect(
      find.textContaining('não realiza diagnóstico clínico'),
      findsOneWidget,
    );
    expect(find.text('Iniciar sessão simulada'), findsOneWidget);
  });

  testWidgets('abre e encerra a preparação simulada', (tester) async {
    await tester.pumpWidget(const BluePulseApp());

    await tester.tap(find.byKey(const Key('start-simulated-session')));
    await tester.pumpAndSettle();

    expect(find.text('Preparação da sessão'), findsOneWidget);
    expect(find.text('Modo simulado'), findsOneWidget);
    expect(find.textContaining('identificados como simulados'), findsOneWidget);

    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();

    expect(find.text('Uso experimental'), findsOneWidget);
  });
}
