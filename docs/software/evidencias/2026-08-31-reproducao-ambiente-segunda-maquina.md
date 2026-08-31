# Reprodução do ambiente em uma segunda máquina

## Identificação

- data: 31/08/2026;
- responsável pela verificação: Professor Gerson Cesar Grobe de Miranda;
- equipamento: notebook de trabalho com Windows;
- finalidade: verificar a portabilidade e a reprodutibilidade do ambiente de
  desenvolvimento do BluePulse;
- linha de base do repositório: commit
  `750dc5794f0cb6e44dc875fd1defa607d4384d83`;
- escopo: Git, Flutter, testes automatizados, compilação Android e execução em
  dispositivo físico.

O nome do equipamento, seu identificador de hardware e o identificador único do
dispositivo Android não foram registrados, por não serem necessários para a
reprodução deste ensaio.

## Procedimento

1. Instalar o Git no notebook.
2. Clonar `https://github.com/cesargrobe/bluepulse.git` em
   `C:\Users\professor\Documents\Codex\bluepulse`.
3. Confirmar a branch `main`, a correspondência com `origin/main` e a ausência
   de alterações locais.
4. Verificar se havia instalação anterior do Flutter e se o executável estava
   disponível no `PATH`.
5. Instalar o Flutter `3.47.2` estável em
   `C:\Users\professor\develop\flutter`, sem exigir privilégios
   administrativos.
6. Acrescentar `C:\Users\professor\develop\flutter\bin` ao `PATH` do usuário.
7. Validar o ambiente Flutter e Android.
8. Executar análise estática, testes automatizados e compilação do APK de
   depuração.
9. Conectar um dispositivo Android físico com depuração USB autorizada.
10. Instalar e executar o BluePulse no dispositivo por `flutter run`.

## Observações registradas

| Verificação | Resultado informado |
| --- | --- |
| clone do GitHub | concluído |
| branch | `main` |
| sincronização inicial | 0 commits à frente e 0 atrás de `origin/main` |
| alterações locais antes da preparação | nenhuma |
| Flutter anterior | não encontrado nos locais usuais nem no `PATH` |
| Flutter instalado | `3.47.2`, canal estável |
| localização do SDK | `C:\Users\professor\develop\flutter` |
| análise estática | aprovada |
| testes automatizados | 24 aprovados |
| compilação Android | `app-debug.apk` gerado |
| dispositivo Android físico | reconhecido pelo Flutter |
| instalação e abertura do aplicativo | concluídas com sucesso |
| avaliação do orientador | funcionamento confirmado |

O APK foi gerado no caminho relativo
`app/build/app/outputs/flutter-apk/app-debug.apk`. Os arquivos produzidos em
`build/` permanecem fora do versionamento, conforme o fluxo normal do Flutter.

## Resultado

O ambiente do BluePulse foi reproduzido com sucesso em uma segunda máquina a
partir do repositório GitHub. A aplicação pôde ser analisada, testada,
compilada, instalada e aberta em um dispositivo Android físico. O resultado
reduz a dependência do computador pessoal originalmente utilizado e confirma
que os arquivos versionados são suficientes para retomar o desenvolvimento em
outro computador após a preparação das ferramentas externas.

## Limitações do registro

- as saídas integrais de `flutter doctor -v`, análise, testes e compilação não
  foram preservadas como arquivos de log neste ensaio; os resultados acima
  foram registrados a partir do resumo apresentado pelo ambiente de trabalho e
  da confirmação direta do orientador;
- as versões do Android SDK, Build Tools, JDK e do sistema Android do aparelho
  não foram anotadas nesta reprodução;
- a conexão BLE com o ESP32 não foi repetida no notebook durante esta etapa;
- o ensaio demonstra reprodutibilidade de desenvolvimento e execução, não
  validade clínica, fisiológica ou diagnóstica;
- os limiares `IR > 5000` e `movimento >= 0.08` continuam provisórios e não
  foram avaliados neste procedimento.

## Decisão operacional

O GitHub permanece como fonte oficial dos arquivos do projeto. Antes de iniciar
o trabalho em qualquer máquina, deve-se atualizar a cópia local; ao concluir,
as alterações aprovadas devem ser registradas em commit e enviadas ao GitHub.
Para reduzir conflitos, o desenvolvimento ativo será feito em uma máquina por
vez.
