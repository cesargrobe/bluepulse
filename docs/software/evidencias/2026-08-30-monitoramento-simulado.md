# Evidência da seleção de fonte e monitoramento simulado

## Identificação

- data: 30/08/2026;
- incremento: seleção da fonte e primeiro monitoramento simulado;
- commit do aplicativo verificado: `3a453ff`;
- plataforma: Flutter/Android;
- dispositivo de instalação: tablet Samsung SM-X810;
- estado: verificações automáticas e instalação concluídas; avaliação visual do
  orientador pendente.

## Finalidade

Permitir que o fluxo avance do autorrelato inicial para uma fonte de dados
artificial, reproduzível e claramente identificada. O incremento permite testar
os estados da interface antes de conectar o ESP32.

## Seleção da fonte

A nova tela apresenta duas alternativas:

- **modo simulado:** disponível e identificado como sequência artificial;
- **dispositivo BLE:** visível, mas desabilitado até que o protocolo de
  comunicação seja definido e testado.

Nenhuma permissão Bluetooth é solicitada nesta etapa. A escolha informa somente
a origem técnica das amostras e não produz interpretação clínica.

## Simulador determinístico

O simulador usa uma semente estável derivada do código anônimo da sessão. A
mesma semente e o mesmo índice produzem a mesma amostra, permitindo repetir os
testes. A sequência manual percorre quatro cenários:

1. **sem contato:** intensidade infravermelha baixa e qualidade indisponível;
2. **sinal adequado:** contato simulado e baixo movimento;
3. **movimento detectado:** amostra marcada como afetada;
4. **falha simulada:** leitura temporariamente indisponível.

Após o quarto cenário, a sequência recomeça. O usuário pode avançar cada amostra
manualmente ou reiniciar a sequência. Não há temporizador, transmissão nem
coleta em segundo plano.

## Dados exibidos

- intensidade infravermelha simulada;
- contato detectado;
- índice de movimento;
- qualidade da amostra;
- número do cenário na sequência.

BPM, SpO₂ e GSR permanecem nulos no modelo e são apresentados como “Não
disponíveis”. A interface também declara que os critérios `IR > 5000` e
`movimento >= 0.08` são provisórios de bancada e que os valores não representam
uma pessoa.

## Estrutura adicionada

- `lib/src/models/session_draft.dart`: rascunho da sessão e autorrelato;
- `lib/src/simulation/deterministic_simulator.dart`: amostras e cenários;
- `lib/src/screens/data_source_selection_screen.dart`: seleção da origem;
- `lib/src/screens/simulated_monitoring_screen.dart`: monitoramento manual;
- `test/deterministic_simulator_test.dart`: reprodutibilidade e campos nulos.

## Verificações executadas

| Verificação | Resultado |
| --- | --- |
| formatação Dart | concluída |
| análise estática Flutter | sem problemas |
| testes automatizados | 9 de 9 aprovados |
| compilação Android de depuração | sucesso |
| atualização no tablet SM-X810 | sucesso |
| abertura da atividade principal | sucesso |

Os testes confirmam:

- mesma semente gera a mesma sequência;
- índice negativo é rejeitado;
- os quatro cenários aparecem na ordem definida;
- BPM, SpO₂ e GSR permanecem nulos;
- BLE permanece desabilitado;
- o modo simulado é identificado na interface;
- os quatro estados podem ser percorridos;
- os limiares provisórios aparecem na tela.

## Limitações e próximo portão

- as amostras não são persistidas nem exportadas;
- o simulador é manual e possui apenas quatro estados básicos;
- ainda faltam testes de serialização dos modelos;
- a fonte BLE é somente uma indicação visual desabilitada;
- a nova interface precisa de avaliação visual no tablet pelo orientador.

Após a aprovação visual, o próximo incremento deverá definir o comportamento da
sessão simulada ao longo do tempo e preparar a intervenção Blue Space, sem
antecipar a implementação BLE real.
