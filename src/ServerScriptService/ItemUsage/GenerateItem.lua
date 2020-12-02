allItemMudule = require(game.ServerScriptService.Modules.AllItemModule)


itemNum = 2

for i=1, itemNum do
    item = game.ReplicatedStorage.model[allItemMudule.items[i].modelName]:Clone()
    item.id.Value = i
    local floorid = string.format("_02%d", i)
    item.Parent = workspace.floor:waitForChild(floorid)
end