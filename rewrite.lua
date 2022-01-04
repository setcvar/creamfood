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

local function GetPlayer(Name)
	for _,v in ipairs(game.Players:GetPlayers()) do

		if string.lower(v.Name):match("^" .. string.lower(Name)) then
			return v
		end

	end
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

local function run_command ( cmd )
    local command
    local arguments
    local _index = 0
    for result in string.gmatch(cmd, "%g+") do
        if _index == 0 and commands[result] then
            command = result

        elseif _index == 0 and not commands[result] then
            for i,v in pairs (alias) do
                if i == result then command = v; break end
            end

        elseif _index == 1 then
            arguments = result

        elseif _index >= 2 then
            arguments = arguments .. " " ..result
        end
        _index = _index + 1
    end

    local function run ( )
        if commands[command] then
            commands[command](arguments)
        end
    end
    coroutine.resume( coroutine.create ( run ) )
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
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GTX1O8OTi/Graphics/experimental/new.lua", true))()
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
    math.randomseed ( game.Players.LocalPlayer.UserId + (100 / 2 * 6 + 2 - 1) )
    for index, value in pairs ( workspace:GetDescendants() ) do
        if value:IsA ( "BasePart" ) or value:IsA ( "Part" ) then
            value.Color3 = Color3.fromRGB ( math.random ( 0, 255 ), math.random ( 0, 255 ), math.random ( 0, 255 ) )
        end
    end
end

local function drugs ( )
    math.randomseed ( game.Players.LocalPlayer.UserId + 50 )
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
        -- error
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
    if FindPlayer ( _string ) == game.Players.LocalPlayer then Freeze ( game.Players.LocalPlayer ) end -- me

    if FindPlayer ( _string ) == 0 then -- others
        for index, value in pairs ( game.Players:GetPlayers (  ) ) do
            if value == game.Players.LocalPlayer then return end
            Freeze ( value )
        end

    end
    
    if FindPlayer ( _string ) == 1 then -- all
        for index, value in pairs ( game.Players:GetPlayers ( ) ) do
            Freeze ( value )
        end
    end
end

local function _Thaw ( _string )
    if FindPlayer ( _string ) == game.Players.LocalPlayer then Thaw ( game.Players.LocalPlayer ) end -- me

    if FindPlayer ( _string ) == 0 then -- others
        for index, value in pairs ( game.Players:GetPlayers (  ) ) do
            if value == game.Players.LocalPlayer then return end
            Thaw ( value )
        end

    end
    
    if FindPlayer ( _string ) == 1 then -- all
        for index, value in pairs ( game.Players:GetPlayers ( ) ) do
            Thaw ( value )
        end
    end
end

local function Hitbox ( )
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
    if workspace.CurrentCameraFindFirstChildWhichIsA ( "Clouds" ) then workspace:FindFirstChildWhichIsA ( "Clouds" ):Destroy() end
    for index, value in pairs ( game.Players:GetPlayers() ) do
        for _, value2 in pairs ( value.Character:GetDescendants ( ) ) do
            if value2:IsA ( "Shirt" ) or value2:IsA ( "Pants" ) or value2:IsA ( "Accessory" ) then value2:Destroy() end
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
	if table.find ( events,  "loopnight 0" ) then day_loop:Disconnect() end
	if table.find ( events, "loopnight 1" ) then day_loop:Disconnect() end
end

local function IsR15()
	if game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return 1; else return 0 end
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
		game.Players.LocalPlayer.Character.Humanoid:MoveTo ( GetPlayer ( _string ).Character.HumnaoidRootPart.Position )
	end)
	table.insert ( events, "walkto" )
end

local function UnWalkto ( )
	if table.find ( events, "walkto" ) then getgenv().walkto:Disconnect(); table.remove ( events, table.find ( events, "walkto" ) ) end
end

local function Commands ( )
	print ( "Comandos: \n" )
	for index, value in pairs ( commands ) do
		print ( index )
	end
    game.StarterGui:SetCore( "SendNotification", { 
        Title = 'Creamfood',
        Text = 'Press F9 to view the commands.',
        Duration = 5
    })
end

local function ShiftSpeed ( int )
    table.insert ( events, "imspeed" )
    getgenv().shift = game:GetService ( "UserInputService" ).InputBegan:Connect (function(input, gameProcessedEvent)
        if input == Enum.KeyCode.LeftShift and not gameProcessedEvent then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = int end
    end)
    getgenv().shift_end = game:GetService( "UserInputService" ).InputEnded:Connect (function(input, gameProcessedEvent)
        if input == Enum.KeyCode.LeftShift and not gameProcessedEvent then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
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
        if game.Players.LocalPlayer.Character.Humanoid.FloorMaterial ≃ Enum.Material.Air then run_command ( "jump" )
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
    for index, value in pairs ( game.Players.LocalPlayer.Character.Humanoid:GetAccessories ( ) ) do
        value.Parent = workspace
    end
end

-- // commands

addcmd ( "print", "p", _print )
addcmd ( "speed", "ws" , walkspeed )
addcmd ( "jumppower", "jpp",  jumppower)
addcmd ( "setmaxfps", "mfps",  setmaxfps)
addcmd ( "antiafk", "aa", antiafk )
addcmd ( "unantiafk", "unaa", unantiafk )
addcmd ( "spin", "sp", spin )
addcmd ( "unspin", "unsp", unspin )
addcmd ( "clearevents", "ce", clearevents )
addcmd ( "noclip", "nc", noclip )
addcmd ( "clip", "c", clip )
addcmd ( "jump", "", jump )
addcmd ( "sit", "sit", sit )
addcmd ( "colorful_world", "", colorful_world )
addcmd ( "drugs", "drgs", drugs )
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

-- // commands

local function CreateInstance(cls,props)
    local inst = Instance.new(cls)
    for i,v in pairs(props) do
        inst[i] = v
    end
    return inst
end
        
local ScreenGui = CreateInstance('ScreenGui',{DisplayOrder=0,Enabled=true,ResetOnSpawn=true,Name='ScreenGui', Parent=gethui() or game.CoreGui})
local TextBox = CreateInstance('TextBox',{ClearTextOnFocus=true,Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size14,MultiLine=false,Text='',TextColor3=Color3.new(0, 0, 0), PlaceholderText='', PlaceholderColor3=Color3.new(0.7, 0.7, 0.7),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-0.00244425423, 0, 0.770705044, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 200, 0, 50),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='TextBox',Parent = ScreenGui})

TextBox.FocusLost:Connect(function(enter)
	if enter then
		run_command(TextBox.Text)
		TextBox.Text = ""
	end
end)

game:GetService("ContextActionService"):BindAction("Focus", function()
	if TextBox.Visible then
		TextBox:CaptureFocus()
		game:GetService("RunService").RenderStepped:Wait()
		TextBox.Text = ""
	end
end, false, Enum.KeyCode.RightBracket)
