extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var numCookies = 30
var rowMax = 68
var temp
var cookies = []
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
var rng3 = RandomNumberGenerator.new()
var rng4 = RandomNumberGenerator.new()
var rng5 = RandomNumberGenerator.new()
var rng6 = RandomNumberGenerator.new()
var oddsMouse
var freshPress = false
var trialNum = 1
var saveOutput = []
var finalSaveOutput = []
var timeElapsedSinceGameStart = 0
var timeElapsedSinceLastLog = 0
var betted
var http_client
var dataString = {"filename": "", "filedata":""}
# dont know dont know IS 1 AND dont know then know IS 2
var configureGameType = 1
var gameType
var oddsArr = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
var tempOdd
var tempIndex

var normalColor = "ffad00"
var winColor = "ffffff"
var betColor = "fff500"
var loseColor = "ff2a00"
var characters = 'abcdefghijklmnopqrstuvwxyz'

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

# Called when the node enters the scene tree for the first time.
func _ready():
	if configureGameType == 1:
		gameType = 1
	elif configureGameType == 2:
		gameType = global.gameOverClicked + 1
	$"..".popup()
	for k in 30:
		rng6.randomize()
		tempIndex = rng6.randi_range(0, 29)
		tempOdd = oddsArr[k]
		oddsArr[k] = oddsArr[tempIndex]
		oddsArr[tempIndex] = tempOdd
	$"Button".set_action_mode(BaseButton.ACTION_MODE_BUTTON_RELEASE)
	spawnCookies(numCookies)
	saveOutput.append("timeStamp,numTrial,timeElapsedSinceGameStart,timeElapsedSinceLastLog,event/buttonClicked,gamblemouseType,cookieChange,totalCookies,amtBet,proportionBet,winLose,winnings")
	timeElapsedSinceLastLog = 0
	if gameType == 2:
		$"RichTextLabel".text = $"RichTextLabel".text + " of 30"
	http_client = HTTPClient.new()

func _make_post_request(url, data_to_send):
	var query = JSON.print(data_to_send)
	#var query = data_to_send
	var headers = ["Content-Type: application/json"]
	#http_client.connect_to_host("192.168.0.101", 8081)
	http_client.connect_to_host("https://maloneylabexperiments.hosting.nyu.edu")
	while(http_client.get_status() != 5):
		http_client.poll()
	http_client.poll()
	http_client.request(HTTPClient.METHOD_POST, url, headers, query)
	http_client.close()

func spawnCookies(howMany):
	var offset = 0
	for i in howMany: 
		temp = Sprite.new()
		temp.texture = load("res://cookie.png")
		temp.scale = Vector2(0.03, 0.03)
		temp.modulate = Color(normalColor)
		temp.name = generate_word(characters, 10)
		if i%rowMax == 0:
			offset = offset + 15
		temp.position = Vector2(10+15*(i%rowMax), 370+offset)
		cookies.append(temp)
		$".".add_child(cookies[i])

func deleteCookies(howMany):
	for i in howMany: 
		remove_child(cookies.pop_back())

func colorCookies(howMany, whatColor):
	for i in howMany: 
		cookies[numCookies-i-1].modulate = Color(whatColor)

func loseCookies():
	for i in (numCookies+betted): 
		if cookies[numCookies+betted-i-1].modulate == Color(betColor):
			cookies[numCookies+betted-i-1].modulate = Color(loseColor)

func resetCookies():
	var howMany = 0
	for i in cookies: 
		if i.modulate == Color(winColor):
			i.modulate = Color(normalColor)
		if i.modulate == Color(loseColor):
			howMany = howMany + 1
	for i in howMany: 
		remove_child(cookies.pop_back())

func resetCookiesOld():
	var howMany = 0
	for i in numCookies: 
		if cookies[numCookies-i-1].modulate == Color(winColor):
			cookies[numCookies-i-1].modulate = Color(normalColor)
	for i in (numCookies+betted): 
		if cookies[numCookies+betted-i-1].modulate == Color(loseColor):
			howMany = howMany + 1
	for i in howMany: 
		remove_child(cookies.pop_back())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsedSinceGameStart = timeElapsedSinceGameStart + delta
	timeElapsedSinceLastLog = timeElapsedSinceLastLog + delta
	
	

