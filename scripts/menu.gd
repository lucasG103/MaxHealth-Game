extends Control

func _ready():
	$play_btn.pressed.connect(_on_play_pressed)
	$config_btn.pressed.connect(_on_config_pressed)
	$quit_btn.pressed.connect(_on_quit_pressed)
	DadosJogo.tocar_musica_menu()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://cenas/jogo.tscn")


func _on_config_pressed():
	get_tree().change_scene_to_file("res://cenas/configuracoes.tscn")


func _on_quit_pressed():
	if OS.has_feature("web"):
		# No navegador, get_tree().quit() não fecha a aba. Tentamos fechar com JavaScript;
		# se o navegador bloquear (acontece quando a aba não foi aberta por script),
		# a página é trocada por uma tela em branco.
		JavaScriptBridge.eval("window.close();")
		JavaScriptBridge.eval("setTimeout(function(){ window.location.replace('about:blank'); }, 250);")
	get_tree().quit()
