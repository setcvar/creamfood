local commands = {}
local alias = {}
local events = {}

local function mAddCMD(cmd , data)
    table.insert(commands, data)
end

local function addcmd(cmd, _alias, callback)
    commands[cmd] = callback
	if _alias == "" then return end
    alias[_alias] = cmd
end

local function Notification (message, color, size)
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = message,
        Color = color,
        FontSize = size
    })
end

local function ICommand (command) 
    local list = {}

    for word in string.gmatch(command, "%g+") do
            table.insert(list, tostring(word))
    end

    local cmd = list[1]
    if not cmd == commands[cmd] then
            for index, value in pairs (alias) do
                    if index == cmd then
                            cmd = value
                            return
                    end
            end
    end

    table.remove(list,1)

    local arguments = table.concat(list, " ")
    print(arguments)

    --local f = coroutine.wrap(function() commands[cmd](arguments) end)
    local success, errMessage = pcall( coroutine.wrap (function() commands[cmd](arguments) end) )
    if success then return end
    if errMessage then
        Notification ("Oops, something is not right. Error message: " .. tostring (errMessage), Color3.fromRGB(200,0,0), Enum.FontSize.Size18)
        return
    end
    
end

local function GetPlayer(Name)
	for _,v in ipairs(game.Players:GetPlayers()) do

		if string.lower(v.Name):match("^" .. string.lower(Name)) then
			return v
		end

	end
    Notification ("Couldn't find player!", Color3.fromRGB(200,0,0), Enum.FontSize.Size18)
	return nil
end

local function findcommand(cmd_name)
    for i,v in pairs (commands) do
        if tostring(i) == tostring(cmd_name) then
            print("true "..i)
            return true

        else
            for index, value in pairs (alias) do
                --if value = i
            end
        end
    end
    return false
end

local function FindPlayer ( PLAYERNAME )
    if PLAYERNAME == "me" then
        return game.Players.LocalPlayer

    elseif PLAYERNAME == "others" then
        return 0

    elseif PLAYERNAME == "all" then
        return 1
    end
end

local function _print ( _string )
    print ( _string )
end

local function walkspeed ( int )
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = int
end

local function jumppower ( int )
    if tonumber(int) <= 0 then int = game.Players.LocalPlayer.Character.Humanoid.JumpPower end
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber ( int )
end

local function setmaxfps ( int )
    if setfpscap then
        setfpscap ( int )
    end
end

local function antiafk ( )
    antiafk = game.Players.LocalPlayer.Idled:Connect(function()
        for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
            v:Disable()
            v:Disconnect()
        end
    end)
    table.insert(events, "antiafk")
end

local function unantiafk ( )
    if events.antiafk then antiafk:Disconnect() end
    table.remove(events, table.find(events, "antiafk"))
end

local function spin( int )
    local BodyAngularVelocity = Instance.new( "BodyAngularVelocity" )
    BodyAngularVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    BodyAngularVelocity.AngularVelocity = Vector3.new( 0, tonumber( int ), 0 )
    BodyAngularVelocity.MaxTorque = Vector3.new( 0, math.huge, 0 )
    table.insert( events, "spin" )
end

local function unspin ( )
    game.Players.LocalPlayer.Character.HumanoidRootPart.BodyAngularVelocity:Destroy()
    table.remove(events, table.find(events, "spin"))
end

local function clearevents ( )
    for index, value in pairs ( events ) do
        if value:IsA ( "Connection" ) or value:IsA ( "RBXScriptConnection" ) then value:Disconnect(); table.remove ( events, index ); continue end
        table.remove ( events, index )
    end
end

local function highgraphics ( )
    local link = "https://raw.githubusercontent.com/GTX1O8OTi/Graphics/experimental/new.lua"
    --loadstring(game:HttpGet("https://raw.githubusercontent.com/GTX1O8OTi/Graphics/experimental/new.lua", true))()
    local r = request ( {
        Url = link,
        Method = "GET"
    } )

    if not request then loadstring ( game:HttpGet (link) )(); return end
    loadstring ( r.Body ) ( )
end

local function noclip ( )
    local function _noclip ( )
        for index, value in pairs (game.Players.LocalPlayer.Character:GetDescendants()) do
            if value:IsA("BasePart") and value.CanCollide == true then
                value.CanCollide = false
            end
        end
    end
    getgenv().__noclip = game:GetService("RunService").Stepped:Connect(_noclip)
    table.insert( events, "noclip" )
end

local function clip ( )
    local event = table.find( events, "noclip" )
    if event then getgenv().__noclip:Disconnect() end
end

local function changestate ( state )
    game.Players.LocalPlayer.Character.Humanoid:ChangeState( Enum.HumanoidStateType [ state ] )
end

local function jump ( )
    game.Players.LocalPlayer.Character.Humanoid:ChangeState( Enum.HumanoidStateType.Jumping )
end

local function sit ( )
    game.Players.LocalPlayer.Character.Humanoid.Sit = true
end

local function colorful_world ( )
    math.randomseed ( game.Players.LocalPlayer.UserId + (100 / 2 * 6 + 2 - 1) + (math.random ( 0, math.random ( 0, 49604212 ) ) * 0.5 ) - 6 )
    for index, value in pairs ( workspace:GetDescendants() ) do
        if value:IsA ( "BasePart" ) or value:IsA ( "Part" ) then
            value.Color3 = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )
        end
    end
