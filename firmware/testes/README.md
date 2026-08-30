# Firmware de testes

Os sketches abaixo preservam a evolução experimental de 29/08/2026. Eles não
representam versões sucessivas de um produto pronto: cada pasta responde a uma
pergunta específica do ensaio.

| Ordem | Sketch | Finalidade | Resultado registrado |
| ---: | --- | --- | --- |
| 1 | [`esp32_serial`](esp32_serial/esp32_serial.ino) | validar programação e serial | funcional |
| 2 | [`scanner_i2c`](scanner_i2c/scanner_i2c.ino) | localizar periférico em GPIO21/22 | `0x57` ou `0x68`, conforme módulo conectado |
| 3 | [`max30102_ir`](max30102_ir/max30102_ir.ino) | observar resposta óptica | separação clara entre sem contato e contato |
| 4 | [`max30102_bpm_v1`](max30102_bpm_v1/max30102_bpm_v1.ino) | primeira tentativa de BPM | resultados plausíveis e espúrios; média inicial inadequada |
| 5 | [`max30102_bpm_v2`](max30102_bpm_v2/max30102_bpm_v2.ino) | corrigir reinicialização e média | proposta posterior à análise da V1; não validada clinicamente |
| 6 | [`mpu6050_adafruit_falha_identificacao`](mpu6050_adafruit_falha_identificacao/mpu6050_adafruit_falha_identificacao.ino) | testar biblioteca Adafruit MPU6050 | compilou, mas falhou em execução porque o módulo não respondeu como MPU6050 |
| 7 | [`mpu65xx_who_am_i`](mpu65xx_who_am_i/mpu65xx_who_am_i.ino) | ler identidade eletrônica | `WHO_AM_I=0x70` |
| 8 | [`mpu65xx_leitura_direta`](mpu65xx_leitura_direta/mpu65xx_leitura_direta.ino) | acessar acelerômetro e giroscópio diretamente | leituras coerentes com módulo parado e em movimento |
| 9 | [`mpu65xx_movimento`](mpu65xx_movimento/mpu65xx_movimento.ino) | calcular índice experimental de movimento | separou repouso e perturbações no ensaio |
| 10 | [`scanner_duplo_i2c`](scanner_duplo_i2c/scanner_duplo_i2c.ino) | testar dois controladores I²C | `0x57` em GPIO32/33 e `0x68` em GPIO21/22 |
| 11 | [`integracao_max30102_mpu65xx`](integracao_max30102_mpu65xx/integracao_max30102_mpu65xx.ino) | combinar IR e movimento | operação simultânea validada em bancada |
| 12 | [`max30102_oled`](max30102_oled/max30102_oled.ino) | compartilhar OLED e MAX30102 | ambos inicializaram em GPIO32/33 |
| 13 | [`integracao_sensores_oled`](integracao_sensores_oled/integracao_sensores_oled.ino) | integrar MAX30102, MPU65xx e OLED | operação simultânea validada em bancada |

## Observações

- A presença de um sketch no repositório não significa que seu método foi
  validado. O resultado registrado na tabela faz parte da interpretação.
- `IR > 5000` e `movimento >= 0.08` são limiares provisórios.
- A V1 de BPM foi mantida intencionalmente para documentar o problema encontrado.
- A falha com a biblioteca Adafruit foi mantida porque levou à identificação
  `WHO_AM_I=0x70` e à leitura direta do MPU65xx compatível.
- O sistema não realiza diagnóstico clínico.

Os detalhes cronológicos estão no
[diário de bordo](../../docs/diario-de-bordo/2026-08-29.md).

A verificação de compilação está registrada em
[COMPILACAO-2026-08-30.md](COMPILACAO-2026-08-30.md).
