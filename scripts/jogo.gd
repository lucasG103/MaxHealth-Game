extends Node

# ---------------------------------------------------------------
# Cenas
# ---------------------------------------------------------------
var pombo = preload("res://cenas/Pombo.tscn")
var placa = preload("res://cenas/placa_1.tscn")
var placa2 = preload("res://cenas/placa_2.tscn")
var item_cena = preload("res://cenas/item_coletavel.tscn")
var game_over_cena = preload("res://cenas/game_over.tscn")
var obstaculos_tipos := [placa, placa2]
var obstaculos : Array
var pombo_alt := [200, 390]

# ---------------------------------------------------------------
# Itens coletáveis (sprites). Troque pelos seus caminhos aqui.
# ---------------------------------------------------------------
const ITENS_BONS := [
	"res://IMGS/itens/maca.png",
	"res://IMGS/itens/brocolis.png",
	"res://IMGS/itens/peso.png",
]
const ITENS_RUINS := [
	"res://IMGS/itens/ruim_refri.png",
	"res://IMGS/itens/hamburguer.png",
	"res://IMGS/itens/ruim_donut.png",
]
var texturas_bons : Array = []
var texturas_ruins : Array = []
var itens_mundo : Array = []

const CHANCE_ITEM_BOM : float = 0.5
const DIST_ITEM_MIN : float = 450.0      # distância mínima entre itens (px)
const DIST_ITEM_MAX : float = 900.0
const DIST_SEGURA : float = 400.0        # item e obstáculo não nascem mais perto que isso
const ALTURAS_ITEM := [530.0, 430.0, 330.0]  # chão (dá para pegar deslizando), pulo curto, pulo alto
var proximo_item_x : float = 0.0

# ---------------------------------------------------------------
# Barra de vida: 0..100. Vermelho = 0..25, verde = 25..100. Começa em 50.
# ---------------------------------------------------------------
const BARRA_INICIAL : float = 50.0
const BARRA_ZONA_VERMELHA : float = 25.0
const BARRA_ITEM_BOM : float = 10.0
const BARRA_ITEM_RUIM : float = 10.0
const BONUS_BARRA_CHEIA : int = 100      # pontos extras ao completar a barra
const XP_ITEM_BOM : int = 50             # 100 XP = 1 moeda
var vida : float = BARRA_INICIAL
var pontos_bonus : int = 0

# ---------------------------------------------------------------
# Itens da loja em uso
# ---------------------------------------------------------------
const DURACAO_RELOGIO : float = 8.0
const FATOR_RELOGIO : float = 0.5
const TEMPO_INVULNERAVEL : float = 1.5
var maca_ativa : bool = false
var escudo_ativo : bool = false
var relogio_restante : float = 0.0
var invulneravel : float = 0.0

# ---------------------------------------------------------------
# Jogo
# ---------------------------------------------------------------
var finalizando_partida: bool = false

const MENINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var dificuldade : int
const MAX_DIFICULDADE : int = 2

var score : float
const SCORE_MODIFIER : int = 10

const START_SPEED : float = 10.0
const MAX_SPEED : float = 25.0
const SPEED_MODIFIER : int = 5000
var speed : float

var screen_size : Vector2i
var ground_height : int
var game_running : bool
var ultimo_obstaculo
var ultimo_obs_x : float = -100000.0
var moedas_inicio : int = 0

@onready var hud = $HUD


func _ready():
	screen_size = get_window().size
	ground_height = $chao.get_node("Sprite2D").texture.get_height()
	texturas_bons = _carregar_texturas(ITENS_BONS)
	texturas_ruins = _carregar_texturas(ITENS_RUINS)
	hud.item_pressionado.connect(usar_item)
	# música do jogo: em loop, e para a música do menu
	DadosJogo.parar_musica_menu()
	DadosJogo.ativar_loop($Musica.stream)
	$Musica.volume_db = DadosJogo.volume_musica_db()
	new_game()