end

local function drugs ( )
    math.randomseed ( game.Players.LocalPlayer.UserId + (100 / 2 * 6 + 2 - 1) + (math.random ( 0, math.random ( 0, 49604212 ) ) * 0.5 ) - 6 )
    for index, value in pairs ( workspace:GetDescendants() ) do
        if value:IsA ( "BasePart" ) or value:IsA ( "Part" ) then
            value.Color = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )
        end
    end
    for i,v in pairs ( game.Lighting:GetDescendants() ) do
        if v:IsA ( "Atmosphere" ) or v:IsA ( "Sky" ) then v:Destroy() end
        Instance.new("Atmosphere", game.Lighting)
        Instance.new("Sky", game.Lighting)
    end
    game:GetService("RunService").RenderStepped:Connect( function ( )
        game.Lighting.ClockTime = math.random ( 0, 24 )
        game.Lighting.Brightness = math.random ( 0, 10 )
        game.Lighting.Atmosphere.Density = math.random ( 0, 1 )
        game.Lighting.Atmosphere.Offset = math.random ( 0, 1 )
        game.Lighting.Atmosphere.Color = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )
        game.Lighting.Atmosphere.Decay = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )
        game.Lighting.Atmosphere.Glare = math.random ( 0, 10 )
    
        game.Lighting.Atmosphere.Haze = math.random ( 0, 10 )
    end)
end

local function chatlog ( player )
    player.Chatted:Connect( function ( message )
        getgenv().chatlog_messages = {}
        table.insert( chatlog_messages, player.Name .. " - " .. message )
    end)
end

local function chatlog_everyone ( )
    for index, value in pairs (game.Players:GetPlayers()) do
        chatlog ( value )
    end
end

local function save_chatlogs ( )
    if writefile then writefile ( "creamfood_chatlogs.txt",  table.concat(getgenv().chatlog_messages, "\n"))
    else
        Notification ("Oops! Something gone wrong")
    end
end

local function _goto ( _string )
    if GetPlayer ( _string ) == game.Players.LocalPlayer then return end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetPlayer ( _string ).Character.HumanoidRootPart.CFrame
end

local function rejoin ( )
    game.Players.LocalPlayer:Kick()
    wait()
    if #game.Players:GetPlayers() <= 1 then
        game:GetService ( "TeleportService" ):Teleport ( game.PlaceId, game.Players.LocalPlayer )
    else
        game:GetService ( 'TeleportService' ):TeleportToPlaceInstance ( game.PlaceId, game.JobId, game.Players.LocalPlayer )
    end
end

local function Freeze ( _string )
    for index, value in pairs ( GetPlayer ( _string ).Character:GetDescendants ( ) ) do
        if value:IsA ( "BasePart" ) and value.Anchored == false or value:IsA ( "Part" ) and value.Anchored == false then
            value.Anchored = true
        end
    end
end

local function Thaw ( _string )
    for index, value in pairs ( GetPlayer ( _string ).Character:GetDescendants ( ) ) do
        if value:IsA ( "BasePart" ) and value.Anchored == true or value:IsA ( "Part" ) and value.Anchored == true then
            value.Anchored = false
        end
    end
end

local function _Freeze ( _string )

    if _string == "me" then Freeze ( game.Players.LocalPlayer ) end;

    if _string == "others" then

        for index, value in pairs ( game.Players:GetPlayers (  ) ) do

            if value == game.Players.LocalPlayer or value.Name == game.Players.LocalPlayer.Name then return end
            Freeze ( value )

        end

    end;

    if _string == "all" then

        for index, value in pairs ( game.Players:GetPlayers (  ) ) do

            Freeze ( value )
        
        end

    end;

end

local function _Thaw ( _string )

    if _string == "me" then Thaw ( game.Players.LocalPlayer ) end;

    if _string == "others" then

        for index, value in pairs ( game.Players:GetPlayers (  ) ) do

            if value == game.Players.LocalPlayer or value.Name == game.Players.LocalPlayer.Name then return end
            Thaw ( value )

        end

    end;

    if _string == "all" then

        for index, value in pairs ( game.Players:GetPlayers (  ) ) do

            Thaw ( value )
        
        end

    end;

end

local function Hitbox ( )
    coroutine.resume ( coroutine.create ( function ( ) 
            
        for index, value in pairs ( workspace:GetDescendants ( ) ) do
            if value:IsA ( "BasePart" ) and value.Transparency <= 0 or value:IsA ( "Part" ) and value.Transparency <= 0 then
            local SelectionBox = Instance.new ( "SelectionBox" )
            SelectionBox.Parent = value
            SelectionBox.Color3 = Color3.fromRGB ( 201, 248, 255 )
            SelectionBox.LineThickness = 0.015
            SelectionBox.Adornee = value

        elseif value:IsA ( "BasePart" ) and value.Transparency > 0 or value:IsA ( "Part" ) and value.Transparency > 0 then
            local SelectionBox = Instance.new ( "SelectionBox" )
            SelectionBox.Parent = value
            SelectionBox.Color3 = Color3.fromRGB ( 255, 201, 252 )
            SelectionBox.LineThickness = 0.015
            SelectionBox.Adornee = value
        end
    end

    end ) )
 end

