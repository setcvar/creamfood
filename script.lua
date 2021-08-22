print("another try")
local players = game.Players
local lp = players.LocalPlayer
local lpChar = lp.Character or lp.CharacterAdded:Wait()

local setc = setclipboard or toclipboard or set_clipboard

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
}



-- [[ COMANDOS ]] --

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

lp.Chatted:Connect(RCMD)
