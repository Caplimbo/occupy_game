local ItemConfigs = {}

ItemConfigs.itemConfig = {}

ItemConfigs.allItemNum = 2

activate = {
    [1] = function(player)
        print("begin to increase attack!")
        print("Original attack is ", player.attack.Value)
        player.attack.Value = player.attack.Value + 5
        print("Revised attack is ", player.attack.Value)
    end,
    [2] = function(player)
        print("begin to increase defense!")
        print("Original defense is ", player.defense.Value)
        player.defense.Value = player.defense.Value + 5
        print("Revised defense is ", player.defense.Value)
    end,
}

deactivate = {
    [1] = function(player)
        print("begin to decrease attack!")
        print("Original attack is ", player.attack.Value)
        player.attack.Value = player.attack.Value - 5
        print("Revised attack is ", player.attack.Value)
    end,
    [2] = function(player)
        print("begin to decrease defense!")
        print("Original defense is ", player.defense.Value)
        player.defense.Value = player.defense.Value - 5
        print("Revised defense is ", player.defense.Value)
    end,
}

ModelName = {
    [1] = "item1",
    [2] = "item2",
}

icons = {
    [1] = "rbxassetid://4633238082",
    [2] = "rbxassetid://4633237956"
}

-- initialize all itemConfig, currently 2
-- Each item has activate(player) and deactivate(player) method.
-- player no need character
for i=1, ItemConfigs.allItemNum do
    ItemConfigs.itemConfig[i] = {ID = i, name = "item"..tostring(i), activateFun = activate[i], deactivateFun = deactivate[i],
                                 modelName = ModelName[i], desc = "this is the description for item"..i, usable = true, icon = icons[i]}
end



return ItemConfigs


