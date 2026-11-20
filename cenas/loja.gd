extends Control

# Loja: itens consumíveis. Cada compra adiciona 1 unidade ao estoque do jogador,
# que usa os itens durante a corrida pelos botões da HUD (ou teclas 1, 2, 3).

@onready var label_moedas = $MoedasLabel
@onready var btn_sair = $BotaoVoltar
@onready var botoes := {
	"item_1": $GridContainer/Item1/Button,
	"item_2": $GridContainer/Item2/Button,
	"item_3": $GridContainer/Item3/Button,
}

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

	for id in botoes:
		botoes[id].pressed.connect(tentar_comprar.bind(id))

	btn_sair.text = "Voltar ao Menu"
	btn_sair.pressed.connect(_on_voltar_pressed)
	atualizar_interface()

func atualizar_interface():
	label_moedas.text = "MOEDAS: " + str(DadosJogo.moedas)
	for id in botoes:
		var item = DadosJogo.itens[id]
		botoes[id].text = "Comprar - %d moedas (tem: %d)" % [item["preco"], item["quantidade"]]
		botoes[id].disabled = DadosJogo.moedas < item["preco"]

func tentar_comprar(id_item: String):
	var item = DadosJogo.itens[id_item]
	if DadosJogo.moedas >= item["preco"]:
		DadosJogo.moedas -= item["preco"]
		item["quantidade"] += 1
		atualizar_interface()

func _on_voltar_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/Menu.tscn")