func _carregar_texturas(caminhos: Array) -> Array:
	var lista : Array = []
	for c in caminhos:
		if ResourceLoader.exists(c):
			lista.append(load(c))
		else:
			push_warning("Sprite de item não encontrado: " + c)
	return lista


func new_game():
	score = 0
	pontos_bonus = 0
	vida = BARRA_INICIAL
	maca_ativa = false
	escudo_ativo = false
	relogio_restante = 0.0
	invulneravel = 0.0
	moedas_inicio = DadosJogo.moedas
	_sincronizar_menino()
	hud.set_vida(vida, false)
	hud.set_moedas(DadosJogo.moedas)
	_atualizar_hud_itens()
	show_score()

	$MSG_INI/Control/Recorde.text = "RECORDE: " + str(DadosJogo.recorde)

	game_running = false
	get_tree().paused = false
	dificuldade = 0
	ultimo_obs_x = -100000.0
	proximo_item_x = MENINO_START_POS.x + screen_size.x + 600.0

	for obs in obstaculos:
		obs.queue_free()
	obstaculos.clear()
	for it in itens_mundo:
		it.queue_free()
	itens_mundo.clear()

	$Menino.position = MENINO_START_POS
	$Menino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$chao.position = Vector2i(0, 0)

	$MSG_INI/Control/Iniciar.show()


func _process(delta):
	if game_running:
		_atualizar_efeitos(delta)

		var base_speed : float = minf(START_SPEED + score / SPEED_MODIFIER, MAX_SPEED)
		speed = base_speed * (FATOR_RELOGIO if relogio_restante > 0.0 else 1.0)

		ajustar_dificuldade()
		gerar_obs()
		gerar_itens()

		$Menino.position.x += speed
		$Camera2D.position.x += speed

		# a pontuação usa a velocidade normal (o relógio não deve "custar" pontos)
		score += base_speed
		show_score()

		if $Camera2D.position.x - $chao.position.x > screen_size.x * 1.5:
			$chao.position.x += screen_size.x

		for obs in obstaculos.duplicate():
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remover_obs(obs)
		for it in itens_mundo.duplicate():
			if it.position.x < ($Camera2D.position.x - screen_size.x):
				remover_item(it)

	else:
		# Só permite iniciar se o menino ainda estiver vivo
		if not $Menino.morreu and not finalizando_partida and Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$MSG_INI/Control/Iniciar.hide()


func _unhandled_input(event):
	for i in range(1, 4):
		if event.is_action_pressed("usar_item_" + str(i)):
			usar_item("item_" + str(i))


# ---------------------------------------------------------------
# Obstáculos
# ---------------------------------------------------------------
func _x_ref() -> float:
	# distância percorrida pelo menino (independe do relógio)
	return $Menino.position.x - MENINO_START_POS.x


func _x_ultimo_obs() -> float:
	if is_instance_valid(ultimo_obstaculo):
		ultimo_obs_x = ultimo_obstaculo.position.x
	return ultimo_obs_x


func _tem_algo_perto(x: float, lista: Array, dist: float) -> bool:
	for n in lista:
		if is_instance_valid(n) and absf(n.position.x - x) < dist:
			return true
	return false


