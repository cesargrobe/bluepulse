# Histórico inicial de aquisição e seleção de componentes

Durante a fase de concepção foi elaborada uma lista para aquisição pública de
componentes. Foram considerados ESP32, MAX30102, módulo inercial, OLED, sensor
GSR, motor de vibração, LED endereçável, bateria e circuito de carga, além de
materiais de montagem.

## Situação documental

- as listas e faixas de preço discutidas eram estimativas históricas;
- preços, fornecedores e especificações comerciais não foram revalidados neste
  repositório e não devem ser usados como cotação atual;
- a planilha mencionada na conversa foi fornecida pelo pesquisador em
  30/08/2026 e preservada sem alteração;
- a composição final do dispositivo ainda não foi congelada como lista de
  materiais aprovada.

## Planilha recuperada

- arquivo: [`Planilha_Licitacao_BluePulse_Especificacoes_Tecnicas.xlsx`](anexos/Planilha_Licitacao_BluePulse_Especificacoes_Tecnicas.xlsx);
- tamanho: 6.722 bytes;
- data registrada nos metadados do arquivo: 16/07/2026 às 12:00;
- SHA-256: `4D00B9AE7BFB8E9D58328E1E1B2E5F19DF565AC372468D0BB7376228A934B992`;
- incorporação ao repositório: 30/08/2026;
- estrutura: uma aba denominada `Licitação`, uma tabela em `A1:G14`, 13 itens
  e sete colunas;
- integridade lógica: não foram encontradas fórmulas nem valores de erro do
  Excel.

As colunas registram item, unidade, quantidade, especificação técnica mínima,
marca de referência não vinculante, aceitação de equivalente e observações.
O arquivo versionado é uma cópia byte a byte do documento fornecido; nenhuma
correção foi aplicada dentro da planilha.

## Pontos para revisão antes de nova aquisição

Esta é uma leitura técnica preliminar, não uma alteração da fonte histórica:

- confirmar tensões e interfaces para cada módulo comercial efetivamente
  ofertado, pois placas de desenvolvimento podem incorporar reguladores que o
  componente eletrônico isolado não possui;
- tratar frequência cardíaca e SpO2 como requisitos de aquisição do MAX30102,
  não como capacidades já validadas pelo BluePulse;
- revisar em conjunto bateria, conector, circuito de proteção e carregador;
- atualizar a referência do módulo inercial à luz do componente ensaiado, que
  respondeu `WHO_AM_I=0x70` e passou a ser tratado como MPU65xx compatível;
- verificar se as especificações de chave, caixa e pulseira correspondem à
  futura montagem vestível.

Uma nova versão destinada à compra deve ser criada como documento derivado,
mantendo esta planilha original intacta para preservar o histórico.

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
