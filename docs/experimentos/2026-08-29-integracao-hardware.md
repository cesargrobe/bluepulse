# Integração de hardware — 29 de agosto de 2026

## Objetivo

Validar o funcionamento simultâneo do ESP32, do sensor óptico MAX30102, do
módulo inercial tratado como MPU65xx compatível e do display OLED, incluindo a
aquisição dos sinais, classificações experimentais e apresentação local.

## Configuração ensaiada

| Componente | Barramento | Ligações | Endereço I²C |
| --- | --- | --- | --- |
| MAX30102 | I²C 0 | SDA GPIO32 / SCL GPIO33 | `0x57` |
| OLED SSD1306 | I²C 0 | SDA GPIO32 / SCL GPIO33 | `0x3C` |
| MPU65xx compatível | I²C 1 | SDA GPIO21 / SCL GPIO22 | `0x68` |

Os três módulos foram alimentados por `3V3` e `GND` do ESP32.

## Procedimento

1. O módulo inercial foi consultado pelo registrador `WHO_AM_I` e respondeu
   `0x70`. O componente passou a ser denominado MPU65xx compatível, sem assumir
   um modelo comercial específico.
2. Foram realizados testes de varredura I²C para confirmar a presença dos
   dispositivos nos dois barramentos.
3. O MAX30102 e o OLED foram inicializados no barramento GPIO32/33 e testados em
   conjunto.
4. O MPU65xx foi mantido no barramento independente GPIO21/22.
5. O firmware integrado passou a ler o valor infravermelho do MAX30102, os três
   eixos do acelerômetro e o módulo da aceleração.
6. Foram observados três estados: sem contato e parado; com contato e parado;
   e perturbação física do conjunto.
7. Os resultados foram acompanhados simultaneamente no monitor serial e no
   display OLED.

## Critérios usados no ensaio

```text
Contato:   IR > 5000
Movimento: |módulo da aceleração - 1 g| >= 0.08
```

Esses dois limiares são **provisórios**. Eles servem somente à exploração
inicial do protótipo e ainda não passaram por calibração ou validação sistemática.

## Resultados

### Inicialização e comunicação

- o OLED foi inicializado corretamente;
- o MAX30102 foi inicializado corretamente;
- o MPU65xx respondeu no segundo barramento;
- os três componentes funcionaram simultaneamente;
- o MAX30102 e o OLED compartilharam o barramento GPIO32/33 sem conflito
  observado no ensaio.

### Detecção de contato

Sem contato, as leituras de IR permaneceram predominantemente próximas de
`900` a `1200`. Com o dedo sobre o sensor, o sinal subiu para dezenas de
milhares, com valores observados acima de `85.000`. As transições entre os dois
estados foram reconhecidas pelo critério provisório `IR > 5000`.

Exemplos registrados:

```text
IR=1161  | Movimento=0.018 | PARADO | SEM CONTATO
IR=4510  | Movimento=0.025 | PARADO | SEM CONTATO
IR=22286 | Movimento=0.026 | PARADO | CONTATO
IR=85832 | Movimento=0.022 | PARADO | CONTATO
```

### Detecção de movimento

Com o conjunto parado, o módulo da aceleração permaneceu em torno de `1 g` e o
indicador de movimento apareceu frequentemente entre `0.015` e `0.030`. Durante
perturbações físicas, foram observados valores como `0.115`, `0.127` e `0.194`,
classificados como movimento pelo limiar provisório `0.08`.

Exemplos registrados:

```text
IR=1222 | A=0.873g | Movimento=0.127 | EM MOVIMENTO | SEM CONTATO
IR=993  | A=0.806g | Movimento=0.194 | EM MOVIMENTO | SEM CONTATO
IR=926  | A=1.115g | Movimento=0.115 | EM MOVIMENTO | SEM CONTATO
```

### Instabilidades observadas

O log final preserva 131 linhas de leitura: 40 classificadas como contato, 91
como sem contato, três como movimento e 128 como parado. Também ocorreram seis
mensagens de erro na leitura do MPU, incluindo uma sequência de três erros
consecutivos. A comunicação foi restabelecida nas iterações seguintes, sem
reinicialização do sistema. A
hipótese atual é instabilidade elétrica ou mau contato nas conexões provisórias,
mas isso não foi conclusivamente determinado. Um próximo ensaio deverá usar
conexões mecanicamente estáveis e poderá incluir tentativas adicionais de
leitura antes de declarar falha.

## Evidências preservadas

- [log serial integral da integração com OLED](../../dados/brutos/2026-08-29/04-integracao-sensores-oled.txt);
- [registro fotográfico dos módulos e da bancada](../imagens/2026-08-29/README.md);
- [firmware integrado](../../firmware/testes/integracao_sensores_oled/integracao_sensores_oled.ino).

## Conclusão

A etapa de integração básica foi considerada validada: ESP32, MAX30102,
MPU65xx compatível e OLED operaram simultaneamente, com detecção experimental de
contato e movimento e exibição dos estados no OLED.

O ensaio não validou medição de BPM, qualidade clínica do sinal ou uso médico.
O BluePulse não realiza diagnóstico clínico, não substitui avaliação
profissional e, neste estágio, deve ser tratado exclusivamente como protótipo
experimental.

## Próximos passos

- estabilizar as conexões físicas e repetir o teste;
- adicionar tolerância a falhas transitórias do MPU65xx;
- integrar o cálculo de BPM;
- usar movimento como indicador de qualidade da leitura óptica;
- definir e executar um protocolo de calibração dos limiares.
