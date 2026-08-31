# Plano passo a passo de construção, testes e validações

## Preferências de execução

- **modo:** passo a passo;
- **participação:** Codex implementa e verifica; estudante e orientador avaliam
  os marcos visuais e científicos;
- **Git:** um commit claro por item ou incremento verificável;
- **verificação:** automática sempre que possível e manual quando envolver
  experiência de uso ou hardware;
- **pausas de avaliação:** após os itens 3, 6, 9 e 11;
- **princípio:** uma etapa não avança enquanto seu critério de aceitação não for
  atendido ou a exceção não estiver documentada.

## Níveis de validação

O plano separa deliberadamente:

1. **validação de software:** o aplicativo funciona como especificado;
2. **validação de integração:** aplicativo e ESP32 trocam dados corretamente;
3. **validação do sinal:** os valores possuem qualidade suficiente no contexto
   definido;
4. **validação de usabilidade:** as pessoas compreendem e conseguem usar o
   fluxo;
5. **avaliação científica exploratória:** uma intervenção é estudada sob
   protocolo adequado.

Nenhuma dessas etapas, isoladamente, constitui validação clínica.

## Checklist de construção

- [x] **1. Fixar o escopo e a arquitetura do MVP**
  Referência: `especificacao-mvp.md > Finalidade e Definição de concluído`
  O que construir: definir plataforma, fluxo, telas, dados, limites e arquitetura
  desacoplada do BLE.
  Aceitação: MVP executável sem hardware; Android/Flutter; armazenamento local;
  ausência de diagnóstico e nuvem.
  Verificação: revisão cruzada com requisitos iniciais, visão científica e
  decisão 0002.

- [x] **2. Preparar e validar o ambiente Flutter/Android**
  Referência: `especificacao-mvp.md > Estado`
  O que construir: instalar Flutter estável, Android SDK, JDK compatível e
  configurar um aparelho ou emulador.
  Aceitação: diagnóstico do Flutter sem erro bloqueante para Android e um
  aplicativo padrão executando no dispositivo escolhido.
  Verificação: registrar versões; executar diagnóstico do ambiente, análise
  estática e teste padrão; guardar a saída em arquivo datado.
  Resultado em 30/08/2026: concluído com compilação, instalação e execução no
  emulador `Pixel_7a`. O estado das licenças aparece como desconhecido devido à
  incompatibilidade entre o Flutter 3.47.2 e a nova Android CLI; a exceção e as
  evidências estão registradas em
  `evidencias/2026-08-30-primeira-execucao-android.md`.

- [ ] **3. Criar a estrutura do aplicativo e o primeiro fluxo navegável**
  Referência: `especificacao-mvp.md > Telas obrigatórias`
  O que construir: tema visual inicial, rotas e telas vazias de apresentação,
  sessão, monitoramento, intervenção e resultado.
  Aceitação: o usuário percorre o fluxo de início ao fim sem travamento; aviso
  experimental aparece antes da sessão; voltar e cancelar funcionam.
  Verificação: testes de navegação e revisão visual em aparelho Android.
  Estado em 30/08/2026: iniciado com apresentação, aviso experimental e tela de
  preparação simulada. Esse incremento foi aprovado visualmente pelo orientador
  no emulador e em um tablet físico Samsung SM-X810. Código anônimo e
  autorrelato inicial foram aprovados nos testes automatizados e na avaliação
  visual do orientador no tablet. Seleção da fonte e monitoramento simulado
  também foram aprovados no tablet, incluindo os quatro estados de qualidade.
  As demais telas e a revisão visual do fluxo completo continuam abertas.

- [ ] **4. Implementar modelos de dados e simulador determinístico**
  Referência: `especificacao-mvp.md > Dados mínimos da sessão`
  O que construir: modelos de sessão, amostra e autorrelato; fonte simulada com
  cenários reproduzíveis de sem contato, contato, movimento e falha.
  Aceitação: a mesma semente gera a mesma sequência; BPM, SpO2 e GSR permanecem
  nulos; dados simulados são identificados como simulados.
  Verificação: testes unitários de serialização, limites, cenários e relógio
  controlado.
  Estado em 30/08/2026: rascunho da sessão, amostra e simulador determinístico
  implementados; mesma semente reproduz a sequência e BPM, SpO₂ e GSR ficam
  nulos. Os quatro estados foram aprovados visualmente no tablet. Permanecem
  pendentes serialização e cenários temporais ampliados.
  Um relógio controlável foi implementado e aprovado em teste automatizado; a
  sessão automática de 30 segundos usa o mesmo simulador.

