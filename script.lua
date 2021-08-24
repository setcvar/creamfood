local hui = get_hidden_gui or gethui

local HTTPService = game:GetService("HttpService")

local players = game.Players

local lp = players.LocalPlayer

local CAS = game:GetService("ContextActionService")

local sethiddenproperty = sethiddenproperty or set_hidden_prop

local character = game.Players.LocalPlayer.Character

-- [[ FUNÇÕES ]] --

local function GetPlayer(Name)

	for _,v in ipairs(game.Players:GetPlayers()) do

		if string.lower(v.Name):match("^" .. string.lower(Name)) then
			return v
		end

	end
	return nil
end


-- [[ FUNÇÕES ]] --

local function GetCharacter()
	return game.Players.LocalPlayer.Character;
end

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

	["fpslimit"] = function(arg1)
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

	["tp"] = function(arg1)

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
			sethiddenproperty(game.Players.LocalPlayer, "MaximumSimulationRadius", math.huge)
			sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
		end
	end,

	["grav"] = function(arg1)
		workspace.Gravity = tonumber(arg1)
	end,

	["fireclickdetectors"] = function()
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
	
	["halve"] = function()
		local character = GetCharacter()
		if character.Humanoid and character:FindFirstChild("LowerTorso") then
			character.LowerTorso.WaistRigAttachment:Destroy()
		end
	end,
}

local usage = {
	["print"] = "(string) | it prints to roblox console, view it with F9",
	["speed"] = "(number) | you go fast. thats it",
	["jppower"] = "(number) | you can change how high you'll jump",
	["fpslimit"] = "(number) | read the name",
	["rejoin"] = "| you rejoin the game",
	["tp"] = "(string) | you teleport to the player",
	["noclip"] = "| you can walk through walls",
	["clip"] = "| you cant walk through walls",
	["simradius"] = "| yes",
	["grav"] = "(number) | TO THE MOON!",
	["fireclickdetectors"] = "| haha click go brrr",
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
	["colorful_world"] = "| sim",
	["halve"] = "| Who needs legs",
}
-- [[ COMANDOS ]] --

-- obrigado ao remfly

local function RCMD(cmd)
	local index = 0

	local comando, args

	for result in string.gmatch(cmd, "%g+") do

		if index == 0 and commands[result] then
			comando = result

		elseif index == 1 then
			args = result
			break
		end

		index = index + 1
	end

	if commands[comando] then
		commands[comando](args)
	end
	
end

-- [[ COMANDOS ]] --

local sc = Instance.new("ScreenGui")
sc.Parent = hui() or game.CoreGui

local frame = Instance.new("Frame")
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.443,0, 0.293, 0)
frame.Size = UDim2.new(0,418,0,262)
frame.Parent = sc
frame.Draggable = true
frame.Active = true
frame.Selectable = true

local textbox = Instance.new("TextBox")
textbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
textbox.ClearTextOnFocus = true
textbox.BorderSizePixel = 0
textbox.Size = UDim2.new(0,418,0,30)
textbox.PlaceholderText = "command here"
textbox.Position = UDim2.new(0,0,0.997,0)
textbox.Parent = frame
textbox.TextColor3 = Color3.fromRGB(255,255,255)
textbox.Text = ""

local sframe = Instance.new("ScrollingFrame")
sframe.BackgroundColor3 = Color3.fromRGB(20,20,20)
sframe.BorderSizePixel = 0
sframe.Position = UDim2.new(0.048,0,0.107,0)
sframe.Size = UDim2.new(0,398,0,233)
sframe.Parent = frame
sframe.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
sframe.ScrollBarThickness = 11

local label = Instance.new("TextLabel")
label.BackgroundColor3 = Color3.fromRGB(70,70,70)
label.BorderSizePixel = 0
label.Position = UDim2.new(0.022,0,0,0)
label.Size = UDim2.new(0,379,0,225)
label.TextSize = 10
label.BackgroundTransparency = 1
label.Parent = sframe
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Text = ""
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top

local frame2 = Instance.new("Frame")
frame2.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame2.BorderSizePixel = 0
frame2.Position = UDim2.new(0,0,0.107,0)
frame2.Size = UDim2.new(0,20,0,233)
frame2.Parent = frame

------------------------------------------

local update_date = Instance.new("ScreenGui")
update_date.Parent = hui() or game.CoreGui

local update_frame = Instance.new("Frame")
update_frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
update_frame.BorderSizePixel = 0
update_frame.Position = UDim2.new(0.869,0,0.892,0)
update_frame.Size = UDim2.new(0,113,0,52)
update_frame.Parent = update_date

local update_frame2 = Instance.new("Frame")
update_frame2.BackgroundColor3 = Color3.fromRGB(0,255,0)
update_frame2.BorderSizePixel = 0
update_frame2.Position = UDim2.new(-0.007,0,0.892,0)
update_frame2.Size = UDim2.new(0,113,0,5)
update_frame2.Parent = update_frame

local update_label = Instance.new("TextLabel")
update_label.BackgroundTransparency = 1
update_label.Position = UDim2.new(0,0,0,0)
update_label.Size = UDim2.new(0,113,0,52)
update_label.TextColor3 = Color3.fromRGB(255,255,255)
update_label.Text = "Update: 23/08"
update_label.TextSize = 12
update_label.Parent = update_frame

------------------------------------------

local function RGB(red, green, blue)
	return Color3.fromRGB(red, green, blue)
end

for i,v in pairs (commands) do		
	if usage[tostring(i)] then
		label.Text = label.Text .. "\n" .. tostring(i) .. " " .. usage[tostring(i)]
	else
		label.Text = label.Text .. "\n" .. tostring(i) .. " " .. "| remember to add"
	end
end

CAS:BindAction("focus", function()
	textbox:CaptureFocus()
	game:GetService("RunService").RenderStepped:Wait()
	textbox.Text = ""
end, false, Enum.KeyCode.RightBracket)

local function ToggleWindow(actionName, inputState)
	if actionName == "yes" and inputState == Enum.UserInputState.Begin then
		frame.Visible = not frame.Visible
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
	game.Players.LocalPlayer.CharacterAdded:Wait()
	commands.clip()
end)

