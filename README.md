```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/navet2416/creamfood/main/main")) ()
```

Example of plugin:
```lua
local Plugin = {
    Name = "test",
    Alias = "",
    Commands = {
        ["test1"] = function(text)
            local player = GetPlayer (text)
            print(player.Name)
        end,
    },
}

return Plugin
```

currently being remade on the new-command-sys branch
