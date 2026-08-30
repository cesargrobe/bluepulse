#include <Wire.h>

#define MPU_ADDR 0x68

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
    dados[i] = Wire.read();
    i++;
  }
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("          BLUEPULSE");
  Serial.println("  TESTE MPU65xx - DIRETO I2C");
  Serial.println("==============================");

  escreverRegistro(0x6B, 0x00);
  delay(100);

  Serial.println("Sensor inicializado.");
  Serial.println("Movimente o modulo.");
  Serial.println();
}

void loop() {
  byte dados[14];
  lerRegistros(0x3B, 14, dados);

  int16_t ax = (dados[0] << 8) | dados[1];
  int16_t ay = (dados[2] << 8) | dados[3];
  int16_t az = (dados[4] << 8) | dados[5];
  int16_t gx = (dados[8] << 8) | dados[9];
  int16_t gy = (dados[10] << 8) | dados[11];
  int16_t gz = (dados[12] << 8) | dados[13];

  float AX = ax / 16384.0;
  float AY = ay / 16384.0;
  float AZ = az / 16384.0;
  float GX = gx / 131.0;
  float GY = gy / 131.0;
  float GZ = gz / 131.0;

  Serial.print("AX=");
  Serial.print(AX, 2);
  Serial.print("g | AY=");
  Serial.print(AY, 2);
  Serial.print("g | AZ=");
  Serial.print(AZ, 2);
  Serial.print(" || GX=");
  Serial.print(GX, 2);
  Serial.print(" | GY=");
  Serial.print(GY, 2);
  Serial.print(" | GZ=");
  Serial.print(GZ, 2);
  Serial.println();

  delay(250);
}
