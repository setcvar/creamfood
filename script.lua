if not game:IsLoaded() then repeat wait() until game:IsLoaded() end


local hui = get_hidden_gui or gethui

local HTTPService = game:GetService("HttpService")

local players = game.Players

local lp = players.LocalPlayer

local CAS = game:GetService("ContextActionService")

local debugging = false

local sethiddenproperty = sethiddenproperty or set_hidden_prop

local character = game.Players.LocalPlayer.Character

local UIS = game:GetService("UserInputService")

local function ChatLog(plr)
	plr.Chatted:Connect(function(message)
		--print("Player: " .. plr.Name .. "\n" .. "Message: " .. message .. "\n")
		log_label.Text = log_label.Text .. plr.Name .. " | " .. "Message: " .. message .. "\n"
	end)
end

-- [[ FUNÇÕES ]] --

local function GetPlayer(Name)

	for _,v in ipairs(game.Players:GetPlayers()) do

		if string.lower(v.Name):match("^" .. string.lower(Name)) then
			return v
		end

	end
	return nil
end

local function GetCharacter()
	return game.Players.LocalPlayer.Character;
end

local function Say(message, speaker)
	game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message,speaker)
end

function RGB(red, green, blue)
	return Color3.fromRGB(red, green, blue)
end

-- [[ FUNÇÕES ]] --

-- [[ COMANDOS ]] -- 

local clip = true
local noclipping = nil

local last_pos = nil

local loop_night = nil