local function PotatoMode ( )
    game.Lighting.FogEnd = math.huge
	game.Lighting.Ambient = Color3.fromRGB ( 255, 255, 255 )
	game.Lighting.GlobalShadows = false

    for index, value in pairs ( workspace:GetDescendants ( ) ) do
        if value:IsA ( "Part" ) or value:IsA ( "BasePart" ) then value.Material = Enum.Material.SmoothPlastic end
        if value:IsA ( "Decal" ) then value:Destroy() end
        if value:IsA ( "UnionOperation" ) then value.RenderFidelity = Enum.RenderFidelity.Performance; value.Material = Enum.Material.SmoothPlastic end
        if value:IsA ( "Atmosphere" ) or value:IsA ( "Sky" ) or value:IsA ( "BloomEffect" ) or value:IsA ( "ColorCorrectionEffect" ) or value:IsA ( "BlurEffect" ) or value:IsA ( "DepthOfFieldEffect" ) or value:IsA ( "SunRaysEffect" ) then value:Destroy() end
        if sethiddenproperty then sethiddenproperty(game.Lighting, "Technology", "Compatibility") end
    end
end

local function ExtremePotatoMode ( )
    game.Lighting.FogEnd = math.huge
	game.Lighting.Ambient = Color3.fromRGB ( 255, 255, 255 )
	game.Lighting.GlobalShadows = false

    for index, value in pairs ( workspace:GetDescendants ( ) ) do
        if value:IsA ( "Part" ) or value:IsA ( "BasePart" ) then value.Material = Enum.Material.SmoothPlastic; value.Shape = Enum.PartType.Block end
        if value:IsA ( "Decal" ) then value:Destroy() end
        if value:IsA ( "UnionOperation" ) then value:Destroy() end
        if value:IsA ( "Atmosphere" ) or value:IsA ( "Sky" ) or value:IsA ( "BloomEffect" ) or value:IsA ( "ColorCorrectionEffect" ) or value:IsA ( "BlurEffect" ) or value:IsA ( "DepthOfFieldEffect" ) or value:IsA ( "SunRaysEffect" ) then value:Destroy() end
        if sethiddenproperty then sethiddenproperty(game.Lighting, "Technology", "Compatibility") end
        if value:IsA ( "Shirt" ) or value:IsA ( "Pants" ) or value:IsA ( "Accessory" ) then value:Destroy() end
        if value:IsA ( "Beam" ) or value:IsA ( "Explosion" ) or value:IsA ( "Fire" ) or value:IsA ( "ParticleEmitter" ) or value:IsA ( "Sparkles" ) or value:IsA ( "Trail" ) then value:Destroy() end
        if value:IsA ( "BlockMesh" ) or value:IsA ( "SpecialMesh" ) then value:Destroy() end
        if value:IsA ( "Texture" ) then value:Destroy()
    end
    if workspace.CurrentCamera:FindFirstChildWhichIsA ( "Clouds" ) then workspace:FindFirstChildWhichIsA ( "Clouds" ):Destroy() end
    for index, value in pairs ( game.Players:GetPlayers() ) do
        for _, value2 in pairs ( value.Character:GetDescendants ( ) ) do
            if value2:IsA ( "Shirt" ) or value2:IsA ( "Pants" ) or value2:IsA ( "Accessory" ) then value2:Destroy() end
        end
    end
end
end

local function Gravity ( int )
	if tonumber ( int ) < 0 then int = 0 end
	workspace.Gravity = tonumber ( int )
end

local function FireClickDetectors ( )
	for index, value in pairs ( workspace:GetDescendants( ) ) do
		if value:IsA ( "ClickDetector" ) then fireclickdetector ( value ) end
	end
end

local function SetCreatorId ( )
	game.Players.LocalPlayer.UserId = game.CreatorId
end

local function View ( player )
	if FindPlayer ( player ) == game.Players.LocalPlayer then workspace.CurrentCamera.CameraSubject = FindPlayers ( player ).Character.Humanoid; return end
	if GetPlayer ( player ) then workspace.CurrentCamera.CameraSubject = GetPlayer ( player ).Character.Humanoid end
end

local function Unview ( )
	workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end

local function LoopDay ( ... )
	local arguments = { ... } -- [1] = <opcional> segundos
	if arguments[1] then
		day_loop = game:GetService("RunService").RenderStepped:Connect( function ( )
			game.Lighting.ClockTime = 14.5
		end)

		coroutine.create( coroutine.resume ( function ()
			wait ( tonumber(arguments[1]) )
			day_loop:Disconnect()
		end))

		table.insert ( events, "loopday 1" )
		
	else
		day_loop = game:GetService("RunService").RenderStepped:Connect( function ( )
			game.Lighting.ClockTime = 14.5
		end)
		table.insert ( events, "loopday 0" )
	end
end

local function UnLoopDay ( )
	if table.find ( events,  "loopday 0" ) then day_loop:Disconnect() end
	if table.find ( events, "loopday 1" ) then day_loop:Disconnect() end
