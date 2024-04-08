extends CharacterBody2D

@export var direction : Vector2 = Vector2.UP
@export var speed : float = 150
var quotes = ["Beyond the days of being hurt, what awaits? SOULTKAER", "In the frozen world, a voice awakens the heart, resounding", "Shaking off the fear of loneliness from yesterday, into the whirlpool of the era", "What do I believe in now?", "What do I hold close to my heart as I run?", "The soul's scream kicks away ambitions, proudly howl, SOULTAKER", "A single beam of light guiding the world", "Grasp the unvanishing dream with your own hands, SOULTAKER", "Somewhere in my memories, the gaze we met with remains in my heart", "In the tailwind, I chased after it with all my heart (Who was that beloved one?)", "That bond, stronger than anything", "That vow, I will never forget it no matter what happens", "The deep crimson knife that tears through the dark night", "A testament of tears, SOULTAKER", "These passionate feelings, conveyed to the future", "I'll wager everything and fight, SOULTAKER", "Beyond the days of being hurt, what are you looking at?", "The deep crimson knife that cuts through the dark night, a testament of tears, SOULTAKER", "These passionate feelings, conveyed to the future, risking everything, we fight, SOULTAKER", "The soul's scream that scatters ambitions, proudly roar, SOULTAKER", "Guiding the world, a single beam of light, grasp the unvanishing dream with your own hands, SOULTAKER", "https://lyricstranslate.com/en/soultaker-soultaker.html"]
var random : String
var index = 0

func _ready():
	random = quotes.pick_random() + "       " + quotes.pick_random() + "  " + quotes.pick_random()
	$RichTextLabel2.text = ""

func _process(delta):
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	$RichTextLabel2.text += random[index]
	if index != random.length()-1: index += 1

func _on_despawn_timeout():
	queue_free()
