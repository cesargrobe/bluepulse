# Roteiro para apresentação do BluePulse à banca

## Identificação

- **data prevista:** 03/09/2026;
- **apresentadora:** Emanuelle Pinheiro da Silva, estudante do 9º ano;
- **orientador:** Professor Gerson Cesar Grobe de Miranda;
- **duração sugerida:** 8 a 10 minutos, seguida das perguntas da banca;
- **objetivo:** apresentar a origem da proposta, o protótipo atual, as
  validações já realizadas, os limites científicos e as próximas etapas.

Este roteiro deve servir como apoio. A recomendação é que Emanuelle compreenda
a sequência das ideias e fale com suas próprias palavras, sem tentar decorar
cada frase.

## Mensagem central

O BluePulse já demonstrou que é possível integrar sensores, ESP32, display e
um aplicativo Android por Bluetooth, com registro técnico auditável e cuidado
com privacidade. O projeto ainda não mede frequência cardíaca de forma validada,
não identifica ansiedade ou estresse e não comprovou efeito terapêutico. Essas
são etapas futuras que exigem calibração, comparação, método científico e
tratamento ético.

## Estrutura sugerida

| Parte | Tempo | Recurso visual |
| --- | ---: | --- |
| 1. Apresentação e origem | 45 s | título e autoria |
| 2. Problema e ideia | 1 min | diagrama aplicativo–protótipo |
| 3. Como o sistema foi construído | 1 min | fotografia do hardware |
| 4. O que já funciona | 2 min | aplicativo e evidências |
| 5. Demonstração | 1 min 30 s | tablet e protótipo |
| 6. Limites atuais | 1 min | quadro “já comprovado × ainda não” |
| 7. Próximas etapas | 1 min | linha do tempo |
| 8. Encerramento | 30 s | mensagem final |

## Fala sugerida

### 1. Apresentação e origem

> Bom dia. Meu nome é Emanuelle Pinheiro da Silva, sou estudante do 9º ano e
> apresento o projeto BluePulse, desenvolvido sob orientação do Professor
> Gerson Cesar Grobe de Miranda.
>
> A proposta surgiu do meu interesse em investigar como recursos inspirados nos
> chamados *blue spaces*, ou ambientes relacionados à água, poderiam ser
> integrados à tecnologia para apoiar experiências de bem-estar.

### 2. Problema e evolução da ideia

> A ideia inicial foi integrar um aplicativo a um relógio inteligente para
> acompanhar a frequência cardíaca e oferecer recursos como respiração guiada,
> sons do oceano e registro das emoções.
>
> Durante o desenvolvimento, percebemos que uma frequência cardíaca isolada não
> permite afirmar que uma pessoa está estressada ou ansiosa. Por isso, a pergunta
> foi aperfeiçoada. Hoje, buscamos entender como sinais fisiológicos, movimento,
> autorrelato e intervenções inspiradas nos *blue spaces* podem ser estudados de
> forma separada e responsável.
>
> O BluePulse é experimental, não realiza diagnóstico clínico e não substitui
> profissionais de saúde.

### 3. Como o protótipo foi construído

> O protótipo utiliza um ESP32 como unidade principal. Um sensor MAX30102 fornece
> o sinal óptico bruto; um módulo compatível com a família MPU65xx registra o
> movimento; e um display OLED apresenta o estado do sistema.
>
> Os componentes foram organizados em dois barramentos de comunicação. O
> MAX30102 e o OLED usam os pinos 32 e 33, enquanto o módulo de movimento usa os
> pinos 21 e 22. Todos trabalham com alimentação de 3,3 volts e terra comum.
>
> O módulo inercial respondeu com o código eletrônico `0x70`. Como ainda não
> confirmamos seu modelo comercial exato, registramos de forma cuidadosa apenas
> que ele é compatível com a família MPU65xx.

### 4. O que já funciona

> Na bancada, o sistema já reconhece alterações do sinal infravermelho quando há
> contato com o sensor e identifica alterações de movimento. Os limites usados
> atualmente, infravermelho maior que 5 mil e movimento maior ou igual a 0,08,
> são provisórios e ainda precisam de calibração.
>
> Também criamos um protocolo Bluetooth próprio, chamado BluePulse versão 1. O
> ESP32 envia ao aplicativo o sinal infravermelho bruto, o índice de movimento,
> a validade do módulo inercial e a sequência dos pacotes.
>
> Nos ensaios realizados, o tablet recebeu os dados do ESP32. Em uma das
> repetições, observamos 682 pacotes sem lacunas, duplicações ou inversões. Em
> outra comparação, a mesma amostra, de sequência 2427, apresentou no monitor
> serial e no tablet os mesmos valores de infravermelho e movimento. Esses
> resultados valem apenas para as condições testadas e não garantem o mesmo
> desempenho em qualquer ambiente.
>
> O aplicativo Android foi desenvolvido em Flutter. Ele possui identificação
> por código anônimo, autorrelato inicial, modo simulado, conexão Bluetooth,
> exercício visual de respiração, exportação em CSV e JSON, exclusão confirmada
> e histórico local de sessões simuladas.

