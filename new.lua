local alias = {}
local commands = {}

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
        --print(arguments)

        local f = coroutine.wrap(function() commands[cmd](arguments) end)
        f()
        
end

-- no aliases for now, use addcmd to make them
local function addcmd(cmd ,callback)
        commands[cmd] = callback
end 

