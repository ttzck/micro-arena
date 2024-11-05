extends Control

const rect_size := 32.0
@export var color1 : Color
@export var color2 : Color

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var view = get_viewport_rect().size
	for x in floori(view.x / rect_size) + 1:
		for y in floori(view.y / rect_size) + 1:
			var rect = Rect2(x * rect_size, y * rect_size, rect_size, rect_size)
			var c = color1 if (x + y) % 2 == 0 else color2
			draw_rect(rect, c, true, 0, false)
