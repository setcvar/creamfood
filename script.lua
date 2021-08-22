local hui = get_hidden_gui or gethui

local players = game.Players
local lp = players.LocalPlayer
local lpChar = lp.Character or lp.CharacterAdded:Wait()

local debugging = false

-- [[ COMANDOS ]] -- 

local commands = {
	["print"] = function(...)
		local args = {...}
		for i,v in pairs (args) do
			print(v)
		end
	end,
	["speed"] = function(arg1)
		lpChar.Humanoid.WalkSpeed = tonumber(arg1)
	end,
	["copy"] = function(...)
		local args = {...}
		for i,v in pairs (args) do
			setc(v)
		end
	end,
	["jppower"] = function(arg1)
		lpChar.Humanoid.JumpPower = tonumber(arg1)
	end,
}



-- [[ COMANDOS ]] --

-- obrigado ao remfly por dizer que dava pra usar string.gmatch

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
			break
		end

		index = index + 1
	end

	commands[comando](args)

end

local sc = Instance.new("ScreenGui")

if hui then
sc.Parent = hui()
else sc.Parent = game.CoreGui
end

local HTTPService = game:GetService("HttpService")

sc.Name = HTTPService:GenerateGUID(false)
sc.ResetOnSpawn = false

local textbox = Instance.new("TextBox")
textbox.BackgroundColor3 = Color3.fromRGB(255,255,255)
textbox.ClearTextOnFocus = true
textbox.Size = UDim2.new(0,200,0,50)
textbox.Position = UDim2.new(0,0,0.736,0)
textbox.Parent = sc

local CAS = game:GetService("ContextActionService")

CAS:BindAction("focus", function()
	textbox:CaptureFocus()
end, false, Enum.KeyCode.RightBracket)

textbox.FocusLost:Connect(function(enter)
	if enter then
		RCMD(textbox.Text)
	end
end)
