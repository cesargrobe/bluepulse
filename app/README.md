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
- seleção explícita da origem das amostras;
- modo simulado determinístico com quatro cenários de qualidade;
- sessão simulada automática de 30 segundos, com pausa e continuação;
- pausa oceânica visual opcional de 30 segundos, sem áudio nesta versão;
- opção BLE visível, porém desabilitada até a validação do protocolo;
- respostas mantidas somente na memória durante este incremento;
- BPM, SpO₂, GSR, áudio, armazenamento e BLE real ainda não implementados.

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
