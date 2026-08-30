#include <Wire.h>
#include <math.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "MAX30105.h"

// =====================================================
// BLUEPULSE — MAX30102 + OLED + MPU65xx compatível
// Protótipo experimental; não realiza diagnóstico clínico.
// =====================================================

// Dois barramentos I2C independentes no ESP32.
TwoWire I2C_MAX = TwoWire(0);
TwoWire I2C_MPU = TwoWire(1);

// OLED SSD1306 no mesmo barramento do MAX30102.
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
#define OLED_ADDR 0x3C

Adafruit_SSD1306 display(
  SCREEN_WIDTH,
  SCREEN_HEIGHT,
  &I2C_MAX,
  OLED_RESET
);

MAX30105 maxSensor;

// O módulo inercial respondeu WHO_AM_I=0x70 e é tratado como
// um dispositivo compatível com a família MPU65xx.
#define MPU_ADDR 0x68

// Limiares provisórios para os ensaios iniciais, ainda sem calibração.
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
  Serial.println(" OLED + MAX30102 + MPU65xx");
  Serial.println("==============================");

  // MAX30102 + OLED: SDA=GPIO32, SCL=GPIO33.
  I2C_MAX.begin(32, 33, 100000);

  if (!display.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
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

  // MPU65xx: SDA=GPIO21, SCL=GPIO22.
  I2C_MPU.begin(21, 22, 100000);
  escreverRegistroMPU(0x6B, 0x00);
  delay(100);

  Serial.println("MPU65xx iniciado!");

  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(2);
  display.setCursor(10, 8);
  display.println("BluePulse");
  display.setTextSize(1);
  display.setCursor(18, 38);
  display.println("Inicializando...");
  display.display();

  delay(2000);
}

void loop() {
  long valorIR = maxSensor.getIR();
  byte dados[14];
  bool leituraMPU = lerRegistrosMPU(0x3B, 14, dados);

  if (!leituraMPU) {
    Serial.println("ERRO na leitura do MPU.");

    display.clearDisplay();
    display.setTextSize(1);
    display.setCursor(0, 20);
    display.println("ERRO MPU65xx");
    display.display();

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

  bool contato = valorIR > LIMIAR_IR_CONTATO;
  bool emMovimento = movimento >= LIMIAR_MOVIMENTO;

  Serial.print("IR=");
  Serial.print(valorIR);
  Serial.print(" | A=");
  Serial.print(aceleracao, 3);
  Serial.print("g");
  Serial.print(" | Movimento=");
  Serial.print(movimento, 3);
  Serial.print(emMovimento ? " | EM MOVIMENTO" : " | PARADO");
  Serial.println(contato ? " | CONTATO" : " | SEM CONTATO");

  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(1);
  display.setCursor(34, 0);
  display.println("BLUEPULSE");
  display.drawLine(0, 10, 127, 10, SSD1306_WHITE);

  display.setCursor(0, 15);
  display.print("IR: ");
  display.println(valorIR);

  display.setCursor(0, 27);
  display.print("Mov: ");
  display.print(movimento, 3);

  display.setCursor(0, 39);
  display.println(emMovimento ? "EM MOVIMENTO" : "PARADO");

  display.setCursor(0, 51);
  display.println(contato ? "CONTATO: OK" : "SEM CONTATO");

  display.display();
  delay(200);
}