end

local function LoopNight ( ... )
	local arguments = { ... } -- [1] = <opcional> segundos
	if arguments[1] then
		day_loop = game:GetService("RunService").RenderStepped:Connect( function ( )
			game.Lighting.ClockTime = 0
		end)

		coroutine.create( coroutine.resume ( function ()
			wait ( tonumber(arguments[1]) )
			day_loop:Disconnect()
		end))

		table.insert ( events, "loopnight 1" )
		
	else
		day_loop = game:GetService("RunService").RenderStepped:Connect( function ( )
			game.Lighting.ClockTime = 0
		end)
		table.insert ( events, "loopnight 0" )
	end
end

local function UnLoopNight ( )
	if table.find ( events,  "loopnight 0" ) or table.find ( events, "loopnight 1" ) then day_loop:Disconnect() end
end

local function IsR15()
	if game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return 1; else return 0; end
end

local function Halve ( )
	if ISR15() == 1 then game.Players.LocalPlayer.Character.LowerTorso.WaistRigAttachment:Destroy() end
end

local function InfJump ( )
	getgenv().infinite_jump = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if input == Enum.KeyCode.Space and not gameProcessedEvent then game.Players.LocalPlayer.Character.Humanoid:ChangeState( Enum.HumanoidStateType.Jumping ) end
	end)
	table.insert ( events, "infinite_jump" )
end

local function NoInfJump ( )
	if table.find ( events, "infinite_jump" ) then getgenv().infinite_jump:Disconnect(); table.remove ( events, table.find( events, "infinite_jump" ) ) end
end

local function NoSit ( )
	getgenv().nosit = game:GetService("RunService").RenderStepped:Connect(function()
		if game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Seated then game.Players.LocalPlayer.Character.Humanoid:ChangeState( Enum.HumanoidStateType.Jumping ) end
	end)
	table.insert ( events, "nosit" )
end

local function UnNosit ( )
	if table.find ( events, "nosit" ) then getgenv().nosit:Disconnect(); table.remove ( events, table.find ( events, "nosit" ) ) end
end

local function WalkTo ( _string )
	getgenv().walkto = game:GetService("RunService").RenderStepped:Connect (function()
		game.Players.LocalPlayer.Character.Humanoid:MoveTo ( GetPlayer ( _string ).Character.HumanoidRootPart.Position )
	end)
	table.insert ( events, "walkto" )
end

local function UnWalkto ( )
	if table.find ( events, "walkto" ) then getgenv().walkto:Disconnect(); table.remove ( events, table.find ( events, "walkto" ) ) end
end

local function Commands ( )
    local index = 0
    for __, _ in pairs ( commands ) do index += 1 end;
	print ( "Comandos: " .. tostring ( index ) )
	for index, value in pairs ( commands ) do
		print ( index )
	end
    Notification ("Press F9 to view the commands", Color3.fromRGB(30,30,30), Enum.FontSize.Size18)
end

local function ShiftSpeed ( int )
    table.insert ( events, "imspeed" )
    getgenv().shift = game:GetService ( "UserInputService" ).InputBegan:Connect (function(input, gameProcessedEvent)
        if input == Enum.KeyCode.LeftShift and not gameProcessedEvent then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = int end
    end)
    getgenv().shift_end = game:GetService( "UserInputService" ).InputEnded:Connect (function(input, gameProcessedEvent)
        if input == Enum.KeyCode.LeftShift and not gameProcessedEvent then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
    end)
end

local function UnShiftSpeed ( )
    if table.find ( events, "imspeed" ) then getgenv().shift:Disconnect(); getgenv().shift_end:Disconnect() end
end

local function Spam ( _string )
    local event = game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
    getgenv().spam = true
    while wait ( getgenv ( ).spamspeed ) and getgenv().spam == true do
        event:FireServer ( _string, "All" )
    end

    table.insert ( events, "spam" )
end

local function PMSpam ( _string2, _string )
    local event = game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
    getgenv().pmspam = true
    while wait ( getgenv ( ).spamspeed ) and getgenv().pmspam == true do
        event:FireServer ( _string2, GetPlayer ( _string ) )
    end
    table.insert ( events, "pmspam" )
end

local function SpamSpeed ( int )
    getgenv().spamspeed = int
end

local function UnSpam ( )
    if getgenv ( ).spam or table.find ( events, "spam" ) then getgenv().spam = false; table.remove ( events, table.find ( events, "spam" ) ) end
end

local function UnPMSpam ( )
    if getgenv ( ).spam or table.find ( events, "pmspam" ) then getgenv().pmspam = false; table.remove ( events, table.find ( events, "pmspam" ) ) end
end

local function NoRotate ( )
    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = false
end

local function UnNoRotate ( )
    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
end

local function Bhop ( )
    if getgenv().bhop or table.find ( events, "bhop" ) then return end
    getgenv().bhop = game:GetService ( "RunService" ).Stepped:Connect(function()
        if game.Players.LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then run_command ( "jump" ) end
    end)
    table.insert( events, "bhop" )
end

local function StopBhop( )
    if getgenv().bhop or table.find ( events, "bhop" ) then getgenv().bhop:Disconnect(); table.remove ( events, table.find ( events, "bhop" ) ); end