func gerar_obs():
	if obstaculos.is_empty() or _x_ultimo_obs() < _x_ref() + randi_range(50, 500):
		# não nasce em cima de um item
		if _tem_algo_perto(screen_size.x + _x_ref() + 150.0, itens_mundo, DIST_SEGURA):
			return

		var spawnar_pombo = false
		if dificuldade == MAX_DIFICULDADE and (randi() % 2) == 0:
			spawnar_pombo = true

		if spawnar_pombo:
			var obs = pombo.instantiate()
			var obs_x : int = screen_size.x + _x_ref() + 200
			var obs_y : int = pombo_alt[randi() % pombo_alt.size()]
			ultimo_obstaculo = obs
			adicionar_obs(obs, obs_x, obs_y)
		else:
			var obs_tipo = obstaculos_tipos[randi() % obstaculos_tipos.size()]
			var obs
			var max_obs = dificuldade + 1

			for i in range(randi() % max_obs + 1):
				obs = obs_tipo.instantiate()
				var obs_alt = obs.get_node("Sprite2D").texture.get_height()
				var obs_escala = obs.get_node("Sprite2D").scale

				var obs_x : int = screen_size.x + _x_ref() + 100 + (i * 100)
				var obs_y : int = screen_size.y - ground_height - (obs_alt * obs_escala.y / 2) + 60

				ultimo_obstaculo = obs
				adicionar_obs(obs, obs_x, obs_y)


func adicionar_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(colidir_obs.bind(obs))
	add_child(obs)
	obstaculos.append(obs)


func remover_obs(obs):
	obstaculos.erase(obs)
	if is_instance_valid(obs):
		obs.queue_free()


func colidir_obs(body, obs):
	if body.name != "Menino":
		return
	if finalizando_partida or body.morreu or invulneravel > 0.0:
		return

	if escudo_ativo:
		escudo_ativo = false
		_sincronizar_menino()
		_atualizar_hud_itens()
		_ficar_invulneravel()
		remover_obs(obs)
		hud.mostrar_aviso("ESCUDO PROTEGEU!", Color(0.4, 0.8, 1.0))
		return

	if maca_ativa:
		_reviver()
		remover_obs(obs)
		return

	finalizar_partida()


# ---------------------------------------------------------------
# Itens coletáveis (bons e ruins)
# ---------------------------------------------------------------
func gerar_itens():
	var borda_x : float = $Menino.position.x + screen_size.x + 150.0
	if borda_x < proximo_item_x:
		return
	# não nasce em cima de um obstáculo
	if _tem_algo_perto(borda_x, obstaculos, DIST_SEGURA):
		return

	var bom : bool = randf() < CHANCE_ITEM_BOM
	var lista : Array = texturas_bons if bom else texturas_ruins
	if lista.is_empty():
		proximo_item_x = borda_x + randf_range(DIST_ITEM_MIN, DIST_ITEM_MAX)
		return

	var item = item_cena.instantiate()
	add_child(item)
	item.configurar(lista[randi() % lista.size()], bom)
	item.position = Vector2(borda_x, ALTURAS_ITEM[randi() % ALTURAS_ITEM.size()])
	item.area_entered.connect(coletar_item.bind(item))
	itens_mundo.append(item)
	proximo_item_x = borda_x + randf_range(DIST_ITEM_MIN, DIST_ITEM_MAX)


func remover_item(item):
	itens_mundo.erase(item)
	if is_instance_valid(item):
		item.queue_free()


func coletar_item(area, item):
	# quem coleta é a "AreaColeta" do Menino (funciona também deslizando)
	if area.name != "AreaColeta":
		return
	var body = area.get_parent()
	if body.name != "Menino" or finalizando_partida or body.morreu:
		return
	if item.coletado:
		return
	item.coletado = true
	var bom : bool = item.bom
	remover_item(item)

	if bom:
		DadosJogo.adicionar_xp(XP_ITEM_BOM)
		hud.set_moedas(DadosJogo.moedas)
		body.piscar(Color(0.4, 1.0, 0.4))
		DadosJogo.tocar_sfx("bom")
		alterar_vida(BARRA_ITEM_BOM)
	else:
		body.piscar(Color(1.0, 0.3, 0.3))
		DadosJogo.tocar_sfx("ruim")
		alterar_vida(-BARRA_ITEM_RUIM)


