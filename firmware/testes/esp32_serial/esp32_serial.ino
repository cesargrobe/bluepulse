void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println();
  Serial.println("==============================");
  Serial.println("         BLUEPULSE");
  Serial.println("==============================");
  Serial.println("ESP32 conectado com sucesso!");
}

void loop() {
  Serial.println("BluePulse ativo...");
  delay(2000);
}
