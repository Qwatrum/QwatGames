extends Panel

func set_arena_number(n):
	$"Arena".text = "Arena: "+str(n)

func set_arena_score(t):
	$"Score".text = "Best score:\n"+str(t)
