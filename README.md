# MaxHealth 🏃‍♂️🍎

**Endless Runner 2D · Saúde & Bem-Estar (ODS 3 — ONU)**

Projeto de Extensão Curricular (Ciência da Computação — UniFil) desenvolvido em **Godot Engine 4.6**, exportado para **HTML5/Web** e jogável direto no navegador, sem instalação.

### 🎮 [Jogue online](https://lucasg103.github.io/MaxHealth-Game/)

> Publicado via GitHub Pages. Gratuito, sem cadastro e sem coleta de dados.

---

## 📖 Sobre o jogo

Max corre automaticamente por uma rua da cidade. O jogador precisa **coletar itens saudáveis**, **evitar itens prejudiciais** e **desviar de obstáculos**. Cada escolha tem consequência imediata na barra de vida, transformando hábitos do cotidiano em uma dinâmica de jogo simples e direta.

O projeto está alinhado ao **ODS 3 (Saúde e Bem-Estar)** da ONU e funciona como ferramenta pedagógica para conscientizar jovens sobre alimentação e bem-estar, sem depender de textos explicativos durante a partida.

## 🎮 Como jogar

| Ação | Teclas |
|---|---|
| Iniciar a corrida | `Espaço` ou `Enter` |
| Pular | `Espaço`, `W` ou `↑` |
| Deslizar (segure) | `S` ou `↓` |
| Queda rápida | Segure `S` ou `↓` no ar |
| Usar Maçã Dourada / Escudo / Relógio | `1` / `2` / `3` (ou clique nos botões da HUD) |

Requisitos: computador com navegador atual e teclado. Não há suporte mobile. A lista de controles também está na tela **Configurações** do jogo.

## 🧩 Mecânicas principais

- **Coleta**
  * ✅ Item saudável (maçã, água, cenoura) → +10 na barra de vida e +50 XP
  * ❌ Item prejudicial (refrigerante, hambúrguer, donut) → −10 na barra de vida
  * 🚧 Obstáculo (placas e pombos) → derrota imediata, exceto com proteção ativa
- **Barra de vida:** começa em 50. Chegar a 25 ou menos encerra a partida; chegar a 100 dá **+100 pontos** e reinicia em 50.
- **Progressão:** 100 XP = 1 moeda. As moedas compram itens de proteção na loja (acessível pelo Game Over).
- **Dificuldade:** velocidade e quantidade de obstáculos aumentam gradualmente, sem fases separadas.

### 🛒 Loja (itens consumíveis)

| Item | Efeito | Preço |
|---|---|---|
| 🍎 Maçã Dourada | Revive uma vez (a barra volta a 50) | 10 moedas |
| 🛡️ Escudo de Proteção | Absorve uma colisão com obstáculo | 25 moedas |
| ⏱️ Relógio do Tempo | Reduz a velocidade para 50% por 8 s | 50 moedas |

Os itens são ativados antes do perigo, com as teclas `1`, `2` e `3`. Escudo e Maçã Dourada concedem 1,5 s de invulnerabilidade depois de usados.

## 🖥️ HUD

| Elemento | Função |
|---|---|
| Barra de vida | Vida atual (zona vermelha até 25, zona verde acima) |
| Pontuação e recorde | Pontos por distância, mais bônus de barra cheia |
| Saldo de moedas | Moedas disponíveis para a loja |
| Botões de itens `[1] [2] [3]` | Estoque e uso dos itens de proteção |

## 🗺️ Telas

Menu → Jogo → Fim de jogo → (Menu | Loja) → Menu. O menu também abre **Configurações** (volume da música e dos efeitos, salvo no navegador).

## 🛠️ Tecnologias

- **Engine:** Godot Engine 4.6 (2D, exportação HTML5/Web, sem threads)
- **Arte:** LibreSprite (pixel art)
- **Áudio:** BeepBox (trilha); softwares gratuitos de edição para SFX
- **Versionamento e hospedagem:** GitHub e GitHub Pages

**Restrições técnicas:** sem orçamento (apenas ferramentas gratuitas), sem servidores externos, APIs ou banco de dados remoto. Jogo 100% estático e client-side.

## 📁 Estrutura do repositório

```
MaxHealth-Game/
├── max-health/        # projeto Godot (project.godot, cenas/, scripts/, IMGS/, personagem/, audios/)
├── documents/         # Vision Document, GDD e guia de publicação
├── audio/musicas/     # fontes das músicas
├── sprites/           # fontes dos sprites
└── README.md
```

O build Web fica no ramo `gh-pages` (servido pelo GitHub Pages) e, compactado, na seção **Releases**. Detalhes em [documents/GUIA_PUBLICACAO_GITHUB_PAGES.md](documents/GUIA_PUBLICACAO_GITHUB_PAGES.md).

## ▶️ Executar e exportar

**Abrir o projeto:** instale o Godot 4.6, importe a pasta `max-health/` e execute (F5).

**Testar o build Web localmente:** o `index.html` não abre com duplo clique. Sirva a pasta do build com um servidor local:

```bash
cd build/web
python -m http.server 8000
# acesse http://localhost:8000
```

**Exportar:** Projeto → Exportar → preset *Web* (sem suporte a threads) → arquivo de saída `../build/web/index.html`.

## 👥 Equipe

| Integrante | Função | GitHub |
|---|---|---|
| Lucas Eduardo da Silva | Cria os efeitos sonoros (SFX) e cuida da documentação do portfólio e do GitHub | [@lucasG103](https://github.com/lucasG103) |
| Vitor Hugo Cardozo de Abreu | Desenha os sprites e implementa o jogo no Godot | [@vitorcdz](https://github.com/vitorcdz) |
| Carlos Henrique Yudi Endo | Dirige a arte e organiza as ideias do projeto, cuidando da parte criativa | [@CarlosHenriqueYudi](https://github.com/CarlosHenriqueYudi) |
| Davi Daisuke Yazima da Silva | Programa o jogo no Godot e otimiza as mecânicas | [@Davidayz](https://github.com/Davidayz) |

## 📄 Documentação

- [Vision Document](documents/VISION_DOCUMENT.md)
- [Game Design Document (GDD)](documents/GAME_DESIGN_DOCUMENT.md)
- [Guia de Publicação (GitHub Pages e peso dos arquivos)](documents/GUIA_PUBLICACAO_GITHUB_PAGES.md)
- [Portfólio completo do projeto](https://sites.google.com/edu.unifil.br/portflio-jogo/p%C3%A1gina-inicial)

## ⚠️ Limitações conhecidas

- Moedas, itens e recorde não são salvos: valem apenas durante a sessão do navegador. Os volumes são salvos.
- Efeitos sonoros apenas para item saudável e item prejudicial.
- No navegador, o botão "Sair" tenta fechar a aba e troca a página por uma tela em branco.
- Sem suporte a celulares e tablets.

## 🌍 Impacto social

O jogo pode ser usado em escolas, projetos sociais e atividades comunitárias como apoio pedagógico. Por ser gratuito e acessível por link, sem instalação, busca democratizar o acesso à educação em saúde.

## 🎓 Projeto de extensão

Ao término do projeto, o repositório e todos os artefatos serão transferidos para o GitHub da UniFil.
