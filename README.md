# BluePulse

Sistema vestível experimental de biofeedback e monitoramento fisiológico voltado
à identificação de alterações de ativação fisiológica e ao apoio a estratégias
de autorregulação associadas aos *Blue Spaces*.

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

## Documentação e firmware

- [Arquitetura de hardware](docs/hardware/README.md)
- [Experimento de integração de 29/08/2026](docs/experimentos/2026-08-29-integracao-hardware.md)
- [Firmware de integração dos sensores e OLED](firmware/testes/integracao_sensores_oled/integracao_sensores_oled.ino)

## Próximas etapas

- integrar a estimativa de frequência cardíaca (BPM);
- usar o sinal de movimento como indicador de qualidade da medição;
- melhorar a tolerância a falhas transitórias de leitura do módulo inercial;
- calibrar os limiares com um protocolo de testes reproduzível;
- evoluir a interface do OLED para apresentar informações úteis ao usuário.

## Licença

Este projeto é distribuído sob os termos da licença presente no arquivo
[LICENSE](LICENSE).
