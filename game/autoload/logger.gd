class_name Logger


static func log(debug_name: String, debug: bool, msc: String):
	if not debug:
		return

	print(debug_name + ": " + msc)


static func create(debug_name: String, debug: bool) -> Callable:
	return func(msc: String): Logger.log(debug_name, debug, msc)
