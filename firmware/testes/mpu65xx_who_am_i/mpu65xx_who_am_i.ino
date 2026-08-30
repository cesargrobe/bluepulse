#include <Wire.h>

#define MPU_ADDR 0x68

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("       BLUEPULSE");
  Serial.println("   TESTE WHO_AM_I MPU6050");
  Serial.println("==============================");

  Wire.beginTransmission(MPU_ADDR);
  Wire.write(0x75);

  byte erro = Wire.endTransmission(false);

  if (erro != 0) {
    Serial.print("Erro de comunicacao I2C: ");
    Serial.println(erro);
    return;
  }

  Wire.requestFrom(MPU_ADDR, 1);

  if (Wire.available()) {
    byte valor = Wire.read();

    Serial.print("WHO_AM_I = 0x");
    if (valor < 16) Serial.print("0");
    Serial.println(valor, HEX);

    if (valor == 0x68) {
      Serial.println("Chip identificado como MPU6050.");
    } else {
      Serial.println("Resposta diferente de 0x68.");
    }
  } else {
    Serial.println("Nao houve resposta do registrador.");
  }
}

void loop() {
}
