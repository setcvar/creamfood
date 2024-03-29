--[[

example

addcmd ("name", {
	['needs_player'] = true or false
	['func'] = function,
	['alias'] = 'yeet',
	['parts'] = {},
	['events'] = {},
	['connections'] = {},
	['players'] = {}
})
}

]]

local commands = {}

-- constants
local PLAYERS: Players = game:GetService ("Players")
local LOCALPLAYER: Player = PLAYERS.LocalPlayer
local CHARACTER = LOCALPLAYER.Character or LOCALPLAYER.CharacterAdded:Wait()
local GUI: ScreenGui
-- constants

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	PLAYERS = game:GetService ("Players")
	LOCALPLAYER = PLAYERS.LocalPlayer
	CHARACTER = character
end)

-- properties can be anything you want, just be sure that it has at least ['func'] or ["func"]
function addcmd (cmd: string, properties: table)
	commands[cmd] = properties
end

addcmd ("print", {
	['needs_player'] = false,
	['func'] = function(hiimatext: table)
		print(hiimatext.text)
	end,
	['alias'] = 'p',
})

addcmd ('speed', {
	['needs_player'] = false,
	['alias'] = 'ws',
	['func'] = function( imtable: table )
		CHARACTER.Humanoid.WalkSpeed = tonumber(imtable.text)
	end
})

addcmd ('jumppower',{
	['alias'] = 'jp',
	['needs_player'] = false,
	['func'] = function(imtable: table)
		CHARACTER.Humanoid.JumpPower = tonumber(imtable.text)
	end
})

addcmd ('maxfps', {
	['alias'] = nil,
	['needs_player'] = false,
	['func'] = function (imtable: table)
		local setmaxfps = setmaxfps or set_fps_cap or setfpscap
		if setmaxfps then
			local number = tonumber(imtable.text)
			setmaxfps(number)
		end
	end
})

addcmd ('antiafk', {
	['events'] = {},
	['needs_player'] = false,
	['func'] = function ()
		local antiafk = LOCALPLAYER.Idled:Connect(function()
			for index, value in ipairs (getconnections(LOCALPLAYER.Idled)) do
				value:Disable()
				value:Disconnect()
			end
		end)
		table.insert(commands.antiafk.events, antiafk)
	end,
})

addcmd ('unantiafk', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.antiafk.events) do
			value:Disconnect()
		end
		table.clear (commands.antiafk.events)
	end
})

addcmd ('spin', {
	['alias'] = 'angularvelocity',
	['needs_player'] = false,
	['events'] = {},
	['func'] = function(imtable: table)
		local bav = Instance.new ('BodyAngularVelocity')
		bav.Parent = CHARACTER.HumanoidRootPart or CHARACTER:WaitForChild ('HumanoidRootPart')
		bav.AngularVelocity = Vector3.new (0, tonumber(imtable.text), 0)
		bav.MaxTorque = Vector3.new (0, math.huge, 0)
		table.insert(commands.spin.events, bav)
	end
})

addcmd ('unspin', {
	['alias'] = 'unangularvelocity',
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.spin.events) do
			value:Destroy()
		end
		table.clear (commands.spin.events)
	end
})

addcmd ('rejoin', {
	['needs_player'] = false,
	['func'] = function()
		LOCALPLAYER:Kick()
    	task.wait(0.3)
    	if #PLAYERS:GetPlayers() <= 1 then
        	game:GetService ( "TeleportService" ):Teleport ( game.PlaceId, LOCALPLAYER )
    	else
        	game:GetService ( 'TeleportService' ):TeleportToPlaceInstance ( game.PlaceId, game.JobId, LOCALPLAYER )
    	end
	end
})

addcmd ('loadfile', {
	['needs_player'] = false,
	['func'] = function(imtable: table)
		if loadfile then
			loadfile(imtable.text)()
		end
	end
})

addcmd ('runcode', {
	['alias'] = 'rc',
	['needs_player'] = false,
	['func'] = function (imtable:table): string
		loadstring (imtable.text)()
	end
})

addcmd ('hitbox', {
	['alias'] = 'collisions',
	['needs_player'] = false,
	['events'] = {},
	['func'] = function(): nil
		for index, value in ipairs (workspace:GetDescendants()) do
			if value:IsA'BasePart' then
				local box = Instance.new ('SelectionBox')
				table.insert (commands.hitbox.events, box)
				box.Parent = value
				box.LineThickness = 0.015
				box.Adornee = value
				if value.Transparency > 0 then
					box.Color3 = Color3.fromRGB (255, 201, 252)
				else
					box.Color3 = Color3.fromRGB (201,248,255)
				end
			end
		end
	end
})

