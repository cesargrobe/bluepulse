#include <Wire.h>
#include <math.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "MAX30105.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// =====================================================
// BLUEPULSE — MAX30102 + OLED + MPU65xx + BLE
// Protocolo BLE v1; não realiza diagnóstico clínico.
// =====================================================

TwoWire I2C_MAX = TwoWire(0);
TwoWire I2C_MPU = TwoWire(1);

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
#define OLED_ADDR 0x3C
#define MPU_ADDR 0x68

#define BLE_DEVICE_NAME "BluePulse-ESP32"
#define BLE_SERVICE_UUID "7d2a0001-8f5b-4c2d-a9e1-3b6f5c7d9000"
#define BLE_SAMPLE_UUID "7d2a0002-8f5b-4c2d-a9e1-3b6f5c7d9000"

const long LIMIAR_IR_CONTATO = 5000;
const float LIMIAR_MOVIMENTO = 0.08;
const uint8_t PROTOCOLO_VERSAO = 1;

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &I2C_MAX, OLED_RESET);
MAX30105 maxSensor;
BLECharacteristic *caracteristicaAmostra = nullptr;
bool clienteConectado = false;
bool clienteConectadoAnteriormente = false;
uint32_t sequencia = 0;

class EventosServidor : public BLEServerCallbacks {
  void onConnect(BLEServer *servidor) override {
    clienteConectado = true;
  }

  void onDisconnect(BLEServer *servidor) override {
    clienteConectado = false;
  }
};

void escreverRegistroMPU(byte registro, byte valor) {
  I2C_MPU.beginTransmission(MPU_ADDR);
  I2C_MPU.write(registro);
  I2C_MPU.write(valor);
  I2C_MPU.endTransmission();
}

bool lerRegistrosMPU(byte registro, byte quantidade, byte *dados) {
  I2C_MPU.beginTransmission(MPU_ADDR);
  I2C_MPU.write(registro);
  if (I2C_MPU.endTransmission(false) != 0) return false;

  byte recebidos = I2C_MPU.requestFrom(MPU_ADDR, quantidade);
  if (recebidos != quantidade) return false;

  for (byte i = 0; i < quantidade; i++) dados[i] = I2C_MPU.read();
  return true;
}

void escreverUint16LE(uint8_t *destino, uint16_t valor) {
  destino[0] = valor & 0xFF;
  destino[1] = (valor >> 8) & 0xFF;
}

void escreverUint32LE(uint8_t *destino, uint32_t valor) {
  destino[0] = valor & 0xFF;
  destino[1] = (valor >> 8) & 0xFF;
  destino[2] = (valor >> 16) & 0xFF;
  destino[3] = (valor >> 24) & 0xFF;
}

void iniciarBLE() {
  BLEDevice::init(BLE_DEVICE_NAME);
  BLEServer *servidor = BLEDevice::createServer();
  servidor->setCallbacks(new EventosServidor());

  BLEService *servico = servidor->createService(BLE_SERVICE_UUID);
  caracteristicaAmostra = servico->createCharacteristic(
    BLE_SAMPLE_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  caracteristicaAmostra->addDescriptor(new BLE2902());

  uint8_t pacoteInicial[12] = { PROTOCOLO_VERSAO, 0 };
  caracteristicaAmostra->setValue(pacoteInicial, sizeof(pacoteInicial));
  servico->start();

  BLEAdvertising *anuncio = BLEDevice::getAdvertising();
  anuncio->addServiceUUID(BLE_SERVICE_UUID);
  anuncio->setScanResponse(true);
  BLEDevice::startAdvertising();
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("BLUEPULSE BLE v1");

  I2C_MAX.begin(32, 33, 100000);
  if (!display.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
    Serial.println("ERRO: OLED nao encontrado.");
    while (1) delay(1000);
  }
  if (!maxSensor.begin(I2C_MAX, I2C_SPEED_STANDARD)) {
    Serial.println("ERRO: MAX30102 nao encontrado.");
    while (1) delay(1000);
  }
  maxSensor.setup();
  maxSensor.setPulseAmplitudeRed(0x0A);
  maxSensor.setPulseAmplitudeIR(0x1F);

  I2C_MPU.begin(21, 22, 100000);
  escreverRegistroMPU(0x6B, 0x00);
  delay(100);

  iniciarBLE();
  Serial.println("BLE anunciando como BluePulse-ESP32");
}

void loop() {
  if (!clienteConectado && clienteConectadoAnteriormente) {
    delay(300);
    BLEDevice::startAdvertising();
    Serial.println("BLE desconectado; anuncio reiniciado.");
  }
  clienteConectadoAnteriormente = clienteConectado;

  long valorIR = maxSensor.getIR();
  byte dados[14];
  bool leituraMPU = lerRegistrosMPU(0x3B, 14, dados);
  float movimento = 0.0;

  if (leituraMPU) {
    int16_t axRaw = (dados[0] << 8) | dados[1];
    int16_t ayRaw = (dados[2] << 8) | dados[3];
    int16_t azRaw = (dados[4] << 8) | dados[5];
    float ax = axRaw / 16384.0;
    float ay = ayRaw / 16384.0;
    float az = azRaw / 16384.0;
    movimento = fabs(sqrt(ax * ax + ay * ay + az * az) - 1.0);
  }

  bool contato = valorIR > LIMIAR_IR_CONTATO;
  bool emMovimento = leituraMPU && movimento >= LIMIAR_MOVIMENTO;
  uint8_t flags = 0;
  if (leituraMPU) flags |= 0x01;
  if (contato) flags |= 0x02;
  if (emMovimento) flags |= 0x04;
  if (!leituraMPU) flags |= 0x08;

  uint16_t movimentoMilli = leituraMPU
    ? (uint16_t)constrain(lround(movimento * 1000.0), 0L, 65535L)
    : 0;
  uint8_t pacote[12];
  pacote[0] = PROTOCOLO_VERSAO;
  pacote[1] = flags;
  escreverUint32LE(&pacote[2], sequencia++);
  escreverUint32LE(&pacote[6], (uint32_t)(int32_t)valorIR);
  escreverUint16LE(&pacote[10], movimentoMilli);
  caracteristicaAmostra->setValue(pacote, sizeof(pacote));
  if (clienteConectado) caracteristicaAmostra->notify();

  Serial.printf(
    "SEQ=%lu | IR=%ld | MOV=%.3f | MPU=%s | BLE=%s\n",
    sequencia - 1,
    valorIR,
    movimento,
    leituraMPU ? "OK" : "ERRO",
    clienteConectado ? "CONECTADO" : "ANUNCIANDO"
  );

  display.clearDisplay();
  display.setTextColor(SSD1306_WHITE);
  display.setTextSize(1);
  display.setCursor(28, 0);
  display.println("BLUEPULSE BLE");
  display.drawLine(0, 10, 127, 10, SSD1306_WHITE);
  display.setCursor(0, 15);
  display.print("IR: ");
  display.println(valorIR);
  display.setCursor(0, 27);
  display.print("Mov: ");
  display.println(movimento, 3);
  display.setCursor(0, 39);
  display.println(contato ? "CONTATO: PROVISORIO" : "SEM CONTATO");
  display.setCursor(0, 51);
  display.println(clienteConectado ? "BLE: CONECTADO" : "BLE: ANUNCIANDO");
  display.display();

  delay(200);
}
