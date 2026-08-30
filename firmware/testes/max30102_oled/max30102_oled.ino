#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "MAX30105.h"

TwoWire I2C_MAX = TwoWire(0);

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1

Adafruit_SSD1306 display(
  SCREEN_WIDTH,
  SCREEN_HEIGHT,
  &I2C_MAX,
  OLED_RESET
);

MAX30105 maxSensor;

// Limiar provisório usado no ensaio inicial.
const long LIMIAR_IR_CONTATO = 5000;

void setup() {
  Serial.begin(115200);
  delay(1000);

  I2C_MAX.begin(32, 33, 100000);

  Serial.println();
  Serial.println("==============================");
  Serial.println("       BLUEPULSE OLED");
  Serial.println("==============================");

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println("ERRO: OLED nao encontrado.");
    while (1);
  }

  Serial.println("OLED OK!");

  if (!maxSensor.begin(I2C_MAX, I2C_SPEED_STANDARD)) {
    Serial.println("ERRO: MAX30102 nao encontrado.");
    while (1);
  }

  Serial.println("MAX30102 OK!");

  maxSensor.setup();
  maxSensor.setPulseAmplitudeRed(0x0A);
  maxSensor.setPulseAmplitudeIR(0x1F);

  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(2);
  display.setCursor(12, 5);
  display.println("BluePulse");
  display.setTextSize(1);
  display.setCursor(15, 35);
  display.println("Sistema iniciado");
  display.display();

  delay(2000);
}

void loop() {
  long valorIR = maxSensor.getIR();

  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(1);
  display.setCursor(0, 0);
  display.println("BLUEPULSE");
  display.drawLine(0, 10, 127, 10, SSD1306_WHITE);
  display.setCursor(0, 18);
  display.print("IR: ");
  display.println(valorIR);
  display.setCursor(0, 35);

  if (valorIR > LIMIAR_IR_CONTATO) {
    display.println("Contato detectado");
  } else {
    display.println("Sem contato");
  }

  display.display();
  delay(200);
}