addcmd ('unhitbox', {
	['alias'] = 'uncollisions',
	['needs_player'] = false,
	['func'] = function(): nil
		for index, value in ipairs (commands.hitbox.events) do
			value:Destroy()
		end
		table.clear(commands.hitbox.events)
	end
})

addcmd ('cmds', {
	['alias'] = 'help',
	['needs_player'] = false,
	['func'] = function ()
		table.foreach (commands, function (key, value)
			print (key, value.alias)
		end)
	end
})

addcmd ('noclip', {
	['alias'] = 'nc',
	['needs_player'] = false,
	['events'] = {},
	['connections'] = {},
	['func'] = function ()
		for index, value in ipairs (CHARACTER:GetDescendants()) do
			if value:IsA'BasePart' and value.CanCollide == true then
				table.insert (commands.noclip.events, value)
			end
		end

		table.insert (commands.noclip.connections,game:GetService("RunService").Stepped:Connect (function()
			for index, value in ipairs (commands.noclip.events) do
				value.CanCollide = false
			end
		end) )
	end
})

addcmd ('clip', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.noclip.events) do
			value.CanCollide = true
		end
		
		for index, value in ipairs (commands.noclip.connections) do
			value:Disconnect()
		end

		table.clear (commands.noclip.connections)
		table.clear (commands.noclip.events)
	end
})

addcmd ('jump', {
	['needs_player'] = false,
	['func'] = function()
		CHARACTER.Humanoid:ChangeState ( Enum.HumanoidStateType.Jumping )
	end
})

addcmd ('sit', {
	['needs_player'] = false,
	['func'] = function()
		CHARACTER.Humanoid.Sit = true
	end
})

addcmd ('rainbow', {
	['alias'] = 'rainbow_world',
	['needs_player'] = false,
	['func'] = function()
		local fancymath = LOCALPLAYER.AccountAge + LOCALPLAYER.UserId + workspace.GlobalWind.Magnitude + workspace.Gravity
		local rand = Random.new (fancymath)
		for index, value in ipairs (workspace:GetDescendants()) do
			if value:IsA'BasePart' then
				value.Color = Color3.fromRGB (rand:NextNumber(0, 255), rand:NextNumber(0,255), rand:NextNumber(0,255))
			end
		end
	end
})

addcmd ('notify', {
	['needs_player'] = false,
	['alias'] = 'fakechat',
	['func'] = function(imtable: table)
		Notify (imtable.text)
	end
})

addcmd ('goto', {
	['alias'] = 'to',
	['needs_player'] = true,
	['func'] = function(imtable: table)
		for index, value in ipairs (imtable.playerobjects) do
			CHARACTER.HumanoidRootPart.CFrame = value.Character.HumanoidRootPart.CFrame
		end
	end
})

addcmd ('firecds', {
	['alias'] = 'fireclickdetectors',
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (workspace:GetDescendants()) do
			if value:IsA'ClickDetector' then
				fireclickdetector (value)
			end
		end
	end
})

addcmd ('view', {
	['needs_player'] = true,
	['connections'] = {},
	['func'] = function (imtable: table)
		for index, value in ipairs (imtable.playerobjects) do
			workspace.CurrentCamera.CameraSubject = value.Character.Humanoid
			
			table.insert(commands.view.connections, value.Character.Humanoid.Died:Connect(function()
				workspace.CurrentCamera.CameraSubject = LOCALPLAYER.Character.Humanoid
			end))
		end
	end
})

addcmd ('infjump', {
	['needs_player'] = false,
	['func'] = function()

		game:GetService("ContextActionService"):BindAction("JUMPFOREVERYEEEEEEEEEEEEEEEEEEEE", function(actionName, state, object)
			if state == Enum.UserInputState.Begin then
				CHARACTER.Humanoid:ChangeState (Enum.HumanoidStateType.Jumping)
			end
		end, false, Enum.KeyCode.Space)
	end
})


addcmd ('uninfjump', {
	['needs_player'] = false,
	['func'] = function()
		game:GetService"ContextActionService":UnbindAction("JUMPFOREVERYEEEEEEEEEEEEEEEEEEEE")
	end
})

addcmd ('nosit', {
	['needs_player'] = false,
	['events'] = {},
	['func'] = function()
		table.insert (commands.nosit.events, CHARACTER.Humanoid.Seated:Connect(function(seated)
			if seated then
				CHARACTER.Humanoid:ChangeState (Enum.HumanoidStateType.Jumping)
			end
		end))
	end
})

