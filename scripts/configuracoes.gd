extends Control

# Tela de configurações: volume da música, volume dos efeitos e lista de controles.

@onready var slider_musica: HSlider = $Centro/Caixa/LinhaMusica/Slider
@onready var valor_musica: Label = $Centro/Caixa/LinhaMusica/Valor
@onready var slider_sfx: HSlider = $Centro/Caixa/LinhaSfx/Slider
@onready var valor_sfx: Label = $Centro/Caixa/LinhaSfx/Valor
@onready var btn_voltar: Button = $Centro/Caixa/Voltar


func _ready():
	DadosJogo.tocar_musica_menu()

	slider_musica.value = roundf(DadosJogo.volume_musica * 100.0)
	slider_sfx.value = roundf(DadosJogo.volume_sfx * 100.0)
	_atualizar_textos()

	slider_musica.value_changed.connect(_on_musica_mudou)
	slider_sfx.value_changed.connect(_on_sfx_mudou)
	# ao soltar o controle de efeitos, toca um som de exemplo
	slider_sfx.drag_ended.connect(func(_mudou): DadosJogo.tocar_sfx("bom"))
	btn_voltar.pressed.connect(_voltar)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_voltar()


func _on_musica_mudou(v: float):
	DadosJogo.volume_musica = v / 100.0
	DadosJogo.aplicar_volumes()
	_atualizar_textos()


func _on_sfx_mudou(v: float):
	DadosJogo.volume_sfx = v / 100.0
	DadosJogo.aplicar_volumes()
	_atualizar_textos()


func _atualizar_textos():
	valor_musica.text = "%d%%" % int(slider_musica.value)
	valor_sfx.text = "%d%%" % int(slider_sfx.value)


func _voltar():
	DadosJogo.salvar_config()
	get_tree().change_scene_to_file("res://cenas/Menu.tscn")
