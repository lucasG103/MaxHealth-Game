# Guia de Publicação — Peso dos Arquivos e GitHub Pages

Guia interno da equipe MaxHealth. Cobre (1) o peso do build, antes e depois da otimização, (2) os limites do GitHub, (3) o que ainda falta ajustar antes de publicar e (4) o passo a passo para publicar no GitHub Pages, conforme exigido pela extensão (seção 4.3: publicação via GitHub Pages, repositório público, link direto no portfólio).

---

## 1. Peso do build: antes e depois

| Arquivo | Antes (build antigo) | Agora | Observação |
|---|---|---|---|
| `index.pck` | 72,7 MB (≈ 69 MiB) | **8,0 MB (≈ 7,6 MiB)** | Todos os assets do jogo empacotados |
| `index.wasm` | 35,7 MB (≈ 34 MiB) | 35,7 MB (≈ 34 MiB) | Motor do Godot; tamanho fixo do template |
| `index.js`, `index.html`, ícones | < 0,4 MB | < 0,4 MB | Irrelevantes |
| **Download na primeira visita** | **≈ 108 MB** | **≈ 44 MB** | Redução de cerca de 60% |

**O que causava o peso:** `jogo.mp3` (56 MB, 24 minutos a 320 kbps) e `menu.mp3` (7 MB) respondiam por quase 90% do `.pck`.

**O que foi feito:**
- Música convertida para OGG: `jogo.ogg` (2,3 MB) e `menu.ogg` (3,6 MB), com repetição ativada por código.
- Imagens não usadas removidas (`bg3.png`, `Humano-*.png`) e ícones dos itens reduzidos (de ≈ 1,2 MB para ≈ 0,15 MB cada).
- Os SFX são arquivos WAV curtos (10 e 14 KB).

> O Godot exporta com `export_filter="all_resources"`: qualquer arquivo dentro da pasta do projeto vai para o `.pck`, usado ou não. Mantenha fora do projeto o que não for entrar no jogo (fontes `.ase`, áudios originais, rascunhos).

---

## 2. Limites do GitHub (conferidos na documentação em nov/2026)

| Item | Limite |
|---|---|
| Arquivo em `git push` | Aviso acima de **50 MiB**; **bloqueio acima de 100 MiB** |
| Arquivo enviado pelo navegador (upload web) | Máximo de 25 MiB |
| Repositório | Recomendado **< 1 GB** (ideal); < 5 GB como teto forte |
| Site publicado no Pages | Máximo de **1 GB** |
| Deploy no Pages | Expira se passar de **10 minutos** |
| Tráfego do Pages | Limite flexível de **100 GB/mês** |
| Arquivo em Release | Até **2 GiB** por arquivo |

Fontes: documentação do GitHub ("GitHub Pages limits" e "About large files on GitHub").

**Aplicado ao MaxHealth:** nenhum arquivo do build passa de 50 MiB (o maior é o `index.wasm`, com ≈ 34 MiB). Com ≈ 44 MB por visita, o limite flexível de 100 GB/mês comporta cerca de 2.300 visitas mensais.

---

## 3. O risco que restou: o histórico do Git

O Git guarda **todas as versões** de cada arquivo. Um `.pck` ou `.wasm` já é comprimido, então o Git quase não economiza entre versões:

- Cada export comitado no histórico soma ≈ 44 MB ao repositório.
- 10 exports seguidos somam ≈ 440 MB.
- Apagar o arquivo depois **não** remove o peso: ele continua no histórico (só `git filter-repo` ou BFG limpam).

**Regra:** o build nunca vai para o ramo `main`.

Pontos de atenção:
- **Não use Git LFS para o build servido pelo Pages:** o Pages não serve objetos LFS (serve apenas o ponteiro), e o jogo quebraria.
- Se um arquivo grande já foi comitado por engano, a limpeza exige `git filter-repo` ou BFG Repo-Cleaner (reescreve o histórico; avise a equipe antes).

---

## 4. Pendências do build antes de publicar

Conferidas no último pacote enviado pela equipe:

