extends Node3D

# 7x7
var calendar_labels = []

func init(w :float, h:float)->void:
	init_calendar(w/4,h/4)

func init_calendar(w :float, h :float)->void:
	# prepare calendar
	for i in range(7): # week title + 6 week
		var ln = []
		for j in Global3d.weekdaystring.size():
			var co = Global3d.colors.weekday[j]
			var mat = MatCache.get_color_mat(co)
			var lb = new_text(h*2, mat, Global3d.weekdaystring[j])
			lb.rotation.x = deg2rad(-90)
			#t.rotation.y = deg2rad(90)
			lb.rotation.z = deg2rad(-90)
			lb.position = Vector3(i*h -3*h , 0, j*w-4*w)
			ln.append(lb)
			add_child(lb)
		calendar_labels.append(ln)


func new_text(h :float, mat :Material, text :String)->MeshInstance3D:
	var mesh = TextMesh.new()
	mesh.depth = h / 30
	mesh.pixel_size = h / 50
	mesh.font_size = h
	mesh.text = text
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

func deg2rad(deg :float) ->float :
	return deg * 2 * PI / 360