addcmd ('unnosit', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.nosit.events) do
			value:Disconnect()
		end

	end
})

addcmd ('makewaypoint', {
	['alias'] = 'mkwp',
	['waypoints'] = {},
	['needs_player'] = false,
	['func'] = function(imtable: table)
		local currentCFrame = CHARACTER.HumanoidRootPart.CFrame
		commands.makewaypoint.waypoints[imtable.text] = currentCFrame
		-- make garbage collector free it
		currentCFrame = nil
	end
})

addcmd ('gotowaypoint', {
	['alias'] = 'gotowp',
	['needs_player'] = false,
	['func'] = function(imtable)
		table.foreach (commands.makewaypoint.waypoints, function(key, value)
			if key == imtable.text then
				CHARACTER.HumanoidRootPart.CFrame = value
			end
		end)
	end
})

addcmd ('removewaypoint', {
	['alias'] = 'rmwp',
	['needs_player'] = false,
	['func'] = function(imtable)
		local waypoints: table = commands.makewaypoint.waypoints
		waypoints[imtable.text] = nil
	end
})

addcmd ('pathtowaypoint', {
	['alias'] = 'pathwp',
	['needs_player'] = false,
	['parts'] = {},
	['func'] = function(imtable: table)
		local pathfinding = game:GetService("PathfindingService")

		local path = pathfinding:CreatePath({
			AgentRadius = 2.0,
			AgentHeight = 5.0,
			AgentCanJump = true,
		})
		local wp = commands.makewaypoint.waypoints[imtable.text].Position
		local points
		local success, result = pcall (function()path:ComputeAsync(CHARACTER.HumanoidRootPart.Position, wp )end)

		if success and path.Status == Enum.PathStatus.Success then
			points = path:GetWaypoints()
		end

		for index, value in ipairs (points) do
			local part = Instance.new("Part")
			part.Parent = workspace
			part.Size = Vector3.one
			part.Color = Color3.new (1, 1, 1)
			part.CastShadow = false
			part.CanCollide = false
			part.Shape = Enum.PartType.Ball
			part.CanTouch = false
			part.CanQuery = false
			part.Anchored = true
			part.Material = Enum.Material.Neon
			part.Position = value.Position + Vector3.new (0, 3, 0)
			table.insert(commands.pathtowaypoint.parts, part)
		end

		task.delay (10, function()
			for index, value in ipairs (commands.pathtowaypoint.parts) do
				value:Destroy()
			end
			table.clear (commands.pathtowaypoint.parts)
		end)
	end
})

addcmd ('bhop', {
	['alias'] = 'bunnyhop',
	['events'] = {},
	['needs_player'] = false,
	['func'] = function()
		table.insert(commands.bhop.events, game:GetService("RunService").Heartbeat:Connect(function()
			if CHARACTER.Humanoid.Sit or CHARACTER.Humanoid.FloorMaterial ~= Enum.Material.Air then
				CHARACTER.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end))
	end
})

addcmd ('unbhop', {
	['alias'] = 'unbunnyhop',
	['func'] = function()
		for index, value in pairs (commands.bhop.events) do
			value:Disconnect()
		end
		table.clear (commands.bhop.events)
	end
})

addcmd ('hipheight', {
	['alias'] = 'hh',
	['needs_player'] = false,
	['func'] = function(imtable)
		CHARACTER.Humanoid.HipHeight = tonumber(imtable.text)
	end
})

addcmd ('randomspeed', {
	['alias'] = 'rs',
	['events'] = {},
	['needs_player'] = false,
	['func'] = function(imtable: table)
		table.insert (commands.randomspeed.events, game:GetService("RunService").RenderStepped:Connect(function()
			CHARACTER.Humanoid.WalkSpeed = math.random(16,200)
		end))
	end
})

addcmd ('unrandomspeed', {
	['alias'] = 'unrs',
	['needs_player'] = false,
	['func'] = function()
		for index, value in pairs (commands.randomspeed.events) do
			value:Disconnect()
		end
		table.clear (commands.randomspeed.events)
	end
})

addcmd ('togglegui', {
	['alias'] = 'tggui',
	['needs_player'] = false,
	['func'] = function()
		GUI.Enabled = not GUI.Enabled
	end
})

