# Aplicativo BluePulse

Aplicativo Android experimental do projeto acadêmico BluePulse, desenvolvido
em Flutter. O código está no primeiro incremento do fluxo navegável e ainda não
recebe dados reais do protótipo.

## Estado atual

- apresentação do projeto, autoria e orientação;
- aviso explícito de uso experimental e ausência de diagnóstico clínico;
- identificação por código anônimo, sem dados pessoais;
- confirmação de privacidade antes de avançar;
- autorrelato inicial provisório de tensão, tranquilidade e conforto;
- respostas mantidas somente na memória durante este incremento;
- dados fisiológicos reais, armazenamento e BLE ainda não implementados.

## Verificação

Na pasta `app/`, executar:

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

O histórico dos testes e as versões das ferramentas estão na
[evidência da primeira execução Android](../docs/software/evidencias/2026-08-30-primeira-execucao-android.md).

## Limite de uso

O aplicativo é experimental e educacional. Não realiza diagnóstico clínico,
não substitui avaliação profissional e não deve orientar decisões médicas.
