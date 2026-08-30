# Protocolo para documentação de ensaios

## Finalidade

Este protocolo define o conteúdo mínimo dos próximos registros experimentais do
BluePulse. O objetivo é favorecer rastreabilidade, reprodutibilidade e distinção
entre dado observado e interpretação.

## Antes do ensaio

Registrar:

1. data e, quando disponível, horário e local;
2. responsável pelo ensaio;
3. objetivo ou pergunta experimental;
4. componentes, versões e identificação visível;
5. montagem elétrica e alimentação;
6. versão do firmware, preferencialmente pelo hash do commit;
7. versão das ferramentas e bibliotecas;
8. condições relevantes, como tipo de contato, posição do sensor, fixação,
   iluminação e estado das conexões;
9. critérios de interrupção por segurança.

## Durante o ensaio

- preservar a saída serial completa em arquivo de texto sem edição;
- registrar alterações de montagem ou procedimento no momento em que ocorrerem;
- identificar períodos ou eventos, como “sem contato”, “contato”, “parado” e
  “em movimento”;
- guardar fotografias da montagem quando elas forem necessárias para reproduzir
  a configuração;
- não apagar leituras inesperadas ou falhas.

## Depois do ensaio

Produzir um documento com:

1. objetivo;
2. materiais e configuração;
3. procedimento executado;
4. dados brutos associados;
5. resultados observados;
6. interpretação;
7. hipóteses que ainda exigem teste;
8. limitações;
9. conclusão restrita ao que foi efetivamente demonstrado;
10. próximos passos.

## Integridade dos dados

Os arquivos brutos devem ser preservados sem correção de grafia, remoção de
linhas ou normalização. Quando possível, registrar tamanho e hash SHA-256. Dados
tratados, recortes e gráficos devem ficar separados dos arquivos brutos e citar
claramente a fonte.

## Controle de versões

- cada sketch experimental deve permanecer recuperável;
- mudanças substanciais de método ou lógica devem gerar novo arquivo ou commit;
- o relatório deve apontar o sketch e o commit usados;
- resultados negativos fazem parte do registro e não devem ser sobrescritos;
- correções retrospectivas devem ser identificadas como correções.

## Limiares e linguagem

Valores como `IR > 5000` e `movimento >= 0.08` devem ser descritos como
**provisórios** até que exista protocolo de calibração e validação. Expressões
como “comprovado” ou “validado” devem indicar exatamente o escopo: por exemplo,
comunicação eletrônica no ensaio de bancada, e não desempenho clínico.

O BluePulse não realiza diagnóstico clínico e não substitui avaliação por
profissional de saúde.