end

local function DeleteHats ( )
    game.Players.LocalPlayer.Character.Humanoid:RemoveAccessories()
end

local function DropHats ( )
    for index, value in pairs ( game.Player.LocalPlayer.Character.Humanoid:GetAccessories ( ) ) do
        value.Parent = workspace
    end
end

local function SpamDecal ( assetID )

    local function CreateDecal ( part, face )
        local decal = Instance.new ( "Decal" )
        decal.Parent = part
        decal.Color3 = Color3.fromRGB ( 0, 0, 0 )
        decal.Texture = "http://www.roblox.com/asset/?id=" .. toumber ( assetID )
        decal.Transparency = 0
        decal.Face = face
        decal.Name = game:GetService ( "HttpService" ):GenerateGUID ( false )
    end

    for index, value in pairs ( workspace:GetDescendants ( ) ) do
        if not value:IsA ( "Part" ) or not value:IsA ( "BasePart" ) then return end
        --[[
        CreateDecal ( value, Enum.NormalId.Top )
        CreateDecal ( value, Enum.NormalId.Bottom )
        CreateDecal ( value, Enum.NormalId.Left )
        CreateDecal ( value, Enum.NormalId.Right )
        CreateDecal ( value, Enum.NormalId.Back )
        CreateDecal ( value, Enum.NormalId.Front )
        ]]
        for i,v in pairs (Enum.NormalId) do
            CreateDecal (value, i)
        end
    end
end

local function SpamTextures ( assetID, StudsPerTileU, StudsPerTileV )

    local function CreateTexture ( part, face, StudsPerTileU, StudsPerTileV )
        local texture = Instance.new ( "Texture" )
        texture.Parent = part
        texture.Color3 = Color3.fromRGB ( 0, 0, 0 )
        texture.Texture = "http://www.roblox.com/asset/?id=" .. tonumber ( assetID )
        texture.Transparency = 0
        texture.Face = face
        texture.Name = game:GetService ( "HttpService" ):GenerateGUID ( false )
        texture.StudsPerTileU = StudsPerTileU
        texture.StudsPerTileV = StudsPerTileV
    end

    for index, value in pairs ( workspace:GetDescendants ( ) ) do

        CreateTexture ( value, Enum.NormalId.Top, StudsPerTileU, StudsPerTileV  )
        CreateTexture ( value, Enum.NormalId.Bottom, StudsPerTileU, StudsPerTileV )
        CreateTexture ( value, Enum.NormalId.Left, StudsPerTileU, StudsPerTileV )
        CreateTexture ( value, Enum.NormalId.Right, StudsPerTileU, StudsPerTileV )
        CreateTexture ( value, Enum.NormalId.Back, StudsPerTileU, StudsPerTileV )
        CreateTexture ( value, Enum.NormalId.Front, StudsPerTileU, StudsPerTileV )

    end

end

local function DestroyEverything (  )

    for index, value in pairs ( workspace:GetChildren ( ) ) do
        value:Destroy ( )
    end

end

local function SetShirt ( assetID )

    if not game.Players.LocalPlayer.Character then game.Players.LocalPlayer.CharacterAdded:Wait() SetShirt ( assetID ) end;
    if not game.Players.LocalPlayer.Character:FindFirstChildWhichIsA ( "Shirt" ) then Instance.new ( "Shirt", game.Players.LocalPlayer.Character ) end;
    game.Players.LocalPlayer.Character:FindFirstChildWhichIsA ( "Shirt" ).ShirtTemplate = "http://www.roblox.com/asset/?id=" .. assetID

end

local function SetPants ( assetID )

    if not game.Players.LocalPlayer.Character then game.Players.LocalPlayer.CharacterAdded:Wait(); SetPants ( assetID ) end;
    if not game.Players.LocalPlayer.Character:FindFirstChildWhichIsA ( "Pants" ) then Instance.new ( "Pants", game.Players.LocalPlayer.Character ) end;
    game.Players.LocalPlayer.Character:FindFirstChildWhichIsA ( "Pants" ).PantsTemplate = "http://www.roblox.com/asset/?id=" .. assetID
    
end

local function HipHeight ( studs )

    if not game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.CharacterAdded:Wait(); HipHeight ( studs ); end
    game.Players.LocalPlayer.Character.Humanoid.HipHeight = tonumber ( studs )

end

local function RequiresNeck ( bool )

    if not game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.CharacterAdded:Wait(); RequiresNeck ( bool ) end
    if bool == "true" then game.Players.LocalPlayer.Character.Humanoid.RequiresNeck = true; end
    if bool == "false" then game.Players.LocalPlayer.Character.Humanoid.RequiresNeck = false; end

end

local function TakeDamage ( damage )

    if not game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.CharacterAdded:Wait(); TakeDamage ( damage ) end
    game.Players.LocalPlayer.Character.Humanoid:TakeDamage ( tonumber ( damage ) )

end

