# Arquitetura de hardware

## Visão geral

A arquitetura validada do protótipo BluePulse utiliza dois barramentos I²C do
ESP32. A separação mantém o módulo inercial em um barramento independente,
enquanto o MAX30102 e o display OLED compartilham o segundo barramento.

| Componente | Alimentação | SDA | SCL | Endereço observado/esperado |
| --- | --- | --- | --- | --- |
| MAX30102 | 3V3 / GND | GPIO32 | GPIO33 | `0x57` |
| OLED SSD1306 128 × 64 | 3V3 / GND | GPIO32 | GPIO33 | `0x3C` |
| MPU65xx compatível | 3V3 / GND | GPIO21 | GPIO22 | `0x68` |

```text
ESP32
├── I²C 0 — SDA GPIO32 / SCL GPIO33
│   ├── MAX30102
│   └── OLED SSD1306
└── I²C 1 — SDA GPIO21 / SCL GPIO22
    └── MPU65xx compatível

Alimentação comum: 3V3 e GND
```

Todos os módulos são alimentados em `3V3` e compartilham o mesmo `GND`. Essa
configuração respeita o nível lógico do ESP32 e foi a configuração usada nos
testes de integração.

## Identificação do módulo inercial

Durante a identificação eletrônica, a leitura do registrador `WHO_AM_I` retornou
`0x70`. O resultado confirma que o módulo responde no endereço I²C `0x68`, mas
não é suficiente, isoladamente, para registrar neste estágio uma identificação
comercial definitiva.

Por rastreabilidade, o firmware e a documentação adotam a denominação
**MPU65xx compatível**. O acesso atual usa diretamente os registradores comuns
da família: `PWR_MGMT_1` (`0x6B`) para retirar o dispositivo do modo de espera e
o bloco iniciado em `ACCEL_XOUT_H` (`0x3B`) para leitura dos dados.

## Critérios experimentais atuais

- `IR > 5000`: classifica provisoriamente que há contato com o MAX30102;
- `movimento >= 0.08`: classifica provisoriamente o conjunto como em movimento.

O valor de movimento é calculado como o desvio absoluto do módulo da aceleração
em relação a `1 g`. Ambos os limiares são provisórios e foram escolhidos a partir
dos primeiros ensaios de bancada. Não representam critérios clínicos e deverão
ser recalibrados após novos testes.

## Limitações observadas

Foram registradas falhas isoladas de leitura do MPU65xx durante movimentações e
com conexões provisórias. Como o sensor voltou a responder nas iterações
seguintes, a hipótese de trabalho é instabilidade elétrica ou mau contato. Essa
hipótese ainda precisa ser confirmada com montagem mais estável e repetição do
ensaio.

O BluePulse é um protótipo experimental: não realiza diagnóstico clínico, não é
um dispositivo médico validado e não substitui avaliação por profissional de
saúde.
