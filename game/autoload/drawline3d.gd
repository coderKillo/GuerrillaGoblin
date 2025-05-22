extends Node2D


class Line:
	var Start
	var End
	var LineColor
	var time

	func _init(Start, End, LineColor, time):
		self.Start = Start
		self.End = End
		self.LineColor = LineColor
		self.time = time


var Lines = []
var RemovedLine = false


func _process(delta):
	for i in range(len(Lines)):
		Lines[i].time -= delta

	if len(Lines) > 0 || RemovedLine:
		queue_redraw()  #Calls _draw
		RemovedLine = false


func _draw():
	var Cam = get_viewport().get_camera_3d()
	for i in range(len(Lines)):
		var ScreenPointStart = Cam.unproject_position(Lines[i].Start)
		var ScreenPointEnd = Cam.unproject_position(Lines[i].End)

		#Dont draw line if either start or end is considered behind the camera
		#this causes the line to not be drawn sometimes but avoids a bug where the
		#line is drawn incorrectly
		if Cam.is_position_behind(Lines[i].Start) || Cam.is_position_behind(Lines[i].End):
			continue

		draw_line(ScreenPointStart, ScreenPointEnd, Lines[i].LineColor, 3.0)

	#Remove lines that have timed out
	var i = Lines.size() - 1
	while i >= 0:
		if Lines[i].time < 0.0:
			Lines.remove_at(i)
			RemovedLine = true
		i -= 1


func DrawLine(Start, End, LineColor, time = 0.0):
	Lines.append(Line.new(Start, End, LineColor, time))


func DrawRay(Start, Ray, LineColor, time = 0.0):
	Lines.append(Line.new(Start, Start + Ray, LineColor, time))


func DrawCube(Center, HalfExtents, LineColor, time = 0.0):
	#Start at the 'top left'
	var LinePointStart = Center
	LinePointStart.x -= HalfExtents
	LinePointStart.y += HalfExtents
	LinePointStart.z -= HalfExtents

	#Draw top square
	var LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)

	#Draw bottom square
	LinePointStart = LinePointEnd + Vector3(0, -HalfExtents * 2.0, 0)
	LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time)

	#Draw vertical lines
	LinePointStart = LinePointEnd
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
	LinePointStart += Vector3(0, 0, HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
	LinePointStart += Vector3(HalfExtents * 2.0, 0, 0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
	LinePointStart += Vector3(0, 0, -HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)


func DrawTrajectory(Start, End, LineColor, time = 0.0):
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	var flight_time = 1.0
	var displacement = End - Start
	var max_points = 50
	var delta = flight_time / max_points

	var velocity = Vector3(
		displacement.x / flight_time,
		(displacement.y / flight_time) + 0.5 * gravity * flight_time,
		displacement.z / flight_time
	)
	var point = Start
	var prev_point = Start
	for i in max_points:
		velocity.y -= gravity * delta
		point += velocity * delta
		Drawline3d.DrawLine(point, prev_point, LineColor, time)
		prev_point = point
