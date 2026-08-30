# Aplicativo BluePulse

Aplicativo Android experimental do projeto acadêmico BluePulse, desenvolvido
em Flutter. O fluxo já recebe amostras técnicas reais do ESP32 por BLE, além de
manter o modo simulado para testes reproduzíveis.

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
- conexão BLE experimental pelo protocolo BluePulse v1;
- recepção de IR bruto, movimento, validade do MPU e sequência;
- contagem local de pacotes, lacunas de sequência, duplicações, ordem e
  percentual observado de entrega por conexão;
- respostas mantidas somente na memória durante este incremento;
- BPM, SpO₂, GSR, áudio e armazenamento ainda não implementados.

## Verificação

Na pasta `app/`, executar:

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

O conjunto atual possui 17 testes automatizados. O histórico dos testes e as
versões das ferramentas estão na
[evidência da primeira execução Android](../docs/software/evidencias/2026-08-30-primeira-execucao-android.md).

## Limite de uso

O aplicativo é experimental e educacional. Não realiza diagnóstico clínico,
não substitui avaliação profissional e não deve orientar decisões médicas.
