#include <Wire.h>
#include "MAX30105.h"

MAX30105 sensor;

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("       BLUEPULSE");
  Serial.println("   Teste MAX30102 - IR");
  Serial.println("==============================");

  if (!sensor.begin(Wire, I2C_SPEED_STANDARD)) {
    Serial.println("ERRO: MAX30102 nao encontrado.");
    while (1);
  }

  Serial.println("MAX30102 encontrado!");

  sensor.setup();
  sensor.setPulseAmplitudeRed(0x0A);
  sensor.setPulseAmplitudeIR(0x1F);
}

void loop() {
  long valorIR = sensor.getIR();

  Serial.print("IR = ");
  Serial.println(valorIR);

  delay(500);
}