local function Hell ( )

    math.randomseed ( game.Players.LocalPlayer.UserId + (100 / 2 * 6 + 2 - 1) + (math.random ( 0, math.random ( 0, 49604212 ) ) * 0.5 ) - 6 )

    if not game:IsLoaded() then game.Loaded:Wait(); end

    for index, value in pairs ( workspace:GetDescendants ( ) ) do

        local fire = Instance.new ( "Fire" )
        fire.Parent = value
        fire.Color = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )
        fire.Heat = math.random ( 0, 69420 )
        fire.Size = math.random ( 0, 69420 )
        fire.SecondaryColor = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )

    end

end

local function runscript ( _script )

    coroutine.resume ( coroutine.create ( function ( )
    
        local success, err = pcall ( loadstring ( _script ) ( ) ) -- probably not the most secure or fastest way possible
        if success then return end;
        if err then return end;

    end ) )

end

local function filescript ( file )

    local _script = readfile ( tostring ( file ) )
    coroutine.resume ( coroutine.create ( function ( )
        
        local success, err = pcall ( loadstring ( _script ) ( ) )
        if success then return end;
        if err then return end;
    end ) )

end

local function persistafterteleport ( )

    local _script = [[pcall ( function ( )
        local r = request ( {
            Url = "https://raw.githubusercontent.com/GTX1O8OTi/creamfood/developer/rewrite.lua",
            Method = "GET"
        } )
        loadstring ( r.Body ) ( )
    end )]]
    queue_on_teleport ( _script )
    Notification ("Contact navet#2416 if it doesnt work", Color3.fromRGB(30,30,30), Enum.FontSize.Size18)
end

local function simradius ( ... )
    local arguments = { ... }

    pcall ( function ( )
    
        if not table.find ( events, "simradius" ) then table.insert ( events, "simradius" ) end;
        if arguments[1] ~= nil and tonumber ( arguments [1] ) > 0 then
    
            getgenv().simradius = game:GetService ( "RunService" ).RenderStepped:Connect ( function ( )
                setsimulationradius ( tonumber( arguments [1] ) )
            end );
    
        else
    
            getgenv().simradius = game:GetService ( "RunService" ).RenderStepped:Connect ( function ( )
                setsimulationradius ( math.huge )
            end );
    
        end

    end)

end

local function unsimradius ( )

    if not table.find ( events, "simradius" ) then return end;
    table.remove ( events, table.find ( events, "simradius" ) )
    if getgenv ( ).simradius then getgenv ( ).simradius:Disconnect ( ) end;

end

local function movedir ( )
    if table.find ( events, "movedirection" ) then return end;
    table.insert ( events, "movedirection" )
    getgenv ( ).movedirection = game:GetService ( "RunService" ).RenderStepped:Connect ( function ( )
        if game.Players.LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * game.Players.LocalPlayer.Character.Humanoid.MoveDirection
        end
    end)

end

getgenv ( ).waypoints = { }
local function MakeWaypoint ( name )
    
    getgenv ( ).waypoints [ name ] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
 
    game.StarterGui:SetCore ( 'SendNotification', {
        Title = 'Creamfood',
        Text = 'cmon bro, give it a name',
        Duration = 10
    } )

    Notification ("cmon bro, give it a name", Color3.fromRGB(30,30,30), Enum.FontSize.Size18)

end

local function GotoWaypoint ( name )

    local found = false
    for index, value in pairs ( getgenv ( ).waypoints ) do

        if tostring ( index ) == name then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = value; found = true break end;

    end
    if not found then Notification ("No waypoint found", Color3.fromRGB(150,150,150), Enum.FontSize.Size18) end
    found = false

end

local function DeleteWaypoints ( name )

    print ( name )
    table.remove ( getgenv ( ).waypoints, table.find ( getgenv ( ).waypoints, name ) ) -- tf does this not work?

    Notification ("No waypoint found", Color3.fromRGB(150,150,150), Enum.FontSize.Size18)

end

local function ClearWaypoints ( name )

    table.clear ( getgenv ( ).waypoints )

end

local function printwaypoints ( )

    for index, value in pairs ( getgenv ( ).waypoints ) do

        print ( index )

    end

end

local function WalkToWaypoint ( name )

    for index, value in pairs ( getgenv ( ).waypoints ) do
        if tostring ( index ) == name then game.Players.LocalPlayer.Character.Humanoid:MoveTo ( value.Position ) end;
    end

    Notification ("No waypoint found", Color3.fromRGB(150,150,150), Enum.FontSize.Size18)
end

local function chat ( ... )

    local arguments = { ... }
    if arguments [1] ~= nil and arguments [2] then
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer ( arguments [1], arguments [2] )
    elseif arguments [1] ~= nil then game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer ( arguments [1], "All") end;

end

local function changefov ( fov )

    if tonumber ( fov ) <= 0 then return end
    workspace.CurrentCamera.FieldOfView = tonumber ( fov )

end

local function zoom ( distance )

    workspace.CurrentCamera.Zoom = tonumber ( distance )

end

local function globalshadows ( ... )

    local args = { ... }
    local bool = args [1]

    if bool == "on" or bool == "1" then game.Lighting.GlobalShadows = true return end;
    if bool == "off" or bool == "0" then game.Lighting.GlobalShadows = false return end;
    if not bool then return end;

end

local function printuserid ( player )
    local user = GetPlayer (player)
    if user then
        print (user.UserId)
    end
