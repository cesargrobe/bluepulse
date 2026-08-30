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
    expect(find.text('Iniciar sessão experimental'), findsOneWidget);
  });

  testWidgets('exige código anônimo válido e confirmação de privacidade', (
    tester,
  ) async {
    await tester.pumpWidget(const BluePulseApp());

    await tester.tap(find.byKey(const Key('start-session')));
    await tester.pumpAndSettle();

    expect(find.text('Código anônimo'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('session-code-field')), 'AB');
    await tester.tap(find.byKey(const Key('continue-to-self-report')));
    await tester.pump();

    expect(find.text('Use pelo menos 3 caracteres.'), findsOneWidget);
    expect(
      find.text('Esta confirmação é necessária para continuar.'),
      findsOneWidget,
    );
    expect(find.text('Autorrelato inicial'), findsNothing);
  });

  testWidgets('conclui o autorrelato inicial sem interpretação clínica', (
    tester,
  ) async {
    await tester.pumpWidget(const BluePulseApp());

    await tester.tap(find.byKey(const Key('start-session')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('session-code-field')),
      'bp-001',
    );
    await tester.tap(find.byKey(const Key('privacy-confirmation')));
    await tester.tap(find.byKey(const Key('continue-to-self-report')));
    await tester.pumpAndSettle();

    expect(find.text('Autorrelato inicial'), findsOneWidget);
    expect(find.text('Sessão BP-001'), findsOneWidget);

    final finishButton = tester.widget<FilledButton>(
      find.byKey(const Key('finish-initial-self-report')),
    );
    expect(finishButton.onPressed, isNull);

    for (final key in const ['tension-3', 'tranquility-4', 'comfort-5']) {
      final option = find.byKey(Key(key));
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();
    }
    await tester.ensureVisible(
      find.byKey(const Key('finish-initial-self-report')),
    );
    await tester.tap(find.byKey(const Key('finish-initial-self-report')));
    await tester.pumpAndSettle();

    expect(find.text('Autorrelato inicial concluído'), findsOneWidget);
    expect(find.textContaining('somente na memória'), findsOneWidget);
    expect(
      find.textContaining('não representam uma avaliação clínica'),
      findsOneWidget,
    );
  });

  testWidgets('permite cancelar a preparação e voltar ao início', (
    tester,
  ) async {
    await tester.pumpWidget(const BluePulseApp());

    await tester.tap(find.byKey(const Key('start-session')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar e voltar'));
    await tester.pumpAndSettle();

    expect(find.text('Uso experimental'), findsOneWidget);
  });

  testWidgets('oferece simulação e mantém BLE indisponível', (tester) async {
    await _goToDataSourceSelection(tester);

    expect(find.text('Fonte dos dados'), findsOneWidget);
    expect(find.text('Modo simulado'), findsOneWidget);
    expect(find.text('Dispositivo BLE'), findsOneWidget);

    final bleButton = tester.widget<FilledButton>(
      find.byKey(const Key('select-ble-source')),
    );
    expect(bleButton.onPressed, isNull);
  });

  testWidgets('percorre os quatro cenários simulados', (tester) async {
    await _goToDataSourceSelection(tester);

    final simulatedSource = find.byKey(const Key('select-simulated-source'));
    await tester.ensureVisible(simulatedSource);
    await tester.tap(simulatedSource);
    await tester.pumpAndSettle();

    expect(find.text('DADOS SIMULADOS'), findsOneWidget);
    expect(find.text('Sem contato'), findsOneWidget);
    expect(find.text('BPM / SpO₂ / GSR'), findsOneWidget);
    expect(find.text('Não disponíveis'), findsOneWidget);
    expect(find.textContaining('IR > 5000'), findsOneWidget);

    for (final expectedTitle in const [
      'Sinal adequado',
      'Movimento detectado',
      'Falha simulada',
    ]) {
      final nextButton = find.byKey(const Key('next-simulated-sample'));
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pump();
      expect(find.text(expectedTitle), findsOneWidget);
    }
  });
}

Future<void> _goToDataSourceSelection(WidgetTester tester) async {
  await tester.pumpWidget(const BluePulseApp());
  await tester.tap(find.byKey(const Key('start-session')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('session-code-field')), 'bp-001');
  await tester.tap(find.byKey(const Key('privacy-confirmation')));
  await tester.tap(find.byKey(const Key('continue-to-self-report')));
  await tester.pumpAndSettle();

  for (final key in const ['tension-3', 'tranquility-4', 'comfort-5']) {
    final option = find.byKey(Key(key));
    await tester.ensureVisible(option);
    await tester.tap(option);
    await tester.pump();
  }

  final finishButton = find.byKey(const Key('finish-initial-self-report'));
  await tester.ensureVisible(finishButton);
  await tester.tap(finishButton);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continuar'));
  await tester.pumpAndSettle();
}
