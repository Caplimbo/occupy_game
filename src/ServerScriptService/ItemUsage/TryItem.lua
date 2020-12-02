allItemModule = require(game.ServerScriptService.Modules.AllItemModule)

game.ReplicatedStorage.ItemControl.TryItem.OnServerEvent:Connect(function(player, id)
    local u = player.character
    print("id is ", id)
    allItemModule.items[id].activateFun(player)
    u.used.Value=true
end)