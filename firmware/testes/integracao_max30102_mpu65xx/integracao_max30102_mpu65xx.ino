#include <Wire.h>
#include <math.h>
#include "MAX30105.h"

TwoWire I2C_MAX = TwoWire(0);
TwoWire I2C_MPU = TwoWire(1);

MAX30105 maxSensor;

#define MPU_ADDR 0x68

// Limiares provisórios usados no ensaio inicial.
const long LIMIAR_IR_CONTATO = 5000;
const float LIMIAR_MOVIMENTO = 0.08;

void escreverRegistroMPU(byte registro, byte valor) {
  I2C_MPU.beginTransmission(MPU_ADDR);
  I2C_MPU.write(registro);
  I2C_MPU.write(valor);
  I2C_MPU.endTransmission();
}

bool lerRegistrosMPU(byte registro, byte quantidade, byte *dados) {
  I2C_MPU.beginTransmission(MPU_ADDR);
  I2C_MPU.write(registro);

  if (I2C_MPU.endTransmission(false) != 0) {
    return false;
  }

  byte recebidos = I2C_MPU.requestFrom(MPU_ADDR, quantidade);

  if (recebidos != quantidade) {
    return false;
  }

  for (byte i = 0; i < quantidade; i++) {
    dados[i] = I2C_MPU.read();
  }

  return true;
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println();
  Serial.println("==============================");
  Serial.println("          BLUEPULSE");
  Serial.println("  MAX30102 + MPU65xx");
  Serial.println("==============================");

  I2C_MAX.begin(32, 33, 100000);

  Serial.println("Iniciando MAX30102...");

  if (!maxSensor.begin(I2C_MAX, I2C_SPEED_STANDARD)) {
    Serial.println("ERRO: MAX30102 nao encontrado.");
    while (1);
  }

  Serial.println("MAX30102 OK!");

  maxSensor.setup();
  maxSensor.setPulseAmplitudeRed(0x0A);
  maxSensor.setPulseAmplitudeIR(0x1F);

  I2C_MPU.begin(21, 22, 100000);

  Serial.println("Iniciando MPU65xx...");
  escreverRegistroMPU(0x6B, 0x00);
  delay(100);

  Serial.println("MPU65xx OK!");
  Serial.println();
  Serial.println("Iniciando leituras...");
  Serial.println();
}

void loop() {
  long valorIR = maxSensor.getIR();
  byte dados[14];
  bool leituraMPU = lerRegistrosMPU(0x3B, 14, dados);

  if (!leituraMPU) {
    Serial.println("ERRO na leitura do MPU.");
    delay(500);
    return;
  }

  int16_t axRaw = (dados[0] << 8) | dados[1];
  int16_t ayRaw = (dados[2] << 8) | dados[3];
  int16_t azRaw = (dados[4] << 8) | dados[5];

  float ax = axRaw / 16384.0;
  float ay = ayRaw / 16384.0;
  float az = azRaw / 16384.0;

  float aceleracao = sqrt(ax * ax + ay * ay + az * az);
  float movimento = fabs(aceleracao - 1.0);

  Serial.print("IR=");
  Serial.print(valorIR);
  Serial.print(" | A=");
  Serial.print(aceleracao, 3);
  Serial.print("g");
  Serial.print(" | Movimento=");
  Serial.print(movimento, 3);

  if (movimento < LIMIAR_MOVIMENTO) {
    Serial.print(" | PARADO");
  } else {
    Serial.print(" | EM MOVIMENTO");
  }

  if (valorIR < LIMIAR_IR_CONTATO) {
    Serial.print(" | SEM CONTATO");
  } else {
    Serial.print(" | SENSOR EM CONTATO");
  }

  Serial.println();
  delay(200);
}
