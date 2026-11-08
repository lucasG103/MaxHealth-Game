# Vision Document — MaxHealth

## 1. Visão Geral

MaxHealth é um jogo *endless runner* 2D alinhado ao **ODS 3 — Saúde e Bem-Estar** da ONU. O jogador controla um personagem que corre automaticamente por uma rua da cidade, coletando itens saudáveis, evitando itens prejudiciais e desviando de obstáculos.

O projeto integra a Extensão Curricular do curso de Ciência da Computação da UniFil, unindo desenvolvimento de jogos, design de interação e programação a uma proposta de conscientização sobre hábitos de vida. O produto final é um jogo educativo, **gratuito e aberto à comunidade**, jogável diretamente no navegador.

## 2. Problema

O sedentarismo, a rotina agitada, o uso excessivo de tecnologia e a falta de informação prática sobre cuidados com o corpo e a mente dificultam a manutenção de hábitos saudáveis, especialmente entre crianças e jovens. Falta, nesse público, contato com formas simples e envolventes de refletir sobre as próprias escolhas de saúde no dia a dia.

## 3. Proposta de Solução

Em vez de comunicar hábitos saudáveis por texto expositivo, o MaxHealth transforma a mensagem em experiência jogável: a cada corrida, o jogador decide em tempo real entre coletar o que fortalece o personagem e desviar do que o prejudica, percebendo a consequência imediatamente na barra de vida, na pontuação e na continuidade da partida.

Hábitos viram mecânica:
- **Escolhas saudáveis** (maçã, água, cenoura) enchem a barra de vida, rendem XP e, ao completar a barra, pontos extras.
- **Escolhas prejudiciais** (refrigerante, hambúrguer, donut) reduzem a barra; três seguidas, a partir do meio, encerram a corrida.
- **Perigos do caminho** (placas e pombos) exigem atenção e reflexo.
- **Recompensa progressiva:** o XP vira moeda (100 XP = 1 moeda), usada na loja para comprar itens de proteção: Maçã Dourada, Escudo de Proteção e Relógio do Tempo.

## 4. Público-Alvo

- **Jogadores diretos:** crianças, adolescentes e jovens estudantes.
- **Educadores e famílias:** apoio lúdico para introduzir o tema de hábitos saudáveis.
- **Sociedade em geral:** contribuição para despertar atenção às próprias escolhas de saúde.

## 5. Alinhamento com a Extensão e com os ODS

| Diretriz | Como o projeto atende |
|---|---|
| Temática social (ODS) | Saúde e bem-estar (ODS 3) |
| Framework | Godot Engine 4.6 |
| Jogo 2D, estático e client-side | Sem servidor, API, banco de dados ou autenticação; todos os arquivos locais |
| Exportação HTML5, sem instalação | Build Web executado no navegador |
| Mecânica cíclica e rejogável | Corrida infinita com recorde e progressão por moedas |
| Hospedagem | GitHub Pages (repositório público) |
| Acesso livre | Gratuito, sem cadastro nem login |

## 6. Mecânicas Centrais

- O personagem corre automaticamente; o jogador pula e desliza para desviar de obstáculos e alcançar itens.
- **Itens saudáveis:** +10 na barra de vida e +50 XP.
- **Itens prejudiciais:** −10 na barra de vida.
- **Obstáculos:** derrota imediata, exceto com item de proteção ativo.
- **Barra de vida:** começa em 50; chegar a 25 ou menos encerra a partida; chegar a 100 dá +100 pontos e reinicia em 50.
- **Progressão:** XP convertido em moedas (100 XP = 1 moeda) para comprar itens consumíveis na loja (Maçã Dourada 10, Escudo 25, Relógio 50).
- **Dificuldade:** velocidade e quantidade de obstáculos crescem gradualmente, sem fases separadas.
- **Configurações:** volume da música e dos efeitos, salvo no navegador.
- **HUD:** barra de vida, pontuação, recorde, saldo de moedas e botões de itens.

Detalhes completos no [Game Design Document](GAME_DESIGN_DOCUMENT.md).

## 7. Escopo Técnico e Restrições

- **Engine:** Godot Engine 4.6 (2D).
- **Plataforma:** navegador (HTML5), sem instalação; exclusivo para PC com teclado.
- **Infraestrutura:** nenhuma dependência de servidor, banco de dados ou serviço externo.
- **Orçamento:** zero; apenas ferramentas gratuitas (Godot, LibreSprite, BeepBox, GitHub).
- **Hospedagem:** GitHub Pages (exigência da extensão).
- **Peso do build:** cerca de 44 MB no total (motor de 35,7 MB e pacote do jogo de 8 MB), mantido enxuto para uso em computadores escolares.

## 8. Entregas Finais

- Jogo exportado para Web e hospedado no GitHub Pages, com link direto no portfólio.
- Repositório público com código-fonte, assets, documentação e build.
- Portfólio completo e atualizado (documentação, vídeo, relatórios).
- Relatório de impacto social.
- Fotos para divulgação institucional.
- Ao término do projeto, transferência do repositório para o GitHub da UniFil.

## 9. Estratégia de Avaliação de Impacto

Como o jogo não pode coletar dados (sem servidor nem serviços externos), o impacto é avaliado fora do jogo:
- sessões de teste com público-alvo (estudantes, educadores), com observação direta;
- questionário externo curto, aplicado antes e depois da sessão, sobre percepção do tema e usabilidade;
- registro das respostas e conclusões no relatório de impacto social, sem dados pessoais.

## 10. Critérios de Sucesso

- Mecânicas essenciais implementadas e funcionando sem erros críticos.
- Navegação completa entre todas as telas: menu → jogo → fim de jogo → (menu | loja) → menu, além das configurações.
- Proposta comunicada de forma clara pela jogabilidade, sem texto explicativo extenso.
- Jogo acessível online por link direto, carregando em tempo razoável em computadores comuns.
- Todos os itens de entrega da extensão cumpridos e documentados.

## 11. Riscos e Mitigações

| Risco | Mitigação |
|---|---|
| Build pesado, com carregamento lento em máquinas escolares | Áudio convertido para OGG, assets não usados removidos e ícones reduzidos; conferir o peso a cada exportação |
| Crescimento do repositório com builds repetidos | Manter o build fora do ramo principal (ramo `gh-pages`) e usar Releases para distribuição |
| Perda de progresso do jogador (sem salvamento de moedas e itens) | Documentado como limitação; partidas curtas e independentes |
| Incompatibilidade de navegador | Teste nos navegadores mais comuns antes da entrega final |

## 12. Equipe

| Nome | Função |
|---|---|
| Lucas Eduardo da Silva | Cria os efeitos sonoros (SFX) e cuida da documentação do portfólio e do GitHub |
| Vitor Hugo Cardozo de Abreu | Desenha os sprites e implementa o jogo no Godot |
| Carlos Henrique Yudi Endo | Dirige a arte e organiza as ideias do projeto, cuidando da parte criativa |
| Davi Daisuke Yazima da Silva | Programa o jogo no Godot e otimiza as mecânicas |
