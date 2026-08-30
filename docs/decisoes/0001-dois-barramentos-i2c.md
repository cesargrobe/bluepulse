# Decisão 0001 — adoção de dois barramentos I²C

- **Data da decisão:** 29/08/2026
- **Estado:** adotada para o protótipo atual
- **Reconstrução documental:** 30/08/2026

## Contexto

O MAX30102 e o módulo inercial foram inicialmente testados no barramento padrão
do ESP32, em GPIO21/22. Isoladamente, o scanner encontrou o MAX30102 em `0x57` e
o módulo inercial em `0x68`.

Ao conectar ambos ao mesmo barramento, foram observadas situações em que apenas
`0x57` aparecia ou nenhum dispositivo era encontrado. Em uma etapa do
diagnóstico, a conexão USB caiu ao conectar o GND do MAX30102. O teste conjunto
foi interrompido para evitar insistência em uma possível falha elétrica.

As conexões eram provisórias e não estavam adequadamente soldadas.

## Evidências

### Observações

- cada módulo respondeu isoladamente;
- os endereços `0x57` e `0x68` não representam conflito lógico de endereço;
- o barramento compartilhado apresentou comportamento instável na montagem
  provisória;
- com o MAX30102 em GPIO32/33 e o MPU65xx em GPIO21/22, ambos foram encontrados
  simultaneamente e repetidamente;
- a leitura integrada dos dois sensores funcionou nessa configuração.

### Hipóteses não confirmadas

- mau contato nos terminais e jumpers;
- instabilidade de alimentação ou terra;
- interação dos resistores de *pull-up* presentes nos módulos;
- ligação incorreta ou contato cruzado durante a montagem provisória.

Não houve medição elétrica suficiente para selecionar uma dessas hipóteses como
causa definitiva.

## Decisão

Adotar dois controladores I²C do ESP32:

```text
I²C 0 — SDA GPIO32 / SCL GPIO33
├── MAX30102 (0x57)
└── OLED SSD1306 (0x3C)

I²C 1 — SDA GPIO21 / SCL GPIO22
└── MPU65xx compatível (0x68)
```

Todos os módulos usam alimentação `3V3` e `GND` comum.

## Consequências

### Positivas

- permitiu a continuidade dos testes integrados;
- isolou o módulo inercial do barramento do sensor óptico e do display;
- tornou a arquitetura observada reproduzível no protótipo atual.

### Limitações

- utiliza os dois controladores I²C disponíveis;
- não determina a causa da falha do barramento compartilhado;
- a decisão poderá ser revista após soldagem, inspeção e medições elétricas.

## Alternativas consideradas

- manter os dois sensores em GPIO21/22: rejeitada provisoriamente pela
  instabilidade observada;
- desenvolver cada sensor separadamente: útil como diagnóstico, mas insuficiente
  para o objetivo de integração;
- soldar e investigar eletricamente antes de avançar: permanece recomendado para
  a montagem definitiva, mas não foi executado naquele ensaio.
