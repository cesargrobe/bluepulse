# Requisitos iniciais do aplicativo

> Documento de concepção. Estes requisitos foram discutidos antes da validação
> do hardware e ainda não representam uma implementação concluída.

O escopo executável adotado está na [especificação do MVP](especificacao-mvp.md),
e sua sequência de construção está no
[plano de testes e validações](plano-testes-validacoes.md).

## Funções propostas

- conectar-se futuramente ao ESP32;
- receber sinais ópticos, movimento e indicadores de qualidade;
- solicitar autorrelatos antes e depois das intervenções;
- oferecer áudio, imagem e respiração guiada inspirados em *Blue Spaces*;
- comparar a sessão com a linha de base individual;
- manter histórico com proveniência e consentimento adequados;
- informar falhas de contato ou movimento que prejudiquem a leitura.

## Telas conceituais

1. início e conexão do dispositivo;
2. monitoramento;
3. visualização da ativação e da qualidade do sinal;
4. intervenção de autorregulação;
5. histórico de sessões.

## Contrato de dados preliminar

O exemplo abaixo é apenas um ponto de partida para simulação e integração. O
campo `gsr` permanece nulo enquanto o sensor não estiver disponível. `bpm` e
`spo2` também devem permanecer nulos até existirem algoritmos e condições de
aquisição adequadamente validados.

```json
{
  "timestamp": "2026-08-29T00:00:00-03:00",
  "ir": 0,
  "bpm": null,
  "spo2": null,
  "gsr": null,
  "aceleracao_g": null,
  "indice_movimento": null,
  "contato": null,
  "qualidade_sinal": "nao_avaliada"
}
```

## Regras de interpretação

- não converter BPM isolado em “estresse” ou “ansiedade”;
- separar dado bruto, indicador de qualidade, regra experimental e autorrelato;
- priorizar a linha de base individual e a persistência da alteração;
- descartar ou sinalizar janelas afetadas por movimento;
- apresentar alertas como convite a uma pausa, nunca como diagnóstico;
- registrar a versão do firmware e do algoritmo junto com cada conjunto de
  dados.

Os limiares atuais `IR > 5000` e `movimento >= 0.08` são provisórios e pertencem
aos ensaios de bancada. Eles não devem ser transferidos automaticamente para o
aplicativo ou para um protocolo com participantes.
