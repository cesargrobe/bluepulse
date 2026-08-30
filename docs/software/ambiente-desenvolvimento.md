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
  `C:\Users\cesar\Documents\Codex\tools\flutter`.

O cache e os arquivos de configuração usados na automação foram isolados em
`C:\Users\cesar\Documents\Codex\tools`, sem substituir o Java padrão do
Windows e sem alterar globalmente a lista de diretórios confiáveis do Git.

## Pendências encontradas pelo diagnóstico

- `Android SDK Command-line Tools (latest)` não está instalado corretamente;
- as licenças Android ainda precisam ser lidas e aceitas pelo responsável;
- não há aparelho ou emulador conectado;
- Flutter e Dart ainda não foram adicionados ao `PATH` global;
- o diagnóstico de Windows desktop é irrelevante para o MVP Android e não será
  tratado como bloqueio.

## Critério para concluir a preparação

- Flutter estável instalado e identificado;
- Android SDK e licenças configurados;
- JDK compatível selecionado sem substituir desnecessariamente o Java legado;
- diagnóstico do Flutter sem bloqueio para Android;
- um aparelho Android ou emulador detectado;
- projeto padrão compilado, testado e executado;
- versões e saída da verificação preservadas em registro datado.

Até que as pendências Android sejam resolvidas, o item 2 do
[plano de testes e validações](plano-testes-validacoes.md) permanece aberto.
