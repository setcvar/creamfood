```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/GTX1O8OTi/creamfood/main/main")) ()
```
!! If you're going to make a plugin, be sure to include at least a function !!

the table passed as a argument to the function is a table

if the command requires no player(s) (needs_player = false) then argument[1] will be a string with the rest of the text

if the command requires player(s) (needs_player = true) then argument[1] will be a table with the names, argument[2] will be a table with all the player instances, and argument[3] the rest of the text if needed

Example of plugin:
```lua
local module = {}

-- first command to add
module.example1 = {}
module.example1.Name = 'himom'
module.example1.Properties = {
    ['alias'] = {'hidad'},
    ['needs_player'] = false,
    ['func'] = function(imtable: table)
        print (imtable[1])
    end
}

-- second command to add
module.example2 = {}
module.example2.Name = 'freeze'
module.example2.Properties = {
    ['alias'] = {'stuck'}.
    ['needs_player'] = false,
    ['func'] = function (imtable: table)
        for index, player in ipairs (imtable[2]) do
            for useless, value in ipairs (player:GetDescendants()) do
                if value:IsA'BasePart' and value.Anchored == false then
                    value.Anchored = true
                end
            end
        end
    end
}
```
