extends CanvasLayer

# HUD: barra de vida (25% vermelha / 75% verde com ponteiro), moedas e botões de itens.

signal item_pressionado(id: String)

const LARGURA_BARRA: float = 340.0

var botoes := {}
var _tween_ponteiro: Tween

@onready var ponteiro: ColorRect = $Raiz/BarraVida/Ponteiro
@onready var fundo_barra: ColorRect = $Raiz/BarraVida/Moldura
@onready var lbl_moedas: Label = $Raiz/Moedas
@onready var lbl_aviso: Label = $Raiz/Aviso


func _ready() -> void:
	botoes = {
		"item_1": $Raiz/Itens/BtnItem1,
		"item_2": $Raiz/Itens/BtnItem2,
		"item_3": $Raiz/Itens/BtnItem3,
	}
	for id in botoes:
		botoes[id].pressed.connect(func(): item_pressionado.emit(id))
	lbl_aviso.hide()
	set_vida(50.0, false)
	set_moedas(DadosJogo.moedas)


func _x_ponteiro(valor: float) -> float:
	return clampf(valor, 0.0, 100.0) / 100.0 * LARGURA_BARRA - ponteiro.size.x / 2.0


func set_vida(valor: float, animar: bool = true) -> void:
	if _tween_ponteiro:
		_tween_ponteiro.kill()
	if animar:
		_tween_ponteiro = create_tween()
		_tween_ponteiro.tween_property(ponteiro, "position:x", _x_ponteiro(valor), 0.15)
	else:
		ponteiro.position.x = _x_ponteiro(valor)


# Barra completa: ponteiro vai até o fim, brilha e volta para o meio
func barra_cheia() -> void:
	if _tween_ponteiro:
		_tween_ponteiro.kill()
	_tween_ponteiro = create_tween()
	_tween_ponteiro.tween_property(ponteiro, "position:x", _x_ponteiro(100.0), 0.12)
	_tween_ponteiro.tween_callback(func(): fundo_barra.color = Color(1, 0.9, 0.2))
	_tween_ponteiro.tween_interval(0.25)
	_tween_ponteiro.tween_callback(func(): fundo_barra.color = Color.BLACK)
	_tween_ponteiro.tween_property(ponteiro, "position:x", _x_ponteiro(50.0), 0.4)


func set_moedas(qtd: int) -> void:
	lbl_moedas.text = "MOEDAS: " + str(qtd)


# Atualiza um botão de item. restante > 0 mostra a contagem regressiva (relógio).
func atualizar_item(id: String, quantidade: int, ativo: bool, restante: float = 0.0) -> void:
	var btn: Button = botoes[id]
	var tecla: String = id.right(1)
	if ativo:
		var extra: String = ("%ds" % ceili(restante)) if restante > 0.0 else "ATIVO"
		btn.text = "[%s] %s" % [tecla, extra]
	else:
		btn.text = "[%s] x%d" % [tecla, quantidade]
	btn.disabled = ativo or quantidade <= 0


func mostrar_aviso(texto: String, cor: Color = Color.WHITE) -> void:
	lbl_aviso.text = texto
	lbl_aviso.add_theme_color_override("font_color", cor)
	lbl_aviso.modulate.a = 1.0
	lbl_aviso.show()
	var tw := create_tween()
	tw.tween_interval(1.0)
	tw.tween_property(lbl_aviso, "modulate:a", 0.0, 0.4)
	tw.tween_callback(lbl_aviso.hide)
