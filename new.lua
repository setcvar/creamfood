local commands = {}
local alias = {}

local function Interface ( ... )

	-- 1 : command
	-- 2 : arguments
	-- 3 : addcmd callback / optional on every other command
	-- 4 : addcmd alias < optional >
	
	local function_arguments = { ... }
	
	local command = function_arguments[1]
	local arguments function_arguments[2]
	local callback = function_arguments[3]
	local command_alias = function_arguments[4]

	-- check if arguments[1] is a "cmds" / "help"
	if command and command == "cmds" or command == "help" then
		-- if run "cmds" or "help" then print every command index
		for index, value in pairs (commands) do print(index) end
		return
	end

	local function ICommand (cmd)
		local list = {}
		
		-- we add every "word" to list
		for word in string.gmatch (cmd, "%g+") do
			table.insert (list, tostring(word))
		end
		
		local command = list[1]
		if not command then
			for index, value in pairs (alias) do
				if index == command then command = value return end
			end
			return
		end
		table.remove(list,1)

		local arguments = table.concat(list, " ")

		local function temporary() commands[command](arguments) end
		local success, err = pcall (function () coroutine.resume (coroutine.create (temporary) ) end)

	end

	-- check if argument[1] is a command
	if command ~= "cmds" or command ~= "help" then
		ICommand (command)
		return
	end

	-- addcmd name function <optional>alias
	if command and command == "addcmd" and callback then
		commands[arguments] = callback
		if command_alias == "" then return end
		alias[command_alias] = command
		return
	end

  -- rmcmd name
	if command and command == "rmcmd" and arguments then
		table.remove(commands, table.find(commands, arguments))
		return
	end
end

Interface ("addcmd", "print", print, "p")
