extends Label

func _process(delta):
	if OS.is_debug_build():
		set_text("FPS %d" % Engine.get_frames_per_second())
