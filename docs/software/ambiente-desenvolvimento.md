# Ambiente de desenvolvimento do aplicativo

## Auditoria inicial — 30/08/2026

| Ferramenta | Situação observada |
| --- | --- |
| Git | instalado, versão `2.49.0.windows.1` |
| Flutter | não encontrado |
| Dart | não encontrado |
| Android Debug Bridge (`adb`) | não encontrado |
| Java | Java 8, atualização 481, em caminho Oracle de 32 bits |

## Interpretação

O computador ainda não está pronto para compilar e executar o aplicativo
Flutter para Android. Git está disponível, mas Flutter, Dart e Android SDK
precisam ser instalados. A versão de Java existente deve permanecer intacta caso
seja usada por outros programas; o ambiente Android deverá utilizar um JDK
compatível próprio.

## Critério para concluir a preparação

- Flutter estável instalado e identificado;
- Android SDK e licenças configurados;
- JDK compatível selecionado sem substituir desnecessariamente o Java legado;
- diagnóstico do Flutter sem bloqueio para Android;
- um aparelho Android ou emulador detectado;
- projeto padrão compilado, testado e executado;
- versões e saída da verificação preservadas em registro datado.

Até que esses critérios sejam atendidos, o item 2 do
[plano de testes e validações](plano-testes-validacoes.md) permanece aberto.
