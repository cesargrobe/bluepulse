# Protocolo BLE BluePulse — versão 1

## Finalidade

Este documento define a primeira comunicação Bluetooth Low Energy entre o
ESP32 e o aplicativo Android. A versão 1 transmite somente dados técnicos já
observados nos ensaios de bancada. Não transmite diagnóstico, classificação de
estresse ou ansiedade, BPM, SpO₂ ou GSR.

## Identificação GATT

| Elemento | Valor |
| --- | --- |
| nome anunciado | `BluePulse-ESP32` |
| serviço | `7d2a0001-8f5b-4c2d-a9e1-3b6f5c7d9000` |
| característica de amostras | `7d2a0002-8f5b-4c2d-a9e1-3b6f5c7d9000` |
| propriedades | leitura e notificação |
| intervalo nominal | 200 ms (5 amostras por segundo) |

O aplicativo deve filtrar pelo UUID do serviço, descobrir a característica e
ativar notificações. O emparelhamento permanente não é requisito desta versão.

## Pacote binário de amostra

Cada notificação contém exatamente 12 bytes. Números com mais de um byte usam
ordem *little-endian*.

| Deslocamento | Tamanho | Campo | Tipo | Descrição |
| ---: | ---: | --- | --- | --- |
| 0 | 1 | versão | `uint8` | deve ser `1` |
| 1 | 1 | flags | bits | estado técnico da leitura |
| 2 | 4 | sequência | `uint32` | contador crescente desde a inicialização |
| 6 | 4 | IR | `int32` | leitura infravermelha bruta do MAX30102 |
| 10 | 2 | movimento | `uint16` | índice de movimento multiplicado por 1000 |

### Flags

| Bit | Máscara | Significado quando igual a 1 |
| ---: | ---: | --- |
| 0 | `0x01` | leitura do MPU65xx válida |
| 1 | `0x02` | contato provisório (`IR > 5000`) |
| 2 | `0x04` | movimento provisório (`movimento >= 0.08`) |
| 3 | `0x08` | falha de leitura do MPU65xx |
| 4–7 | — | reservados; devem ser zero |

Quando o MPU65xx falha, o firmware envia o valor de movimento como zero e
marca a falha. O valor IR continua sendo a leitura bruta disponível.

## Regras de validação no aplicativo

- rejeitar pacote cujo tamanho seja diferente de 12 bytes;
- rejeitar versão diferente de 1;
- não converter IR ou movimento em diagnóstico;
- apresentar a origem como **DADOS REAIS — PROTÓTIPO**;
- apresentar falha do sensor e perda de conexão sem inventar valores;
- manter `IR > 5000` e `movimento >= 0.08` identificados como provisórios;
- manter BPM, SpO₂ e GSR indisponíveis até protocolo específico de validação.

## Evolução

Qualquer alteração de tamanho, unidade ou significado exige uma nova versão do
pacote. A versão deve ser interpretada antes dos demais campos para impedir que
um aplicativo antigo apresente dados incompatíveis.
