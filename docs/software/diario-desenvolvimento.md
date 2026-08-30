# Diário de desenvolvimento do aplicativo

## 30/08/2026 — início do planejamento verificável

### Decisões

- Flutter adotado para o aplicativo;
- Android definido como primeira plataforma;
- modo simulado deverá preceder BLE;
- dados permanecerão locais no MVP;
- desenvolvimento será passo a passo, com pausas de avaliação visual;
- commits funcionarão como pontos de restauração e evidência.

### Produção documental

- criada a especificação `0.1` do MVP;
- criado o plano com 12 etapas e critérios de aceitação;
- registrada a decisão tecnológica 0002;
- realizada auditoria inicial do ambiente.

### Resultado da auditoria

Git está instalado. Flutter, Dart e `adb` não foram encontrados. O Java
disponível é a versão 8. O próximo incremento será preparar o ambiente Flutter e
Android sem remover o Java legado.

### Estado

- item 1 do plano: concluído;
- item 2 do plano: iniciado;
- código do aplicativo: ainda não criado.

### Continuação da preparação do ambiente

Uma inspeção mais específica encontrou Android Studio, Android SDK 36, Build
Tools 36.0.0, ADB e o JDK 21 fornecido pelo Android Studio. O ADB foi iniciado e
não encontrou dispositivo conectado.

Foi baixado o Flutter 3.47.2 estável do repositório oficial. O hash SHA-256 do
arquivo coincidiu com o publicado, e a inicialização confirmou Dart 3.13.2. O
SDK foi configurado para apontar ao Android SDK e ao JDK do Android Studio.

O diagnóstico identificou a ausência do `Android SDK Command-line Tools
(latest)`. A preparação foi pausada para que o responsável instale esse
componente pelo SDK Manager e leia/aceite pessoalmente as licenças Android. Essa
aceitação não foi automatizada.
