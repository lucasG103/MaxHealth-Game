extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int = -1600
# Segurar S/seta para baixo no ar: gravidade extra (1.0 = gravidade total 2x, 2.0 = 3x...)
const QUEDA_RAPIDA_EXTRA: float = 1.0

# --- Deslizar ---
const TEMPO_MIN_SLIDE: float = 0.35     # mesmo com toque rápido, desliza por esse tempo
const TEMPO_MAX_SLIDE: float = 0.8      # limite: depois disso levanta, mesmo segurando a tecla
const ALTURA_SLIDE: float = 14.0        # altura da caixa de colisão deslizando (px locais)
const FRAME_DEITADO: int = 6            # frame em que o menino está deitado (fica parado nele)
const FRAME_LEVANTAR: int = 7           # frames 7 e 8 = levantando
# Área que coleta itens quando deitado (o corpo fica baixo para passar sob a placa,
# mas o sprite deitado é maior que ele). Em px locais.
const COLETA_SLIDE: Vector2 = Vector2(56.0, 35.0)

var morreu: bool = false
var deslizando: bool = false
var levantando: bool = false
var tempo_slide: float = 0.0
var tempo_deitado: float = 0.0
var _slide_bloqueado: bool = false   # depois do limite, só desliza de novo após soltar a tecla

# Efeitos de itens (o jogo.gd liga/desliga estes valores)
var com_maca: bool = false:
	set(v):
		if v and not com_maca:
			_maca_intro_ok = false
		com_maca = v
var com_escudo: bool = false
var com_relogio: bool = false
var _maca_intro_ok: bool = false

var _tamanho_em_pe: Vector2
var _pos_em_pe: Vector2
var _tween_cor: Tween
var _coleta_colisao: CollisionShape2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# Cada instância usa a sua própria forma de colisão (vamos alterar o tamanho no slide)
	colisao.shape = colisao.shape.duplicate()
	_tamanho_em_pe = colisao.shape.size
	_pos_em_pe = colisao.position
	_criar_area_coleta()

	var frames := sprite.sprite_frames
	# As animações de slide (normal e com cada item) tocam uma vez:
	# agacha, fica deitado e levanta
	for nome in ["slide", "slide_apple", "slide_shield", "slide_time"]:
		if frames.has_animation(nome):
			frames.set_animation_loop(nome, false)
			frames.set_animation_speed(nome, 24.0)
	# A animação "apple" original não repete; criamos uma versão em loop
	# (só os frames de corrida) para continuar depois da introdução.
	if not frames.has_animation("apple_loop"):
		frames.add_animation("apple_loop")
		frames.set_animation_loop("apple_loop", true)
		frames.set_animation_speed("apple_loop", frames.get_animation_speed("apple"))
		for i in range(6, frames.get_frame_count("apple")):
			frames.add_frame("apple_loop", frames.get_frame_texture("apple", i))

	sprite.animation_finished.connect(_on_animacao_terminou)
	sprite.frame_changed.connect(_on_frame_mudou)


func _physics_process(delta: float) -> void:
	if morreu:
		# Continua caindo até o chão se morrer no ar
		velocity.x = 0.0
		velocity.y += GRAVITY * delta
		move_and_slide()
		return

	var jogando: bool = get_parent().game_running
	var no_chao := is_on_floor()
	var quer_slide := Input.is_action_pressed("ui_down")
	if not quer_slide:
		_slide_bloqueado = false

	velocity.y += GRAVITY * delta
	# Queda rápida (como no jogo do dinossauro): S no ar faz voltar ao chão mais rápido
	if jogando and not no_chao and quer_slide:
		velocity.y += GRAVITY * QUEDA_RAPIDA_EXTRA * delta

	if jogando and no_chao:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_SPEED
			_parar_slide(false)
		else:
			if quer_slide and not deslizando and not _slide_bloqueado:
				_comecar_slide()
			if deslizando:
				tempo_slide -= delta
				tempo_deitado += delta
				if tempo_deitado >= TEMPO_MAX_SLIDE:
					# tempo máximo: levanta mesmo com a tecla apertada
					_slide_bloqueado = true
					_parar_slide(true)
				elif not quer_slide and tempo_slide <= 0.0:
					_parar_slide(true)
	elif deslizando:
		# saiu do chão (ex.: caiu de algum lugar): cancela o slide
		_parar_slide(false)

	# --- Escolha da animação ---
	if not jogando:
		if no_chao:
			_tocar("idle")
	elif not no_chao:
		levantando = false
		_tocar_variante(_anim_com_item("jump"))
	elif deslizando or levantando:
		# troca para a versão do item (ex.: usou o escudo durante o slide) mantendo o frame
		_tocar_variante(_anim_com_item("slide"))
	else:
		_tocar(_anim_corrida())

	move_and_slide()


# Animação de corrida conforme o item ativo (prioridade: escudo > relógio > maçã)
func _anim_corrida() -> StringName:
	if com_escudo:
		return &"shield"
	if com_relogio:
		return &"time"
	if com_maca:
		return &"apple_loop" if _maca_intro_ok else &"apple"
	return &"run"


func _tocar(nome: StringName) -> void:
	if sprite.animation != nome or not sprite.is_playing():
		sprite.play(nome)


