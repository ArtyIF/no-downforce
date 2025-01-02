extends RichTextLabel

func _ready() -> void:
	meta_clicked.connect(on_meta_clicked)
	set_deferred("text", "Version %s\nChecking updates..." % ProjectSettings.get_setting("application/config/version"))

	if not OS.has_feature("editor"):
		var platform: String = ""
		if OS.has_feature("linuxbsd"):
			platform = "linux"
		elif OS.has_feature("windows"):
			platform = "win"
		elif OS.has_feature("web"):
			set_deferred("text", "Version %s\nDownload the standalone version below for a smoother experience!" % ProjectSettings.get_setting("application/config/version"))
			return

		var req: HTTPRequest = $VersionRequest
		req.request_completed.connect(update_check)
		req.request("https://itch.io/api/1/x/wharf/latest?game_id=3159377&channel_name=%s-x64" % platform)
	else:
		set_deferred("text", "Version %s\nRunning from editor" % ProjectSettings.get_setting("application/config/version"))

func update_check(result, response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS and response_code < 400:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var version = json["latest"]
		if version == ProjectSettings.get_setting("application/config/version"):
			set_deferred("text", "Version %s\nUp to date" % ProjectSettings.get_setting("application/config/version"))
		else:
			set_deferred("text", "Version %s\nNew version available! %s\nUpdate now: [url]https://artyif.itch.io/no-downforce[/url]" % [ProjectSettings.get_setting("application/config/version"), version])
	else:
		set_deferred("text", "Version %s\nUpdate check failed!" % ProjectSettings.get_setting("application/config/version"))

func on_meta_clicked(meta):
	OS.shell_open(str(meta))
