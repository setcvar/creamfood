if not game:IsLoaded() then game.Loaded:Wait() end

local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function GetCommandPlayer (Text)
	local SpecialUseCases = {"all","me", "random", "others"}
	local selected_player = {}
	local Players = players:GetPlayers()
	
	local cases = {
		["all"] = function() for k,v in pairs (Players) do selected_player[#selected_player+1] = v end end,
		["others"] = function() for k,v in pairs (Players) do if v.Name ~= player.Name then selected_player[#selected_player+1] = v end end end,
		["random"] = function() local number = math.random(1,#Players) selected_player[#selected_player+1] = Players[number] end,
		["me"] = function() selected_player[#selected_player+1] = player end,
	}
	
	local Split_Text = string.split(Text, " ")
	
	local hi = Split_Text[1]:lower()
	
	table.remove(Split_Text, 1) -- command, useless in this function
	local idk = string.gsub(hi, "%$", "")
	
	for _, yeet in next, SpecialUseCases do
		for k,func in pairs (cases) do
			if yeet == idk and k == idk then func() end
		end
	end
	
	for _, plr in pairs (Players) do
		local e = hi
		if string.lower (plr.Name):match("^"..string.lower(e)) or string.lower (plr.DisplayName):match("^"..string.lower(e)) or string.lower(plr.Character.Humanoid.DisplayName):match("^"..string.lower(e)) then
			selected_player[#selected_player+1] = plr
		end
	end
	
	return selected_player
end

local commands = {}

local function add(command_name, func, aliases, description, paramTypes, separated)
	commands[#commands+1] = {
	name = command_name,
	func = func,
	aliases = aliases,
	desc = description,
	paramTypes = paramTypes,
	separated = separated,
	}
end

local function playcmd (text)
	local text = text:split(" ")
	
	local cmd_name = text[1]
	local plr = text[2]
	local params = {}
	
	if commands[cmd_name] == nil then
		
		for i, cmd in pairs (commands) do
			
			for k, value in pairs (cmd) do
				if k == "aliases" or k == "name" then
					
					if typeof(value) == "string" and value == cmd_name then
						cmd_name = cmd
						elseif typeof(value) == "table" then
						for j,k in pairs (value) do
							if k == cmd_name then
								cmd_name = cmd
							end
						end
					end
					
				end
			end
			
		end
		
	end
	
	local separated, paramTypes = cmd_name.Separated, cmd_name.paramTypes
	local text2
	if cmd_name.paramTypes[1] == "player" then
		text2 = table.concat(text, " ",3)
		else
		text2 = table.concat(text, " ", 2)
	end
	
	local text2 = text2:split(" ")
	
	if separated then
		params.Text = text2
		else
		params.Text = table.concat(text2," ")
	end
	
	for k,v in ipairs (paramTypes) do
		if v == "player" then
			params[k] = GetCommandPlayer(text[2])
			elseif v == "number" then
			params.Text = tonumber(params.Text)
			elseif v == "string" then
			params.Text = tostring(params.Text)
		end
	end
	print(cmd_name)
	local success, errMessage = pcall(cmd_name.func, params)
	if not success then erroruiconsole(errMessage) end
end

add ("print", function(yeet) printuiconsole(yeet.Text) end, {"p"}, "maeks console add text :3", {"string"}, false)

add ("speed", function(yeet)
	if player and player.Character then
		player.Character.Humanoid.WalkSpeed = yeet.Text
	end
end, {"ws","walkspeed"}, "go fast", {"number"},false)

playcmd("ws 25")
