import 'package:flutter/material.dart';

void main() {
  runApp(const BluePulseApp());
}

class BluePulseApp extends StatelessWidget {
  const BluePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const oceanBlue = Color(0xFF075985);

    return MaterialApp(
      title: 'BluePulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: oceanBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F9FF),
        useMaterial3: true,
      ),
      home: const PresentationScreen(),
    );
  }
}

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.water_drop_rounded,
                    size: 72,
                    color: Color(0xFF0284C7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'BluePulse',
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall?.copyWith(
                      color: const Color(0xFF0C4A6E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tecnologia, cultura oceânica e pesquisa sobre bem-estar.',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: const Color(0xFFFFFBEB),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uso experimental',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Este aplicativo faz parte de um projeto educacional '
                            'e de pesquisa. Ele não realiza diagnóstico clínico, '
                            'não substitui avaliação profissional e não deve '
                            'orientar decisões médicas.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const Key('start-simulated-session'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SimulatedSessionScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Iniciar sessão simulada'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nesta fase, nenhum dado pessoal ou fisiológico real será coletado.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Proposta de Emanuelle Pinheiro da Silva\n'
                    'Orientação: Prof. Gerson Cesar Grobe de Miranda',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimulatedSessionScreen extends StatelessWidget {
  const SimulatedSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preparação da sessão')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.science_outlined,
                      size: 56,
                      color: Color(0xFF0284C7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Modo simulado',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'O primeiro fluxo navegável está funcionando. Os dados '
                      'desta etapa serão artificiais e estarão sempre '
                      'identificados como simulados.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'BPM, SpO₂ e GSR ainda não serão apresentados como '
                      'medidas validadas.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Voltar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
