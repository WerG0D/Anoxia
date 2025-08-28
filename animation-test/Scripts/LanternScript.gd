extends AnimatedSprite2D
#Animação está rodando(true) ou não(false)
#Acho q seria util colocar essa var num arquivo global
var lantern_animation = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("use_item"):
		TurnOnOff(lantern_animation)

func TurnOnOff (state):
	#Liga
	if !state:
		lantern_animation = true
		#Animação de aquecimento no começo, quando essa acabar trigga _on_animation_finished
		play("Heating")
	#Desliga
	if state: 
		lantern_animation = false
		#Setta pra animação inicial e pausa
		play("Heating")
		pause()
		#Garante que a animação n fique pausada em frame errado
		frame = 0

#Isso faz a transição da animação de heating->lantern
func _on_animation_finished() -> void:
	play("Lantern")

#Isso faz a lanterna falhar em um intervalo de tempo aleatório
func _on_timer_timeout() -> void:
	if lantern_animation:
		var rng = RandomNumberGenerator.new()
		var timeRNG = rng.randf_range(5.0,10.0)
		var frameRNG = rng.randi_range(0,4)
		var timer = $Timer
		
		play("Heating")
		frame = frameRNG
		timer.start(timeRNG)
