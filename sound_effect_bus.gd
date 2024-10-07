extends AudioStreamPlayer

@export var beep_low: AudioStream
@export var beep_high: AudioStream
@export var pop: AudioStream
@export var vending: AudioStream
@export var whistle: AudioStream
@export var kick: AudioStream

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
