extends Node

@onready var hud = $Player/Camera2D/HUD_Canvas/HUD/VBoxContainer/ScoreLabel

var score: int = 0
var http: HTTPRequest

func _ready():
	Global.score_updated.connect(_on_score_updated)

	# Check if HTTPRequest node exists in the scene
	http = get_node_or_null("HTTPRequest")
	
	if http == null:
		print("❌ HTTPRequest node is missing from the scene! Creating one.")
		http = HTTPRequest.new()
		add_child(http)
	
	if not http.request_completed.is_connected(_on_request_completed):
		http.request_completed.connect(_on_request_completed)
	
	# Send the score to the server
	send_score_to_server()
	
func _on_score_updated(new_score: int):
	if hud:
		hud.update_score(new_score)

func send_score_to_server():
	if http == null:
		print("❌ HTTPRequest is not initialized!")
		return

	var url = "http://localhost/GameWebsite/update_score.php"
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var data = "score=" + str(score)

	var error = http.request(url, headers, HTTPClient.METHOD_POST, data)
	if error != OK:
		print("❌ Failed to send request: ", error)

func _on_request_completed(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("🔄 Server Response:", response_text)

	var response = JSON.parse_string(response_text)  # ✅ Fixed JSON parsing
	if response and response.has("status") and response["status"] == "success":
		print("✅ Score updated successfully on the server!")