addcmd ('streamer', {
	['alias'] = 'streamermode',
	['needs_player'] = false,
	['events'] = {},
	['func'] = function()
		
		table.insert(commands.streamer.events, game:GetService('RunService').Heartbeat:Connect(function()
			for index, value in ipairs (PLAYERS:GetPlayers()) do
				value.Name = game:GetService('HttpService'):GenerateGUID (false)
				value.Character.Humanoid.DisplayName = game:GetService('HttpService'):GenerateGUID (false)
				value.Character.Humanoid.Died:Connect(function()
					value.Name = game:GetService('HttpService'):GenerateGUID (false)
					value.Character.Humanoid.DisplayName = game:GetService('HttpService'):GenerateGUID (false)
				end)
			end
	
			game.Players.PlayerAdded:Connect (function(player)
				player.CharacterAdded:Wait()
				player.Name = game:GetService('HttpService'):GenerateGUID (false)
				player.DisplayName = game:GetService('HttpService'):GenerateGUID (false)
				player.Character.Humanoid.Died:Connect(function()
					player.CharacterAdded:Wait()
					for index, value in pairs (player.Character:GetDescendants()) do
						if value:IsA'BasePart' then
							player.Name = game:GetService('HttpService'):GenerateGUID (false)
							player.DisplayName = game:GetService('HttpService'):GenerateGUID (false)
						end
					end
				end)
			end)
		end))

	end
})

addcmd ('unstreamer', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.streamer.events) do
			value:Disconnect()
		end
		table.clear (commands.streamer.events)
	end
})

addcmd ('togglerotate', {
	['alias'] = 'togglerot',
	['needs_player'] = false,
	['func'] = function()
		CHARACTER.Humanoid.AutoRotate = not CHARACTER.Humanoid.AutoRotate
	end
})

addcmd ('hidedisplaynames', {
	['needs_player'] = false,
	['events'] = {},
	['names'] = {},
	['func'] = function()
		for index, value in ipairs (PLAYERS:GetPlayers()) do
			table.insert (commands.nodisplaynames.names, value.Name..' '..value.DisplayName)
			value.DisplayName = value.Name
			value.Character.Humanoid.DisplayName = value.Name
		end

		table.insert (commands.nodisplaynames.events, PLAYERS.PlayerAdded:Connect(function(player)
			local character = player.Character or player.CharacterAdded:Wait()
			table.insert ( commands.nodisplaynames.names, player.Name.." "..player.DisplayName)
			player.DisplayName = player.Name
			if character then
				character.Humanoid.DisplayName = player.Name
			end
		end))
	end
})

addcmd ('showdisplaynames', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.nodisplaynames.names) do
			for index2, value2 in ipairs (PLAYERS:GetPlayers()) do
				local str = string.split (value, " ")
				if str[1] == value2.Name then
					value2.DisplayName = str[2]
					value2.Character.Humanoid.DisplayName = str[2]
				end
			end
		end
	end
})

addcmd ('freeze', {
	['needs_player'] = true,
	['parts'] = {},
	['func'] = function (imtable: table)
		local playernames = imtable.playernames
		local playerobjs = imtable.playerobjects

		for index, value in ipairs (playerobjs) do

			for _, value2 in ipairs (value.Character:GetDescendants()) do
				if value2:IsA'BasePart' and value2.Anchored == false then
					value2.Anchored = true
					table.insert (commands.freeze.parts, value2)
				end
			end

		end
	end
})

addcmd ('unfreeze', {
	['alias'] = 'thaw',
	['needs_player'] = false,
	['func'] = function()
		for index, value in pairs (commands.freeze.parts) do
			value.Anchored = false
		end
		table.clear (commands.freeze.parts)
	end
})

addcmd ('gravity', {
	['alias'] = 'grav',
	['needs_player'] = false,
	['func'] = function (imtable: table)
		game:GetService'Workspace'.Gravity = tonumber(imtable.text)
	end
})

addcmd ('fov', {
	['alias'] = 'changefov',
	['needs_player'] = false,
	['func'] = function(imtable: table)
		workspace.CurrentCamera.FieldOfView = tonumber (imtable.text)
	end
})

addcmd ('spam', {
	['alias'] = 'annoy',
	['needs_player'] = false,
	['events'] = {},
	['func'] = function(imtable: table)
		commands.spam.events.spamvar = true
		while commands.spam.events.spamvar do
			wait(3)
			game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer (imtable.text, 'All')
		end
	end
})

addcmd ('unspam', {
	['alias'] = 'unannoy',
	['needs_player'] = false,
	['func'] = function()
		table.clear(commands.spam.events)
	end
})

addcmd ('pmspam', {
	['alias'] = 'pmannoy',
	['needs_player'] = true,
	['events'] = {},
	['func'] = function(imtable: table)
		local playername = imtable[1]
		commands.pmspam.events.spamvar = true
		for index, value in ipairs (playername) do
			while commands.pmspam.events.spamvar do
				wait(3)
				game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer (imtable.text, value)
			end
		end
	end
})