| Pendência | Por que importa | O que fazer |
|---|---|---|
| `index.html` com `fileSizes` desatualizado (declara um `.pck` de 72.752.348 bytes; o `.pck` novo tem 7.972.324) | Indica exportação mista (`.pck` novo com `index.html` antigo). A barra de carregamento fica incorreta | Reexportar o projeto inteiro e substituir **todos** os arquivos `index.*` de uma vez |
| 3 arquivos `jogo.tscn*.tmp` em `cenas/` | Resíduos do editor; vão para o repositório se ninguém os ignorar | Apagar e incluir `*.tmp` no `.gitignore` |
| `.gitignore` do projeto só ignora `.godot/` e `/android/` | Os arquivos `index.*` exportados dentro de `max-health/` seriam comitados (≈ 44 MB) | Acrescentar `index.*` e `*.tmp` e exportar para `../build/web/` |
| `export_path` em `./index.html` (dentro do projeto) | Mistura build e código-fonte | Trocar para `../build/web/index.html` |
| `MininoJump.ase` dentro de `personagem/` | Arquivo-fonte do editor de sprites, não é usado pelo jogo | Mover para fora do projeto ou excluir no filtro de exportação (`*.ase`) |

Na raiz do repositório, o `.gitignore` deve conter:

```
build/
.godot/
*.tmp
index.*
```

---

## 5. Organização do repositório (três lugares, três funções)

| Onde | O que guarda | Por quê |
|---|---|---|
| Ramo `main` | Código-fonte do Godot (`max-health/`), `documents/`, README, fontes de áudio e sprites | Histórico leve e confiável |
| Ramo `gh-pages` | **Somente** os arquivos do build Web (`index.html`, `.js`, `.wasm`, `.pck`...) | É o que o GitHub Pages serve; pode ser regravado sem acumular histórico |
| **Releases** | `MaxHealth-web-vX.zip` (build compactado) | Cumpre "build no repositório" e "disponível para download" sem pesar o repositório |

---

## 6. Passo a passo: publicar no GitHub Pages

> Pré-requisito: repositório **público** (exigência da extensão; o Pages gratuito só funciona em repositórios públicos).

### Passo 1 — Preparar o projeto
1. Resolva as pendências da seção 4.
2. Confirme em `dados_jogo.gd` que o saldo inicial é `moedas = 0`.
3. Confirme no preset Web (Projeto → Exportar): **Suporte a Threads desligado** (o GitHub Pages não envia os cabeçalhos necessários para threads).
4. Na aba Recursos do preset, ponha em "Filtros para excluir arquivos/pastas": `*.mp3, *.tmp, *.ase`.

### Passo 2 — Exportar o build
1. Projeto → Exportar → preset **Web** → desmarque *Exportar com depuração*.
2. Caminho de saída: `../build/web/index.html`. **O arquivo deve se chamar `index.html`.**
3. Clique em **Exportar projeto**.
4. Confira o tamanho: o `index.pck` deve ter cerca de 8 MB. Se passar muito disso, há arquivo sobrando no projeto.

### Passo 3 — Testar localmente (obrigatório)
O `index.html` não funciona com duplo clique (`file://`). Use um servidor local:

```bash
cd build/web
python -m http.server 8000
```

Abra `http://localhost:8000` e jogue uma partida completa: menu → jogo → fim de jogo → loja → menu, e teste as Configurações.

> O GitHub Pages diferencia maiúsculas de minúsculas (como Linux); o Windows não. Se algum caminho no código estiver com caixa diferente do nome real do arquivo, funciona no editor mas quebra no navegador. A checagem feita no último pacote não encontrou nenhum caminho com esse problema, mas o teste local do build continua obrigatório.

### Passo 4 — Enviar o código para o ramo `main`
Como o repositório já tem README, `documents/`, `audio/` e `sprites/`:

```bash
git clone https://github.com/lucasG103/MaxHealth-Game.git
cd MaxHealth-Game
# copie para dentro do clone: a pasta max-health/ (projeto Godot), os .md atualizados e o .gitignore
git add .
git status          # confira: não deve haver build/, .godot/, index.* nem .tmp
git commit -m "Projeto Godot e documentação atualizada"
git push origin main
```

Se o `git push` reclamar de arquivo grande, revise a seção 4 antes de insistir.

### Passo 5 — Publicar o build no ramo `gh-pages`

