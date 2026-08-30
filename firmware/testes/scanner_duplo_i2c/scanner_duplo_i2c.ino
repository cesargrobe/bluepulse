#include <Wire.h>

TwoWire I2C_MAX = TwoWire(0);
TwoWire I2C_MPU = TwoWire(1);

void escanearI2C(TwoWire &barramento, const char *nome) {
  byte erro;
  int encontrados = 0;

  Serial.println();
  Serial.println("------------------------------");
  Serial.print("Escaneando: ");
  Serial.println(nome);
  Serial.println("------------------------------");

  for (byte endereco = 1; endereco < 127; endereco++) {
    barramento.beginTransmission(endereco);
    erro = barramento.endTransmission();

    if (erro == 0) {
      Serial.print("Encontrado em: 0x");

      if (endereco < 16) {
        Serial.print("0");
      }

      Serial.println(endereco, HEX);
      encontrados++;
    }
  }

  Serial.print("Total encontrado: ");
  Serial.println(encontrados);
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println();
  Serial.println("==============================");
  Serial.println("          BLUEPULSE");
  Serial.println("    TESTE DUPLO I2C ESP32");
  Serial.println("==============================");

  I2C_MAX.begin(32, 33, 100000);
  I2C_MPU.begin(21, 22, 100000);

  Serial.println("Barramentos iniciados.");
}

void loop() {
  escanearI2C(I2C_MAX, "MAX30102 - GPIO32/33");
  escanearI2C(I2C_MPU, "MPU65xx - GPIO21/22");

  Serial.println();
  Serial.println("==============================");
  Serial.println("Nova leitura em 5 segundos...");
  Serial.println("==============================");

  delay(5000);
}
