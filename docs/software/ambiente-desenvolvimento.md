# Ambiente de desenvolvimento do aplicativo

## Auditoria inicial — 30/08/2026

| Ferramenta | Situação observada |
| --- | --- |
| Git | instalado, versão `2.49.0.windows.1` |
| Flutter | inicialmente não encontrado |
| Dart | inicialmente não encontrado |
| Android Debug Bridge (`adb`) | existente no SDK, mas fora do `PATH` |
| Java padrão do terminal | Java 8, atualização 481, em caminho Oracle de 32 bits |

## Interpretação

O primeiro levantamento por comandos disponíveis no `PATH` não revelou todo o
ambiente existente. Uma inspeção dirigida confirmou que Android Studio, Android
SDK e um JDK próprio já estavam instalados. A versão legada de Java permanece
intacta para não afetar outros programas.

## Preparação executada em 30/08/2026

### Componentes encontrados

| Componente | Versão ou localização |
| --- | --- |
| Android Studio | `C:\Program Files\Android\Android Studio` |
| Android SDK | `C:\Users\cesar\AppData\Local\Android\Sdk` |
| plataforma Android | 36 |
| Android Build Tools | 36.0.0 |
| Android Platform Tools / ADB | 35.0.2 |
| Android Emulator | 35.4.9.0 |
| JDK do Android Studio | OpenJDK 21.0.5 |

O serviço local do ADB foi iniciado com sucesso. Nenhum aparelho ou emulador
estava conectado durante a verificação.

### Flutter instalado

- versão: Flutter `3.47.2`, canal estável;
- revisão: `d3b14c8769`;
- Dart: `3.13.2`;
- DevTools: `2.60.0`;
- arquivo oficial: `flutter_windows_3.47.2-stable.zip`;
- SHA-256 verificado:
  `37934F2128A55D77A38BABA12FD611157ED23A47BF7D2B7D17E9E84DA118409D`;
- instalação usada pelo Codex:
  `C:\Users\cesar\Documents\Codex\tools\flutter-3.47.2-clean\flutter`.

O cache e os arquivos de configuração usados na automação foram isolados em
`C:\Users\cesar\Documents\Codex\tools`, sem substituir o Java padrão do
Windows e sem alterar globalmente a lista de diretórios confiáveis do Git.

### Componentes Android concluídos

- Android SDK Command-line Tools `23.0.0` instalado;
- NDK `28.2.13676358` instalado com a nova ferramenta `android sdk`;
- emulador `Pixel_7a`, Android 16/API 36, detectado e iniciado;
- aplicativo instalado e executado como atividade principal;
- Android Debug APK compilado com sucesso.

O Flutter 3.47.2 ainda informa `Android license status unknown`. A versão 23
das Command-line Tools declara que `sdkmanager --licenses` não é mais
necessário e transfere o gerenciamento para a nova ferramenta Android. Essa
incompatibilidade de diagnóstico foi documentada como exceção não bloqueante:
as licenças estão presentes no SDK, os componentes foram baixados pela
ferramenta oficial e a compilação, instalação e execução Android foram
concluídas.

## Pendências não bloqueantes

- Flutter e Dart ainda não foram adicionados ao `PATH` global;
- o diagnóstico de licença acima permanece como limitação de compatibilidade;
- Visual Studio não está instalado, mas o suporte a Windows desktop está fora
  do escopo do MVP Android.

## Critério para concluir a preparação

- Flutter estável instalado e identificado;
- Android SDK e licenças configurados;
- JDK compatível selecionado sem substituir desnecessariamente o Java legado;
- diagnóstico do Flutter sem bloqueio para Android;
- um aparelho Android ou emulador detectado;
- projeto padrão compilado, testado e executado;
- versões e saída da verificação preservadas em registro datado.

O ambiente atende ao desenvolvimento Android. Os detalhes da compilação e da
execução estão na [evidência da primeira execução](evidencias/2026-08-30-primeira-execucao-android.md).