end

local function copyuserid ( player )

    local user = GetPlayer (player)
    if user then
        setclipboard (player.UserId)
    end

end

getgenv ( ).disabledguis = { }
local function nogui ( )

    for index, value in pairs ( game.Players.LocalPlayer.PlayerGui:GetChildren ( ) ) do

        if value.Enabled == false then table.insert ( getgenv ( ).disabledguis, value.Name ); end
        value.Enabled = false

    end
end

local function yesgui ( )

    for index, value in pairs ( game.Players.LocalPlayer.PlayerGui:GetChildren ( ) ) do
        
        if table.find (getgenv ( ).disabledguis, value.Name ) then table.remove ( getgenv ( ).disabledguis, table.find ( getgenv ( ).disabledguis, value.Name ) ); continue end;
        value.Enabled = true

    end

end

local function SaveWaypoints ( )

    local HTTPService = game:GetService ( "HttpService" )
    
    local ttable = {}
    for index, value in pairs ( getgenv ( ).waypoints ) do
        table.insert ( ttable, {
            name = index,
            pos = tostring ( value )
        })
    end
    
    local Encoded = HTTPService:JSONEncode ( ttable )
    writefile ( "creamfood-waypoints.txt", Encoded )

end

local function LoadWaypoints ( )

    local HTTPService = game:GetService ( "HttpService" )
    local Encoded = HTTPService:JSONDecode ( readfile ( "creamfood-waypoints.txt" ) )

    for index, value in pairs ( Encoded ) do

        table.insert ( getgenv ( ).waypoints, value.name )
        local stocf = CFrame.new ( table.unpack ( value.pos:gsub (" ", ""):split (",") ) ) -- lembrete pra mim mesmo: aprender mais sobre strings
        getgenv ( ).waypoints [ value.name ] = stocf

    end

end

local function PFGotoPlayer (player) -- thx roblox wiki / obg roblox wiki
local Pathfinding = game:GetService("PathfindingService")

local _player = GetPlayer(player)
local character = _player.Character
local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

local path = Pathfinding:CreatePath({
    AgentRadius = 0.5,
    AgentHeight = 6,
    AgentCanJump = true,
})

local waypoints
local nextWaypointIndex
local reachedConnection
local blockedConnection

local function follow(dest)
    local success, err = pcall(function()
        path:ComputeAsync(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, dest)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        waypoints = path:GetWaypoints()

        blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
            if blockedWaypointIndex >= nextWaypointIndex then
                blockedConnection:Disconnect()
                follow(dest)
            end
        end)

        if not reachedConnection then
            reachedConnection = humanoid.MoveToFinished:Connect(function(reached)
                if reached and nextWaypointIndex < #waypoints then
                    nextWaypointIndex += 1
                    humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
                else
                    reachedConnection:Disconnect()
					blockedConnection:Disconnect()
                end
            end)
        end

        nextWaypointIndex = 2
        humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
    end
end

    follow(character.HumanoidRootPart.Position)
end

getgenv().predictedTime = 0.3
local function SetPredictTime (time)
    getgenv().predictedTime = tonumber (time)
end

local function LinearPrediction (instance)
    local part = Instance.new ("Part")
    part.CanCollide = false
    part.Anchored = true
    part.Size = Vector3.new(1,1,1)
    part.Parent = instance


    coroutine.wrap(function()
        game:GetService("RunService").Stepped:Connect(function()
            local currentPosition = instance.Position
            local currentVelocity = instance.AssemblyLinearVelocity
            local currentOrientation = instance.Orientation
            local predictedPosition = currentPosition + currentVelocity * getgenv().predictedTime
            part.Position = predictedPosition
            part.Orientation = currentOrientation
        end)
    end)()
end

local function PredictAll ()
    for index, value in pairs (game.Players:GetPlayers()) do
        if value.Name ~= game.Players.LocalPlayer.Name then
            LinearPrediction(value.Character.HumanoidRootPart)
        end
    end
end


-- // commands