```bash
cd build/web
# PowerShell: New-Item .nojekyll -ItemType File   |   Git Bash/Linux/Mac: touch .nojekyll
touch .nojekyll
git init -b gh-pages
git add .
git commit -m "Build Web MaxHealth v1.0"
git remote add origin https://github.com/lucasG103/MaxHealth-Game.git
git push -f origin gh-pages
```

- O arquivo `.nojekyll` evita que o GitHub processe o site com Jekyll.
- `git push -f` substitui o ramo `gh-pages` por inteiro; isso é o esperado e mantém o histórico do build sempre leve.
- A pasta `.git` dentro de `build/web` **não** deve ser apagada entre exportações.

### Passo 6 — Ativar o Pages
1. No GitHub: repositório → **Settings** → **Pages**.
2. Em *Build and deployment* → *Source*: **Deploy from a branch**.
3. *Branch*: `gh-pages`, pasta `/ (root)` → **Save**.
4. Aguarde a publicação (pode levar alguns minutos; a documentação fala em até 10). O endereço aparece no topo da página de Pages. O esperado é:

```
https://lucasg103.github.io/MaxHealth-Game/
```

### Passo 7 — Verificar o jogo publicado
Abra o link em **janela anônima** e confira:
- [ ] O menu carrega e a música toca (após o primeiro clique; os navegadores bloqueiam áudio automático).
- [ ] Uma partida completa funciona: iniciar, pular, deslizar, coletar (com som), perder, fim de jogo, loja, voltar ao menu.
- [ ] Configurações abre e ajusta o volume da música e dos efeitos.
- [ ] Sem erros no console (F12 → Console).
- [ ] Testado em pelo menos 2 navegadores (por exemplo Chrome e Firefox).
- [ ] Tempo de carregamento aceitável (F12 → Rede: confira o tamanho do `.pck`).

### Passo 8 — Atualizações futuras
```bash
# depois de reexportar para build/web
cd build/web
git add .
git commit --amend -m "Build Web MaxHealth vX"
git push -f origin gh-pages
```

Use `Ctrl+F5` (ou janela anônima) para evitar cache ao conferir.

### Passo 9 — Release com o build compactado
1. Compacte o conteúdo de `build/web` (sem a pasta `.git`) em `MaxHealth-web-v1.0.zip`.
2. No GitHub: **Releases** → **Draft a new release** → tag `v1.0` → anexe o `.zip` → **Publish**.

### Passo 10 — Usar o link
- Coloque o link do jogo no **portfólio** (obrigatório), no README e na entrega do **Classroom** (cada integrante envia individualmente).
- O jogo precisa permanecer online até a data da avaliação final.

---

## 7. Transferência para o GitHub da UniFil (ao final)

A extensão exige a transferência do repositório e de todos os artefatos para o GitHub da UniFil. Antes de transferir, confirme por escrito com os professores quem recebe e em que organização. Depois da transferência, o endereço do jogo muda para o da organização: **teste o novo link e atualize portfólio, README e Classroom.**

---

## 8. Problemas comuns

| Sintoma | Causa provável | Solução |
|---|---|---|
| 404 no link do Pages | `index.html` fora da raiz do ramo, ramo errado ou publicação ainda em andamento | Confira a raiz do `gh-pages`, a configuração do Pages e aguarde alguns minutos |
| Página em branco ou erro de "SharedArrayBuffer"/"cross-origin isolation" | Build exportado com suporte a threads | Desligue *Thread Support* e reexporte |
| Abre local mas não no Pages | Diferença de maiúsculas e minúsculas em caminhos | Corrija os caminhos e teste no servidor local |
| Sem música | Bloqueio de áudio automático do navegador | Normal até o primeiro clique ou tecla |
| Barra de carregamento incorreta | `index.html` e `index.pck` de exportações diferentes | Reexporte e substitua todos os arquivos `index.*` juntos |
| Carregamento muito lento | `.pck` pesado | Reaplique a seção 1 e confira o filtro de exclusão |
| `git push` rejeitado por arquivo grande | Arquivo acima de 100 MiB | Comprima ou mova o arquivo para fora do Git |
| Build antigo aparecendo | Cache do navegador | `Ctrl+F5` ou janela anônima |
