# Evidência da primeira conexão BLE real

## Identificação

- data: 30/08/2026;
- orientador e executor do ensaio: Professor Gerson Cesar Grobe de Miranda;
- dispositivo Android: tablet Samsung SM-X810;
- placa: ESP32 Dev Module com ESP32-WROOM-32;
- firmware: `bluepulse_ble_integracao.ino`;
- protocolo: BluePulse BLE v1;
- commits principais: `931169c`, `4d7b454` e `9c0db29`.

## Objetivo

Verificar se o aplicativo Android localiza o ESP32 por Bluetooth Low Energy,
conecta ao serviço BluePulse v1 e recebe amostras reais do MAX30102 e do módulo
MPU65xx compatível, sem calcular ou exibir BPM não validado.

## Procedimento e ocorrências

1. O firmware BLE foi compilado para `esp32:esp32:esp32` e gravado pela COM6.
2. A primeira tentativa de gravação falhou porque a placa não estava no modo de
   programação. O botão BOOT foi mantido pressionado durante a tentativa
   seguinte, que concluiu e verificou a gravação.
3. O monitor serial confirmou sequência crescente, IR, movimento, MPU válido e
   estado interno `BLE=ANUNCIANDO`.
4. A primeira busca no tablet falhou porque o Bluetooth estava desligado. O
   aplicativo foi corrigido para orientar ou solicitar sua ativação.
5. Com Bluetooth e permissões concedidas, a busca encontrou outros dispositivos,
   mas não o BluePulse. O aplicativo passou a executar busca diagnóstica sem
   filtro do sistema.
6. O firmware foi corrigido para colocar explicitamente o nome
   `BluePulse-ESP32` no anúncio e o UUID do serviço na resposta de varredura.
7. Após nova gravação e reinicialização, o tablet localizou, conectou e passou a
   receber notificações do ESP32.

As falhas intermediárias foram preservadas porque documentam a diferença entre
o estado interno “anunciando” e um anúncio efetivamente observável pelo cliente.

## Resultado observado

A captura fornecida pelo orientador mostra:

- estado **Recebendo amostras reais**;
- sequência `732`;
- IR bruto `5404`;
- índice de movimento `0.131`;
- MPU65xx com leitura válida;
- estado **Amostra afetada por movimento**;
- BPM, SpO₂ e GSR explicitamente indisponíveis.

O resultado é compatível com o protocolo v1: o movimento observado é superior
ao limiar provisório `0.08`. O valor IR também é superior ao limiar provisório
`5000`. Esses limiares continuam sendo critérios técnicos de bancada e não
representam diagnóstico ou validação clínica.

![Aplicativo recebendo amostras reais por BLE](imagens/2026-08-30/conexao-ble-real-bluepulse.jpg)

| Arquivo | Tamanho | SHA-256 |
| --- | ---: | --- |
| `conexao-ble-real-bluepulse.jpg` | 447.361 bytes | `4F866B2DC5EA0ECDA5D1F109063EDCD3F13CA6AB591615C2BFBBF15A7AA5B133` |

## Verificações técnicas anteriores ao ensaio

| Verificação | Resultado |
| --- | --- |
| compilação do firmware BLE | aprovada |
| gravação e verificação da flash | aprovada |
| inicialização de MAX30102 e MPU65xx | observada pela saída serial |
| análise estática Flutter | nenhuma ocorrência |
| testes automatizados Flutter | 14 aprovados |
| compilação e instalação Android | aprovadas |
| localização e conexão BLE | aprovadas no tablet |
| recepção de notificações reais | aprovada no tablet |

## Limites e próximos testes

Esta evidência valida a primeira conexão e recepção. Ainda permanecem pendentes:

- ensaio controlado de desconexão e reconexão;
- comparação simultânea entre sequência/valores no monitor serial e no tablet;
- registro de perda, duplicação ou atraso de pacotes;
- repetição controlada dos estados sem contato, contato e movimento;
- validação específica de qualidade de sinal antes de qualquer BPM.

O sistema não realiza diagnóstico clínico, não infere estresse ou ansiedade e
não deve orientar decisões médicas.