addcmd ( "print", "p", _print )
addcmd ( "speed", "ws" , walkspeed )
addcmd ( "jumppower", "jp",  jumppower)
addcmd ( "setmaxfps", "",  setmaxfps)
addcmd ( "antiafk", "", antiafk )
addcmd ( "unantiafk", "", unantiafk )
addcmd ( "spin", "", spin )
addcmd ( "unspin", "", unspin )
addcmd ( "clearevents", "", clearevents )
addcmd ( "noclip", "nc", noclip )
addcmd ( "clip", "", clip )
addcmd ( "jump", "", jump )
addcmd ( "sit", "", sit )
addcmd ( "colorful_world", "", colorful_world )
addcmd ( "drugs", "", drugs )
addcmd ( "chatlog", "clog", chatlog_everyone )
addcmd ( "savechatlog", "saveclog", save_chatlogs )
addcmd ( "goto", "", _goto )
addcmd ( "freeze", "stuck", _Freeze )
addcmd ( "thaw", "unstuck", _Thaw )
addcmd ( "hitbox", "hbox", Hitbox )
addcmd ( "potato", "ptt", PotatoMode )
addcmd ( "extremepotato", "eptt", ExtremePotatoMode )
addcmd ( "highgraphics", "hg", highgraphics )
addcmd ( "rejoin", "rj", rejoin )
addcmd ( "loopday", "ld", LoopDay )
addcmd ( "unloopday", "unld", UnLoopDay )
addcmd ( "view","", View )
addcmd ( "unview", "", Unview )
addcmd ( "loopnight", "ln", LoopNight )
addcmd ( "unloopnight", "unln", UnLoopNight )
addcmd ( "halve", "", Halve )
addcmd ( "infjump", "", InfJump )
addcmd ( "noinfjump", "", NoInfJump )
addcmd ( "nosit", "", NoSit )
addcmd ( "walkto", "", WalkTo )
addcmd ( "unnosit","nnsit", UnNosit )
addcmd ( "unwalkto", "", UnWalkto )
addcmd ( "cmds", "help", Commands )
addcmd ( "shiftspeed", "sspeed", ShiftSpeed )
addcmd ( "unshiftspeed", "unsspeed", UnShiftSpeed )
addcmd ( "setcreatorid", "creatorid", SetCreatorId )
addcmd ( "spam", "", Spam )
addcmd ( "pmspam", "", PMSpam )
addcmd ( "unspam", "", UnSpam )
addcmd ( "unpmspam", "", UnPMSpam )
addcmd ( "spamspeed", "", SpamSpeed )
addcmd ( "bhop", "", Bhop )
addcmd ( "stopbhop", "", StopBhop )
addcmd ( "deletehats", "delhats", DeleteHats )
addcmd ( "drophats","dhats", DropHats )
addcmd ( "spamdecals", "", SpamDecal )
addcmd ( "spamtextures", "", SpamTextures )
addcmd ( "destroyeverything", "clean", DestroyEverything )
addcmd ( "setshirt", "changeshirt", SetShirt )
addcmd ( "setpants", "changepants", SetPants )
addcmd ( "hipheight", "hh", HipHeight )
addcmd ( "requiresneck", "", RequiresNeck )
addcmd ( "hell", "", Hell )
addcmd ( "runscript", "rs", runscript )
addcmd ("filescript", "runfile", filescript )
addcmd ( "persistafterteleport", "persisttp", persistafterteleport )
addcmd ( "simradius", "", simradius )
addcmd ( "unsimradius", "", unsimradius )
addcmd ( "movedir", "", movedirection )
addcmd ( "makewaypoint", "mkwp", MakeWaypoint )
addcmd ( "deletewaypoint", "delwp", DeleteWaypoints )
addcmd ( "renamewaypoint", "renamewp", RenameWaypoints )
addcmd ( "gotowaypoint", "gotowp", GotoWaypoint )
addcmd ( "clearwaypoints", "clearwp", ClearWaypoints )
addcmd ( "walktowaypoint", "walktowp", WalkToWaypoint )
addcmd ( "chat", "say", chat )
addcmd ( "fov", "changefov", changefov )
addcmd ( "zoom", "", zoom )
addcmd ( "globalshadows", "gshadows", globalshadows )
addcmd ( "printuserid", "pid", printuserid )
addcmd ( "copyuserid", "cid", copyuserid )
addcmd ( "nogui", "", nogui )
addcmd ( "yesgui", "restoregui", yesgui )
addcmd ( "savewaypoints", "savewp", SaveWaypoints )
addcmd ( "loadwaypoints", "loadwp", LoadWaypoints )
addcmd ( "printwaypoints", "printwp", printwaypoints )
addcmd ( "pfgoto", "", PFGotoPlayer )
addcmd ( "predictall","", PredictAll )
addcmd ( "predict", "", LinearPrediction )
addcmd ( "setpredicttime", "", SetPredictTime )
-- // commands

Notification ("Use cmds to view the commands", Color3.fromRGB(30,30,30), Enum.FontSize.Size18)
Notification ("Making a new ui for it soon, use F9 to see the commands", Color3.fromRGB(30,30,30), Enum.FontSize.Size18)

local function CreateInstance(cls,props)
    local inst = Instance.new(cls)
    for i,v in pairs(props) do
        inst[i] = v
    end
    return inst
end
        
local ScreenGui = CreateInstance('ScreenGui',{DisplayOrder=0,Enabled=true,ResetOnSpawn=true,Name='ScreenGui', Parent=gethui() or game.CoreGui})
local TextBox = CreateInstance('TextBox',{ClearTextOnFocus=true,Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size14,MultiLine=false,Text='',TextColor3=Color3.new(0, 0, 0), PlaceholderText='', PlaceholderColor3=Color3.new(0.7, 0.7, 0.7),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-0.00244425423, 0, 0.770705044, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 200, 0, 50),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='TextBox',Parent = ScreenGui})

local function FocusLost (enter)
    if enter then
        ICommand (TextBox.Text)
		TextBox.Text = ""
	end
end

TextBox.FocusLost:Connect(FocusLost)

local function Focus ()
    TextBox:CaptureFocus()
    game:GetService("RunService").RenderStepped:Wait()
    TextBox.Text = ""
end

game:GetService("ContextActionService"):BindAction("Focus", Focus, false, Enum.KeyCode.RightBracket)
