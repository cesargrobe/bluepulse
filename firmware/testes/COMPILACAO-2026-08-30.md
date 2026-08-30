# Verificação de compilação — 30/08/2026

## Ambiente

- Arduino CLI: `1.5.1`;
- plataforma: `esp32:esp32 3.3.11`;
- placa-alvo: `esp32:esp32:esp32` (`ESP32 Dev Module`);
- Adafruit BusIO: `1.17.4`;
- Adafruit GFX Library: `1.12.6`;
- Adafruit SSD1306: `2.5.17`;
- Adafruit MPU6050: `2.2.9`;
- Adafruit Unified Sensor: `1.1.15`;
- SparkFun MAX3010x Pulse and Proximity Sensor Library: `1.1.2`.

## Procedimento

Cada diretório contendo um arquivo principal com o mesmo nome da pasta foi
compilado separadamente com:

```text
arduino-cli compile --fqbn esp32:esp32:esp32 <diretório-do-sketch>
```

## Resultado

Os 13 sketches listados no [índice de testes](README.md) compilaram sem erros.
O firmware integrado final ocupou:

```text
Memória de programa: 310.484 bytes de 1.310.720 bytes (23%)
Memória dinâmica:     23.932 bytes de   327.680 bytes (7%)
```

## Limite da verificação

Esta verificação comprova compatibilidade de compilação com o ambiente listado.
Não houve upload nem execução no hardware em 30/08/2026. Os resultados de
execução descritos no diário correspondem aos ensaios de 29/08/2026.

O fato de um sketch compilar não valida seu método experimental. Em particular,
a primeira versão de BPM produziu resultados espúrios, e o sketch baseado na
biblioteca Adafruit MPU6050 falhou na identificação do módulo durante a execução.