addcmd ('unpmspam', {
	['alias'] = 'unpmannoy',
	['events'] = {},
	['func'] = function()
		table.clear(commands.pmspam.events)
	end
})

addcmd ('walkto', {
	['alias'] = 'pathfindwalk',
	['needs_player'] = true,
	['events'] = {},
	['func'] = function(imtable: table)
		local playernames = imtable.playernames
		local playerobjs = imtable.playerobjects
		
		local pathfinding = game:GetService'PathfindingService'
		local path = pathfinding:CreatePath({
			AgentRadius = 2.0,
			AgentCanJump = true,
			AgentHeight = 5.0
		})

		local waypoints, reached, blocked, nextindex

		for index, value in ipairs (playerobjs) do
			local success, result = pcall(function()
				path:ComputeAsync(CHARACTER.HumanoidRootPart.Position, value.Character.HumanoidRootPart.Position)
			end)

			if success and path.Status == Enum.PathStatus.Success then
				waypoints = path:GetWaypoints()
			end

			blocked = path.Blocked:Connect(function(blockedwaypoint)
				if blockedwaypoint >= nextindex then
					path.Unblocked:Wait()
				end
			end)
			table.insert (commands.walkto.events, blocked)

			if not reached then
				reached = CHARACTER.Humanoid.MoveToFinished:Connect(function(reached)
					if reached and nextindex < #waypoints then
						nextindex += 1
						CHARACTER.Humanoid:MoveTo (waypoints [nextindex].Position)
					else
						for index2, value2 in ipairs (commands.walkto.events) do
							value2:Disconnect()
						end
						table.clear (commands.walkto.events)
					end
				end)
				table.insert (commands.walkto.events, reached)
			end
			nextindex = 2
			CHARACTER.Humanoid:MoveTo (waypoints[nextindex].Position)

			for index, value in ipairs (waypoints) do
				local part = Instance.new("Part")
				part.Parent = workspace
				part.Size = Vector3.one
				part.Color = Color3.new (1, 1, 1)
				part.CastShadow = false
				part.CanCollide = false
				part.Shape = Enum.PartType.Ball
				part.CanTouch = false
				part.CanQuery = false
				part.Anchored = true
				part.Material = Enum.Material.Neon
				part.Position = value.Position + Vector3.new (0, 2.5, 0)

				game:GetService('Debris'):AddItem (part, #waypoints/2)
			end
		end
	end
})

addcmd ('unwalkto', {
	['alias'] = 'unpathfindwalkto',
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.walkto.events) do
			value:Disconnect()
		end
	end
})

addcmd ('shiftspeed', {
	['needs_player'] = false,
	['events'] = {},
	['func'] = function(imtable: table)
		commands.shiftspeed.events.speed = CHARACTER.Humanoid.WalkSpeed
		local number = tonumber(imtable.text)
		game:GetService('ContextActionService'):BindAction(
			'ILIKECHEESE',
			function(actionname, inputstate, inputobject)
				if inputstate == Enum.UserInputState.Begin then
					CHARACTER.Humanoid.WalkSpeed = number
				elseif inputstate == Enum.UserInputState.End then
					CHARACTER.Humanoid.WalkSpeed = commands.shiftspeed.events.speed
				end
			end,
		false,
		Enum.KeyCode.LeftShift)
	end
})

addcmd ('unshiftspeed', {
	['needs_player'] = false,
	['func'] = function()
		game:GetService('ContextActionService'):UnbindAction('ILIKECHEESE')
		CHARACTER.Humanoid.WalkSpeed = commands.shiftspeed.events.speed
		table.clear (commands.shiftspeed.events)
	end
})

addcmd ('tpunanchored', {
	['alias'] = 'tpun',
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (game:GetService('Workspace'):GetDescendants()) do
			if value:IsA'BasePart' and value.Anchored == false then
				value.Position = CHARACTER.HumanoidRootPart.Position
			end
		end
	end
})

addcmd ('rmcmd', {
	['alias'] = 'removecmd',
	['needs_player'] = false,
	['func'] = function(imtable: table)
		commands[imtable.text] = nil
	end
})

