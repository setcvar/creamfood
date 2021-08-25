local hui = get_hidden_gui or gethui

local HTTPService = game:GetService("HttpService")

local players = game.Players

local lp = players.LocalPlayer

local CAS = game:GetService("ContextActionService")

local sethiddenproperty = sethiddenproperty or set_hidden_prop

local character = game.Players.LocalPlayer.Character

local UIS = game:GetService("UserInputService")

local LastUpdate = "24/08"

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
		if sethiddenproperty then
			game:GetService("RunService").RenderStepped:Connect(function()
				pcall(function()
					settings().AllowSleep = false
					sethiddenproperty(game.Players.LocalPlayer, "MaximumSimulationRadius", math.huge)
					sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
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

	["legit_esp"] = function()
		for i,v in pairs(game.Players:GetPlayers()) do
			if v.UserId ~= game.Players.LocalPlayer.UserId then
				for _,k in pairs(v.Character:GetChildren()) do
					if k:IsA("Part") or k:IsA("BasePart") then
						local sb = Instance.new("SelectionBox")
						sb.Parent = k
						sb.Adornee = k
						sb.LineThickness = 0.1
						sb.Color3 = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
					end
				end
			end
		end
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
				Say("Do you wanna have fun? Get Creamfood!","All")
				Say("github , com/GTX1O8OTi/creamfood", "All")
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
		bav.P = 20
		bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
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
		BotMode()
	end,

	["unbot_mode"] = function()
		UnBotMode()
	end,

	["nosit"] = function()
		nositting = GetCharacter().Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
			if GetCharacter().Humanoid.Sit then
				character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
}

local usage = {
	["print"] = "(string) | it prints to roblox console, view it with F9",
	["speed"] = "(number) | you go fast. thats it",
	["jppower"] = "(number) | you can change how high you'll jump",
	["maxfps"] = "(number) | 0 for unlimited fps",
	["rejoin"] = "| you rejoin the game",
	["goto"] = "(string) | you teleport to the player",
	["noclip"] = "| you can walk through walls",
	["clip"] = "| you cant walk through walls",
	["grav"] = "(number) | TO THE MOON!",
	["firecds"] = "| haha click go brrr",
	["freeze"] = "| get cold and stuck",
	["thaw"] = "| unstuck yourself",
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
	["legit_esp"] = "| its not the best, but im trying ok",
	["shiftspeed"] = "(string) | Press LSHIFT to run with the speed",
	["infjump"] = "| You can jump without any limit",
	["advertise"] = "| <3",
	["spin"] = "(number) | You spin, what else can I explain?",
	["clog"] = "| Chatlog",
	["bot_mode"] = "| It's literally just advertise, antiafk and spin",
	["nosit"] = "| You dont like sitting? Not a problem anymore",
}
-- [[ COMANDOS ]] --

-- obrigado ao remfly

function ForceJump()
	commands.jump()
end

function BotMode()
	commands:advertise()
	commands:antiafk()
	commands:spin("69")
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
update_label.Text = "Update: " .. LastUpdate
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
log_frame.Size = UDim2.new(0,461,0,307)
log_frame.BorderColor3 = RGB(100,100,100)
log_frame.Active = true
log_frame.Selectable = true
log_frame.Draggable = true

local log_sframe = Instance.new("ScrollingFrame")
log_sframe.BackgroundColor3 = RGB(20,20,20)
log_sframe.BorderSizePixel = 0
log_sframe.Position = UDim2.new(0,0,0.088,0)
log_sframe.Size = UDim2.new(0,461,0,223)
log_sframe.ScrollBarImageColor3 = RGB(255,255,255)
log_sframe.CanvasSize = UDim2.new(0,0,10,0)
log_sframe.Parent = log_frame

log_label = Instance.new("TextLabel")
log_label.BackgroundTransparency = 1
log_label.Position = UDim2.new(0.011,0,0,0)
log_label.Parent = log_sframe
log_label.Size = UDim2.new(0,450,0,2000)
log_label.Text = ""
log_label.TextColor3 = RGB(255,255,255)
log_label.TextWrapped = true
log_label.TextSize = 10
log_label.TextXAlignment = Enum.TextXAlignment.Left
log_label.TextYAlignment = Enum.TextYAlignment.Top

local log_button = Instance.new("TextButton")
log_button.Parent = log_frame
log_button.BackgroundColor3 = RGB(24,24,24)
log_button.BorderSizePixel = 0
log_button.Position = UDim2.new(0.735,0,0.865,0)
log_button.Size = UDim2.new(0,103,0,28)
log_button.Text = "Save to .txt file"
log_button.TextColor3 = RGB(255,255,255)

log_button.MouseButton1Click:Connect(function()
	if writefile then
		writefile("creamfood_chatlog.txt", log_label.Text)
	end
end)
------------------------------------------

for i,v in pairs (commands) do		
	if usage[tostring(i)] then
		label.Text = label.Text .. "\n" .. tostring(i) .. " " .. usage[tostring(i)]
	else
		label.Text = label.Text .. "\n" .. tostring(i) .. " " .. "| None"
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
