extends Label

func _ready() -> void:
	text = "Version %s (Checking updates...)" % ProjectSettings.get_setting("application/config/version")

	if not OS.has_feature("editor"):
		var platform: String = ""
		if OS.has_feature("linuxbsd"):
			platform = "linux"
		elif OS.has_feature("windows"):
			platform = "win"

		var req: HTTPRequest = $VersionRequest
		req.request_completed.connect(update_check)
		req.request("https://itch.io/api/1/x/wharf/latest?game_id=3159377&channel_name=%s-x64" % platform)
	else:
		text = "Version %s (Running in editor, no update check)" % ProjectSettings.get_setting("application/config/version")

func update_check(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS and response_code < 400:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var version = json["latest"]
		if version == ProjectSettings.get_setting("application/config/version"):
			text = "Version %s (Up to date)" % ProjectSettings.get_setting("application/config/version")
		else:
			text = "Version %s (New version available! %s)\nDownload at https://artyif.itch.io/no-downforce" % [ProjectSettings.get_setting("application/config/version"), version]
	else:
		text = "Version %s (Update check failed!)" % ProjectSettings.get_setting("application/config/version")