- [ ] **5. Implementar autorrelato e máquina de estados da sessão**
  Referência: `especificacao-mvp.md > Fluxo obrigatório`
  O que construir: estados de preparação, pré-avaliação, monitoramento,
  intervenção, pós-avaliação, conclusão e cancelamento.
  Aceitação: não é possível pular campos obrigatórios; sessão cancelada recebe
  estado próprio; autorrelatos pré e pós não são confundidos.
  Verificação: testes unitários da máquina de estados e testes de interface dos
  caminhos normal, incompleto e cancelado.

- [ ] **6. Implementar a primeira intervenção Blue Space**
  Referência: `especificacao-mvp.md > Telas obrigatórias`
  O que construir: exercício respiratório temporizado, estímulo visual e áudio
  com licença e proveniência registradas.
  Aceitação: duração configurável; pausar, continuar e interromper funcionam;
  áudio não inicia sem ação do usuário; sessão registra início e fim.
  Verificação: testes do temporizador e revisão manual de legibilidade,
  acessibilidade básica, volume e conforto.
  Estado em 30/08/2026: iniciado com estímulo visual e orientação respiratória
  opcional de 30 segundos. Pausar, continuar e interromper foram implementados;
  temporizador e navegação foram aprovados automaticamente, e o orientador
  aprovou o fluxo visual no tablet. Áudio, duração configurável e registro de
  início/fim continuam pendentes.

- [ ] **7. Implementar armazenamento local e exportação auditável**
  Referência: `especificacao-mvp.md > Dados mínimos da sessão`
  O que construir: persistência local, histórico, exclusão controlada e
  exportação estruturada de metadados, autorrelatos e amostras.
  Aceitação: reiniciar o aplicativo não perde sessão concluída; arquivo exportado
  informa origem e versões; nenhum dado nominal é incluído.
  Verificação: teste de gravação/leitura, comparação entre arquivo exportado e
  sessão original, teste de caracteres e fusos horários.
  Estado em 30/08/2026: primeiro incremento implementado somente para a sessão
  simulada de 30 segundos. A gravação é explícita e ocorre na área privada do
  aplicativo; CSV e JSON podem ser compartilhados pelo Android; a exclusão
  exige confirmação. Os arquivos registram origem simulada, versões,
  autorrelato, limiares provisórios e métricas indisponíveis. Gravação, leitura,
  serialização, exportação e exclusão foram aprovadas em testes automatizados.
  O APK foi instalado no tablet. A gravação e a exportação foram aprovadas
  manualmente: CSV e JSON apresentaram 30 amostras correspondentes, sequência
  contínua e ausência de campos nominais diretos. A auditoria detectou que
  `ended_at_utc` registrava o toque em salvar, não o fim do temporizador. O código
  foi corrigido para congelar o horário ao concluir a contagem, e um teste de
  regressão confirmou que um salvamento posterior não o altera. A exclusão local
  foi aprovada manualmente no tablet, com confirmação visual da remoção.
  Permanecem pendentes a repetição manual da exportação corrigida, a tela de
  histórico, o teste após reinicialização e a política para qualquer
  persistência de dados reais.

- [ ] **8. Definir e testar o protocolo BLE sem depender do sensor**
  Referência: `especificacao-mvp.md > Arquitetura lógica`
  O que construir: serviço, características, unidades, versão de protocolo,
  frequência de envio, reconexão e tratamento de mensagens incompletas.
  Aceitação: adaptador BLE falso passa nos mesmos testes da fonte simulada;
  pacote inválido é rejeitado sem encerrar o aplicativo.
  Verificação: testes unitários do codificador/decodificador e teste de
  desconexão/reconexão simulada.
  Estado em 30/08/2026: pacote binário v1, UUIDs, unidades e frequência foram
  documentados; o decodificador rejeita tamanho e versão incompatíveis em teste
  automatizado. A primeira recepção real foi aprovada. Permanecem pendentes o
  adaptador BLE falso e os cenários simulados de desconexão/reconexão.

