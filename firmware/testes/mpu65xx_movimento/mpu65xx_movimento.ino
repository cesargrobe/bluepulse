#include <Wire.h>
#include <math.h>

#define MPU_ADDR 0x68

// Limiar experimental usado no ensaio de 29/08/2026.
const float LIMIAR_MOVIMENTO = 0.08;

void escreverRegistro(byte registro, byte valor) {
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(registro);
  Wire.write(valor);
  Wire.endTransmission();
}

void lerRegistros(byte registro, byte quantidade, byte *dados) {
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(registro);
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_ADDR, quantidade);

  byte i = 0;

  while (Wire.available() && i < quantidade) {
    dados[i++] = Wire.read();
  }
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("        BLUEPULSE");
  Serial.println("   DETECTOR DE MOVIMENTO");
  Serial.println("==============================");

  escreverRegistro(0x6B, 0x00);
  delay(100);

  Serial.println("Sensor iniciado.");
  Serial.println();
}

void loop() {
  byte dados[14];
  lerRegistros(0x3B, 14, dados);

  int16_t axRaw = (dados[0] << 8) | dados[1];
  int16_t ayRaw = (dados[2] << 8) | dados[3];
  int16_t azRaw = (dados[4] << 8) | dados[5];

  float ax = axRaw / 16384.0;
  float ay = ayRaw / 16384.0;
  float az = azRaw / 16384.0;

  float aceleracao = sqrt(ax * ax + ay * ay + az * az);
  float movimento = fabs(aceleracao - 1.0);

  Serial.print("A=");
  Serial.print(aceleracao, 3);
  Serial.print("g");
  Serial.print(" | Movimento=");
  Serial.print(movimento, 3);

  if (movimento < LIMIAR_MOVIMENTO) {
    Serial.println(" | PARADO");
  } else {
    Serial.println(" | EM MOVIMENTO");
  }

  delay(200);
}
