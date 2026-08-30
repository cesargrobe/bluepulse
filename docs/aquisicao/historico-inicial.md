# Histórico inicial de aquisição e seleção de componentes

Durante a fase de concepção foi elaborada uma lista para aquisição pública de
componentes. Foram considerados ESP32, MAX30102, módulo inercial, OLED, sensor
GSR, motor de vibração, LED endereçável, bateria e circuito de carga, além de
materiais de montagem.

## Situação documental

- as listas e faixas de preço discutidas eram estimativas históricas;
- preços, fornecedores e especificações comerciais não foram revalidados neste
  repositório e não devem ser usados como cotação atual;
- uma planilha de aquisição foi mencionada e gerada durante a conversa, mas o
  arquivo não estava disponível entre os anexos recuperáveis em 30/08/2026;
- a composição final do dispositivo ainda não foi congelada como lista de
  materiais aprovada.

## Componentes efetivamente presentes nos ensaios de 29/08/2026

| Componente | Situação observada |
| --- | --- |
| ESP32-WROOM-32 em placa de desenvolvimento | programado como `ESP32 Dev Module` |
| MAX30102 | respondeu em `0x57`; intensidade IR testada |
| módulo inercial | respondeu em `0x68` e `WHO_AM_I=0x70`; tratado como MPU65xx compatível |
| OLED SSD1306 | respondeu em `0x3C`; integrado ao MAX30102 |
| sensor GSR | não disponível nessa fase |

Motor, LED, bateria, carregador e comunicação com o aplicativo não fizeram parte
da validação registrada. A capacidade de SpO2 do MAX30102 também não foi
validada.
