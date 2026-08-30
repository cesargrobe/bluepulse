# Evidência do código anônimo e autorrelato inicial

## Identificação

- data: 30/08/2026;
- incremento: código anônimo e autorrelato inicial;
- commit do aplicativo verificado: `fcea779`;
- plataforma: Flutter/Android;
- dispositivo de instalação: tablet Samsung SM-X810;
- estado: verificação automática e avaliação visual do orientador concluídas.

## Finalidade

Construir as duas etapas seguintes do fluxo do MVP sem introduzir contas,
cadastro nominal, persistência ou interpretação clínica. O incremento permanece
independente dos sensores e do BLE.

## Funcionalidades implementadas

### Código anônimo da sessão

- campo limitado a 12 caracteres;
- aceitação somente de letras, números e hífen;
- mínimo de três caracteres;
- transformação em letras maiúsculas ao avançar;
- orientação explícita para não usar nome, e-mail, telefone ou matrícula;
- confirmação obrigatória de ausência de dados pessoais;
- opção de cancelar e voltar à apresentação.

O aplicativo não tenta verificar se o texto corresponde a um nome real. A
proteção atual combina limitação de formato, aviso e confirmação do responsável
pela sessão. O protocolo futuro deverá definir previamente os códigos.

### Autorrelato inicial

Foram incluídas três perguntas provisórias, cada uma com escala de 1 a 5:

- tensão percebida;
- tranquilidade percebida;
- conforto percebido.

As perguntas testam apenas a interface. Não constituem escala psicológica
validada, diagnóstico, triagem ou medida de eficácia. O botão de conclusão só é
habilitado quando as três respostas são preenchidas.

Ao concluir, o aplicativo informa que as respostas:

- permanecem somente na memória;
- serão descartadas ao fechar o aplicativo;
- não representam avaliação clínica.

## Estrutura do código

O arquivo inicial foi dividido em componentes menores:

- `lib/main.dart`: inicialização;
- `lib/src/bluepulse_app.dart`: tema e configuração do aplicativo;
- `lib/src/screens/presentation_screen.dart`: apresentação;
- `lib/src/screens/session_code_screen.dart`: código e privacidade;
- `lib/src/screens/initial_self_report_screen.dart`: escalas provisórias.

Essa divisão prepara o crescimento do fluxo sem acoplar as telas ao BLE ou ao
armazenamento futuro.

## Verificações executadas

| Verificação | Resultado |
| --- | --- |
| formatação Dart | concluída |
| análise estática Flutter | sem problemas |
| testes automatizados | 4 de 4 aprovados |
| compilação Android de depuração | sucesso |
| atualização no tablet SM-X810 | sucesso |
| abertura da atividade principal | sucesso |
| avaliação visual e funcional pelo orientador | aprovada |

Os testes cobrem:

1. presença do aviso experimental;
2. rejeição de código curto;
3. exigência da confirmação de privacidade;
4. normalização do código para maiúsculas;
5. bloqueio da conclusão enquanto houver pergunta sem resposta;
6. preenchimento das três escalas;
7. aviso de armazenamento somente em memória e ausência de avaliação clínica;
8. cancelamento e retorno à apresentação.

## Avaliação pelo orientador

O Professor Gerson Cesar Grobe de Miranda percorreu o novo fluxo no tablet e
confirmou que estava tudo certo. Foram considerados aprovados neste incremento:

- apresentação da tela de código anônimo;
- validação e confirmação de privacidade;
- avanço para o autorrelato inicial;
- seleção das três escalas;
- habilitação do botão somente após o preenchimento;
- aviso final de armazenamento apenas em memória e ausência de avaliação
  clínica;
- legibilidade e funcionamento geral no dispositivo físico.

Não foram preservados o código digitado nem as respostas escolhidas durante a
avaliação, pois esses valores não são necessários como evidência e poderiam
representar dados indevidos no repositório.

## Limitações e próximo portão

- os valores ainda não são persistidos nem exportados;
- as perguntas e os rótulos dependem de revisão metodológica;
- não existe seleção entre modo simulado e BLE neste incremento;
- não houve análise de dados nem comparação pré/pós;
- o fluxo completo ainda depende das telas posteriores e de nova avaliação.

O próximo incremento poderá criar a seleção da fonte de dados e o primeiro
monitoramento simulado, mantendo BPM, SpO₂ e GSR nulos.
