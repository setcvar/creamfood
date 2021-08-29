local Branch = "Dev Branch"

local hui = get_hidden_gui or gethui

local HTTPService = game:GetService("HttpService")

local players = game.Players

local lp = players.LocalPlayer

local TweenService = game:GetService("TweenService")

local CAS = game:GetService("ContextActionService")

local debugging = false

local sethiddenproperty = sethiddenproperty or set_hidden_prop

local character = game.Players.LocalPlayer.Character

local UIS = game:GetService("UserInputService")

local LastDeathLocation = Vector3.new(0,0,0)

-- [[ FUNÇÕES ]] --

local function GetPlayer(Name)

	for _,v in ipairs(game.Players:GetPlayers()) do

		if string.lower(v.Name):match("^" .. string.lower(Name)) then
			return v
		end

	end
	return nil
end

local function SendNotification(message)
	game.StarterGui:SetCore("SendNotification",message)
end

local function GetCharacter()
	return game.Players.LocalPlayer.Character;
end

local rootpart = GetCharacter().HumanoidRootPart

local function Say(message, speaker)
	game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message,speaker)
end

function RGB(red, green, blue)
	return Color3.fromRGB(red, green, blue)
end


local function ChatLog(plr)
	plr.Chatted:Connect(function(message)
		--print("Player: " .. plr.Name .. "\n" .. "Message: " .. message .. "\n")
		CL_label.Text = CL_label.Text .. plr.Name .. " | " .. "Message: " .. message .. "\n"
	end)
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
	
	["freeze"] = function(arg1)
		if typeof(arg1) == "string" and arg1 == "me" then
			for i,v in pairs (GetCharacter():GetChildren()) do
				if v:IsA("Part") or v:IsA("BasePart") then
					v.Anchored = true
				end
			end
			
		elseif typeof(arg1) == "string" and arg1 == "others" then
			for i,v in pairs (game.Players:GetPlayers()) do
				if v.Name ~= lp.Name then
					
					for _,k in pairs (v.Character:GetChildren()) do
						if k:IsA("Part") or k:IsA("BasePart") then
							k.Anchored = true
						end
					end
					
				end
			end
			
		else
			local target = GetPlayer(tostring(arg1))

			for i,v in pairs (target.Character:GetChildren()) do
				if v:IsA("Part") or v:IsA("BasePart") then
					v.Anchored = true
				end
			end
		end
	end,
	
	["thaw"] = function(arg1)
		if typeof(arg1) == "string" and arg1 == "me" then
			for i,v in pairs (GetCharacter():GetChildren()) do
				if v:IsA("Part") or v:IsA("BasePart") then
					v.Anchored = false
				end
			end

		elseif typeof(arg1) == "string" and arg1 == "others" then
			for i,v in pairs (game.Players:GetPlayers()) do
				if v.Name ~= lp.Name then

					for _,k in pairs (v.Character:GetChildren()) do
						if k:IsA("Part") or k:IsA("BasePart") then
							k.Anchored = false
						end
					end

				end
			end

		else
			local target = GetPlayer(tostring(arg1))

			for i,v in pairs (target.Character:GetChildren()) do
				if v:IsA("Part") or v:IsA("BasePart") then
					v.Anchored = false
				end
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
			esp_label.TextColor3 = Color3.fromRGB(player.TeamColor)
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
		shiftwalking_began = UIS.InputBegan:Connect(function(input,chat)
			if input.KeyCode == Enum.KeyCode.LeftShift and not chat then
				character.Humanoid.WalkSpeed = tonumber(arg1)
			end
		end)
		
		shiftwalking_end = UIS.InputEnded:Connect(function(input, chat)
			if input.KeyCode == Enum.KeyCode.LeftShift and not chat then
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
				Say("Are you bored of the same old admin script? Get Creamfood at .gg/uqhDdceHW9","All")
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
	
	["spin"] = function(speed)
		local bav = Instance.new("BodyAngularVelocity")
		bav.Parent = GetCharacter().HumanoidRootPart
		bav.AngularVelocity = Vector3.new(0, tonumber(speed), 0)
		bav.MaxTorque = Vector3.new(0,math.huge,0)
	end,
	
	["unspin"] = function()
			GetCharacter().HumanoidRootPart.BodyAngularVelocity:Destroy()
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
				end
			end
			
			local bg = Instance.new("BoxHandleAdornment")
			bg.Adornee = player.Character.Head
			bg.Parent = player.Character.Head
			bg.Color = player.TeamColor
			bg.AlwaysOnTop = true
			bg.Size = player.Character.Head.Size + Vector3.new(-1,.1,.1)
			player.Character.Head.Transparency = 1
			
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
					
				elseif k:IsA("BasePart") or k:IsA("Part") and k.Name ~= "HumanoidRootPart" then
					k.Transparency = 0
				end
			end
		end
		chams_playeradded:Disconnect()
	end,
	
	["drugs"] = function()
		--[[for i,v in pairs (workspace:GetDescendants()) do

			if v:IsA("Part") or v:IsA("BasePart") then
				v.Color = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
			end

		end]]
		
		for i,child in pairs(workspace:GetDescendants()) do
			local sb = Instance.new("SelectionBox")
			sb.Parent = child
			sb.Adornee = child
			sb.LineThickness = 0.1
			sb.Color3 = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
			
			if child:IsA("Part") then
				math.randomseed(math.random(0,214712312))
				local bg = Instance.new("BoxHandleAdornment")
				bg.Adornee = child
				bg.Parent = child
				bg.Color = BrickColor.new(RGB(math.random(0,255),math.random(0,255),math.random(0,255)))
				bg.Size = child.Size + Vector3.new(.1,.1,.1)
				bg.AlwaysOnTop = false
			end
			
		end
	end,
	
	["backtrack"] = function(arg1)
		settings().Network.IncomingReplicationLag = tonumber(arg1)
	end,
	
	["serverhop"] = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId)
	end,
	
	["bhop"] = function()
		bhopping = game:GetService("RunService").RenderStepped:Connect(function()
			if GetCharacter().Humanoid:GetState() == Enum.HumanoidStateType.Landed or GetCharacter().Humanoid.FloorMaterial ~= Enum.Material.Air then
				ForceJump()
			end
		end)
	end,
	
	["unbhop"] = function()
		bhopping:Disconnect()
	end,
	
	["fastbhop"] = function(speed)
		bhopping = game:GetService("RunService").RenderStepped:Connect(function()
			if GetCharacter().Humanoid:GetState() == Enum.HumanoidStateType.Landed or GetCharacter().Humanoid.FloorMaterial ~= Enum.Material.Air then
				ForceJump()
			end
		end)
		
		GetCharacter().Humanoid.WalkSpeed = 100
	end,
	
	["unfastbhop"] = function()
		bhopping:Disconnect()
		
		GetCharacter().Humanoid.WalkSpeed = 16
		GetCharacter().Humanoid.JumpPower = 50
	end,
	
	["normalslopeangle"] = function()
		GetCharacter().Humanoid.MaxSlopeAngle = 89
	end,
	
	["changestate"] = function(state)
		GetCharacter().Humanoid:ChangeState(Enum.HumanoidStateType[state])
	end,
	
	["rgbfog"] = function()
		rgbfog = game:GetService("RunService").RenderStepped:Connect(function()
			local TweenService = game:GetService("TweenService")
			
			local info = TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
			
			local tween = TweenService:Create(game.Lighting, info, {FogColor = RGB(math.random(0,255),math.random(0,255), math.random(0,255))})
			
			tween:Play()
			
			tween.Completed:Wait()
			
		end)
	end,
	
	["stoprgbfog"] = function()
		rgbfog:Disconnect()
	end,
	
	["rgbambient"] = function()
		rgbambient = game:GetService("RunService").RenderStepped:Connect(function()
			local TweenService = game:GetService("TweenService")

			local info = TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)

			local tween = TweenService:Create(game.Lighting, info, {Ambient = RGB(math.random(0,255),math.random(0,255), math.random(0,255))})

			tween:Play()

			tween.Completed:Wait()

		end)
	end,
	
	["stoprgbambient"] = function()
		rgbambient:Disconnect()
	end,
	
	["rgbcolorshift"] = function()
		rgbcolorshift = game:GetService("RunService").RenderStepped:Connect(function()
			local TweenService = game:GetService("TweenService")

			local info = TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)

			local tween = TweenService:Create(game.Lighting, info, {ColorShift_Bottom = RGB(math.random(0,255),math.random(0,255), math.random(0,255))})
			local tween2 = TweenService:Create(game.Lighting, info, {ColorShift_Top = RGB(math.random(0,255),math.random(0,255), math.random(0,255))})
			tween:Play()
			tween2:Play()
			tween.Completed:Wait()
		end)
	end,
	
	["stoprgbcolorshift"] = function()
		rgbcolorshift:Disconnect()
	end,
	
	["antikick"] = function()
		local mt = getrawmetatable(game)
		local oldnamecall = mt.__namecall
		setreadonly(mt,false)
		
		mt.__namecall = newcclosure(function(self,...)
			if getnamecallmethod() == "Kick" then
				Rejoin()
			end
			return oldnamecall
		end)
	end,
	
	["discord"] = function()
		setclipboard("https://discord.gg/uqhDdceHW9")
		SendNotification({
			Title = "Creamfood",
			Text = "Set Discord invite to clipboard",
			Duration = 5
		})
	end,
	
	["enable"] = function(arg1)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[arg1], true)
	end,
	
	["disable"] = function(arg1)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[arg1], false)
	end,
	
	["stare"] = function(arg1)
		local target = GetPlayer(arg1)
		
		bg = Instance.new("BodyGyro")
		bg.Parent = GetCharacter().HumanoidRootPart
		bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		gyro = game:GetService("RunService").RenderStepped:Connect(function()
			bg.CFrame = CFrame.new(GetCharacter().HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
			
		end)
		
	end,
	
	["unstare"] = function()
		gyro:Disconnect()
		bg:Destroy()
	end,
	
	["tweengoto"] = function(arg1)
		local target = GetPlayer(arg1)
		
		local info = TweenInfo.new(.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0)
		
		local Tween = TweenService:Create(GetCharacter().HumanoidRootPart, info, {Position = target.Character.HumanoidRootPart})
		Tween:Play()
	end,
	
	["deathloc"] = function()
		GetCharacter().HumanoidRootPart.CFrame = LastDeathLocation
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
	["freeze"] = "(player)| You freeze without being able to move",
	["thaw"] = "(player)| Unfreeze",
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
	["nocdlimit"] = "| Remove any Click Detector's activation limit",
	["potatographics"] = "| Your game will look like a 1998 game, dont blame me",
	["drugs"] = "| yes",
	["backtrack"] = "| Makes you lag behind; 0 to revert",
	["fastbhop"] = "(number) | I dont know how to explain this one",
	["bhop"] = "| You jump when you land",
	["changestate"] = "| You change your Humanoid's state",
	["enable"] = "| Backpack, Chat, Playerlist, Health",
	["disable"] = "| Backpack, Chat, Playerlist, Health",
	["deathloc"] = "| You teleport back to where you died"
	
}
-- [[ COMANDOS ]] --

