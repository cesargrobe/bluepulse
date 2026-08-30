#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"

// Primeira tentativa de BPM, preservada para rastreabilidade.
// A média inclui posições inicialmente zeradas e pode produzir valores espúrios.
MAX30105 sensor;

const byte TAXA_MEDIA = 4;
byte taxas[TAXA_MEDIA];

byte indice = 0;
long ultimoBatimento = 0;

float bpmAtual;
int bpmMedio;

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("       BLUEPULSE");
  Serial.println("   Teste de Frequencia");
  Serial.println("       Cardiaca");
  Serial.println("==============================");

  if (!sensor.begin(Wire, I2C_SPEED_STANDARD)) {
    Serial.println("ERRO: MAX30102 nao encontrado.");
    while (1);
  }

  Serial.println("MAX30102 encontrado.");
  Serial.println("Coloque o dedo sobre o sensor.");

  sensor.setup();
  sensor.setPulseAmplitudeRed(0x0A);
  sensor.setPulseAmplitudeIR(0x1F);
}

void loop() {
  long valorIR = sensor.getIR();

  if (checkForBeat(valorIR)) {
    long intervalo = millis() - ultimoBatimento;
    ultimoBatimento = millis();

    bpmAtual = 60.0 / (intervalo / 1000.0);

    if (bpmAtual > 40 && bpmAtual < 200) {
      taxas[indice++] = (byte)bpmAtual;
      indice %= TAXA_MEDIA;

      bpmMedio = 0;

      for (byte i = 0; i < TAXA_MEDIA; i++) {
        bpmMedio += taxas[i];
      }

      bpmMedio /= TAXA_MEDIA;
    }
  }

  Serial.print("IR=");
  Serial.print(valorIR);
  Serial.print(" | BPM=");
  Serial.print(bpmAtual);
  Serial.print(" | Media=");
  Serial.print(bpmMedio);

  if (valorIR < 10000) {
    Serial.print(" | SEM DEDO");
  } else {
    Serial.print(" | DEDO DETECTADO");
  }

  Serial.println();
}
