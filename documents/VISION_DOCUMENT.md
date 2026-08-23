# Vision Document — MaxHealth

## 1. Visão Geral

MaxHealth é um jogo *endless runner* 2D alinhado ao **ODS 3 — Saúde e Bem-Estar** da ONU. O jogador controla um personagem que corre automaticamente por um cenário urbano, precisando coletar itens saudáveis, desviar de itens prejudiciais e superar obstáculos ao longo do percurso.

O projeto integra a extensão curricular do curso de Ciência da Computação (UniFil), unindo desenvolvimento de jogos, design de interação e programação a uma proposta de conscientização sobre hábitos de vida.

## 2. Problema

O sedentarismo, a rotina agitada e o uso excessivo de tecnologia têm dificultado a manutenção de hábitos saudáveis, especialmente entre crianças e jovens. Falta, nesse público, contato com formas simples e engajantes de refletir sobre as próprias escolhas de saúde no dia a dia.

## 3. Proposta de Solução

Em vez de comunicar hábitos saudáveis por meio de texto expositivo, o MaxHealth transforma a mensagem em experiência jogável: a cada corrida, o jogador decide, em tempo real, entre coletar o que fortalece o personagem e desviar do que o prejudica, sentindo a consequência dessa escolha imediatamente por meio da vida, da pontuação e da velocidade do jogo.

## 4. Público-Alvo

- **Jogadores diretos:** crianças, adolescentes e jovens estudantes.
- **Educadores e famílias:** apoio lúdico para introduzir o tema de hábitos saudáveis.
- **Sociedade em geral:** contribuição para despertar atenção às próprias escolhas de saúde.

## 5. Mecânicas Centrais

- O personagem corre automaticamente; o jogador pula e agacha para desviar de obstáculos e coletar itens.
- **Itens saudáveis:** recuperam vida e geram XP.
- **Itens prejudiciais:** reduzem vida.
- **Obstáculos:** causam derrota imediata, exceto quando o jogador possui um item de proteção ativo.
- **Progressão:** XP acumulado é convertido em moedas (100 XP = 1 moeda), usadas em uma loja para comprar itens de proteção contra obstáculos.
- **HUD:** barra de vida, pontuação e saldo de moedas visíveis durante a partida.

## 6. Escopo Técnico

- **Engine:** Godot Engine.
- **Plataforma:** execução via navegador (exportação HTML5), sem instalação.
- **Infraestrutura:** sem dependência de servidor ou banco de dados.
- **Dispositivo-alvo:** exclusivo para PC.
- **Hospedagem prevista:** apps.unifil.tech, seguindo o padrão de outros projetos da faculdade.

## 7. Critérios de Sucesso

- Mecânicas essenciais implementadas e funcionando sem erros críticos.
- Navegação completa entre todas as telas/cenas (menu → jogo → game over → retorno ao menu).
- Proposta do jogo comunicada de forma clara através da própria jogabilidade, sem depender de texto explicativo extenso.

## 8. Equipe

| Nome | Função |
|---|---|
| Lucas Eduardo da Silva | Documentação (Portfólio e GitHub), design de SFX |
| Vitor Hugo Cardozo de Abreu | Design de sprites, implementação em Godot |
| Carlos Henrique Yudi Endo | Direção de arte, organização criativa |
| Davi Daisuke Yazima da Silva | Programação e otimização de mecânicas |
