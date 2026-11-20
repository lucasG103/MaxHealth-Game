extends Area2D

# Item que aparece no caminho. Pode ser bom (saudável) ou ruim (prejudicial).

const TAMANHO_ALVO: float = 56.0   # tamanho (px) na tela, independente do tamanho do sprite

var bom: bool = true
var coletado: bool = false
var _fase: float = randf() * TAU


func configurar(textura: Texture2D, eh_bom: bool) -> void:
	bom = eh_bom
	$Sprite2D.texture = textura
	var maior: float = maxf(textura.get_width(), textura.get_height())
	if maior > 0.0:
		$Sprite2D.scale = Vector2.ONE * (TAMANHO_ALVO / maior)


func _process(_delta: float) -> void:
	# flutuação leve para chamar atenção
	$Sprite2D.position.y = sin(Time.get_ticks_msec() / 220.0 + _fase) * 4.0
