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

### Avaliação visual pelo orientador

O aplicativo foi aberto pelo Professor Gerson Cesar Grobe de Miranda no
emulador `Pixel_7a`. A tela inicial, o aviso experimental, a autoria, a
orientação e a tela de preparação simulada foram visualizados. A navegação de
ida e volta funcionou, e o orientador confirmou que o incremento estava
correto. As duas capturas recebidas foram anexadas à evidência datada.

### Validação em tablet físico

Um tablet Samsung SM-X810 foi conectado por USB com depuração autorizada. O APK
foi instalado e aberto diretamente no aparelho. O dispositivo executava Android
16/API 36 e informou resolução física de 1752 × 2800 pixels. O orientador
confirmou o funcionamento e autorizou o uso do tablet nas próximas etapas,
inclusive para a futura integração BLE. O identificador único do aparelho não
foi incluído no repositório.

## 30/08/2026 — registro da proposta visual

Duas telas conceituais com ambientação oceânica foram incorporadas ao histórico
para discussão com Emanuelle. A análise preserva a paleta, a atmosfera, os
cartões e a organização como referências, mas rejeita para o MVP login nominal,
classificação automática de estresse, humor inferido, BPM ainda não validado e
assistente de IA.

Os arquivos recebidos foram preservados com hashes. Permanecem pendentes a
confirmação de autoria, origem, licenças, arquivos de fundo sem interface e a
decisão sobre o uso do nome “Oceannara”. O registro está em
`design/proposta-visual-2026-08-30.md`.

## 30/08/2026 — código anônimo e autorrelato inicial

O aplicativo foi reorganizado em arquivos menores e recebeu as duas etapas
seguintes do fluxo. O código da sessão limita formato e tamanho, alerta contra
dados pessoais e exige confirmação de privacidade. Em seguida, o autorrelato
inicial apresenta escalas provisórias de tensão, tranquilidade e conforto.

As respostas permanecem somente na memória e não recebem interpretação. O
aplicativo declara que elas não representam avaliação clínica. Quatro testes
automatizados foram aprovados, a análise estática não encontrou problemas e o
APK foi recompilado e instalado no tablet Samsung SM-X810.

O commit verificado é `fcea779`. A avaliação visual dessas novas telas pelo
orientador permanece como próximo portão antes do avanço.

### Aprovação visual do incremento

O Professor Gerson percorreu no tablet o código anônimo, a confirmação de
privacidade, as três escalas do autorrelato e o aviso de conclusão. O
funcionamento e a legibilidade foram aprovados. Código e respostas usados no
teste não foram registrados, respeitando a minimização de dados.

## 30/08/2026 — fonte de dados e monitoramento simulado

Foi criada a seleção entre modo simulado e BLE. Somente a simulação está
habilitada; BLE permanece visível como etapa futura e nenhuma permissão foi
solicitada. O simulador usa semente derivada do código da sessão e percorre sem
contato, sinal adequado, movimento e falha transitória.

A interface identifica permanentemente os dados como simulados, mantém BPM,
SpO₂ e GSR indisponíveis e repete que `IR > 5000` e `movimento >= 0.08` são
limiares provisórios. Nove testes foram aprovados, a análise estática não
encontrou problemas e o APK foi instalado no tablet. O commit verificado é
`3a453ff`; a avaliação visual permanece pendente.

### Aprovação do monitoramento simulado

O Professor Gerson testou no tablet a seleção da fonte e confirmou o
funcionamento adequado do monitoramento. Os quatro estados — sem contato, sinal
adequado, movimento detectado e falha simulada — foram percorridos com sucesso.
As amostras artificiais do teste não foram armazenadas.

## 30/08/2026 — sessão temporizada e pausa oceânica visual

Foi acrescentada uma sessão automática de 30 segundos sobre o simulador
determinístico, preservando a opção manual já aprovada. O relógio permite
pausar, continuar e cancelar; concluído o monitoramento, o aplicativo oferece
uma intervenção visual opcional de 30 segundos com orientação respiratória de
quatro segundos para inspiração e seis para expiração.

Nenhum áudio foi incluído, pois ainda não há um arquivo com autoria, origem e
licença registradas. A interface declara esse limite e mantém os avisos de que o
recurso não é tratamento, não realiza diagnóstico clínico e usa dados
simulados. Os limiares `IR > 5000` e `movimento >= 0.08` permanecem
provisórios.

Doze testes automatizados foram aprovados, a análise estática não encontrou
problemas, o APK foi compilado, instalado e aberto no tablet Samsung SM-X810.
O commit verificado é `e1a43e1`.

### Aprovação da sessão temporizada e da pausa visual

O Professor Gerson percorreu todo o processo no tablet e confirmou que tudo
funcionou corretamente. A avaliação interna aprovou o monitoramento de 30
segundos, a pausa e continuação, a transição ao final e a intervenção visual.
Não foi relatado problema de legibilidade, funcionamento ou conforto. Essa
aprovação não representa validação clínica ou comprovação de eficácia.

## 30/08/2026 — primeira conexão BLE real

Foi definido o protocolo binário BluePulse BLE v1 e criado um firmware separado
para transmitir sequência, IR bruto, movimento e validade do MPU65xx a cada 200
ms. BPM, SpO₂ e GSR não fazem parte do pacote.

A integração exigiu diagnosticar três ocorrências: modo de gravação manual pelo
botão BOOT, Bluetooth inicialmente desligado no tablet e anúncio BLE não
observável apesar do estado interno `BLE=ANUNCIANDO`. O anúncio foi corrigido
para declarar explicitamente o nome no pacote principal e o UUID na resposta de
varredura.

Depois da nova gravação, o aplicativo localizou e conectou ao ESP32. O Professor
Gerson registrou a tela recebendo amostras reais, incluindo sequência 732, IR
5404, movimento 0,131 e MPU65xx válido. A interface manteve BPM, SpO₂ e GSR
indisponíveis e marcou a amostra como afetada por movimento conforme o limiar
provisório. Reconexão e comparação simultânea com a serial permanecem abertas.
