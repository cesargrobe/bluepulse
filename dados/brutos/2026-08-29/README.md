# Manifesto dos dados brutos — 29/08/2026

Os três primeiros arquivos deste diretório foram recuperados em 30/08/2026 dos
anexos da conversa usada durante os ensaios. O quarto arquivo foi recuperado de
uma mensagem em que o pesquisador colou diretamente o log final. O conteúdo foi
preservado sem correções. Os arquivos podem conter reinicializações, caracteres
inválidos da serial, repetições e resultados posteriormente considerados
espúrios; esses elementos foram mantidos por fazerem parte do registro original.

| Arquivo | Conteúdo predominante | Tamanho | SHA-256 |
| --- | --- | ---: | --- |
| `01-max30102-ir-e-bpm.txt` | leituras IR e tentativas de BPM do MAX30102 | 423.198 bytes | `1C55FE75CE2DC40BBC9E546949FC53B08799EFC84E6FB53E283915E80EB04C1A` |
| `02-mpu65xx-identificacao-e-movimento.txt` | `WHO_AM_I`, eixos e detector de movimento | 40.001 bytes | `B1AE3121F4DF5A10B9AC57E0896BF0E0E542C1933CC13202CEECBE55A74F5129` |
| `03-integracao-max30102-mpu65xx.txt` | scanner duplo e integração óptica/inercial | 11.552 bytes | `38E6F56F63B4D6147E4B2ED23CB10B42954E3C19B6AD1632809066344DB55D08` |
| `04-integracao-sensores-oled.txt` | integração final de MAX30102, MPU65xx e OLED | 7.972 bytes | `E02E0BCBAD05A0FE58498A7B3AA3B5336A59DD2EC28FCF1D3FA8B2BEAE0787F5` |

## Proveniência e limitações

- data atribuída aos ensaios: 29/08/2026;
- data da incorporação ao repositório: 30/08/2026;
- fonte: três arquivos anexados e um log colado pelo pesquisador durante a
  conversa;
- os anexos agregam mais de uma etapa experimental em alguns casos;
- não havia marcação confiável de horário para cada linha;
- as conexões eram provisórias e não estavam adequadamente soldadas;
- estes dados não constituem validação clínica.

As interpretações estão no [diário de bordo](../../../docs/diario-de-bordo/2026-08-29.md)
e no [relatório de integração](../../../docs/experimentos/2026-08-29-integracao-hardware.md).