addcmd ('esp', {
	['alias'] = 'wallhack',
	['needs_player'] = false,
	['parts'] = {},
	['events'] = {},
	['func'] = function()
		local function CreateBox (object)
			local box = Instance.new ('BoxHandleAdornment')
			box.AlwaysOnTop = true
			box.Parent = object
			box.ZIndex = 10
			box.Transparency = 0.5
			box.Adornee = object
			box.Size = object.Size
			table.insert (commands.esp.parts, box)
			return box
		end

		table.foreach (PLAYERS:GetPlayers(), function(key, value)
			for useless, player in ipairs (value.Character:GetDescendants()) do
				if player.Name == 'Torso' then continue end
				if player:IsA'BasePart' then
					CreateBox (player)
				end
			end

			-- extremely inefficient and can lag on lower end devices, rewrite it later
			value:GetPropertyChangedSignal('TeamColor'):Connect(function()
				for key, object in pairs (commands.esp.events) do
					object:Destroy()
				end

				local character = value.Character or value.CharacterAdded:Wait()
				for _, object in pairs (character:GetDescendants()) do
					if object:IsA'BasePart' then
						CreateBox (object)
					end
				end
			end)

			table.insert(commands.esp.events, value.CharacterAdded:Connect(function(character)
				for useless, val in ipairs (character:GetDescendants()) do
					if val:IsA'BasePart' then
						CreateBox (val)
					end
				end
			end))
		end)

		table.insert (commands.esp.events, PLAYERS.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function(character)
				for index, value in ipairs (character:GetDescendants()) do
					if value:IsA'BasePart' and value.Name ~= 'Torso' then
						CreateBox (value)
					end
				end
			end)
		end))
	end
})

addcmd ('unesp', {
	['alias'] = 'unwallhack',
	['needs_player'] = false,
	['func'] = function()
		table.foreach (commands.esp.parts, function(key, value)
			value:Destroy()
			value = nil
		end)

		table.foreach (commands.esp.events, function(key, value)
			value:Disconnect()
			value = nil
		end)

		table.clear (commands.esp.events)
		table.clear (commands.esp.parts)
	end
})

addcmd ('xray', {
	['needs_player'] = false,
	['connections'] =  {},
	['parts'] = {},
	['func'] = function()
		for index, value in ipairs (workspace:GetDescendants()) do
			if value:IsA('BasePart') then
				table.insert(commands.xray.parts, value)
				value.Transparency = 0.5
			end
		end

		table.insert(commands.xray.connections,workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA'BasePart' then
				descendant.Transparency = 0.5
			end
		end))
	end
})

addcmd ('unxray', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.xray.parts) do
			value.Transparency = 0
		end

		for index, value in ipairs (commands.xray.connections) do
			value:Disconnect()
		end
	end
})

-- not real backtracking, consider storing the player position every frame with RenderStepped then creating a new
-- object with the stored position ( possibly laggy after some time, consider using Debris:AddItem)
addcmd ('backtrack', {
	['needs_player'] = false,
	['func'] = function(imtable: table)
		local number = tonumber(imtable.text)
		game:GetService'NetworkSettings'.IncomingReplicationLag = number
	end
})

addcmd ('plugin', {
	['alias'] = {'addplugin'},
	['needs_player'] = false,
	['plugins'] = {},
	['func'] = function(imtable: table)
		local fileName: string = imtable.text
		local plugin: table = loadfile (fileName)() -- returns a table
		for index, value in ipairs (plugin) do
			commands[value.Name] = value.Properties
		end
		table.insert (commands.plugin.plugins, plugin)
	end
})

addcmd ('removeplugin', {
	['alias'] = {'rmplugin'},
	['needs_player'] = false,
	['func'] = function(imtable: table)
		local name = imtable.text
		for index, value in ipairs (commands.plugin.plugins) do
			if value.Name == name then
				commands[value.Name] = nil
			end
		end
	end
})

addcmd ('fog', {
	['alias'] = 'setfog',
	['needs_player'] = false,
	['func'] = function(imtable: table)
		local number = tonumber(imtable.text)
		game.Lighting.FogStart = number
	end
})

addcmd ('copyname', {
	['alias'] = {'copyplayername'},
	['needs_player'] = true,
	['func'] = function(imtable: table)
		local playernames = imtable.playernames
		if #playernames == 1 then
			setclipboard (playernames[1])
		else
			setclipboard (table.concat(playernames,', '))
		end
	end
})

addcmd ('slopeangle', {
	['alias'] = {'maxslopeangle'},
	['needs_player'] = false,
	['func'] = function(imtable: table)
		local number = tonumber(imtable.text)
		CHARACTER.Humanoid.MaxSlopeAngle = number
	end
})

addcmd ('tpdir', {
	['alias'] = {},
	['needs_player'] = false,
	['events'] = {},
	['func'] = function()
		table.insert(commands.tpdir.events, game:GetService('RunService').RenderStepped:Connect(function()
			CHARACTER.HumanoidRootPart.CFrame += CHARACTER.Humanoid.MoveDirection
		end))
	end
})

