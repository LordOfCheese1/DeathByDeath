extends Node2D


var credits = [
	"DEATH_BY_DEATH,,,,CREDITS",
	"A_GAME_BY,,KAESELORD",
	"SOUNDTRACK,,WOLFGANG_AMADEUS_MOZART,ERIC_ALFRED_LESLIE_SATIE,JOHANNES_BRAHMS,LUDWIG_VAN_BEETHOVEN",
	"GAME_IDEAS,,PIELLOW,ZLAGO,YUMAIKAS",
	"LEVEL_DESIGN_SUPPORT,,YUMAIKAS,PIELLOW",
	"SOUND_DESIGN_HELP,,PIELLOW,ZLAGO",
	"PLAYTESTING,,CAPNSKITTY,PIELLOW,DRAGONHAIRBRINGER",
	"RIVAL_FOR_MOTIVATION,,PIELLOW,AND_MAYBE_ZLAGO",
	"SPECIAL_THANKS_TO,,FALCON_NOVA,PIELLOW,ZLAGO,CAPNSKITTY,YUMAIKAS,KKAIROS_THE_CHEESE_MAN,LUCKY_CLOVER_DEV",
	"AND_OF_COURSE,,,THANK_YOU_FOR_PLAYING;"
]
var current_text = 0


func _ready():
	$CreditsText.change_text(credits[current_text], 0.02)

func _physics_process(delta):
	$CreditsText.position.y += 0.4
	if $CreditsText.position.y > 212:
		if current_text < len(credits) - 1:
			$CreditsText.position.y = -4
			current_text += 1
			$CreditsText.change_text(credits[current_text], 0.02)
		else:
			$CanvasLayer/AnimationPlayer.play("FadeIn")
			yield(get_tree().create_timer(0.5, false), "timeout")
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
