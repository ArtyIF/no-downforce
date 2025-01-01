extends ScrollContainer

var scroll_amount: float = 0.0
var pause_for: float = 0.0

var copyright_info: Dictionary[String, Array] = {
	"Sounds": [
		{
			"name": "Chrysler LHS tire squeal 04 (04-25-2009).wav",
			"source": "https://freesound.org/s/71739/",
			"copyright": ["2009 audible-edge"],
			"license": "CC0-1.0",
			"changes_made": "Trimmed and looped, EQd to remove engine noise, converted to OGG",
		},
		{
			"name": "Collision 1",
			"source": "https://freesound.org/s/446126/",
			"copyright": ["2018 JustInvoke"],
			"license": "CC-BY-4.0",
			"changes_made": "Converted to OGG",
		},
		{
			"name": "Collision 2",
			"source": "https://freesound.org/s/446125/",
			"copyright": ["2018 JustInvoke"],
			"license": "CC-BY-4.0",
			"changes_made": "Converted to OGG",
		},
		{
			"name": "Collision 3",
			"source": "https://freesound.org/s/446132/",
			"copyright": ["2018 JustInvoke"],
			"license": "CC-BY-4.0",
			"changes_made": "Converted to OGG",
		},
		{
			"name": "Car Land/Hit",
			"source": "https://freesound.org/s/446135/",
			"copyright": ["2018 JustInvoke"],
			"license": "CC-BY-4.0",
			"changes_made": "Converted to OGG",
		},
		{
			"name": "metal plate scratch",
			"source": "https://freesound.org/s/707639/",
			"copyright": ["2023 Ridderick"],
			"license": "CC0-1.0",
			"changes_made": "Trimmed and looped, converted to OGG",
		},
		{
			"name": "Hurricane Ophelia - Youghal, Co. Cork, Ireland - 16th October 2017 (2)",
			"source": "https://freesound.org/s/404946/",
			"copyright": ["2017 midaza.com"],
			"license": "CC-BY-4.0",
			"changes_made": "Trimmed and looped, converted to OGG",
		},
		{
			"name": "Car Brakes sqeak screech squeal stop.wav",
			"source": "https://freesound.org/s/456764/",
			"copyright": ["2019 WavJunction.com"],
			"license": "CC0-1.0",
			"changes_made": "Trimmed and looped, converted to OGG",
		},
		{
			"name": "Universal UI/Menu Soundpack",
			"source": "https://cyrex-studios.itch.io/universal-ui-soundpack",
			"copyright": ["2021-2024 Cyrex Studios"],
			"license": "CC-BY-4.0",
			"changes_made": "Trimmed",
		},
		{
			"name": "Interface SFX Pack 1",
			"source": "https://obsydianx.itch.io/interface-sfx-pack-1",
			"copyright": ["2016-2023 ObsydianX"],
			"license": "CC0-1.0",
		},
		{
			"name": ".esc files used to generate engine files with enginesound",
			"source": "https://github.com/DasEtwas/enginesound",
			"copyright": ["2019-2023 DasEtwas"],
			"license": "MIT/Expat",
		},
	],
	"Textures": [
		{
			"name": "WispySmoke01",
			"source": "https://unity.com/blog/engine-platform/free-vfx-image-sequences-flipbooks",
			"copyright": ["2016 Unity Labs Paris"],
			"license": "CC0-1.0",
		},
	],
	"Fonts": [
		{
			"name": "MatrixType",
			"source": "https://ggbot.itch.io/matrixtype-font-family",
			"copyright": ["2024 GGBotNet"],
			"license": "CC0-1.0",
		},
		{
			"name": "Qaz",
			"source": "https://ggbot.itch.io/qaz-font",
			"copyright": ["2022-2024 GGBotNet"],
			"license": "OFL-1.1",
		},
	],
	"Models": [
		{
			"name": "Car Kit",
			"source": "https://kenney.nl/assets/car-kit",
			"copyright": ["2022-2024 Kenney"],
			"license": "CC0-1.0",
		},
	],
	"Code": [
		{
			"name": "Arty's Arcadey Car Controller",
			"source": "https://github.com/ArtyIF/aacc",
			"copyright": ["2024-2025 ArtyIF"],
			"license": "MIT/Expat",
		},
		{
			"name": "Trail Renderer",
			"source": "https://github.com/Hyrdaboo/TrailRenderer",
			"copyright": ["2024 Hydraboo"],
			"license": "MIT/Expat",
		},
	],
}

