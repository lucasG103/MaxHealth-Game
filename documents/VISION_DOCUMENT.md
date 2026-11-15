# Vision Document — MaxHealth

## 1. Visão Geral

MaxHealth é um jogo *endless runner* 2D alinhado ao **ODS 3 — Saúde e Bem-Estar** da ONU. O jogador controla um personagem que corre automaticamente por uma rua da cidade, coletando itens saudáveis, evitando itens prejudiciais e desviando de obstáculos.

O projeto integra a Extensão Curricular do curso de Ciência da Computação da UniFil, unindo desenvolvimento de jogos, design de interação e programação a uma proposta de conscientização sobre hábitos de vida. O produto final é um jogo educativo, gratuito e aberto à comunidade, executável diretamente no navegador.

## 2. Problema

O sedentarismo, a rotina agitada, o uso excessivo de tecnologia e a falta de informação prática sobre cuidados com o corpo e a mente dificultam a manutenção de hábitos saudáveis, especialmente entre crianças e jovens. Falta, nesse público, contato com formas simples e envolventes de refletir sobre as próprias escolhas de saúde no dia a dia.

## 3. Proposta de Solução

Em vez de comunicar hábitos saudáveis por meio de texto expositivo, o MaxHealth transforma a mensagem em experiência jogável. A cada corrida, o jogador decide em tempo real entre coletar o que fortalece o personagem e desviar do que o prejudica, percebendo a consequência imediatamente na barra de vida, na pontuação e na continuidade da partida.

Os hábitos se tornam mecânica de jogo:

- **Escolhas saudáveis** (maçã, água e cenoura) aumentam a barra de vida, geram XP e, ao completar a barra, concedem pontos extras.
- **Escolhas prejudiciais** (refrigerante, hambúrguer e donut) reduzem a barra de vida, e a sequência delas encerra a corrida.
- **Perigos do caminho** (placas e pombos) exigem atenção e reflexo.
- **Recompensa progressiva:** o XP é convertido em moedas, utilizadas na loja para adquirir itens de proteção (Maçã Dourada, Escudo de Proteção e Relógio do Tempo).

## 4. Público-Alvo

- **Jogadores diretos:** crianças, adolescentes e jovens estudantes.
- **Educadores e famílias:** apoio lúdico para introduzir o tema de hábitos saudáveis.
- **Sociedade em geral:** contribuição para despertar atenção às próprias escolhas de saúde.

## 5. Alinhamento com a Extensão e com os ODS

| Diretriz | Atendimento no projeto |
|---|---|
| Temática social (ODS) | Saúde e bem-estar (ODS 3) |
| Framework | Godot Engine 4.6 |
| Jogo 2D, estático e client-side | Sem servidor, API, banco de dados ou autenticação; todos os arquivos locais |
| Exportação HTML5, sem instalação | Build Web executado no navegador |
| Mecânica cíclica e rejogável | Corrida infinita com recorde e progressão por moedas |
| Hospedagem | GitHub Pages (repositório público) |
| Acesso livre | Gratuito, sem cadastro nem login |

## 6. Mecânicas Centrais

- O personagem corre automaticamente, e o jogador pula e desliza para desviar de obstáculos e alcançar itens.
- Itens saudáveis aumentam a barra de vida e geram XP; itens prejudiciais reduzem a barra de vida.
- Obstáculos causam derrota imediata, exceto quando há item de proteção ativo.
- A barra de vida possui zona vermelha, que encerra a partida, e zona verde. Ao ser completada, concede pontos extras e retorna ao ponto médio.
- O XP acumulado é convertido em moedas para a compra de itens consumíveis na loja.
- A velocidade e a quantidade de obstáculos aumentam gradualmente, sem fases separadas.
- A tela de Configurações permite ajustar o volume da música e dos efeitos, com preferência mantida no navegador.
- A HUD exibe barra de vida, pontuação, recorde, saldo de moedas e botões de itens.

Os detalhes completos constam no [Game Design Document](GAME_DESIGN_DOCUMENT.md).

## 7. Escopo Técnico e Restrições

- **Engine:** Godot Engine 4.6 (2D).
- **Plataforma:** navegador (HTML5), sem instalação; exclusivo para PC com teclado.
- **Infraestrutura:** nenhuma dependência de servidor, banco de dados ou serviço externo.
- **Orçamento:** nenhum; utilização exclusiva de ferramentas gratuitas (Godot, LibreSprite, BeepBox e GitHub).
- **Hospedagem:** GitHub Pages, conforme exigência da extensão.
- **Desempenho:** pacote do jogo mantido enxuto, para uso em computadores escolares.

## 8. Entregas Finais

- Jogo exportado para Web e hospedado no GitHub Pages, com link direto no portfólio.
- Repositório público com código-fonte, assets, documentação e build.
- Portfólio completo e atualizado, com documentação, vídeo e relatórios.
- Relatório de impacto social.
- Fotos para divulgação institucional.
- Transferência do repositório para o GitHub da UniFil ao término do projeto.

## 9. Estratégia de Avaliação de Impacto

Como o jogo não coleta dados, por não utilizar servidor nem serviços externos, o impacto é avaliado fora do jogo:

- sessões de teste com público-alvo (estudantes e educadores), com observação direta;
- questionário externo curto, aplicado antes e depois da sessão, sobre percepção do tema e usabilidade;
- registro das respostas e das conclusões no relatório de impacto social, sem dados pessoais.

## 10. Critérios de Sucesso

- Mecânicas essenciais implementadas e funcionando sem erros críticos.
- Navegação completa entre todas as telas: menu, jogo, fim de jogo, loja e configurações.
- Proposta comunicada de forma clara pela jogabilidade, sem texto explicativo extenso.
- Jogo acessível online por link direto, com carregamento em tempo razoável em computadores comuns.
- Todos os itens de entrega da extensão cumpridos e documentados.

## 11. Riscos e Mitigações

| Risco | Mitigação |
|---|---|
| Pacote pesado, com carregamento lento em máquinas escolares | Áudio em formato compactado, remoção de assets não utilizados e redução de imagens |
| Crescimento do repositório com builds repetidos | Manutenção do build fora do ramo principal e distribuição por Releases |
| Perda de progresso do jogador, por ausência de salvamento de moedas e itens | Documentação da limitação; partidas curtas e independentes |
| Incompatibilidade de navegador | Testes nos navegadores mais comuns antes da entrega final |

## 12. Equipe

| Nome | Função |
|---|---|
| Lucas Eduardo da Silva | Cria os efeitos sonoros (SFX) e cuida da documentação do portfólio e do GitHub |
| Vitor Hugo Cardozo de Abreu | Desenha os sprites e implementa o jogo no Godot |
| Carlos Henrique Yudi Endo | Dirige a arte e organiza as ideias do projeto, cuidando da parte criativa |
| Davi Daisuke Yazima da Silva | Programa o jogo no Godot e otimiza as mecânicas |
