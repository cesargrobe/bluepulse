# Decisão 0002 — Flutter com Android como primeira plataforma

- **Data:** 30/08/2026
- **Estado:** adotada para o MVP; sujeita a revisão após o primeiro protótipo

## Contexto

O aplicativo precisa funcionar inicialmente com dados simulados e, em uma etapa
posterior, comunicar-se por Bluetooth Low Energy com o ESP32. O código e os
testes devem permanecer legíveis e versionáveis no GitHub para apoiar a pesquisa
e a participação da estudante.

Foram considerados MIT App Inventor, aplicação web e Flutter. O App Inventor é
adequado para prototipagem didática, mas oferece menor granularidade no histórico
de código. A aplicação web apresenta limitações de compatibilidade para
Bluetooth. Flutter permite criar uma aplicação móvel estruturada, testável e
multiplataforma a partir de uma única base de código.

## Decisão

Adotar:

- Flutter como tecnologia do aplicativo;
- Android como primeira plataforma executável;
- funcionamento local e offline no MVP;
- simulador de dados antes da integração BLE;
- separação entre interface, regras, armazenamento e comunicação com o
  dispositivo;
- pausas de verificação visual com a equipe durante a construção.

## Consequências

- será necessário instalar Flutter, Android SDK e uma versão compatível do JDK;
- o desenvolvimento para iOS poderá reutilizar grande parte do código, mas sua
  compilação exigirá posteriormente um ambiente macOS;
- a integração BLE será isolada atrás de uma interface, permitindo que os
  testes continuem funcionando sem o hardware;
- o arquivo exportado para análise será criado somente com dados locais e
  identificadores de participante não nominais.

## Alternativa de contingência

Se a integração BLE em Flutter se tornar impeditiva dentro do cronograma, um
protótipo Android no MIT App Inventor poderá ser usado para validar comunicação.
Essa alternativa deverá gerar uma nova decisão documentada; não substituirá
silenciosamente esta escolha.
