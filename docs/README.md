# Documentação do BluePulse

Este diretório funciona como índice do caderno de engenharia e pesquisa do
BluePulse. Os registros preservam tanto resultados positivos quanto falhas,
incertezas e mudanças de decisão.

## Registros disponíveis

### Fundamentação e evolução da pesquisa

- [Proposta inicial apresentada por Emanuelle Pinheiro da Silva](pesquisa/proposta-inicial-emanuelle.md)
- [Visão científica, problema, hipótese e objetivos](pesquisa/visao-geral.md)
- [Evolução conceitual do projeto](pesquisa/evolucao-conceitual.md)
- [Fonte histórica — conversa “Blue Space e Saúde Mental”](fontes/conversa-blue-space-saude-mental.md)
- [Fonte histórica — artigo apresentado](fontes/artigo-rascunho-39.md)

As formulações científicas são versões preliminares reconstruídas do histórico.
Elas não devem ser confundidas com protocolo aprovado ou resultado experimental.

### Arquitetura

- [Arquitetura de hardware validada](hardware/README.md)
- [Decisão 0001 — adoção de dois barramentos I²C](decisoes/0001-dois-barramentos-i2c.md)

### Diário de bordo e experimentos

- [Diário de bordo de 29/08/2026](diario-de-bordo/2026-08-29.md)
- [Relatório do experimento de integração](experimentos/2026-08-29-integracao-hardware.md)

O diário apresenta a sequência de trabalho e as decisões. O relatório de
experimento descreve, de forma mais concentrada, a validação da arquitetura
integrada.

### Método de registro

- [Protocolo para documentação de ensaios](metodologia/registro-de-ensaios.md)

### Software e aquisição

- [Requisitos iniciais do aplicativo](software/requisitos-iniciais.md)
- [Especificação do MVP Android/Flutter](software/especificacao-mvp.md)
- [Plano passo a passo de testes e validações](software/plano-testes-validacoes.md)
- [Ambiente de desenvolvimento do aplicativo](software/ambiente-desenvolvimento.md)
- [Diário de desenvolvimento do aplicativo](software/diario-desenvolvimento.md)
- [Evidência da primeira execução Android](software/evidencias/2026-08-30-primeira-execucao-android.md)
- [Evidência do código anônimo e autorrelato inicial](software/evidencias/2026-08-30-codigo-anonimo-autorrelato.md)
- [Evidência da seleção de fonte e monitoramento simulado](software/evidencias/2026-08-30-monitoramento-simulado.md)
- [Evidência da sessão temporizada e pausa oceânica](software/evidencias/2026-08-30-sessao-temporizada-pausa-oceanica.md)
- [Evidência da primeira conexão BLE real](software/evidencias/2026-08-30-primeira-conexao-ble-real.md)
- [Proposta visual e análise de design](software/design/proposta-visual-2026-08-30.md)
- [Decisão 0002 — Flutter com Android primeiro](decisoes/0002-flutter-android-primeiro.md)
- [Histórico inicial de aquisição](aquisicao/historico-inicial.md)

### Dados

- [Manifesto dos dados brutos de 29/08/2026](../dados/brutos/2026-08-29/README.md)
- [Registro fotográfico de 29/08/2026](imagens/2026-08-29/README.md)

### Firmware experimental

Os sketches estão no [índice de firmware experimental](../firmware/testes/README.md). Cada pasta é uma
etapa independente e mantém o nome exigido pela estrutura de sketches do
Arduino.

## Convenções de evidência

Os documentos procuram separar quatro categorias:

- **observação:** saída registrada diretamente pelo equipamento ou pelo
  software;
- **interpretação:** explicação considerada compatível com as observações;
- **hipótese:** explicação ainda não confirmada por teste específico;
- **decisão:** escolha de projeto adotada para permitir a continuidade do
  trabalho.

Quando um registro é reconstruído posteriormente, isso deve ser declarado. Não
devem ser acrescentados horários, instrumentos, condições ambientais ou
resultados que não tenham sido anotados durante o ensaio.

## Escopo científico e clínico

O BluePulse é um protótipo experimental. Os registros deste repositório não
demonstram validade diagnóstica ou clínica. O sistema não substitui avaliação
profissional e não deve orientar decisões médicas.
