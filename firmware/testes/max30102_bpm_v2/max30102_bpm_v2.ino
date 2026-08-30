#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"

// Segunda tentativa proposta após a análise dos resultados da V1.
// Este sketch é experimental e não fornece medição clinicamente validada.
MAX30105 sensor;

const byte TAMANHO_MEDIA = 4;
byte bpmBuffer[TAMANHO_MEDIA];
byte indice = 0;
byte quantidadeValidos = 0;

unsigned long ultimoBatimento = 0;

float bpmAtual = 0;
float bpmMedio = 0;

bool dedoAnterior = false;

void limparMedicao() {
  indice = 0;
  quantidadeValidos = 0;
  ultimoBatimento = 0;
  bpmAtual = 0;
  bpmMedio = 0;

  for (byte i = 0; i < TAMANHO_MEDIA; i++) {
    bpmBuffer[i] = 0;
  }
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("          BLUEPULSE");
  Serial.println("     TESTE CARDIACO V2");
  Serial.println("==============================");

  if (!sensor.begin(Wire, I2C_SPEED_STANDARD)) {
    Serial.println("ERRO: MAX30102 nao encontrado!");
    while (1);
  }

  byte brilhoLED = 60;
  byte mediaAmostras = 4;
  byte modoLED = 2;
  int taxaAmostragem = 100;
  int larguraPulso = 411;
  int faixaADC = 4096;

  sensor.setup(
    brilhoLED,
    mediaAmostras,
    modoLED,
    taxaAmostragem,
    larguraPulso,
    faixaADC
  );

  limparMedicao();

  Serial.println("MAX30102 inicializado.");
  Serial.println("Coloque o dedo suavemente sobre o sensor.");
  Serial.println();
}

void loop() {
  long ir = sensor.getIR();
  bool dedo = ir > 10000;

  if (!dedo) {
    if (dedoAnterior) {
      limparMedicao();
      Serial.println();
      Serial.println("Dedo removido. Medicao reiniciada.");
      Serial.println();
    }

    dedoAnterior = false;
    Serial.print("IR=");
    Serial.print(ir);
    Serial.println(" | SEM DEDO");
    delay(100);
    return;
  }

  if (!dedoAnterior) {
    limparMedicao();
    Serial.println();
    Serial.println("DEDO DETECTADO");
    Serial.println("Aguarde estabilizacao...");
    Serial.println();
    dedoAnterior = true;
  }

  if (checkForBeat(ir)) {
    unsigned long agora = millis();

    if (ultimoBatimento != 0) {
      unsigned long intervalo = agora - ultimoBatimento;
      float bpmCalculado = 60000.0 / intervalo;

      if (bpmCalculado >= 40 && bpmCalculado <= 180) {
        bpmAtual = bpmCalculado;
        bpmBuffer[indice] = (byte)bpmAtual;
        indice++;

        if (indice >= TAMANHO_MEDIA) {
          indice = 0;
        }

        if (quantidadeValidos < TAMANHO_MEDIA) {
          quantidadeValidos++;
        }

        int soma = 0;

        for (byte i = 0; i < quantidadeValidos; i++) {
          soma += bpmBuffer[i];
        }

        bpmMedio = (float)soma / quantidadeValidos;

        Serial.print("*** BATIMENTO ***  ");
        Serial.print("BPM=");
        Serial.print(bpmAtual, 1);
        Serial.print(" | MEDIA=");
        Serial.println(bpmMedio, 1);
      }
    }

    ultimoBatimento = agora;
  }

  static unsigned long ultimaExibicao = 0;

  if (millis() - ultimaExibicao >= 500) {
    ultimaExibicao = millis();
    Serial.print("IR=");
    Serial.print(ir);
    Serial.print(" | BPM=");
    Serial.print(bpmAtual, 1);
    Serial.print(" | MEDIA=");
    Serial.print(bpmMedio, 1);
    Serial.println(" | DEDO OK");
  }
}