-- obrigado ao remfly

function ForceJump()
	commands.jump()
end

function Rejoin()
	commands.rejoin()
end

function CountCommands()
	local index = 0
	
	for i,v in pairs(commands) do
		index = index + 1
	end
	
	SendNotification({
		Title = "Creamfood",
		Text = "Quantidade de comandos: " .. tostring(index),
		Duration = 5
	})
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

local function CreateInstance(cls,props)
	local inst = Instance.new(cls)
	for i,v in pairs(props) do
		inst[i] = v
	end
	return inst
end

local StartPage = CreateInstance('ScreenGui',{DisplayOrder=0,Enabled=true,ResetOnSpawn=true,Name='StartPage', Parent=hui() or game.CoreGui})
local Start = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.117647, 0.117647, 0.117647),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.30462727, 0, 0.28957057, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 608, 0, 342),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'Start',Parent = StartPage})
local Start_Label = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size32,Text='Creamfood',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=30,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.335526317, 0, 0.22807017, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 200, 0, 50),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='Start_Label',Parent = Start})
local Start_Button = CreateInstance('TextButton',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size24,Text='Start',TextColor3=Color3.new(0, 0, 0),TextScaled=false,TextSize=20,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0, 0.611765, 0.521569),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.375, 0, 0.526315808, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 152, 0, 38),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='Start_Button',Parent = Start})
local branch = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size24,Text='Dev Branch',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=20,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.773026288, 0, 0.903508782, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 138, 0, 33),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='branch',Parent = Start})
local credits = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size24,Text='Contact me at navet#2416',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=20,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 0, 0.903508782, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 185, 0, 33),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='credits',Parent = Start})
local Main = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.117647, 0.117647, 0.117647),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.151046276, 0, 0.369503051, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 608, 0, 342),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=false,ZIndex=1,Name = 'Main',Parent = StartPage})
local Main_label = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size28,Text='Creamfood',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=25,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.016447369, 0, 0, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 120, 0, 50),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='Main_label',Parent = Main})
local CommandsPanel = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.117647, 0.117647, 0.117647),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.279605269, 0, 0.201754376, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 426, 0, 259),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'CommandsPanel',Parent = Main})
local CMDS_SF = CreateInstance('ScrollingFrame',{BottomImage='rbxasset://textures/ui/Scroll/scroll-bottom.png',CanvasPosition=Vector2.new(0, 0),CanvasSize=UDim2.new(0, 0, 15, 0),MidImage='rbxasset://textures/ui/Scroll/scroll-middle.png',ScrollBarThickness=12,ScrollingEnabled=true,TopImage='rbxasset://textures/ui/Scroll/scroll-top.png',Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0941176, 0.0941176, 0.0941176),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0, 0, 0, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 426, 0, 212),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='CMDS_SF',Parent = CommandsPanel})
local CMDS_LABEL = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=16,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 0, 0, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 413, 0, 3884),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='CMDS_LABEL',Parent = CMDS_SF})
local TextBox = CreateInstance('TextBox',{ClearTextOnFocus=true,Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size24,MultiLine=false,Text='',TextColor3=Color3.new(1, 1, 1), PlaceholderText='', PlaceholderColor3=Color3.new(0.7, 0.7, 0.7),TextScaled=false,TextSize=20,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0941176, 0.0941176, 0.0941176),BackgroundTransparency=0,BorderColor3=Color3.new(0.137255, 0.137255, 0.137255),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 0, 0.849420965, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 426, 0, 39),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='TextBox',Parent = CommandsPanel})
local Commands = CreateInstance('TextButton',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size28,Text='Commands',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=25,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.117647, 0.117647, 0.117647),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.016562663, 0, 0.204678357, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 150, 0, 50),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='Commands',Parent = Main})
local Frame = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0, 0.611765, 0.521569),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.016447369, 0, 0.146198824, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 589, 0, 4),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'Frame',Parent = Main})
local ChatLogger = CreateInstance('TextButton',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size28,Text='Chat Logger',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=25,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.117647, 0.117647, 0.117647),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.0159999952, 0, 0.386257321, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 150, 0, 50),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='ChatLogger',Parent = Main})
local ChatLoggerPanel = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.117647, 0.117647, 0.117647),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.279605269, 0, 0.201754376, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 426, 0, 259),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=false,ZIndex=1,Name = 'ChatLoggerPanel',Parent = Main})
local CL_SF = CreateInstance('ScrollingFrame',{BottomImage='rbxasset://textures/ui/Scroll/scroll-bottom.png',CanvasPosition=Vector2.new(0, 0),CanvasSize=UDim2.new(0, 0, 15, 0),MidImage='rbxasset://textures/ui/Scroll/scroll-middle.png',ScrollBarThickness=12,ScrollingEnabled=true,TopImage='rbxasset://textures/ui/Scroll/scroll-top.png',Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0941176, 0.0941176, 0.0941176),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0, 0, 0, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 426, 0, 216),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='CL_SF',Parent = ChatLoggerPanel})
CL_label = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size14,Text='',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 0, 0, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 413, 0, 3884),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='CL_label',Parent = CL_SF})
local Main_label2 = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size24,Text='Dev Branch',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=20,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.049342107, 0, 0.926900566, 0),Rotation=0,Selectable=false,Size=UDim2.new(0, 109, 0, 25),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='Main_label2',Parent = Main})
local save = CreateInstance('TextButton',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size14,Text='Save to .txt file',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0941176, 0.0941176, 0.0941176),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.779342711, 0, 0.877570212, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 94, 0, 31),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='save',Parent = ChatLoggerPanel})
local clear = CreateInstance('TextButton',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size14,Text='Clear',TextColor3=Color3.new(1, 1, 1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0941176, 0.0941176, 0.0941176),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.521126747, 0, 0.877570212, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 94, 0, 31),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='clear',Parent = ChatLoggerPanel})

