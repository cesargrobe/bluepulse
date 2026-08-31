import 'package:flutter/material.dart';

import '../storage/session_repository.dart';
import 'session_history_screen.dart';
import 'session_code_screen.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({this.repository, super.key});

  final SessionStore? repository;

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
                    key: const Key('start-session'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SessionCodeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Iniciar sessão experimental'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const Key('open-session-history'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              SessionHistoryScreen(repository: repository),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history_rounded),
                    label: const Text('Histórico de coletas simuladas'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Somente coletas simuladas salvas explicitamente ficam na '
                    'área privada do aplicativo. Nenhum dado é enviado pela '
                    'internet.',
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
