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
  no emulador. As demais telas e a revisão visual do fluxo completo permanecem
  pendentes.

- [ ] **4. Implementar modelos de dados e simulador determinístico**
  Referência: `especificacao-mvp.md > Dados mínimos da sessão`
  O que construir: modelos de sessão, amostra e autorrelato; fonte simulada com
  cenários reproduzíveis de sem contato, contato, movimento e falha.
  Aceitação: a mesma semente gera a mesma sequência; BPM, SpO2 e GSR permanecem
  nulos; dados simulados são identificados como simulados.
  Verificação: testes unitários de serialização, limites, cenários e relógio
  controlado.

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

- [ ] **7. Implementar armazenamento local e exportação auditável**
  Referência: `especificacao-mvp.md > Dados mínimos da sessão`
  O que construir: persistência local, histórico, exclusão controlada e
  exportação estruturada de metadados, autorrelatos e amostras.
  Aceitação: reiniciar o aplicativo não perde sessão concluída; arquivo exportado
  informa origem e versões; nenhum dado nominal é incluído.
  Verificação: teste de gravação/leitura, comparação entre arquivo exportado e
  sessão original, teste de caracteres e fusos horários.

- [ ] **8. Definir e testar o protocolo BLE sem depender do sensor**
  Referência: `especificacao-mvp.md > Arquitetura lógica`
  O que construir: serviço, características, unidades, versão de protocolo,
  frequência de envio, reconexão e tratamento de mensagens incompletas.
  Aceitação: adaptador BLE falso passa nos mesmos testes da fonte simulada;
  pacote inválido é rejeitado sem encerrar o aplicativo.
  Verificação: testes unitários do codificador/decodificador e teste de
  desconexão/reconexão simulada.

- [ ] **9. Integrar ESP32 e executar ensaio de hardware em circuito fechado**
  Referência: `especificacao-mvp.md > Definição de concluído`
  O que construir: firmware BLE versionado e conexão real no aplicativo.
  Aceitação: conectar, receber, interromper e reconectar; distinguir sem contato,
  contato e movimento; registrar perda de pacotes e falhas.
  Verificação: ensaio datado com firmware/commit, vídeo ou fotografias, log do
  ESP32, exportação do aplicativo e comparação temporal de amostras.

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
