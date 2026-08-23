# Game Design Document — MaxHealth

## 1. Ficha Técnica

| Item | Descrição |
|---|---|
| Título | MaxHealth |
| Gênero | Endless Runner 2D |
| Engine | Godot Engine |
| Plataforma | Navegador (HTML5) |
| Dispositivo-alvo | PC |
| Servidor/Banco de dados | Não utiliza |
| Hospedagem prevista | apps.unifil.tech |

## 2. Conceito

O jogador controla um personagem em corrida contínua por um cenário urbano, precisando reagir a obstáculos e itens que aparecem no percurso. O objetivo é sobreviver o maior tempo possível, acumulando pontuação e progredindo em um ciclo de risco e recompensa.

## 3. Mecânicas Principais

### 3.1 Movimentação
- Corrida automática do personagem.
- Ações do jogador: **pular** e **agachar**, usadas para desviar de obstáculos e coletar itens posicionados no percurso.

### 3.2 Itens e Obstáculos
| Elemento | Efeito |
|---|---|
| Item saudável | Recupera vida e gera XP |
| Item prejudicial | Reduz vida |
| Obstáculo | Causa derrota imediata, exceto com item de proteção ativo |
| Item de proteção (loja) | Anula o efeito de derrota de um obstáculo |

### 3.3 Progressão
- XP é acumulado ao coletar itens saudáveis.
- Conversão: **100 XP = 1 moeda**.
- Moedas são usadas na loja para comprar itens de proteção.
- Loja: 2 itens especiais + 1 item supremo (em balanceamento).

### 3.4 HUD (Interface durante a partida)
- Barra de vida.
- Pontuação atual.
- Saldo de moedas.

## 4. Estrutura de Telas/Cenas

1. **Menu principal** → início da partida, acesso a configurações (se houver).
2. **Cena de jogo** → gameplay principal (corrida, coleta, obstáculos).
3. **Tela de game over** → exibida ao perder toda a vida ou colidir com obstáculo sem proteção.
4. **Retorno ao menu** → transição de volta à tela inicial a partir do game over.

## 5. Loop de Jogo (Game Loop)

```
Início da corrida
   → Jogador desvia/coleta itens em tempo real
   → Vida e XP são atualizados no HUD
   → XP acumulado converte em moedas
   → Moedas compram itens de proteção na loja (entre partidas)
   → Colisão com obstáculo sem proteção = derrota
   → Tela de game over → opção de retornar ao menu
```

## 6. Proposta Pedagógica

O jogo associa, de forma lúdica, hábitos/elementos saudáveis (itens coletáveis e de proteção) a hábitos/elementos prejudiciais (obstáculos e itens negativos), reforçando essa distinção pela repetição, pelo risco imediato e pela recompensa progressiva do sistema de itens — sem depender de texto expositivo dentro da jogabilidade.

