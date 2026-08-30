#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

// Sketch preservado porque compilou, mas falhou na inicialização durante o
// ensaio: o módulo respondeu WHO_AM_I=0x70 e não foi aceito como MPU6050.
Adafruit_MPU6050 mpu;

void setup() {
  Serial.begin(115200);
  delay(1000);

  Wire.begin(21, 22);

  Serial.println();
  Serial.println("==============================");
  Serial.println("        BLUEPULSE");
  Serial.println("      TESTE MPU6050");
  Serial.println("==============================");

  if (!mpu.begin(0x68, &Wire)) {
    Serial.println("ERRO: MPU6050 nao encontrado!");
    while (1) {
      delay(10);
    }
  }

  Serial.println("MPU6050 encontrado!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  Serial.println("Movimente o sensor.");
  Serial.println();
}

void loop() {
  sensors_event_t aceleracao;
  sensors_event_t giroscopio;
  sensors_event_t temperatura;

  mpu.getEvent(&aceleracao, &giroscopio, &temperatura);

  Serial.print("AX=");
  Serial.print(aceleracao.acceleration.x, 2);
  Serial.print(" | AY=");
  Serial.print(aceleracao.acceleration.y, 2);
  Serial.print(" | AZ=");
  Serial.print(aceleracao.acceleration.z, 2);
  Serial.print(" || GX=");
  Serial.print(giroscopio.gyro.x, 2);
  Serial.print(" | GY=");
  Serial.print(giroscopio.gyro.y, 2);
  Serial.print(" | GZ=");
  Serial.println(giroscopio.gyro.z, 2);

  delay(250);
}
