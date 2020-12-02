local AllItemModule = {}

AllItemModule.items = {}

itemNum = 2

activate = {
    [1] = function(player)
        local u = player.character
        print("begin to increase attack!")
        print("Original attack is ", u.Attack.Value)
        u.Attack.Value = u.Attack.Value + 5
        print("Revised attack is ", u.Attack.Value)
    end,
    [2] = function(player)
        local u = player.character
        print("begin to increase defense!")
        print("Original defense is ", u.Defense.Value)
        u.Defense.Value = u.Defense.Value + 5
        print("Revised defense is ", u.Defense.Value)
    end,
}

deactivate = {
    [1] = function(player)
        local u = player.character
        print("begin to decrease attack!")
        print("Original attack is ", u.Attack.Value)
        u.Attack.Value = u.Attack.Value - 5
        print("Revised attack is ", u.Attack.Value)
    end,
    [2] = function(player)
        local u = player.character
        print("begin to decrease defense!")
        print("Original defense is ", u.Defense.Value)
        u.Defense.Value = u.Defense.Value - 5
        print("Revised defense is ", u.Defense.Value)
    end,
}

ModelName = {
    [1] = "item",
    [2] = "item",
}

-- initialize all items, currently 2
-- Each item has activate(player) and deactivate(player) method.
-- player no need character
for i=1, #activate do
    AllItemModule.items[i] = {activateFun = activate[i], deactivateFun = deactivate[i], modelName = ModelName[i]}
end



return AllItemModule