addcmd ('untpdir', {
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.tpdir.events) do
			value:Disconnect()
		end
	end
})

addcmd ('freezeunanchored', {
	['alias'] = {'freezeua'},
	['needs_player'] = false,
	['parts'] = {},
	['func'] = function()
		for index, value in ipairs (workspace:GetDescendants()) do
			if value:IsA('BasePart') and value.Anchored == false then
				value.Anchored = true
				table.insert(commands.freezeunanchored.parts, value)
			end
		end
	end
})

addcmd ('thawua', {
	['alias'] = {'thawua'},
	['needs_player'] = false,
	['func'] = function()
		for index, value in ipairs (commands.freezeunanchored.parts) do
			value.Anchored = false
		end
	end
})

addcmd ('joinlogs', {
	['alias'] = {},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		table.insert (commands.joinlogs.connections, PLAYERS.PlayerAdded:Connect(function(player)
			Notify (player.Name .. ' joined', Color3.new(0, 1, 0.368627))
		end))
	end
})

addcmd ('unjoinlogs', {
	['alias'] = {},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		for key, value in pairs (commands.joinlogs.connections) do
			value:Disconnect()
		end
		table.clear(commands.joinlogs.connections)
	end
})

addcmd ('leavelogs', {
	['alias'] = {'exitlogs', 'quitlogs'},
	['needs_player'] = false,
	['connections'] = {},
	['func'] = function()
		table.insert (commands.leavelogs.connections, PLAYERS.PlayerRemoving:Connect(function(player)
			Notify (player.Name .. ' left', Color3.new(0.721568, 0, 0))
		end))
	end
})

addcmd ('unleavelogs', {
	['alias'] = {'unexitlogs','unquitlogs'},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		for key, value in pairs (commands.leavelogs.connections) do
			value:Disconnect()
		end
		table.clear(commands.leavelogs.connections)
	end
})


addcmd ('friendlogs', {
	['alias'] = {},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		table.insert (commands.friendlogs.connections, PLAYERS.PlayerAdded:Connect(function(player)
			if player:IsFriendsWith(LOCALPLAYER.UserId) then
				Notify (player.Name .. ' joined', Color3.new(0, 0.898039, 1))
			end
		end))
	end
})

addcmd ('unfriendlogs', {
	['alias'] = {},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		for key, value in pairs (commands.friedlogs.connections) do
			value:Disconnect()
		end
		table.clear(commands.friendlogs.connections)
	end
})

addcmd ('whisperlogs', {
	['alias'] = {},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		local chatevents = game.ReplicatedStorage:WaitForChild ("DefaultChatSystemChatEvents", math.huge)
		table.insert(commands.whisperlogs.connections,chatevents:WaitForChild ("OnMessageDoneFiltering", math.huge).OnClientEvent:Connect (function(data)
			if data ~= nil then
				local player = tostring (data.FromSpeaker)
				local message = tostring (data.Message)
				local channel = tostring (data.OriginalChannel)
				
				if string.find (channel, "To ") then
					message = "/w " .. string.gsub (channel, "To", "") .. message
					Notify (player..message, Color3.new(0.674509, 0.368627, 1))
				end
	
				if channel == "Team" then
					message = "/team " .. message
					Notify ('['..player..']: '.. message, Color3.new(0.662745, 0.345098, 1))
				end
	
			end
		end))
	end
})

addcmd ('unwhisperlogs', {
	['alias'] = {},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		for key, value in pairs (commands.whisperlogs.connections) do
			value:Disconnect()
		end
		table.clear(commands.whisperlogs.connections)
	end
})

addcmd ('tptocamera', {
	['alias'] = {'gotocamera'},
	['connections'] = {},
	['needs_player'] = false,
	['func'] = function()
		CHARACTER.HumanoidRootPart.CFrame = workspace.CurrentCamera.CFrame
	end
})

addcmd ('chatage', {
	['needs_player'] = true,
	['func'] = function(imtable: table)
		local playerobjects = imtable.playerobjects
		for key, value in pairs (playerobjects) do
			game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer (value.Name .. ' is '.. value.AccountAge .. 'days old', 'All')
		end
	end
})

addcmd ('notifyage', {
	['needs_player'] = true,
	['func'] = function(imtable: table)
		for key, value in pairs (imtable.playerobjects) do
			Notify (value.Name..' is '..value.AccountAge..' days old', Color3.new(1, 0, 0.584313))
		end
	end
})

