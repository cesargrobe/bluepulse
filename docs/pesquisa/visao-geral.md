# Visão científica do BluePulse

> **Situação do documento:** versão inicial reconstruída em 30/08/2026 a partir
> da conversa “Blue Space e Saúde Mental”. O problema, a hipótese e os objetivos
> abaixo organizam as ideias discutidas, mas ainda requerem aprovação formal da
> equipe e adequação ao futuro protocolo de pesquisa.

## Contexto

*Blue Spaces* são ambientes naturais ou representações sensoriais associados à
água, como oceano, praias, rios, lagoas e manguezais. O projeto partiu da ideia
de investigar se estímulos inspirados nesses ambientes — áudio, imagens e
exercícios respiratórios — podem apoiar estratégias de autorregulação.

O BluePulse acrescenta a essa proposta um protótipo vestível e um aplicativo.
O sistema deverá reunir sinais ópticos, contexto de movimento e autorrelato,
apresentar intervenções controladas e permitir comparações antes e depois de
cada sessão.

## Problema de pesquisa — formulação preliminar

Como intervenções controladas inspiradas em *Blue Spaces*, apoiadas por sinais
fisiológicos, contexto de movimento e autorrelato, podem contribuir para a
autorregulação e para a avaliação de mudanças na ativação fisiológica dos
participantes?

## Hipótese — formulação preliminar

Intervenções breves com estímulos sonoros, visuais e respiratórios inspirados em
*Blue Spaces* podem estar associadas à redução da ativação fisiológica e das
medidas autorrelatadas de estresse ou ansiedade em relação à linha de base
pré-intervenção.

Essa hipótese ainda não foi testada pelo projeto. Ela não autoriza inferir
estado emocional diretamente de um valor de frequência cardíaca e precisará de
protocolo, instrumentos, critérios de análise e tratamento ético previamente
definidos.

## Objetivo geral — formulação preliminar

Desenvolver e avaliar experimentalmente um sistema de biofeedback que combine
um dispositivo vestível, um aplicativo e intervenções inspiradas em *Blue
Spaces*, preservando a distinção entre sinais fisiológicos, movimento,
autorrelato e interpretação do pesquisador.

## Objetivos específicos — proposta

- desenvolver um protótipo capaz de adquirir sinais ópticos e inerciais;
- caracterizar a qualidade do sinal e os artefatos associados ao movimento;
- desenvolver uma interface para acompanhamento e intervenções de
  autorregulação;
- registrar medidas pré e pós-intervenção de maneira padronizada;
- trabalhar com linhas de base individuais, evitando depender apenas de
  limiares universais;
- avaliar futuramente a contribuição de um sensor de resposta galvânica da
  pele, comparando modelos com e sem esse sinal;
- investigar usabilidade, aceitabilidade e limitações do sistema;
- produzir um conjunto de dados documentado, protegido e adequado ao protocolo
  ético adotado.

## O que já foi demonstrado

Até 29/08/2026, foi demonstrada somente a integração funcional de bancada entre
ESP32, MAX30102, módulo inercial MPU65xx compatível e OLED. Foram observadas
resposta óptica ao contato, leitura de aceleração e uma classificação provisória
de movimento.

Ainda **não** foram demonstrados:

- redução de estresse ou ansiedade;
- medição validada de frequência cardíaca ou SpO2;
- inferência confiável de estado emocional;
- eficácia de qualquer intervenção inspirada em *Blue Spaces*;
- segurança, desempenho clínico ou capacidade diagnóstica.

## Limites clínicos e éticos

O BluePulse é um projeto experimental e educacional. O sistema não realiza
diagnóstico clínico, não substitui profissionais de saúde e não deve ser usado
para orientar decisões médicas.

Qualquer estudo com participantes deverá ser precedido pela definição do
protocolo, avaliação ética aplicável, consentimento ou assentimento, regras de
privacidade, minimização de dados e um plano para situações de desconforto. A
sugestão histórica de “30 estudantes por duas semanas” foi apenas um exemplo de
planejamento e **não constitui protocolo aprovado**.

## Relação com os ODS

A conversa inicial identificou possíveis relações com os Objetivos de
Desenvolvimento Sustentável 3, 11, 13 e 14. Essas relações são linhas de
enquadramento a serem justificadas no trabalho acadêmico; não são, por si só,
evidência de impacto.
