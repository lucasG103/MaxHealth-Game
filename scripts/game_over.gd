extends CanvasLayer

# Tela de fim de jogo: voltar ao menu ou abrir a loja.
# É um CanvasLayer para aparecer sempre na tela, mesmo com a câmera do jogo andando.

@onready var lbl_pontos: Label = $Raiz/Centro/Caixa/Pontos
@onready var lbl_recorde: Label = $Raiz/Centro/Caixa/Recorde
@onready var lbl_moedas: Label = $Raiz/Centro/Caixa/Moedas
@onready var btn_menu: Button = $Raiz/Centro/Caixa/BotaoMenu
@onready var btn_loja: Button = $Raiz/Centro/Caixa/BotaoLoja


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	btn_menu.pressed.connect(_on_menu_pressed)
	btn_loja.pressed.connect(_on_loja_pressed)

	# Evita apertar um botão sem querer (o jogador pode estar apertando espaço/enter)
	btn_menu.disabled = true
	btn_loja.disabled = true
	await get_tree().create_timer(0.6).timeout
	btn_menu.disabled = false
	btn_loja.disabled = false
	btn_menu.grab_focus()


func configurar(pontos: int, recorde: int, moedas_ganhas: int, novo_recorde: bool) -> void:
	lbl_pontos.text = "PONTOS: " + str(pontos)
	lbl_recorde.text = ("NOVO RECORDE: " if novo_recorde else "RECORDE: ") + str(recorde)
	lbl_moedas.text = "MOEDAS GANHAS: +" + str(moedas_ganhas)


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/Menu.tscn")


func _on_loja_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/loja.tscn")
