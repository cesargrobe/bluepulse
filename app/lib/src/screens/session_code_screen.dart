import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'initial_self_report_screen.dart';

class SessionCodeScreen extends StatefulWidget {
  const SessionCodeScreen({super.key});

  @override
  State<SessionCodeScreen> createState() => _SessionCodeScreenState();
}

class _SessionCodeScreenState extends State<SessionCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _privacyConfirmed = false;
  bool _showPrivacyError = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) {
      return 'Informe o código da sessão.';
    }
    if (code.length < 3) {
      return 'Use pelo menos 3 caracteres.';
    }
    if (!RegExp(r'^[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$').hasMatch(code)) {
      return 'Use somente letras, números e hífen entre grupos.';
    }
    return null;
  }

  void _continue() {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    setState(() => _showPrivacyError = !_privacyConfirmed);
    if (!formIsValid || !_privacyConfirmed) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InitialSelfReportScreen(
          sessionCode: _codeController.text.trim().toUpperCase(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identificação da sessão')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      size: 56,
                      color: Color(0xFF0284C7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Código anônimo',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Use apenas o código definido para o ensaio. Não informe '
                      'nome, e-mail, telefone, matrícula ou outro dado que '
                      'identifique a pessoa.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('session-code-field'),
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Código da sessão',
                        hintText: 'Ex.: BP-001',
                        prefixIcon: Icon(Icons.tag_rounded),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9-]'),
                        ),
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: _validateCode,
                      onFieldSubmitted: (_) => _continue(),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      key: const Key('privacy-confirmation'),
                      value: _privacyConfirmed,
                      onChanged: (value) {
                        setState(() {
                          _privacyConfirmed = value ?? false;
                          _showPrivacyError = false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'Confirmo que o código não contém dados pessoais.',
                      ),
                      subtitle: _showPrivacyError
                          ? Text(
                              'Esta confirmação é necessária para continuar.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      key: const Key('continue-to-self-report'),
                      onPressed: _continue,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Continuar para o autorrelato'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar e voltar'),
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
