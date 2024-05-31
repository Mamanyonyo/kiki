class_name SoundManager extends Node

func play(sfx):
	var sound_node = get_node(sfx) as AudioStreamPlayer
	sound_node.play()
	
func play_if_not_playing(sfx):
	var sound_node = get_node(sfx) as AudioStreamPlayer
	if !sound_node.playing: sound_node.play()
