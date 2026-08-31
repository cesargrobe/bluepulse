# BluePulse

Sistema vestível experimental de biofeedback e monitoramento fisiológico voltado
à identificação de alterações de ativação fisiológica e ao apoio a estratégias
de autorregulação associadas aos *Blue Spaces*.

## Origem do projeto

A proposta inicial de um aplicativo inspirado nos benefícios dos *blue spaces*,
integrado a um relógio inteligente, foi idealizada e apresentada pela estudante
**Emanuelle Pinheiro da Silva**, matriculada no 9º ano, sob orientação do
**Professor Gerson Cesar Grobe de Miranda**.

O [registro da proposta inicial](docs/pesquisa/proposta-inicial-emanuelle.md)
preserva o problema, a justificativa, os objetivos, o resumo e o artigo
apresentado pela estudante.

## Objetivo

O BluePulse investiga a integração de sinais fisiológicos e de movimento em um
dispositivo vestível. O protótipo atual combina leitura óptica, medição inercial
e retorno visual local para apoiar o desenvolvimento e a avaliação de futuras
estratégias de biofeedback.

> **Aviso importante:** o BluePulse é um projeto experimental e educacional. O
> sistema não realiza diagnóstico clínico, não substitui avaliação profissional
> e não deve ser usado para orientar decisões médicas.

## Estado atual

A primeira integração de hardware foi validada com os seguintes componentes:

- ESP32 como unidade de processamento;
- MAX30102 e display OLED no barramento I²C com SDA em GPIO32 e SCL em GPIO33;
- módulo inercial MPU65xx em barramento I²C independente, com SDA em GPIO21 e
  SCL em GPIO22;
- alimentação dos módulos em 3V3 e GND;
- leitura simultânea de intensidade infravermelha, aceleração e estado de
  movimento, com apresentação no display OLED.

O módulo inercial respondeu ao registrador `WHO_AM_I` com o valor `0x70`. Por
esse motivo, enquanto a identificação comercial exata não for confirmada, ele
é tratado no projeto como um dispositivo compatível com a família MPU65xx.

Os critérios `IR > 5000` para contato e `movimento >= 0.08` para movimento são
**limiares provisórios**, definidos apenas para os ensaios iniciais. Eles ainda
precisam de calibração, repetição dos testes e validação em condições variadas.

O primeiro aplicativo Android já foi criado em Flutter. Ele apresenta o aviso
de uso experimental, solicita um código anônimo e oferece um autorrelato inicial
provisório. O monitoramento simulado percorre quatro estados reproduzíveis. A
primeira conexão BLE real com o ESP32 já foi realizada, transmitindo IR bruto,
movimento e qualidade pelo protocolo v1; essas amostras reais ainda permanecem
somente na memória. A sessão simulada de 30 segundos já pode ser salva na área
privada do aplicativo, exportada em CSV e JSON ou excluída sob confirmação. Há
também uma primeira pausa oceânica visual opcional, ainda sem áudio. Os
incrementos passam por análise estática, testes automatizados, compilação e
execução Android.

## Documentação e firmware

- [Índice completo da documentação](docs/README.md)
- [Visão científica, problema, hipótese e objetivos](docs/pesquisa/visao-geral.md)
- [Proposta inicial e autoria](docs/pesquisa/proposta-inicial-emanuelle.md)
- [Evolução conceitual do projeto](docs/pesquisa/evolucao-conceitual.md)
- [Especificação do MVP do aplicativo](docs/software/especificacao-mvp.md)
- [Plano passo a passo de testes e validações](docs/software/plano-testes-validacoes.md)
- [Código do aplicativo Flutter](app/README.md)
- [Evidência da primeira execução Android](docs/software/evidencias/2026-08-30-primeira-execucao-android.md)
- [Evidência do código anônimo e autorrelato inicial](docs/software/evidencias/2026-08-30-codigo-anonimo-autorrelato.md)
- [Evidência da seleção de fonte e monitoramento simulado](docs/software/evidencias/2026-08-30-monitoramento-simulado.md)
- [Evidência da sessão temporizada e pausa oceânica](docs/software/evidencias/2026-08-30-sessao-temporizada-pausa-oceanica.md)
- [Evidência da persistência e exportação simulada](docs/software/evidencias/2026-08-30-persistencia-exportacao-simulada.md)
- [Evidência da primeira conexão BLE real](docs/software/evidencias/2026-08-30-primeira-conexao-ble-real.md)
- [Proposta visual e análise de design](docs/software/design/proposta-visual-2026-08-30.md)
- [Arquitetura de hardware](docs/hardware/README.md)
- [Experimento de integração de 29/08/2026](docs/experimentos/2026-08-29-integracao-hardware.md)
- [Registro fotográfico de 29/08/2026](docs/imagens/2026-08-29/README.md)
- [Firmware de integração dos sensores e OLED](firmware/testes/integracao_sensores_oled/integracao_sensores_oled.ino)
- [Dados brutos preservados](dados/brutos/2026-08-29/README.md)

## Próximas etapas

- completar as telas do primeiro fluxo navegável do aplicativo;
- integrar a estimativa de frequência cardíaca (BPM) somente após validação
  específica;
- usar o sinal de movimento como indicador de qualidade da medição;
- melhorar a tolerância a falhas transitórias de leitura do módulo inercial;
- calibrar os limiares com um protocolo de testes reproduzível;
- evoluir a interface do OLED para apresentar informações úteis ao usuário;
- revisar e aprovar formalmente o problema, a hipótese, os objetivos e o
  protocolo ético antes de estudos com participantes;
- verificar no tablet a recuperação de uma sessão salva após fechar e reabrir
  o aplicativo; exportação, horário final e exclusão local já foram validados;
- acrescentar histórico de sessões antes de persistir qualquer dado real.

## Licença

Este projeto é distribuído sob os termos da licença presente no arquivo
[LICENSE](LICENSE).
