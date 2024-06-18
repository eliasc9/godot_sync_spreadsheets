@tool
extends Node
class_name HTTP

const HEADER = ["Content-Type: application/json; charset=UTF-8"]


func req(url: String, ## url ended in /
		callback: Callable, ## callback(response : Dictionary)
		method : HTTPClient.Method = HTTPClient.METHOD_GET,
		query: Dictionary = {},
		body: Dictionary = {},
		headers : Array = HEADER,
		path : String = ""):
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(func(r,c,h,b): _req_completed(r,c,h,b, callback))
	
	var QUERY = "?" + "&".join(query.keys().map(func(k): return k.uri_encode() + "=" + str(query[k]).uri_encode()))
	var error: Error
	var body_str = JSON.new().stringify(body) if body else ""
	
	if path != "":
		http_request.set_download_file(path)
	error = http_request.request(url + QUERY, headers, method, body_str)
	if error != OK:
		push_error("An error occurred in the HTTP request. This should be not happened, is a code error!")
	else:
		pass # print("New HTTP request!")


func _req_completed(result, response_code, headers, body, callback: Callable):
	#print("REQ COMPLETED. result: " + str(result) + " response_code: " + str(response_code))
	var err = OK
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr("ERROR: You are OFFLINE")
		err = result
	elif response_code >= 400:
		printerr("ERROR: Request INVALID")
		err = response_code
	else:
		pass # printt("ONLINE")

	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	callback.call(response, err)
	
	if err != OK:
		printerr("ERROR response: ", response)
