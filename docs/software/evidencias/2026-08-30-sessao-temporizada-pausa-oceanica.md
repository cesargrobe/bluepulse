# Evidência da sessão temporizada e pausa oceânica

## Identificação

- data: 30/08/2026;
- responsável pela implementação: Codex, sob orientação do Professor Gerson
  Cesar Grobe de Miranda;
- commit do incremento: `e1a43e1`;
- dispositivo de instalação: tablet Samsung SM-X810;
- natureza dos dados: exclusivamente simulados.

## Objetivo

Acrescentar ao fluxo já validado uma sessão automática curta e uma primeira
intervenção visual inspirada em *Blue Spaces*, sem apresentar medidas
fisiológicas não validadas e sem introduzir armazenamento ou áudio sem
proveniência.

## Implementação

A tela de monitoramento manual recebeu a opção **Iniciar sessão temporizada**.
O ensaio dura 30 segundos e percorre automaticamente a sequência determinística
dos quatro estados já existentes. A interface informa o tempo restante, o
progresso, o estado da amostra e permite pausar, continuar ou cancelar.

Ao término, o participante pode conhecer uma pausa oceânica visual e opcional
de 30 segundos. Um círculo animado e textos alternam entre quatro segundos de
inspiração suave e seis segundos de expiração suave. A pessoa é orientada a
respirar naturalmente e interromper em caso de desconforto.

O áudio não foi incorporado. A própria tela informa que um som oceânico só
será incluído quando autoria, origem e licença puderem ser registradas.

## Limites e linguagem de segurança

- o aplicativo não realiza diagnóstico clínico e a pausa não é tratamento;
- `IR > 5000` e `movimento >= 0.08` continuam sendo limiares provisórios de
  bancada;
- BPM, SpO₂ e GSR permanecem indisponíveis;
- nenhuma amostra ou resposta é salva nesta versão;
- os dados são identificados permanentemente como simulados;
- a intervenção depende de ação explícita e pode ser recusada ou interrompida.

## Verificação executada

| Verificação | Resultado |
| --- | --- |
| formatação do código | aprovada |
| análise estática Flutter | nenhuma ocorrência |
| testes automatizados | 12 aprovados |
| compilação Android de depuração | aprovada |
| instalação no tablet Samsung SM-X810 | aprovada |
| abertura automática do aplicativo | aprovada |
| avaliação visual e de conforto pelo orientador | aprovada |

Os testes automatizados confirmaram que o relógio inicia, pausa, continua e
termina, que o tempo não avança durante a pausa e que a tela da intervenção só
é apresentada após a conclusão do monitoramento. Também foi verificada a
presença do aviso sobre áudio e da declaração de ausência de diagnóstico.

## Avaliação manual e decisão

O Professor Gerson Cesar Grobe de Miranda percorreu todo o fluxo no tablet em
30/08/2026 e informou que o processo funcionou corretamente. Com essa
confirmação, ficam aprovados neste incremento o monitoramento temporizado, os
controles de pausa e continuação, a transição ao término e a pausa oceânica
visual. Não foi relatado problema de legibilidade, funcionamento ou conforto
durante essa avaliação interna.

A aprovação se limita ao funcionamento e à apresentação do protótipo. Ela não
constitui validação clínica, avaliação de eficácia ou autorização para coleta
com participantes.

Ainda não há autorização para coleta com participantes, inferência de estresse
ou ansiedade, exibição de BPM, inclusão de áudio ou alegação de eficácia.