# ---------------------------------------------------------------
# Barra de vida
# ---------------------------------------------------------------
func alterar_vida(delta_vida: float):
	vida = clampf(vida + delta_vida, 0.0, 100.0)

	if vida <= BARRA_ZONA_VERMELHA:
		# chegou no vermelho: morre (a Maçã Dourada salva)
		if maca_ativa:
			_reviver()
		else:
			hud.set_vida(vida)
			finalizar_partida()
		return

	if vida >= 100.0:
		pontos_bonus += BONUS_BARRA_CHEIA
		vida = BARRA_INICIAL
		hud.barra_cheia()
		hud.mostrar_aviso("BARRA CHEIA! +%d PONTOS" % BONUS_BARRA_CHEIA, Color(1, 0.9, 0.2))
		show_score()
		return

	hud.set_vida(vida)


# ---------------------------------------------------------------
# Itens da loja (botões da HUD / teclas 1, 2, 3)
# ---------------------------------------------------------------
func usar_item(id: String):
	if not game_running or finalizando_partida:
		return
	var item = DadosJogo.itens[id]
	if item["quantidade"] <= 0:
		return

	match id:
		"item_1":
			if maca_ativa:
				return
			maca_ativa = true
		"item_2":
			if escudo_ativo:
				return
			escudo_ativo = true
		"item_3":
			if relogio_restante > 0.0:
				return
			relogio_restante = DURACAO_RELOGIO

	item["quantidade"] -= 1
	_sincronizar_menino()
	_atualizar_hud_itens()


func _atualizar_efeitos(delta):
	if invulneravel > 0.0:
		invulneravel -= delta
	if relogio_restante > 0.0:
		relogio_restante -= delta
		if relogio_restante <= 0.0:
			relogio_restante = 0.0
			_sincronizar_menino()
	_atualizar_hud_itens()


func _sincronizar_menino():
	$Menino.com_maca = maca_ativa
	$Menino.com_escudo = escudo_ativo
	$Menino.com_relogio = relogio_restante > 0.0


func _atualizar_hud_itens():
	hud.atualizar_item("item_1", DadosJogo.itens["item_1"]["quantidade"], maca_ativa)
	hud.atualizar_item("item_2", DadosJogo.itens["item_2"]["quantidade"], escudo_ativo)
	hud.atualizar_item("item_3", DadosJogo.itens["item_3"]["quantidade"], relogio_restante > 0.0, relogio_restante)


func _ficar_invulneravel():
	invulneravel = TEMPO_INVULNERAVEL
	$Menino.piscar_invulneravel(TEMPO_INVULNERAVEL)


func _reviver():
	maca_ativa = false
	vida = BARRA_INICIAL
	_sincronizar_menino()
	_atualizar_hud_itens()
	hud.set_vida(vida)
	_ficar_invulneravel()
	hud.mostrar_aviso("MAÇÃ DOURADA: REVIVEU!", Color(1, 0.85, 0.2))


# ---------------------------------------------------------------
# Pontuação e fim de jogo
# ---------------------------------------------------------------
func pontos_totais() -> int:
	return int(score / SCORE_MODIFIER) + pontos_bonus


func show_score():
	$MSG_INI/Control/Pontos.text = "PONTOS: " + str(pontos_totais())


func checar_recorde() -> bool:
	var total := pontos_totais()
	if total > DadosJogo.recorde:
		DadosJogo.recorde = total
		$MSG_INI/Control/Recorde.text = "RECORDE: " + str(DadosJogo.recorde)
		return true
	return false


func ajustar_dificuldade():
	dificuldade = mini(int(score / SPEED_MODIFIER), MAX_DIFICULDADE)


func finalizar_partida():
	if finalizando_partida:
		return
	finalizando_partida = true
	game_running = false

	var novo_recorde := checar_recorde()

	# Espera a animação de morte terminar
	await $Menino.morrer()

	# Tela de game over (CanvasLayer): voltar ao menu ou abrir a loja
	var tela = game_over_cena.instantiate()
	add_child(tela)
	tela.configurar(pontos_totais(), DadosJogo.recorde, DadosJogo.moedas - moedas_inicio, novo_recorde)