Main.Draggable = true

Start_Button.MouseButton1Click:Connect(function()
	Start.Visible = false
	Main.Visible = true
end)

ChatLogger.MouseButton1Click:Connect(function()
	CommandsPanel.Visible = false
	ChatLoggerPanel.Visible = true
end)

Commands.MouseButton1Click:Connect(function()
	CommandsPanel.Visible = true
	ChatLoggerPanel.Visible = false
end)

for i,v in pairs (commands) do		
	if usage[tostring(i)] then
		CMDS_LABEL.Text = CMDS_LABEL.Text .. "\n" .. tostring(i) .. " " .. usage[tostring(i)]
	else
		CMDS_LABEL.Text = CMDS_LABEL.Text .. "\n" .. tostring(i) .. " " .. "| No description or I have to add one"
	end
end

--------------------------------------------

CAS:BindAction("Focus", function()
	if CommandsPanel.Visible then
		TextBox:CaptureFocus()
		game:GetService("RunService").RenderStepped:Wait()
		TextBox.Text = ""
	end
end, false, Enum.KeyCode.RightBracket)

TextBox.FocusLost:Connect(function(enter)
	if enter then
		RCMD(TextBox.Text)
		TextBox.Text = ""
	end
end)

character.Humanoid.Died:Connect(function()
	LastDeathLocation = rootpart.CFrame
	lp.CharacterAdded:Wait()
	
	
	if noclipping then
		commands:clip()
	end
	
	if nositting then
		commands:unnosit()
	end
end)