# Nome da animação conforme o item ativo (mesma prioridade da corrida:
# escudo > relógio > maçã). Ex.: "jump" -> "jump_shield"; "slide" -> "slide_time".
func _anim_com_item(base: String) -> StringName:
	var nome := base
	if com_escudo:
		nome = base + "_shield"
	elif com_relogio:
		nome = base + "_time"
	elif com_maca:
		nome = base + "_apple"
	if sprite.sprite_frames.has_animation(nome):
		return StringName(nome)
	return StringName(base)


# Troca para outra versão da mesma animação (pulo/slide) mantendo a mesma pose.
# Compara a posição do frame dentro da imagem, porque as versões têm quantidades
# diferentes de frames.
func _tocar_variante(nome: StringName) -> void:
	if sprite.animation == nome:
		if not sprite.is_playing() and not (deslizando and sprite.frame >= FRAME_DEITADO):
			sprite.play(nome)
		return
	var frames := sprite.sprite_frames
	var pose := _pose_do_frame(frames, sprite.animation, sprite.frame)
	var novo_frame := 0
	for i in frames.get_frame_count(nome):
		if _pose_do_frame(frames, nome, i) == pose:
			novo_frame = i
			break
	sprite.play(nome)
	sprite.set_frame_and_progress(novo_frame, 0.0)
	if deslizando and sprite.frame >= FRAME_DEITADO:
		sprite.pause()


func _pose_do_frame(frames: SpriteFrames, anim: StringName, indice: int) -> int:
	var tex := frames.get_frame_texture(anim, indice)
	if tex is AtlasTexture:
		return int(tex.region.position.x / 64.0)
	return indice


# Área própria para coletar itens (acompanha o tamanho do corpo; deitado, usa o
# tamanho do sprite deitado para pegar itens baixos no caminho)
func _criar_area_coleta() -> void:
	var area := Area2D.new()
	area.name = "AreaColeta"
	_coleta_colisao = CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = _tamanho_em_pe
	_coleta_colisao.shape = forma
	_coleta_colisao.position = _pos_em_pe
	area.add_child(_coleta_colisao)
	add_child(area)


# --- Deslizar ----------------------------------------------------

func _comecar_slide() -> void:
	deslizando = true
	levantando = false
	tempo_slide = TEMPO_MIN_SLIDE
	tempo_deitado = 0.0
	# Caixa de colisão baixa: o fundo continua colado no chão
	var fundo: float = _pos_em_pe.y + _tamanho_em_pe.y / 2.0
	colisao.shape.size = Vector2(_tamanho_em_pe.x, ALTURA_SLIDE)
	colisao.position = Vector2(_pos_em_pe.x, fundo - ALTURA_SLIDE / 2.0)
	_coleta_colisao.shape.size = COLETA_SLIDE
	_coleta_colisao.position = Vector2(_pos_em_pe.x, fundo - COLETA_SLIDE.y / 2.0)
	sprite.play(_anim_com_item("slide"))


func _parar_slide(animar_levantada: bool) -> void:
	if not deslizando:
		return
	deslizando = false
	colisao.shape.size = _tamanho_em_pe
	colisao.position = _pos_em_pe
	_coleta_colisao.shape.size = _tamanho_em_pe
	_coleta_colisao.position = _pos_em_pe
	if animar_levantada:
		levantando = true
		sprite.play(_anim_com_item("slide"))
		sprite.set_frame_and_progress(FRAME_LEVANTAR, 0.0)
	else:
		levantando = false


func _on_frame_mudou() -> void:
	# Fica "deitado" enquanto o jogador segura a tecla
	if deslizando and String(sprite.animation).begins_with("slide") and sprite.frame >= FRAME_DEITADO:
		sprite.pause()
		sprite.set_frame_and_progress(FRAME_DEITADO, 0.0)


func _on_animacao_terminou() -> void:
	if String(sprite.animation).begins_with("slide"):
		levantando = false
	elif sprite.animation == &"apple":
		_maca_intro_ok = true


# --- Efeitos visuais ---------------------------------------------

# Pisca o sprite com uma cor (verde = item bom, vermelho = item ruim)
func piscar(cor: Color) -> void:
	if _tween_cor:
		_tween_cor.kill()
	sprite.modulate = cor
	_tween_cor = create_tween()
	_tween_cor.tween_property(sprite, "modulate", Color.WHITE, 0.35)


# Fica piscando (semitransparente) enquanto está invulnerável
func piscar_invulneravel(duracao: float) -> void:
	if _tween_cor:
		_tween_cor.kill()
	_tween_cor = create_tween()
	var voltas: int = maxi(1, int(duracao / 0.24))
	for i in voltas:
		_tween_cor.tween_property(sprite, "modulate:a", 0.35, 0.12)
		_tween_cor.tween_property(sprite, "modulate:a", 1.0, 0.12)
	_tween_cor.tween_callback(func(): sprite.modulate = Color.WHITE)


func morrer() -> void:
	if morreu:
		return

	morreu = true
	velocity = Vector2.ZERO
	if _tween_cor:
		_tween_cor.kill()
	sprite.modulate = Color.WHITE
	_parar_slide(false)

	sprite.play("die")
	await sprite.animation_finished

	sprite.stop()
	sprite.frame = sprite.sprite_frames.get_frame_count("die") - 1
