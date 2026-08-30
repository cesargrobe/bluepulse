import 'package:flutter/material.dart';

class InitialSelfReportScreen extends StatefulWidget {
  const InitialSelfReportScreen({required this.sessionCode, super.key});

  final String sessionCode;

  @override
  State<InitialSelfReportScreen> createState() =>
      _InitialSelfReportScreenState();
}

class _InitialSelfReportScreenState extends State<InitialSelfReportScreen> {
  int? _tension;
  int? _tranquility;
  int? _comfort;

  bool get _isComplete =>
      _tension != null && _tranquility != null && _comfort != null;

  Future<void> _finish() async {
    if (!_isComplete) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autorrelato inicial concluído'),
        content: Text(
          'As respostas da sessão ${widget.sessionCode} estão somente na '
          'memória e serão descartadas ao fechar o aplicativo. Elas não '
          'representam uma avaliação clínica.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autorrelato inicial')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sessão ${widget.sessionCode}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: const Color(0xFF0369A1)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Como você se percebe agora?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Responda espontaneamente. Estas escalas são provisórias, '
                    'não clínicas e serão usadas apenas para testar a interface.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _ScaleQuestion(
                    id: 'tension',
                    question: 'Quanta tensão você percebe neste momento?',
                    lowLabel: 'Muito baixa',
                    highLabel: 'Muito alta',
                    value: _tension,
                    onChanged: (value) => setState(() => _tension = value),
                  ),
                  const SizedBox(height: 16),
                  _ScaleQuestion(
                    id: 'tranquility',
                    question: 'Quão tranquilo(a) você se sente agora?',
                    lowLabel: 'Nada tranquilo(a)',
                    highLabel: 'Muito tranquilo(a)',
                    value: _tranquility,
                    onChanged: (value) => setState(() => _tranquility = value),
                  ),
                  const SizedBox(height: 16),
                  _ScaleQuestion(
                    id: 'comfort',
                    question: 'Qual é seu nível de conforto neste momento?',
                    lowLabel: 'Muito baixo',
                    highLabel: 'Muito alto',
                    value: _comfort,
                    onChanged: (value) => setState(() => _comfort = value),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const Key('finish-initial-self-report'),
                    onPressed: _isComplete ? _finish : null,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Concluir autorrelato inicial'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecione uma resposta em cada escala para continuar.',
                    textAlign: TextAlign.center,
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

class _ScaleQuestion extends StatelessWidget {
  const _ScaleQuestion({
    required this.id,
    required this.question,
    required this.lowLabel,
    required this.highLabel,
    required this.value,
    required this.onChanged,
  });

  final String id;
  final String question;
  final String lowLabel;
  final String highLabel;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(5, (index) {
                final option = index + 1;
                return ChoiceChip(
                  key: Key('$id-$option'),
                  label: Text('$option'),
                  selected: value == option,
                  onSelected: (_) => onChanged(option),
                  tooltip: '$question — opção $option de 5',
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('1 — $lowLabel')),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('5 — $highLabel', textAlign: TextAlign.end),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