### 5. Demonstração curta

> Agora vou mostrar brevemente o aplicativo. Na tela inicial aparece o aviso de
> que o sistema é experimental e não realiza diagnóstico. Neste botão podemos
> iniciar uma sessão, e neste outro podemos consultar o histórico de coletas
> simuladas.
>
> Aqui está a sessão BP-002. Ela permaneceu salva mesmo depois que o aplicativo
> foi fechado e aberto novamente. O registro mostra 30 amostras simuladas e uma
> duração de aproximadamente 30 segundos. Também deixa explícito que frequência
> cardíaca, saturação e resposta galvânica ainda estão indisponíveis.
>
> Quando usamos o protótipo, a tela de Bluetooth recebe somente dados técnicos
> em tempo real. Esses dados reais ainda não são armazenados nesta versão.

### 6. O que foi comprovado e o que ainda não foi

> Até agora, comprovamos a integração de bancada dos componentes, a transmissão
> Bluetooth, o funcionamento do aplicativo e o armazenamento auditável de dados
> simulados.
>
> Ainda não comprovamos a medição confiável de batimentos por minuto ou de
> saturação, não implementamos o sensor GSR, não podemos identificar ansiedade
> ou estresse e ainda não avaliamos se a intervenção inspirada no oceano produz
> mudanças no bem-estar.
>
> Essa diferença é importante porque um protótipo funcionar tecnicamente não é
> o mesmo que comprovar uma hipótese científica ou clínica.

### 7. Próximas etapas

> As próximas etapas são tornar a conexão Bluetooth mais resistente a falhas,
> montar o hardware de forma mais estável e desenvolver um protocolo específico
> para validar a frequência cardíaca por comparação com uma referência.
>
> Também precisamos estudar o efeito do movimento e da iluminação sobre o sinal,
> substituir os limites provisórios por critérios baseados em dados e completar
> a experiência com autorrelato antes e depois da intervenção.
>
> Somente depois de definir privacidade, consentimento ou assentimento, critérios
> de inclusão e análise, e obter as autorizações éticas aplicáveis, poderemos
> considerar estudos com participantes. Até lá, os testes permanecem técnicos,
> simulados ou de bancada.

### 8. Encerramento

> O principal resultado até aqui não é um diagnóstico ou uma conclusão sobre
> ansiedade. É a construção de uma base técnica documentada e reproduzível para
> que a ideia possa ser investigada com responsabilidade.
>
> Todo o processo, incluindo códigos, testes, decisões, falhas e correções, está
> registrado no GitHub. Assim, conseguimos mostrar não apenas o que funcionou,
> mas também o que ainda precisa ser comprovado. Obrigada. Estou à disposição
> para as perguntas.

## Quadro para um slide: onde chegamos e o que falta

| Já realizado e documentado | Ainda precisa ser realizado |
| --- | --- |
| integração ESP32, MAX30102, MPU65xx e OLED | montagem física mais estável |
| leitura de IR bruto e movimento | calibração dos limiares provisórios |
| protocolo BLE BluePulse v1 | testes ampliados de falha e reconexão |
| recepção de dados reais no tablet | validação comparativa de BPM |
| modo simulado reproduzível | estimativa validada de BPM e possível SpO₂ |
| código anônimo e autorrelato inicial | autorrelato final e comparação pré/pós |
| sessão e pausa oceânica visual | áudio com licença e duração configurável |
| CSV, JSON, exclusão e histórico simulados | política para dados fisiológicos reais |
| registro de testes e correções no GitHub | protocolo científico e revisão ética |
| avisos explícitos de não diagnóstico | avaliação de usabilidade e eficácia |

## Demonstração recomendada

### Plano A — demonstração ao vivo

1. Deixar o tablet carregado, desbloqueado e com o BluePulse aberto.
2. Mostrar o aviso experimental da tela inicial.
3. Abrir **Histórico de coletas simuladas**.
4. Mostrar `BP-002`, a duração de `30.003 s` e as 30 amostras.
5. Voltar e abrir a fonte BLE somente se o ESP32 já estiver anunciando.
6. Mostrar por poucos segundos a sequência aumentando, o IR e o movimento.
7. Desconectar pelo botão do aplicativo.