func _on_Button_pressed():
	if ($"Button".text == "Game Over!" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		$"RichTextLabel6".visible = false
		freshPress = false
		$"Sprite".visible = false
		$"Sprite2".visible = false
		$"Sprite3".visible = false
		$"Sprite4".visible = false
		$"Sprite5".visible = false
		$"Sprite6".visible = false
		$"RichTextLabel".visible = false
		$"RichTextLabel2".visible = false
		$"RichTextLabel5".visible = false
		$"RichTextLabel3".visible = false
		$"RichTextLabel4".visible = false
		$"Button".visible = false
		$"SpinBox".visible = false
		deleteCookies(numCookies)
		resetCookies()
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
		timeElapsedSinceLastLog = 0
		var datetime0 = OS.get_datetime()
		var filename_datetime0 = String(datetime0.year) +String(datetime0.month) +String(datetime0.day) +String(datetime0.hour) +String(datetime0.minute) +String(datetime0.second)
		dataString.filename = "dataFile_"+str(global.gameOverClicked+1)+"_"+global.IRBcode+"_"+filename_datetime0+".csv"
		#for line in saveOutput:
		#	finalSaveOutput.append(JSON.print(line+"\r\n"))
		#dataString.filedata = JSON.print(saveOutput)
		#dataString.filedata = JSON.print(finalSaveOutput)
		dataString.filedata = (saveOutput)
		_make_post_request("/record_result.php", dataString)
		if global.gameOverClicked == 0:
			global.gameOverClicked = global.gameOverClicked+1
			$"RichTextLabel3".text = "Now, you are going to play game 2, which is similar to game 1"
			$"RichTextLabel3".visible = true
			$"Button".text = "Game 2"
			$"Button".visible = true
		elif global.gameOverClicked == 1:
			$"RichTextLabel3".text = "Your unique ID is "+global.IRBcode+". Please note it down and enter it in qualtrics survey."
			$"RichTextLabel3".visible = true
			
	if ($"Button".text == "Game 2" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		freshPress = false
		get_tree().reload_current_scene()
		
	if ($"Button".text == "Get Forage Cookies" and freshPress == true):
		freshPress = false
		rng.randomize()
		var genCookies = rng.randi_range(1, 6)
		deleteCookies(numCookies)
		numCookies = numCookies + genCookies
		spawnCookies(numCookies)
		$"RichTextLabel3".text = "You have received "+str(genCookies)+" cookies to start this trial"
		$"RichTextLabel5".text = str(numCookies)
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(genCookies) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
		timeElapsedSinceLastLog = 0
		$"Button".text = "Check for Cookie Monster"
		
	if ($"Button".text == "Check for Cookie Monster" and freshPress == true):
		freshPress = false
		rng2.randomize()
		if (rng2.randi_range(1, 6) == 1):
			$"MONSTERPlayer".play()
			$"Sprite3".visible = true
			rng3.randomize()
			var subCookies = rng3.randi_range(1, 6)
			if (subCookies < numCookies):
				deleteCookies(subCookies)
				numCookies = numCookies - subCookies
				$"RichTextLabel3".text = "Cookie Monster ate "+str(subCookies)+" cookies this trial"
				$"RichTextLabel5".text = str(numCookies)
				var time2 = OS.get_time()
				var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
				saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(-subCookies) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
				timeElapsedSinceLastLog = 0
			else:
				var removedCookies = numCookies
				deleteCookies(numCookies)
				numCookies = 0
				$"RichTextLabel3".text = "Cookie Monster ate all your cookies this trial"
				$"RichTextLabel5".text = str(numCookies)
				var time2 = OS.get_time()
				var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
				saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(-removedCookies) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
				timeElapsedSinceLastLog = 0
				$"Button".text = "Game Over!"
		else:
			$"RichTextLabel3".text = "No Cookie Monster this trial. Your cookies stay the same"
			var time2 = OS.get_time()
			var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
			saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
			timeElapsedSinceLastLog = 0
		if ($"Button".text != "Game Over!"):
			$"Button".text = "Check Gamblemouse"
		
	if ($"Button".text == "Check Gamblemouse" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		freshPress = false
		$"Sprite3".visible = false
		$"Sprite4".visible = true
		#rng4.randomize()
		#oddsMouse = rng4.randi_range(2, 4)
		oddsMouse = oddsArr[trialNum-1]
		$"RichTextLabel4".text = str(oddsMouse)+":1"
		$"RichTextLabel4".visible = true
		$"RichTextLabel3".text = "You encountered "+str(oddsMouse)+":1 Gamblemouse"
		$"SpinBox".visible = true
		$"SpinBox".max_value = numCookies
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + str(oddsMouse)+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
		timeElapsedSinceLastLog = 0
		$"Button".text = "How many cookies do you bet?"
		
	if ($"Button".text == "How many cookies do you bet?" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		freshPress = false
		betted = $"SpinBox".value
		$"SpinBox".visible = false
		#deleteCookies(betted)
		colorCookies(betted, betColor)
		numCookies = numCookies - betted
		$"RichTextLabel3".text = "You placed a bet of "+str(betted)+" cookies"
		$"RichTextLabel3".modulate = betColor
		$"RichTextLabel5".text = str(numCookies) + "+" + str(betted) + "(bet)"
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(-betted) + "," + str(numCookies) + "," + str(betted) + "," + str(betted/(numCookies+betted)) + "," + "none" + "," + "none")
		timeElapsedSinceLastLog = 0
		$"Button".text = "Check the result"
		
		
	if ($"Button".text == "Check the result" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		freshPress = false
		$"SpinBox".visible = false
		$"SpinBox".value = 0
		$"Sprite4".visible = false
		$"RichTextLabel4".visible = false
		if (betted > 0):
			rng5.randomize()
			if (rng5.randi_range(0, 1) == 1):
				$"WINPlayer".play()
				$"Sprite5".visible = true
				var won = betted * oddsMouse
				deleteCookies(betted)
				deleteCookies(numCookies)
				print(cookies.size())
				numCookies = numCookies + won
				spawnCookies(numCookies)
				print(cookies.size())
				colorCookies(won, winColor)
				print(cookies.size())
				$"RichTextLabel3".text = "You had bet "+str(betted)+" cookies on a "+str(oddsMouse)+":1 Gamblemouse and won"
				$"RichTextLabel5".text = str(numCookies-won) + "+" + str(won) + "(won)"
				$"RichTextLabel6".text = str(won)+" cookies"
				$"RichTextLabel6".visible = true
				$"RichTextLabel3".modulate = winColor
				$"RichTextLabel6".modulate = winColor
				var time2 = OS.get_time()
				var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
				saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(won) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "1" + "," + str(won))
				timeElapsedSinceLastLog = 0
			else:
				$"Sprite6".visible = true
				$"LOSEPlayer".play()
				if (numCookies > 0):
					$"RichTextLabel3".text = "You lost your bet of"
					$"RichTextLabel5".text = str(numCookies) + "," + str(betted) + "(lost)"
					$"RichTextLabel6".text = str(betted)+" cookies"
					$"RichTextLabel6".visible = true
					$"RichTextLabel3".modulate = loseColor
					$"RichTextLabel6".modulate = loseColor
					loseCookies()
					var time2 = OS.get_time()
					var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
					saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "0" + "," + str(-betted))
					timeElapsedSinceLastLog = 0
				else:
					$"RichTextLabel3".text = "You lost all your cookies in the bet"
					$"RichTextLabel3".modulate = loseColor
					$"RichTextLabel5".text = str(numCookies) + "," + str(betted) + "(lost)"
					loseCookies()
					var time2 = OS.get_time()
					var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
					saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "0" + "," + str(-betted))
					timeElapsedSinceLastLog = 0
					$"Button".text = "Game Over!"
		else:
			$"RichTextLabel3".text = "You didn't bet anything. Your cookies stay the same"
			$"RichTextLabel5".text = str(numCookies) + "+0"
			var time2 = OS.get_time()
			var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
			saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "-1" + "," + str(0))
			timeElapsedSinceLastLog = 0
		if ($"Button".text != "Game Over!"):
			if gameType == 1:
				$"Button".text = "Check the volcano"
			elif gameType == 2:
				if (trialNum == 30):
					$"Sprite2".visible = true
					$"Sprite".visible = false
					$"Button".text = "Game Over!"
					$"VOLCANOPlayer".play()
				else:
					$"Button".text = "Next trial"
		
	if ($"Button".text == "Check the volcano" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		$"RichTextLabel6".visible = false
		freshPress = false
		$"Sprite5".visible = false
		$"Sprite6".visible = false
		if (trialNum == 30):
			$"VOLCANOPlayer".play()
			$"RichTextLabel3".text = "Volcano exploded! Game Over! Your total winnings are "+str(numCookies)+" cookies"
			$"Sprite2".visible = true
			$"Sprite".visible = false
			var time2 = OS.get_time()
			var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
			saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
			timeElapsedSinceLastLog = 0
			$"Button".text = "Game Over!"
		else:
			$"RichTextLabel3".text = "No volcano explosion! Keep playing"
			var time2 = OS.get_time()
			var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
			saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
			timeElapsedSinceLastLog = 0
			$"Button".text = "Next trial"
			
	if ($"Button".text == "Next trial" and freshPress == true):
		$"RichTextLabel3".modulate = Color("ffffff")
		$"RichTextLabel6".modulate = Color("ffffff")
		$"RichTextLabel5".text = str(numCookies)
		resetCookies()
		$"RichTextLabel6".visible = false
		freshPress = false
		$"Sprite5".visible = false
		$"Sprite6".visible = false
		trialNum = trialNum + 1
		$"RichTextLabel3".text = "You have "+str(numCookies)+" cookies to start trial #"+str(trialNum)
		$"RichTextLabel".text = "Trial #"+str(trialNum)
		if gameType == 2:
			$"RichTextLabel".text = $"RichTextLabel".text + " of 30"
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		saveOutput.append(time_return2 + "," + str(trialNum) + "," + str(timeElapsedSinceGameStart) + "," + str(timeElapsedSinceLastLog) + "," + $"Button".text + "," + "none"+"," + str(0) + "," + str(numCookies) + "," + "none" + "," + "none" + "," + "none" + "," + "none")
		timeElapsedSinceLastLog = 0
		$"Button".text = "Check Gamblemouse"
		

func _on_Button_button_down():
	freshPress = true