var license_scroll_lines: Dictionary[String, int] = {}

func convert_copyright_info_to_string() -> String:
	var result: String = ""
	for copyright_type in copyright_info:
		result += "\n[color=#ff6000]%s[/color]" % copyright_type
		for copyright in copyright_info[copyright_type]:
			result += convert_copyright_dict_to_string(copyright).indent("\t")
	return result

func get_copyright_string(copyright_array: Array, indent_prefix: String = "") -> String:
	if len(copyright_array) > 1:
		return "\n" + "\n".join(copyright_array).indent(indent_prefix)
	return copyright_array[0]

func convert_copyright_dict_to_string(copyright: Dictionary) -> String:
	var result: String = ""
	result += "\n[color=#ff6000]%s[/color]" % copyright["name"]

	if copyright.has("parts"):
		for part in copyright["parts"]:
			if part["files"][0] != "*":
				result += "\n\t[color=#ff6000]Files[/color]\n\t\t"
				result += "\n\t\t".join(part["files"])
			result += "\n\t[color=#ff6000]Copyright[/color] "
			result += get_copyright_string(part["copyright"], "\t\t")
			result += "\n\t[color=#ff6000]License[/color] %s" % part["license"]

	if copyright.has("source"):
		result += "\n\t[color=#ff6000]Source[/color] [url]%s[/url]" % copyright["source"]
	if copyright.has("copyright"):
		result += "\n\t[color=#ff6000]Copyright[/color] "
		result += get_copyright_string(copyright["copyright"], "\t\t")
	if copyright.has("license"):
		result += "\n\t[color=#ff6000]License[/color] [url]%s[/url]" % copyright["license"]
	if copyright.has("changes_made"):
		result += "\n\t[color=#ff6000]Changes made[/color] [url]%s[/url]" % copyright["changes_made"]

	return result + "\n"

@onready var _text: String = $VBox/CreditsLabel.text

func append_text(text: String):
	$VBox/CreditsLabel.append_text(text)
	_text += text

func _ready() -> void:
	gui_input.connect(on_gui_input)
	$VBox/CreditsLabel.meta_clicked.connect(on_meta_clicked)
	
	append_text("\n[color=#ff6000]Third-party assets[/color]")
	append_text(convert_copyright_info_to_string().indent("\t"))
	
	append_text("\n[color=#ff6000]Engine and its third-party libraries[/color]")
	var engine_copyright_info: Array[Dictionary] = Engine.get_copyright_info()
	var license_info: Dictionary = Engine.get_license_info()
	for library in engine_copyright_info:
		append_text(convert_copyright_dict_to_string(library).indent("\t"))
	
	append_text("\n[color=#ff6000]Licenses[/color]")
	for license in license_info.keys():
		append_text("\n\t[color=#ff6000]%s[/color]\n" % license)
		license_scroll_lines[license] = _text.get_slice_count("\n") - 2
		append_text(license_info[license].indent("\t\t"))

func _process(delta: float) -> void:
	if is_visible_in_tree():
		if pause_for <= 0.0:
			scroll_amount += delta * 40.0
		else:
			scroll_amount = scroll_vertical
			pause_for -= delta
	else:
		scroll_amount = 0
	scroll_vertical = int(scroll_amount)

func on_gui_input(event: InputEvent):
	if event is not InputEventMouseMotion:
		pause_for = 1.0

func on_meta_clicked(meta):
	if meta.begins_with("http"):
		OS.shell_open(str(meta))
	else:
		if meta == "MIT/Expat":
			meta = "Expat"
		if license_scroll_lines.has(meta):
			scroll_vertical = 535 + int($VBox/CreditsLabel.get_line_offset(license_scroll_lines[meta]))