local commands = {

	["speed"] = function(arg1)
		local character = game.Players.LocalPlayer.Character
		character.Humanoid.WalkSpeed = tonumber(arg1)
	end,

	["jppower"] = function(arg1)
		local character = game.Players.LocalPlayer.Character
		character.Humanoid.JumpPower = tonumber(arg1)
	end,

	["maxfps"] = function(arg1)
		if setfpscap then
			setfpscap(tonumber(arg1))
		else
			game.StarterGui:SetCore("SendNotification", {
				Title = "Creamfood",
				Text = "Exploit doesnt have setfpscap"
			})
		end
	end,

	["rejoin"] = function()
		lp:Kick()
		wait()
		if #players:GetPlayers() <= 1 then
			game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
		else
			game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
		end
	end,

	["goto"] = function(arg1)

		local target = GetPlayer(tostring(arg1))
		if target then
			local character = game.Players.LocalPlayer.Character
			character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame

		end

	end,

	["noclip"] = function()
		local function NoclipLoop()
			if clip == true and lp.Character ~= nil then
				--clip = false
				for _, v in pairs(lp.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == true then
						v.CanCollide = false
					end
				end
			end
		end
		noclipping = game:GetService("RunService").Stepped:Connect(NoclipLoop)
	end,

	["clip"] = function()

		noclipping:Disconnect()
		clip = true

	end,

	["simradius"] = function()
		if sethiddenproperty and setsimulationradius then
			game:GetService("RunService").RenderStepped:Connect(function()
				pcall(function()
					settings().AllowSleep = false
					sethiddenproperty(game.Players.LocalPlayer, "MaximumSimulationRadius", math.huge)
					sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
					setsimulationradius(math.huge)
				end)
			end)
		end
	end,

	["grav"] = function(arg1)
		workspace.Gravity = tonumber(arg1)
	end,

	["firecds"] = function()
		for i,v in pairs (workspace:GetDescendants()) do

			if v:IsA("ClickDetector") then
				fireclickdetector(v)
			end

		end
	end,

	["freeze"] = function()
		for i,v in pairs (character:GetChildren()) do
			if v:IsA("Part") or v:IsA("BasePart") then
				v.Anchored = true
			end
		end
	end,

	["thaw"] = function()
		for i,v in pairs (character:GetChildren()) do
			if v:IsA("Part") or v:IsA("BasePart") then
				v.Anchored = false
			end
		end
	end,

	["creatorid"] = function()
		game.Players.LocalPlayer.UserId = game.CreatorId
	end,

	["exit"] = function()
		game:GetService("RunService").RenderStepped:Connect(function()
			while true do end
		end)
	end,

	["jump"] = function()
		local character = game.Players.LocalPlayer.Character
		character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end,

	["view"] = function(arg1)
		local target = GetPlayer(tostring(arg1))
		if target then
			workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
		end

		viewing = game.Players.PlayerRemoving:Connect(function(plr)
			if plr.UserId == target.UserId then
				workspace.CurrentCamera.CameraSubject = GetCharacter().Humanoid
			end
		end)
	end,

	["hitboxes"] = function()
		for i,child in pairs(workspace:GetDescendants()) do
			local sb = Instance.new("SelectionBox")
			sb.Parent = child
			sb.Adornee = child
			sb.LineThickness = 0.1
			sb.Color3 = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
		end

	end,

	["day"] = function()
		game.Lighting.ClockTime = 14
	end,

	["night"] = function()
		game.Lighting.ClockTime = 0
	end,

	["loopnight"] = function()
		loop_night = game:GetService("RunService").Stepped:Connect(function()
			game.Lighting.ClockTime = 0
		end)
	end,

	["unloopnight"] = function()
		loop_night:Disconnect()
	end,

	["colorful_world"] = function()
		for i,v in pairs (workspace:GetDescendants()) do

			if v:IsA("Part") or v:IsA("BasePart") then
				math.randomseed(math.random(0,214712312))
				v.Color = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
			end

		end
	end,

	["halve"] = function()
		local character = GetCharacter()
		if character.Humanoid and character:FindFirstChild("LowerTorso") then
			character.LowerTorso.WaistRigAttachment:Destroy()
		end
	end,

	["esp"] = function()

		local function esp(player)
			local bg = Instance.new("BillboardGui")
			bg.Adornee = player.Character.HumanoidRootPart
			bg.Parent = player.Character.HumanoidRootPart
			bg.Size = UDim2.new(0,200,0,100)
			bg.AlwaysOnTop = true
			local esp_label = Instance.new("TextLabel")
			esp_label.Size = UDim2.new(0,200,0,100)
			esp_label.Text = player.Name
			esp_label.BackgroundTransparency = 1
			esp_label.TextColor3 = RGB(255,255,255)
			esp_label.Parent = bg
		end

		for i,v in pairs (game.Players:GetPlayers()) do
			if v.UserId ~= lp.UserId then
				esp(v)
			end
		end

		esp_playeradded = game.Players.PlayerAdded:Connect(function(plr)
			esp(plr)
		end)
	end,

	["shiftspeed"] = function(arg1)
		local character = GetCharacter()
		shiftwalking_began = UIS.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.LeftShift then
				character.Humanoid.WalkSpeed = tonumber(arg1)
			end
		end)

		shiftwalking_end = UIS.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.LeftShift then
				character.Humanoid.WalkSpeed = 16
			end
		end)

	end,

	["unshiftspeed"] = function()
		shiftwalking_began:Disconnect()
		shiftwalking_end:Disconnect()
	end,

	["loopspeed"] = function(arg1)
		loop_speed = game:GetService("RunService").RenderStepped:Connect(function()
			local character = GetCharacter()
			character.Humanoid.WalkSpeed = tonumber(arg1)
		end)
	end,

	["unloopspeed"] = function()
		loop_speed:Disconnect()
	end,

	["unview"] = function()
		workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		viewing:Disconnect()
	end,

	["unhitboxes"] = function()
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA("SelectionBox") then
				v:Destroy()
			end
		end
	end,

	["infjump"] = function()
		_forcejump = UIS.InputBegan:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
				local character = game.Players.LocalPlayer.Character
				character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end,

	["uninfjump"] = function()
		_forcejump:Disconnect()
	end,

	["moveparts"] = function(arg1)
		for i,v in pairs(workspace:GetChildren()) do
			if v:IsA("Part") and v.Anchored == false then
				local target = GetPlayer(tostring(arg1))
				movingparts = game:GetService("RunService").RenderStepped:Connect(function()
					v.Position = target.Character.HumanoidRootPart.Position
				end)
			end
		end
	end,

	["unmoveparts"] = function()
		movingparts:Disconnect()
	end,

	["advertise"] = function()
		advertising = true
		while advertising == true do
			if advertising == true then
				wait(3)
				Say("Do you wanna try my admin script? github , com/GTX1O8OTi/creamfood","All")
				--Say("github , com/GTX1O8OTi/creamfood", "All")
			end
		end
	end,

	["unadvertise"] = function()
		advertising = false
	end,

	["antiafk"] = function()
		antiafk = true
		while antiafk == true do
			if antiafk then
				pcall(function()
					wait()
					for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
						v:Disable()
						v:Disconnect()
					end
				end)
			end
		end
	end,

	["enablebackpack"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	end,

	["enablechat"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	end,

	["enableplayerlist"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	end,

	["enablehealth"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
	end,

	["disablebackpack"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	end,

	["disablechat"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	end,

	["disableplayerlist"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	end,

	["disablehealth"] = function()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	end,

	["spin"] = function(speed)
		local bav = Instance.new("BodyAngularVelocity")
		bav.Parent = GetCharacter().HumanoidRootPart
		bav.AngularVelocity = Vector3.new(0, tonumber(speed), 0)
		bav.MaxTorque = Vector3.new(0,math.huge,0)
	end,

	["unspin"] = function()
		GetCharacter().HumanoidRootPart.BodyAngularVelocity:Destroy()
	end,

	["clog"] = function()
		log.Enabled = true

	end,

	["unclog"] = function()
		log.Enabled = false
	end,

	["bot_mode"] = function()
		local bav = Instance.new("BodyAngularVelocity")
		bav.Parent = GetCharacter().HumanoidRootPart
		bav.AngularVelocity = Vector3.new(0, 30, 0)
		bav.MaxTorque = Vector3.new(0,math.huge,0)
		BotMode()
	end,

	["unbot_mode"] = function()
		UnBotMode()
	end,

	["nosit"] = function()
		nositting = game:GetService("RunService").RenderStepped:Connect(function()
			if GetCharacter().Humanoid:GetState() == Enum.HumanoidStateType.Seated or GetCharacter().Humanoid.Sit then
				ForceJump()
			end
		end)

	end,

	["unnosit"] = function()
		nositting:Disconnect()
	end,

	["unantiafk"] = function()
		antiafk:Disconnect()
	end,

	["sit"] = function()
		GetCharacter().Humanoid.Sit = true
	end,

	["norotate"] = function()
		GetCharacter().Humanoid.AutoRotate = false
	end,

	["unnorotate"] = function()
		GetCharacter().Humanoid.AutoRotate = true
	end,

	["hipheight"] = function(arg1)
		GetCharacter().Humanoid.HipHeight = tonumber(arg1)
	end,

	["hheight"] = function(arg1)
		GetCharacter().Humanoid.HipHeight = tonumber(arg1)
	end,

	["slopeangle"] = function(arg1)
		GetCharacter().Humanoid.MaxSlopeAngle = tonumber(arg1)
	end,

	["walkto"] = function(arg1)
		local target = GetPlayer(arg1)
		walkingto = game:GetService("RunService").RenderStepped:Connect(function()
			GetCharacter().Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
		end)
	end,

	["unwalkto"] = function()
		walkingto:Disconnect()
	end,

	["nohats"] = function()
		GetCharacter().Humanoid:RemoveAccessories()
	end,

	["platformstand"] = function()
		GetCharacter().Humanoid.PlatformStand = true
	end,


	["unplatformstand"] = function()
		GetCharacter().Humanoid.PlatformStand = false
	end,

	["fullbright"] = function()
		game.Lighting.Ambient = RGB(255,255,255)
		game.Lighting.GlobalShadows = false
	end,

	["nofog"] = function()
		game.Lighting.FogEnd = math.huge
	end,

	["loopnofog"] = function()
		loop_fog = game:GetService("RunService").RenderStepped:Connect(function()
			game.Lighting.FogEnd = math.huge
		end)
	end,

	["unloopnofog"] = function()
		loop_fog:Disconnect()
	end,

	["nodisplaynames"] = function()
		for i,v in pairs(game.Players:GetPlayers()) do
			if v.Name ~= v.DisplayName then
				v.DisplayName = v.Name
			end
		end
	end,

	["firetis"] = function()
		for i,v in pairs (workspace:GetDescendants()) do
			if v:IsA("TouchTransmitter") then
				firetouchinterest(GetCharacter().HumanoidRootPart, v, 0)
			end
		end
	end,

	["countcommands"] = function()
		CountCommands()
	end,

	["nocdlimit"] = function()
		for i,v in pairs (workspace:GetDescendants()) do
			if v:IsA("ClickDetector") then
				v.MaxActivationDistance = math.huge
			end
		end
	end,

	["removeguis"] = function()
		for i,v in pairs(lp.PlayerGui:GetChildren()) do
			if v:IsA("ScreenGui") then
				v:Destroy()
			end
		end
	end,

	["flingstuck"] = function()

		for i,v in pairs (character:GetChildren()) do
			if v:IsA("Part") or v:IsA("BasePart") then
				v.Anchored = true
			end
		end

		local bav = Instance.new("BodyAngularVelocity")
		bav.Parent = GetCharacter().HumanoidRootPart
		bav.AngularVelocity = Vector3.new(0, 900, 0)
		bav.MaxTorque = Vector3.new(0, math.huge, 0)
	end,

	["unflingstuck"] = function()

		if GetCharacter().HumanoidRootPart.BodyAngularVelocity then
			GetCharacter().HumanoidRootPart.BodyAngularVelocity:Destroy()

			for i,v in pairs (character:GetChildren()) do
				if v:IsA("Part") or v:IsA("BasePart") then
					v.Anchored = false
				end
			end

		end

	end,

	["potatographics"] = function()
		game.Lighting.FogEnd = math.huge
		game.Lighting.Ambient = RGB(255,255,255)
		game.Lighting.GlobalShadows = false
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA("Part") then
				v.Material = Enum.Material.SmoothPlastic
			elseif v:IsA("Decal") then
				v:Destroy()
			elseif v:IsA("UnionOperation") then
				v.RenderFidelity = Enum.RenderFidelity.Performance
				v.Material = Enum.Material.SmoothPlastic
			end
		end
	end,

	["unesp"] = function()
		esp_playeradded:Disconnect()

		for i,v in pairs (game.Players:GetPlayers()) do
			for _,k in pairs (v.Character:GetDescendants()) do
				if k:IsA("BillboardGui") then
					k:Destroy()
				end
			end
		end
	end,

	["chams"] = function()
		local function chams(player)
			for i,v in pairs (player.Character:GetChildren()) do
				if v:IsA("Part") or v:IsA("BasePart") and v.Name ~= "Head" then
					local bg = Instance.new("BoxHandleAdornment")
					bg.Adornee = v
					bg.Parent = v
					bg.Color = player.TeamColor
					bg.AlwaysOnTop = true
					bg.Size = v.Size + Vector3.new(.1,.1,.1)
					v.Transparency = 1

				elseif v:IsA("Part") or v:IsA("BasePart") and v.Name == "Head" then
					local bg = Instance.new("BoxHandleAdornment")
					bg.Adornee = v
					bg.Parent = v
					bg.Color = player.TeamColor
					bg.AlwaysOnTop = true
					bg.Size = v.Size + Vector3.new(0,.1,.1)
					v.Transparency = 1
				end
			end
		end

		for i,v in pairs (game.Players:GetPlayers()) do
			if v.UserId ~= lp.UserId then				
				chams(v)
			end
		end

		chams_playeradded = game.Players.PlayerAdded:Connect(function(plr)
			chams(plr)
		end)
	end,

	["unchams"] = function()
		for i,v in pairs (game.Players:GetPlayers()) do
			for _,k in pairs (v.Character:GetDescendants()) do
				if k:IsA("BoxHandleAdornment") then
					k:Destroy()
				end
			end
		end
		chams_playeradded:Disconnect()
	end,

	["drugs"] = function()
		for i,v in pairs (workspace:GetDescendants()) do

			if v:IsA("Part") or v:IsA("BasePart") then
				math.randomseed(math.random(0,214712312))
				v.Color = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
			end

		end

		for i,child in pairs(workspace:GetDescendants()) do
			local sb = Instance.new("SelectionBox")
			sb.Parent = child
			sb.Adornee = child
			sb.LineThickness = 0.1
			sb.Color3 = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
		end
	end,

	["backtrack"] = function(arg1)
		settings().Network.IncomingReplicationLag = tonumber(arg1)
	end,

	["serverhop"] = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
	end,
}

local usage = {
	["print"] = "(string) | it prints to roblox console, view it with F9",
	["speed"] = "(number) | you go fast. thats it",
	["jppower"] = "(number) | you can change how high you'll jump",
	["maxfps"] = "(number) | 0 for unlimited fps",
	["rejoin"] = "| you rejoin the game",
	["goto"] = "(player) | you teleport to the player",
	["noclip"] = "| you can walk through walls",
	["clip"] = "| you cant walk through walls",
	["grav"] = "(number) | TO THE MOON!",
	["firecds"] = "| haha click go brrr",
	["freeze"] = "| You freeze without being able to move",
	["thaw"] = "| Unfreeze",
	["creatorid"] = "| makes your userid the same as the owner",
	["exit"] = "| I have to explain this one?",
	["jump"] = "| force yourself to jump",
	["view"] = "(string) | pog champ moment",
	["hitboxes"] = "| Colliders",
	["day"] = "| sun is a deadly laser",
	["night"] = "| i love the moon",
	["loopnight"] = "| i love the moon eternally",
	["unloopnight"] = "| there is monsters nearby",
	["colorful_world"] = "| gamer mode",
	["halve"] = "| Who needs legs",
	["esp"] = "| I have nothing to say about this one",
	["shiftspeed"] = "(string) | Press LSHIFT to run with the speed",
	["infjump"] = "| You can jump without any limit",
	["advertise"] = "| <3",
	["spin"] = "(number) | You spin, what else can I explain?",
	["clog"] = "| Chatlog",
	["bot_mode"] = "| It's literally just advertise, antiafk and spin",
	["nosit"] = "| You dont like sitting? Not a problem anymore",
	["norotate"] = "| Makes your character not rotate automatically",
	["hipheight"] = "(number) | Your distance off the ground",
	["hheight"] = "(number) | Your distance off the ground (shortcut for: hipheight)",
	["slopeangle"] = "(number) | Maximum slope angle before falling to the ground",
	["walkto"] = "(player) | You walk to the specified player",
	["platformstand"] = "| I dont know how to explain this",
	["fullbright"] = "| It's very bright",
	["nofog"] = "| I dont have anything to explain",
	["firetis"] = "| It's basically firecds but with touch instead",
	["nocdlimit"] = "| Remove any Click Detector's activation limit",
	["potatographics"] = "| Your game will look like a 1998 game, dont blame me",
	["drugs"] = "| yes",
	["backtrack"] = "| Makes you lag behind; 0 to revert",

}
-- [[ COMANDOS ]] --

-- obrigado ao remfly

function ForceJump()
	commands.jump()
end

function CountCommands()
	local index = 0

	for i,v in pairs(commands) do
		index = index + 1
	end

	print(index)
end

function BotMode()
	commands:advertise()
	commands:antiafk()
end

function UnBotMode()
	commands:unadvertise()
	commands:unspin()
end

for i,v in pairs(game.Players:GetPlayers()) do
	ChatLog(v)
end

game.Players.PlayerAdded:Connect(function(plr)
	ChatLog(plr)
end)

local function RCMD(cmd)
	local index = 0

	local comando, args

	for result in string.gmatch(cmd, "%g+") do

		if debugging then
			print (result, index)
		end

		if index == 0 and commands[result] then
			comando = result

		elseif index == 1 then
			args = result
		end

		index = index + 1
	end

	if commands[comando] then
		commands[comando](args)
	end

end

-- [[ COMANDOS ]] --


local sgui = Instance.new("ScreenGui")
sgui.Parent = hui() or game.CoreGui
sgui.Name = HTTPService:GenerateGUID(false)

local frame1 = Instance.new("Frame")
frame1.Active = true
frame1.Draggable = true
frame1.Selectable = true
frame1.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame1.BorderSizePixel = 1
frame1.BorderColor3 = Color3.fromRGB(50,50,50)
frame1.Position = UDim2.new(0.354,0,0.439,0)
frame1.Size = UDim2.new(0,499,0,361)
frame1.Parent = sgui

local topbar = Instance.new("Frame")
topbar.BackgroundColor3 = Color3.fromRGB(24,24,24)
topbar.BorderSizePixel = 0
topbar.Position = UDim2.new(0,0,-0.001,0)
topbar.Size = UDim2.new(0,499,0,40)
topbar.Parent = frame1

local sframe = Instance.new("ScrollingFrame")
sframe.BackgroundColor3 = RGB(24,24,24)
sframe.BorderSizePixel = 0
sframe.Position = UDim2.new(0.03,0,0.142,0)
sframe.Size = UDim2.new(0,472,0,251)
sframe.ScrollBarImageColor3 = RGB(255,255,255)
sframe.Parent = frame1
sframe.CanvasSize = UDim2.new(0,0,5,0)

local label = Instance.new("TextLabel")
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.TextSize = 10
label.TextColor3 = RGB(255,255,255)
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.TextWrapped = true
label.Text = ""
label.Position = UDim2.new(0,0,0,0)
label.Parent = sframe
label.Size = UDim2.new(0,462,0,1800)


local textbox = Instance.new("TextBox")
textbox.BackgroundColor3 = RGB(24,24,24)
textbox.BorderSizePixel = 0
textbox.ClearTextOnFocus = false
textbox.Position = UDim2.new(0.03,0,0.86,0)
textbox.Size = UDim2.new(0,473,0,40)
textbox.Text = ""
textbox.Parent = frame1
textbox.TextSize = 15
textbox.TextColor3 = RGB(255,255,255)
textbox.ClearTextOnFocus = false

------------------------------------------

local LastUpdate = "25/08"

local update_date = Instance.new("ScreenGui")
update_date.Parent = hui() or game.CoreGui

local update_frame = Instance.new("Frame")
update_frame.BackgroundColor3 = RGB(30,30,30)
update_frame.BorderSizePixel = 0
update_frame.Position = UDim2.new(0.869,0,0.892,0)
update_frame.Size = UDim2.new(0,113,0,52)
update_frame.Parent = update_date

local update_frame2 = Instance.new("Frame")
update_frame2.BackgroundColor3 = RGB(0,255,0)
update_frame2.BorderSizePixel = 0
update_frame2.Position = UDim2.new(-0.007,0,0.892,0)
update_frame2.Size = UDim2.new(0,113,0,5)
update_frame2.Parent = update_frame

local update_label = Instance.new("TextLabel")
update_label.BackgroundTransparency = 1
update_label.Position = UDim2.new(0,0,0,0)
update_label.Size = UDim2.new(0,113,0,52)
update_label.TextColor3 = RGB(255,255,255)
update_label.Text = "Stable Branch \nUpdate: " .. LastUpdate
update_label.TextSize = 12
update_label.Parent = update_frame

------------------------------------------
log = Instance.new("ScreenGui")

log.Parent = hui() or game.CoreGui
log.Enabled = false

local log_frame = Instance.new("Frame")
log_frame.BackgroundColor3 = RGB(30,30,30)
log_frame.BorderSizePixel = 1
log_frame.Parent = log
log_frame.Position = UDim2.new(0.019,0,0.477,0)
log_frame.Size = UDim2.new(0,461,0,338)
log_frame.BorderColor3 = RGB(100,100,100)
log_frame.Active = true
log_frame.Selectable = true
log_frame.Draggable = true

local log_sframe = Instance.new("ScrollingFrame")
log_sframe.BackgroundColor3 = RGB(20,20,20)
log_sframe.BorderSizePixel = 0
log_sframe.Position = UDim2.new(0,0,0.17,0)
log_sframe.Size = UDim2.new(0,461,0,223)
log_sframe.ScrollBarImageColor3 = RGB(255,255,255)
log_sframe.CanvasSize = UDim2.new(0,0,20,0)
log_sframe.Parent = log_frame

log_label = Instance.new("TextLabel")
log_label.BackgroundTransparency = 1
log_label.Position = UDim2.new(0.011,0,0,0)
log_label.Parent = log_sframe
log_label.Size = UDim2.new(0,450,0,5000)
log_label.Text = ""
log_label.TextColor3 = RGB(255,255,255)
log_label.TextWrapped = true
log_label.TextSize = 10
log_label.TextXAlignment = Enum.TextXAlignment.Left
log_label.TextYAlignment = Enum.TextYAlignment.Top

local log_topbar = Instance.new("Frame")
log_topbar.BackgroundColor3 = RGB(24,24,24)
log_topbar.BorderSizePixel = 0
log_topbar.Position = UDim2.new(0,0,-0.001,0)
log_topbar.Size = UDim2.new(0,460,0,40)
log_topbar.Parent = log_frame

local log_button = Instance.new("TextButton")
log_button.Parent = log_frame
log_button.BackgroundColor3 = RGB(24,24,24)
log_button.BorderSizePixel = 0
log_button.Position = UDim2.new(0.735,0,0.865,0)
log_button.Size = UDim2.new(0,103,0,28)
log_button.Text = "Save to .txt file"
log_button.TextColor3 = RGB(255,255,255)

local log_clear = Instance.new("TextButton")
log_clear.Parent = log_frame
log_clear.BackgroundColor3 = RGB(24,24,24)
log_clear.BorderSizePixel = 0
log_clear.Position  = UDim2.new(0.486,0,0.865,0)
log_clear.Size = UDim2.new(0,103,0,28)
log_clear.Text = "Clear"
log_clear.TextColor3 = RGB(255,255,255)

log_clear.MouseButton1Click:Connect(function()
	log_label.Text = ""
end)

log_button.MouseButton1Click:Connect(function()
	if writefile then
		writefile("creamfood.txt", log_label.Text)
	end
end)
------------------------------------------

-- tamanho desejado: 0,283,0,56

local ann = Instance.new("ScreenGui")
ann.Parent = hui() or game.CoreGui

local ann_frame = Instance.new("Frame")
ann_frame.BackgroundColor3 = RGB(20,20,20)
ann_frame.BorderColor3 = RGB(100,100,100)
ann_frame.Position = UDim2.new(0,0,0.123,0)
ann_frame.Size = UDim2.new(0,0,0,56)
ann_frame.Parent = ann

local ann_label = Instance.new("TextLabel")
ann_label.BackgroundTransparency = 1
ann_label.Position = UDim2.new(0,0,0,0)
ann_label.Size = UDim2.new(0,0,0,56)
ann_label.TextColor3 = RGB(255,255,255)
ann_label.Text = "You can contact me at navet # 2416"
ann_label.Parent = ann_frame
ann_label.TextTransparency = 1

local TweenService = game:GetService("TweenService")
local info = TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, true, 0)
local tween = TweenService:Create(ann_frame, info, {Size = UDim2.new(0,283,0,56)})
local tween2 = TweenService:Create(ann_label, info, {Size = UDim2.new(0,283,0, 56)})
local tween3 = TweenService:Create(ann_label, info, {TextTransparency = 0})

tween:Play()
tween2:Play()
tween3:Play()
------------------------------------------
for i,v in pairs (commands) do		
	if usage[tostring(i)] then
		label.Text = label.Text .. "\n" .. tostring(i) .. " " .. usage[tostring(i)]
	else
		label.Text = label.Text .. "\n" .. tostring(i) .. " " .. "| No description or I have to add one"
	end
end

CAS:BindAction("focus", function()
	textbox:CaptureFocus()
	game:GetService("RunService").RenderStepped:Wait()
	textbox.Text = ""
end, false, Enum.KeyCode.RightBracket)

local function ToggleWindow(actionName, inputState)
	if actionName == "yes" and inputState == Enum.UserInputState.Begin then
		frame1.Visible = not frame1.Visible
	end
end

CAS:BindAction("yes", ToggleWindow, false, Enum.KeyCode.Home)

textbox.FocusLost:Connect(function(enter)
	if enter then
		RCMD(textbox.Text)
		textbox.Text = ""
	end
end)

character.Humanoid.Died:Connect(function()
	lp.CharacterAdded:Wait()
	commands:clip()
	commands:unnosit()
end)