- [ ] **9. Integrar ESP32 e executar ensaio de hardware em circuito fechado**
  Referência: `especificacao-mvp.md > Definição de concluído`
  O que construir: firmware BLE versionado e conexão real no aplicativo.
  Aceitação: conectar, receber, interromper e reconectar; distinguir sem contato,
  contato e movimento; registrar perda de pacotes e falhas.
  Verificação: ensaio datado com firmware/commit, vídeo ou fotografias, log do
  ESP32, exportação do aplicativo e comparação temporal de amostras.
  Estado em 30/08/2026: firmware gravado e primeira localização, conexão e
  recepção de notificações reais aprovadas no tablet. A captura foi preservada.
  A desconexão comandada pelo aplicativo, a nova localização, a reconexão e a
  retomada da sequência crescente de notificações também foram aprovadas.
  A instrumentação de perda, duplicação, ordem e percentual de entrega foi
  implementada e aprovada em testes automatizados. O primeiro ensaio real
  registrou 396 pacotes, 0 lacunas, 0 duplicações, 0 fora de ordem e entrega
  observada de 100,00% nessa conexão. Uma repetição ampliada registrou 682
  pacotes, novamente com 0 lacunas, 0 duplicações, 0 fora de ordem e 100,00%
  de entrega observada na conexão. A comparação simultânea foi concluída na
  sequência 2427: sequência, IR, movimento e validade do MPU coincidiram entre
  o monitor serial e o tablet. A mesma conexão chegou a 2387 pacotes sem
  ocorrência nos contadores de integridade. Permanecem pendentes a medição de
  atraso com referência independente, exportação e repetição controlada dos
  estados e das condições de comunicação.

- [ ] **10. Validar qualidade de sinal e BPM antes de exibi-lo**
  Referência: `especificacao-mvp.md > Regras de segurança e linguagem`
  O que construir: protocolo específico para contato, movimento, iluminação,
  posição, repetição e referência comparativa de frequência cardíaca.
  Aceitação: critérios de inclusão e rejeição definidos antes da coleta; erro,
  cobertura e falhas reportados; BPM só é exibido se atingir o critério aprovado.
  Verificação: dados brutos imutáveis, análise reproduzível e relatório com
  resultados positivos e negativos.

- [ ] **11. Validar linguagem, privacidade e usabilidade interna**
  Referência: `especificacao-mvp.md > Regras de segurança e linguagem`
  O que construir: revisão de todos os textos, permissões, cancelamento, exclusão
  e compreensão do fluxo por avaliadores internos.
  Aceitação: nenhuma frase diagnóstica; permissões explicadas; participante
  consegue concluir e interromper a sessão; problemas são classificados e
  corrigidos ou documentados.
  Verificação: checklist heurístico, teste de acessibilidade, roteiro de tarefas
  e registro de observações sem dados pessoais desnecessários.

- [ ] **12. Preparar piloto científico e versão final reproduzível**
  Referência: `../pesquisa/visao-geral.md > Limites clínicos e éticos`
  O que construir: protocolo, instrumentos, consentimento/assentimento,
  minimização de dados, plano de análise, pacote versionado do aplicativo e
  manual de reprodução.
  Aceitação: autorizações aplicáveis concluídas antes de recrutar participantes;
  desfechos e análise definidos previamente; aplicativo instalável, código,
  firmware, manual e hashes preservados.
  Verificação: revisão ética e metodológica aplicável, ensaio geral sem coleta,
  compilação limpa a partir do repositório e checklist de liberação assinado.

## Portões de interrupção

O desenvolvimento ou ensaio deverá ser interrompido quando:

- houver aquecimento, falha de alimentação ou instabilidade elétrica;
- o aplicativo misturar dados de participantes ou perder a proveniência;
- a comunicação gerar valores sem unidade, versão ou origem conhecidas;
- uma tela apresentar interpretação diagnóstica;
- um estudo com pessoas não tiver o tratamento ético necessário;
- o resultado não puder ser reproduzido a partir do commit registrado.

## Evidências mínimas por etapa

Cada item concluído deverá registrar:

- data e responsáveis;
- commit usado;
- versões das ferramentas;
- procedimento de verificação;
- saída do teste ou captura necessária;
- falhas conhecidas;
- decisão de avançar, repetir ou revisar.
