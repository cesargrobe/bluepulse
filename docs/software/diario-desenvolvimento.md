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

## 30/08/2026 — primeiro aplicativo executável

### Ambiente concluído

Após a instalação das Command-line Tools pelo responsável, o Flutter foi
configurado com o Android SDK e com o JDK do Android Studio. A compilação inicial
revelou que a nova ferramenta Android não interpretava corretamente o nome do
NDK solicitado pelo invólucro legado `sdkmanager`. O NDK `28.2.13676358` foi
então instalado diretamente com a sintaxe da nova ferramenta `android sdk`.

O diagnóstico do Flutter ainda apresenta como desconhecido o estado das
licenças, pois a ferramenta nova considera desnecessário o antigo comando
`--licenses`. A exceção foi preservada no registro do ambiente. Não houve
bloqueio prático: análise, testes, compilação, instalação e execução Android
foram concluídos.

### Primeiro incremento do aplicativo

- criado o projeto `app/` em Flutter para Android;
- definida identidade visual inicial inspirada no oceano;
- criada tela de apresentação com autoria e orientação;
- exibido aviso explícito de que o sistema não realiza diagnóstico clínico;
- criada navegação para a preparação de uma sessão simulada;
- informado que nenhum dado real é coletado nesta fase;
- mantidos BPM, SpO₂ e GSR como medidas ainda não validadas.

### Verificações

- commit do aplicativo verificado: `e4cf3c6`;
- análise estática: sem problemas;
- testes automatizados: 2 aprovados;
- compilação: `app-debug.apk` gerado;
- execução: aplicativo instalado e iniciado no emulador `Pixel_7a`;
- navegação real: botão inicial abriu a tela `Modo simulado`;
- limitação visual: a captura do emulador sem janela ficou preta, mas a atividade
  ativa e os textos das duas telas foram confirmados pela árvore de interface do
  Android.

### Estado

- item 2 do plano: concluído com exceção de diagnóstico documentada;
- item 3 do plano: iniciado;
- próximo incremento: estruturar as telas restantes do fluxo antes de adicionar
  dados simulados.
