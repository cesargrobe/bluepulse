# Evolução conceitual do projeto

Este registro recompõe a trajetória discutida na conversa “Blue Space e Saúde
Mental”. Ele diferencia propostas, decisões e resultados observados.

## 1. Laboratório digital de *Blue Spaces*

A ideia inicial foi um aplicativo que registrasse um check-in antes e depois de
uma exposição breve a sons, imagens ou respiração inspirados em ambientes
aquáticos. Foram propostas visualizações individuais e, apenas com dados
anônimos e tratamento ético, análises coletivas.

Também surgiram possibilidades não adotadas como escopo atual: bioacústica do
litoral do Paraná, realidade aumentada, ciência cidadã, gêmeo digital emocional
e o protocolo escolar denominado, provisoriamente, “5 minutos de oceano”.

## 2. Do aplicativo ao sistema vestível

O projeto evoluiu para um sistema capaz de associar a intervenção a sinais do
corpo. A arquitetura conceitual passou a reunir:

```text
sensores → ESP32 → comunicação com o aplicativo → registro/intervenção
```

Desde essa etapa foi reconhecido que batimentos por minuto, isoladamente, não
permitem concluir que uma pessoa está estressada ou ansiosa. Movimento,
atividade, linha de base individual, duração da alteração e autorrelato precisam
ser tratados como informações distintas.

## 3. Conceito de experiência

Foram propostas cinco áreas para o aplicativo:

1. apresentação e estado da conexão;
2. monitoramento de sinais e qualidade da leitura;
3. visualização simples do nível de ativação;
4. protocolo guiado de pausa, respiração, áudio ou imagem;
5. histórico de sessões e comparação pré/pós.

Expressões como “maré emocional”, “calma”, “atenção” e “tempestade” apareceram
como ideias de interface. Sua adoção futura exige cuidado para não apresentar
uma classificação experimental como diagnóstico emocional.

## 4. Planejamento antes da chegada dos componentes

Enquanto o hardware era adquirido, foi proposto desenvolver a interface com
dados simulados, organizar o repositório e definir um contrato de dados. O uso
do Arduino Uno por USB apareceu apenas como alternativa de bancada; o ESP32 foi
mantido como plataforma prevista para o protótipo vestível e futura comunicação
sem fio.

O sensor GSR não estava disponível. A decisão provisória foi avançar com
MAX30102, módulo inercial e autorrelato, mantendo aberta uma futura comparação
entre modelos com e sem GSR.

## 5. Validação de hardware

Em 29/08/2026, a discussão passou de planejamento para ensaios documentados. O
ESP32 e os três periféricos foram testados separadamente e integrados. O
resultado validado está no [relatório de integração](../experimentos/2026-08-29-integracao-hardware.md).

## 6. Estado resultante

O BluePulse deve ser tratado como uma plataforma experimental em construção:

- a integração eletrônica básica foi demonstrada em bancada;
- a medição de BPM ainda precisa ser estabilizada e validada;
- a comunicação com o aplicativo ainda não foi demonstrada;
- as intervenções e o protocolo com participantes permanecem como proposta;
- nenhuma capacidade clínica ou diagnóstica foi validada.

## Regra para os próximos registros

Novas ideias devem ser marcadas como **proposta** ou **hipótese**. Somente um
resultado acompanhado de procedimento e evidência preservada deve ser marcado
como **observação** ou **validação experimental**.