Não excluir `BP-002` durante a apresentação. Não é necessário executar uma nova
sessão de 30 segundos diante da banca, a menos que haja tempo disponível.

### Plano B — caso o Bluetooth falhe

Usar as capturas já preservadas no repositório e dizer:

> Como conexões sem fio podem sofrer interferência no ambiente da apresentação,
> mantivemos evidências datadas dos ensaios. Esta captura mostra a recepção real,
> e esta outra registra a integridade dos pacotes e a comparação com o monitor
> serial.

Uma falha momentânea de demonstração não deve ser escondida nem interpretada
como invalidação de todos os ensaios anteriores. Ela deve ser apresentada como
uma condição adicional a ser investigada.

## Perguntas prováveis da banca

### O BluePulse já mede frequência cardíaca?

> Ainda não de forma validada. O MAX30102 já fornece o sinal óptico bruto, mas o
> cálculo de BPM precisa ser desenvolvido e comparado com uma referência antes
> de aparecer como resultado no aplicativo.

### O aplicativo consegue detectar ansiedade ou estresse?

> Não. Esses estados não podem ser diagnosticados por uma única medida. O
> projeto pretende estudar sinais fisiológicos, movimento e autorrelatos, sem
> substituir avaliação profissional.

### Então qual é o resultado atual?

> O resultado atual é técnico: sensores integrados, transmissão Bluetooth,
> aplicativo funcional, simulação reproduzível e documentação auditável. A
> hipótese sobre bem-estar ainda será estudada.

### Por que usar *blue spaces*?

> A água e os ambientes costeiros fazem parte da cultura oceânica e são a base
> da intervenção proposta. O projeto quer investigar esse tema de forma
> controlada; não assume antecipadamente que o efeito já foi comprovado pelo
> nosso protótipo.

### De onde vieram os limites 5000 e 0,08?

> Vieram dos primeiros testes de bancada para permitir que o sistema fosse
> desenvolvido. São provisórios, não clínicos e serão substituídos por critérios
> definidos a partir de novos ensaios documentados.

### Os dados das pessoas ficam protegidos?

> Nesta fase usamos código anônimo. Apenas dados simulados podem ser salvos. Os
> dados recebidos do protótipo por Bluetooth ficam somente na memória. Antes de
> armazenar dados reais, precisaremos definir regras de minimização, acesso,
> exclusão, consentimento e revisão ética.

### Por que registrar tudo no GitHub?

> Para preservar versões, datas, código, decisões, resultados e também os erros
> encontrados. Isso melhora a rastreabilidade e permite que o processo seja
> revisado e reproduzido.

### Qual foi a participação da estudante?

> A proposta inicial e a ligação entre *blue spaces*, aplicativo e dispositivo
> vestível foram idealizadas por mim. O desenvolvimento técnico está sendo feito
> de forma orientada e documentada, com decisões discutidas e testes acompanhados
> ao longo do projeto.

## Recomendações para a apresentação

- falar devagar e olhar para a banca, usando o roteiro apenas como apoio;
- explicar siglas na primeira vez: ESP32, BLE, BPM, SpO₂ e GSR;
- nunca dizer “detectamos ansiedade”, “medimos o estresse” ou “o aplicativo
  acalma”; usar “pretendemos investigar”;
- ao apresentar números de pacotes, dizer que eles representam apenas as
  condições daquele ensaio;
- valorizar uma falha documentada como parte do método científico;
- se não souber uma resposta, dizer: “Esse ponto ainda não foi testado; vamos
  registrá-lo como uma próxima etapa”.

## Checklist para 02/09/2026

- [ ] ensaiar a fala uma vez com cronômetro;
- [ ] adaptar o roteiro ao tempo oficial informado pela banca;
- [ ] carregar tablet, ESP32 e computador;
- [ ] confirmar Bluetooth e permissões no tablet;
- [ ] confirmar que `BP-002` continua no histórico;
- [ ] testar a conexão `BluePulse-ESP32` no local disponível;
- [ ] levar cabo USB e fonte de alimentação;
- [ ] manter as capturas de evidência disponíveis sem internet;
- [ ] fechar notificações pessoais antes da apresentação;
- [ ] não apagar a coleta `BP-002`;
- [ ] preparar uma versão de demonstração sem depender do Bluetooth;
- [ ] revisar com o orientador as expressões sobre saúde e diagnóstico.
