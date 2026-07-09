extends RefCounted

const SAVE_PATH := "user://keep_driving_profile_v0.json"

static func default_profile() -> Dictionary:
	return {
		"scrap": 0,
		"upgrades": {
			"fuel_tank": 0,
			"armor": 0,
			"engine": 0,
		},
		"best_miles": 0.0,
		"runs": 0,
	}

static func load_profile() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return default_profile()
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return default_profile()
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return default_profile()
	var profile:Dictionary = parsed
	var defaults := default_profile()
	for key in defaults.keys():
		if not profile.has(key):
			profile[key] = defaults[key]
	if typeof(profile.get("upgrades")) != TYPE_DICTIONARY:
		profile["upgrades"] = defaults["upgrades"]
	for key in defaults["upgrades"].keys():
		if not profile["upgrades"].has(key):
			profile["upgrades"][key] = 0
	return profile

static func save_profile(profile:Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(profile, "\t"))
