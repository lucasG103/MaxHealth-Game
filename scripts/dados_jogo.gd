extends Node

# ---------------------------------------------------------------
# Dados globais (autoload "DadosJogo")
# ---------------------------------------------------------------

signal moedas_mudaram

const XP_POR_MOEDA : int = 100   # GDD: 100 XP = 1 moeda

# Saldo global de moedas
var moedas : int = 0
# Maior pontuação já feita (em pontos exibidos na tela)
var recorde : int = 0
# XP acumulado que ainda não virou moeda (sempre < 100)
var xp : int = 0

# Volumes (0.0 a 1.0), salvos em user://config.cfg
var volume_musica : float = 0.8
var volume_sfx : float = 0.8
const ARQUIVO_CONFIG : String = "user://config.cfg"
const MUSICA_MENU : String = "res://audios/menu.ogg"
var _player_menu : AudioStreamPlayer
var _quer_musica_menu : bool = false

# Itens da loja. São consumíveis: "quantidade" é quanto o jogador
# tem guardado para usar durante a corrida.
var itens := {
	"item_1": {"nome": "Maçã Dourada",      "preco": 50, "quantidade": 0},
	"item_2": {"nome": "Escudo de Proteção", "preco": 25, "quantidade": 0},
	"item_3": {"nome": "Relógio do Tempo",   "preco": 10, "quantidade": 0},
}


func _ready() -> void:
	_registrar_atalhos()
	_carregar_config()


# Ganha XP e converte automaticamente em moedas (100 XP = 1 moeda)
func adicionar_xp(qtd: int) -> void:
	xp += qtd
	while xp >= XP_POR_MOEDA:
		xp -= XP_POR_MOEDA
		moedas += 1
	moedas_mudaram.emit()


# Teclas de atalho para usar os itens (1, 2, 3) e extras de movimento (W / S)
func _registrar_atalhos() -> void:
	var teclas := {
		"usar_item_1": [KEY_1, KEY_KP_1],
		"usar_item_2": [KEY_2, KEY_KP_2],
		"usar_item_3": [KEY_3, KEY_KP_3],
	}
	for acao in teclas:
		if not InputMap.has_action(acao):
			InputMap.add_action(acao)
		for tecla in teclas[acao]:
			_adicionar_tecla(acao, tecla)

	_adicionar_tecla("ui_up", KEY_W)
	_adicionar_tecla("ui_down", KEY_S)


func _adicionar_tecla(acao: String, tecla: Key) -> void:
	var ev := InputEventKey.new()
	ev.physical_keycode = tecla
	InputMap.action_add_event(acao, ev)


# ---------------------------------------------------------------
# Áudio. O volume é aplicado direto em cada player (volume_db), sem barramentos
# criados por código, porque eles não funcionam no modo de áudio "Sample" do
# export Web sem threads.
# ---------------------------------------------------------------
func _db(valor: float) -> float:
	return -80.0 if valor <= 0.001 else linear_to_db(valor)


func volume_musica_db() -> float:
	return _db(volume_musica)


# Chamada quando um slider muda: atualiza a música que estiver tocando
func aplicar_volumes() -> void:
	if _player_menu != null:
		_player_menu.volume_db = volume_musica_db()


func salvar_config() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "musica", volume_musica)
	cfg.set_value("audio", "sfx", volume_sfx)
	cfg.save(ARQUIVO_CONFIG)


func _carregar_config() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(ARQUIVO_CONFIG) == OK:
		volume_musica = clampf(float(cfg.get_value("audio", "musica", 0.8)), 0.0, 1.0)
		volume_sfx = clampf(float(cfg.get_value("audio", "sfx", 0.8)), 0.0, 1.0)


# Música do menu/configurações: toca em loop e continua ao trocar entre as duas telas
func tocar_musica_menu() -> void:
	_quer_musica_menu = true
	if _player_menu == null:
		if not ResourceLoader.exists(MUSICA_MENU):
			push_warning("Música do menu não encontrada: " + MUSICA_MENU)
			return
		_player_menu = AudioStreamPlayer.new()
		_player_menu.stream = load(MUSICA_MENU)
		ativar_loop(_player_menu.stream)
		add_child(_player_menu)
	_player_menu.volume_db = volume_musica_db()
	if not _player_menu.playing:
		_player_menu.play()


func parar_musica_menu() -> void:
	_quer_musica_menu = false
	if _player_menu != null:
		_player_menu.stop()


# Navegadores só liberam o áudio depois de um clique/tecla: se a música do menu
# ainda não começou, tenta de novo na primeira interação do jogador.
func _input(event: InputEvent) -> void:
	if not _quer_musica_menu or _player_menu == null or _player_menu.playing:
		return
	if (event is InputEventMouseButton or event is InputEventKey) and event.is_pressed():
		_player_menu.play()


# Liga o loop em um áudio (mp3/ogg/wav) sem precisar mexer na importação
func ativar_loop(stream: AudioStream) -> void:
	if stream is AudioStreamMP3 or stream is AudioStreamOggVorbis:
		stream.loop = true


# Efeito sonoro simples. Ignora se o arquivo não existir.
func tocar_sfx(nome: String) -> void:
	var caminho := "res://audios/sfx_%s.wav" % nome
	if not ResourceLoader.exists(caminho):
		return
	var p := AudioStreamPlayer.new()
	p.stream = load(caminho)
	p.volume_db = _db(volume_sfx)
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()
