extends AudioStreamPlayer

@export var beep_low: AudioStream
@export var beep_high: AudioStream
@export var pop: AudioStream
@export var vending: AudioStream
@export var whistle: AudioStream
@export var kick: AudioStream
@export var cardflip: AudioStream
@export var cardmany: AudioStream
@export var tada: AudioStream
@export var cash: AudioStream
@export var airhorn: AudioStream
@export var keypress: AudioStream
@export var boing: AudioStream

func play_unique(s: AudioStream, vol: float = 0.0):
	if s == null:
		return
	var p = AudioStreamPlayer.new()
	p.stream = s
	p.volume_db = vol
	add_child(p)
	p.connect("finished", p.queue_free)
	p.play()

func play_countdown_beep():
	stream = beep_low
	play()
	
func play_final_beep():
	stream = beep_high
	play()

func play_pop():
	stream = pop
	play()
	
func play_vending():
	stream = vending
	play()

func play_whistle():
	stream = whistle
	play()

func play_kick():
	stream = kick
	play()

func play_cardflip():
	stream = cardflip
	play()

func play_cardmany():
	stream = cardmany
	play()
	
func play_tada():
	stream = tada
	play()
	
func play_cash():
	stream = cash
	play()
	
@export var wind: AudioStream
func play_wind():
	stream = wind
	play()
	
@export var aww: AudioStream
func play_aww():
	stream = aww
	play()
	
