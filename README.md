# MaxHealth 🏃‍♂️🍎

**Endless Runner 2D · Saúde & Bem-Estar (ODS 3 — ONU)**

Projeto de Extensão Curricular desenvolvido em **Godot Engine**, com exportação para **HTML5/Web**, jogável direto no navegador sem instalação.

---

## 📖 Sobre o jogo

MaxHealth é um *endless runner* no qual o personagem corre automaticamente por uma rua da cidade. O jogador precisa **coletar itens saudáveis** enquanto **desvia de itens prejudiciais e obstáculos**. Cada escolha tem uma consequência imediata na saúde do personagem, transformando hábitos do cotidiano em uma dinâmica de jogo simples e direta.

O projeto está alinhado ao **ODS 3 (Saúde e Bem-Estar)** da Organização das Nações Unidas, funcionando como ferramenta pedagógica para conscientizar jovens sobre alimentação e bem-estar de forma leve e interativa.

## 🎮 Controles

| Ação    | Efeito                                          |
| ------- | ------------------------------------------------ |
| Pular   | Desvia de obstáculos e coleta itens no caminho   |
| Agachar | Passa por baixo de obstáculos                    |

## 🧩 Mecânicas principais

- **Coleta:**
  * ✅ Item saudável → recupera vida e gera XP
  * ❌ Item prejudicial → reduz vida
  * 🚧 Obstáculo → causa derrota imediata, exceto com item de proteção ativo
- **Progressão:** XP acumulado é convertido em moedas (100 XP = 1 moeda), usadas em uma loja para comprar itens de proteção contra obstáculos (2 itens especiais + 1 item supremo, em balanceamento).
- **Dificuldade:** velocidade e densidade de obstáculos aumentam de forma gradual e contínua, sem fases separadas.

## 🖥️ HUD

| Elemento      | Função                                     |
| ------------- | ------------------------------------------- |
| Barra de Vida | Vida atual do personagem                    |
| Pontuação     | Pontos acumulados por distância percorrida  |
| Saldo de Moedas | Moedas disponíveis para compras na loja   |

## 🛠️ Tecnologias

- **Engine:** Godot Engine (2D, export HTML5/Web)
- **Arte:** LibreSprite (Pixel Art)
- **Áudio:** BeepBox (trilha), softwares gratuitos de edição para SFX
- **Versionamento:** GitHub

**Restrições técnicas:** sem orçamento (apenas ferramentas gratuitas), sem servidores externos, APIs ou banco de dados remoto. Suporte apenas para PC/notebook via navegador — sem suporte mobile.

## 👥 Equipe

| Integrante                   | Função                                                                          | GitHub                                                        |
| ----------------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| Lucas Eduardo da Silva        | Designer dos SFXs e responsável pela documentação no Portfólio e GitHub          | [@lucasG103](https://github.com/lucasG103)                     |
| Vitor Hugo Cardozo de Abreu   | Designer dos Sprites e responsável pela implementação no Godot                   | [@vitorcdz](https://github.com/vitorcdz)                       |
| Carlos Henrique Yudi Endo     | Direção de Arte e responsável pela otimização de ideias e organização criativa   | [@CarlosHenriqueYudi](https://github.com/CarlosHenriqueYudi)   |
| Davi Daisuke Yazima da Silva  | Desenvolvedor dos códigos usados no Godot e responsável pela otimização de mecânicas de jogo | [@Davidayz](https://github.com/Davidayz)          |

## 📄 Documentação

- [Vision Document](https://github.com/lucasG103/MaxHealth-Game/blob/main/documents/VISION_DOCUMENT.md)
- [Game Design Document (GDD)](https://github.com/lucasG103/MaxHealth-Game/blob/main/documents/GAME_DESIGN_DOCUMENT.md)
- [Portfólio completo do projeto](https://sites.google.com/edu.unifil.br/portflio-jogo/p%C3%A1gina-inicial)

## 🌍 Impacto social

O jogo pode ser utilizado em escolas, projetos sociais e atividades comunitárias como ferramenta de apoio pedagógico. Por ser gratuito e acessível via link, sem necessidade de instalação, busca democratizar o acesso à educação em saúde.
