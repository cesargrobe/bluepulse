# Especificação do MVP do aplicativo BluePulse

## Estado

- versão: `0.1`;
- data: 30/08/2026;
- plataforma inicial: Android;
- tecnologia: Flutter;
- situação: especificação aprovada como ponto de partida técnico, ainda sem
  protocolo de pesquisa com participantes.

## Finalidade

O MVP deverá executar uma sessão experimental completa com dados simulados:
registrar um autorrelato inicial, acompanhar sinais do protótipo, apresentar uma
intervenção inspirada em *Blue Spaces*, registrar o autorrelato final e exportar
os dados da sessão.

O mesmo fluxo deverá aceitar dados reais do ESP32 posteriormente, sem modificar
as regras de interface, armazenamento ou exportação.

## Usuários previstos

- participante da sessão;
- pesquisador ou orientador responsável pela condução do ensaio.

O MVP não terá contas, autenticação remota, rede social ou armazenamento em
nuvem.

## Fluxo obrigatório

```text
aviso experimental
        ↓
código anônimo da sessão
        ↓
autorrelato inicial
        ↓
monitoramento simulado ou BLE
        ↓
intervenção Blue Space
        ↓
autorrelato final
        ↓
resumo e exportação
```

## Telas obrigatórias

1. apresentação, autoria e aviso de uso experimental;
2. preparação da sessão e código não nominal do participante;
3. autorrelato inicial;
4. conexão ou seleção do modo simulado;
5. monitoramento e qualidade do sinal;
6. intervenção com respiração e estímulo sonoro/visual;
7. autorrelato final;
8. resumo, histórico local e exportação.

## Dados mínimos da sessão

### Metadados

- identificador aleatório da sessão;
- código não nominal do participante;
- início e fim com fuso horário;
- versão do aplicativo;
- versão do firmware, quando houver;
- origem dos dados: `simulado` ou `ble`;
- versão do protocolo de sessão.

### Amostras do dispositivo

- instante da amostra;
- intensidade infravermelha;
- contato detectado;
- aceleração resultante;
- índice de movimento;
- qualidade do sinal;
- BPM, inicialmente nulo;
- SpO2, inicialmente nulo;
- GSR, inicialmente nulo.

### Autorrelato

As perguntas definitivas dependerão do protocolo de pesquisa. Para o ensaio de
interface, serão usados campos provisórios de percepção de tensão,
tranquilidade e conforto, em escala claramente identificada como não clínica.

## Arquitetura lógica

```text
interface
   ↓
controlador da sessão
   ├── fonte simulada
   ├── fonte BLE
   ├── armazenamento local
   └── exportação
```

As fontes simulada e BLE deverão produzir o mesmo modelo de amostra. Nenhuma
tela poderá depender diretamente da biblioteca Bluetooth.

## Regras de segurança e linguagem

- não apresentar diagnóstico de estresse, ansiedade ou qualquer transtorno;
- não calcular estado emocional apenas a partir de BPM;
- exibir quando a leitura estiver sem contato ou afetada por movimento;
- apresentar intervenção como convite opcional;
- manter `IR > 5000` e `movimento >= 0.08` identificados como critérios
  provisórios de bancada;
- não coletar nome, e-mail, telefone ou geolocalização no MVP;
- não enviar dados a servidores;
- permitir interromper a sessão a qualquer momento.

## Fora do escopo do MVP

- diagnóstico ou triagem clínica;
- alertas médicos ou contato com serviços de emergência;
- execução permanente em segundo plano;
- nuvem, painel remoto ou compartilhamento automático;
- integração com relógios comerciais;
- inferência por inteligência artificial;
- validação de eficácia da intervenção;
- BPM e SpO2 apresentados como validados antes dos ensaios específicos.

## Definição de concluído

O MVP estará concluído quando:

- puder ser compilado de forma reproduzível para Android;
- executar uma sessão completa sem hardware usando o simulador;
- executar o mesmo fluxo recebendo amostras de um ESP32 por BLE;
- preservar metadados, autorrelatos e amostras localmente;
- exportar arquivo legível e auditável;
- passar pelos testes automatizados definidos;
- passar pelo ensaio de bancada e por uma avaliação de usabilidade interna;
- não apresentar linguagem diagnóstica;
- possuir documentação, versões e evidências dos testes no GitHub.

A conclusão do MVP não significará validação clínica nem comprovação de redução
de estresse ou ansiedade.
