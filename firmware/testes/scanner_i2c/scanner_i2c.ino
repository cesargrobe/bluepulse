#include <Wire.h>

#define SDA_PIN 21
#define SCL_PIN 22

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(SDA_PIN, SCL_PIN);

  Serial.println();
  Serial.println("==============================");
  Serial.println("       BLUEPULSE");
  Serial.println("     Scanner I2C");
  Serial.println("==============================");
}

void loop() {
  byte erro;
  byte endereco;
  int dispositivos = 0;

  Serial.println();
  Serial.println("Procurando dispositivos I2C...");

  for (endereco = 1; endereco < 127; endereco++) {
    Wire.beginTransmission(endereco);
    erro = Wire.endTransmission();

    if (erro == 0) {
      Serial.print("Dispositivo encontrado: 0x");

      if (endereco < 16) {
        Serial.print("0");
      }

      Serial.println(endereco, HEX);
      dispositivos++;
    }
  }

  if (dispositivos == 0) {
    Serial.println("Nenhum dispositivo I2C encontrado.");
  } else {
    Serial.print("Total encontrado: ");
    Serial.println(dispositivos);
  }

  Serial.println("------------------------------");
  delay(5000);
}