-- message: string, color: Color3, size: number
function Notify (...)
	local args = {...}
	local message: string
	local color: Color3
	local size: number

	message = tostring(args[1])
	color = args[2] or Color3.fromRGB (255,255,255)
	size = args[3] or 18

	game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = message,
        Color = color,
        FontSize = Enum.FontSize["Size" .. tostring(size)]
    })
end

function findplayer (playername: string): table
	local name: table = {}
	local obj: table = {}

	
	-- check to see if its $random which means select a random player
	-- using $ for the rare cases the player has 'random' in their name
	local plrnm: string = string.gsub(playername, '%$', '', 1)
	if plrnm == 'random' then
		-- get all players
		local getplayers = PLAYERS:GetPlayers()
		-- use math.random to select a random index starting from 1 to the length of getplayers
		local random_index = math.random(1,#getplayers)
		local player = getplayers[random_index]
		table.insert (name, player.Name)
		table.insert (obj, player)
		plrnm = nil
		return name, obj
	end

	local playernames = string.split (playername, ',')
	for key, player in pairs (PLAYERS:GetPlayers()) do
		for index, value in pairs (playernames) do
			if string.lower (player.Name):match ("^" .. string.lower(value)) or
			string.lower(player.Character.Humanoid.DisplayName):match("^" .. string.lower(value)) then
				table.insert (name, player.Name)
				table.insert (obj, player)
			end
		end
	end

	-- if everyone then just return every name and instance
	if playername == 'all' then
		for index, value in ipairs (PLAYERS:GetPlayers()) do
			table.insert (name, value.Name)
			table.insert (obj, value)
		end
		return name, obj
	end
	
	-- if others then return everyone except you
	if playername == 'others' then
		for index, value in ipairs (PLAYERS:GetPlayers()) do
			-- continue makes this one be skipped
			if value == LOCALPLAYER then
				continue
			end
			table.insert (name, value.Name)
			table.insert (obj, value)
		end
		return name, obj
	end

	if playername == 'me' then
		table.insert (name, LOCALPLAYER.Name)
		table.insert (obj, LOCALPLAYER)
		return name, obj
	end

	-- find the player and return it
	for index, value in ipairs (PLAYERS:GetPlayers()) do
		if string.lower (value.Name):match ("^" .. string.lower (playername)) then
			table.insert (name, value.Name)
			table.insert (obj, value)
		end
	end

	for index, value in ipairs (PLAYERS:GetPlayers()) do
		if string.lower (value.DisplayName):match ("^" .. string.lower(playername)) or
		string.lower(value.Character.Humanoid.DisplayName):match("^" .. string.lower(playername)) then
			table.insert (name, value.Name)
			table.insert (obj,value)
		end
	end
	
	return name, obj
end

local function runcmd (cmd: string): boolean
	local list = {}

	for word in string.gmatch (cmd, "%g+") do
		table.insert (list, tostring(word))
	end

	local command = string.lower(list[1])

	local arguments = {}

    if not commands[command] then return end

    for key, value in pairs (commands[command]) do
        if key == 'needs_player' and value == true then
            arguments.playernames,arguments.playerobjects = findplayer(list[2])
		    arguments.text = table.concat(list, ' ', 3)
			arguments.split = string.split (table.concat(list, ' ', 3), ' ')
            else
            arguments.text = table.concat (list, ' ', 2)
			arguments.split = string.split(table.concat (list, ' ', 2), ' ')
        end
    end

	local success, result = pcall ( coroutine.wrap (function ()
		commands[command].func (arguments)
		table.clear (list)
		table.clear (arguments)
	end) )
	return success, result
end

local ScreenGui: ScreenGui = Instance.new ("ScreenGui")
GUI = ScreenGui
ScreenGui.Parent = gethui() or game.CoreGui
ScreenGui.ResetOnSpawn = false

local Frame: Frame = Instance.new ("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB (98, 220, 184)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new (0.295,0,0,35)
Frame.Position = UDim2.new (0.35, 0, 0.844, 0)

local TextBox: TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new (0,0,0,0)
TextBox.Size = UDim2.new (1,0, 0, 33)
TextBox.PlaceholderText = "cmds"
TextBox.TextColor3 = Color3.fromRGB (255,255,255)
TextBox.Text = ""

game:GetService ("ContextActionService"):BindAction (
	"Focus",
	function()
		TextBox:CaptureFocus()
		spawn (function()
			repeat TextBox.Text = "" until TextBox.Text == ""
		end)
	end,
	false,
	Enum.KeyCode.RightBracket
)

TextBox.FocusLost:Connect (
	function (key)
		if key then
			runcmd (TextBox.Text)
			TextBox.Text = ""
		end
	end
)

Notify ('Use F9 to view commands for now')
