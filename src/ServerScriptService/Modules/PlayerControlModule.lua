local PlayerControlModule = {}

fightMobilityCost = 1

playerItemDataModule = require(game.ServerScriptService.Modules.PlayerItemDataModule)
itemUIModule = require(game.StartGui.itemUI.ItemUIModule)


function PlayerControlModule:rightClickOnBrick(player, part)
    local humanoid = player.Character:WaitForChild("Humanoid")
    -- move to the target brick
    humanoid:MoveTo(part.Position)
    local res = -1

    -- check if there is a fight
    -- with another player
    if part.playerID.Value ~= 0 then
        player.Character.mobility.Value = player.Character.mobility.Value - fightMobilityCost
        itemUIModule:OpenUItoFight(playerID, 0)
        while (res == -1) do
            wait(1)
            res = playerItemDataModule.res
        end
    end

    -- with a monster
    if part.monsterID.Value ~= 0 then
        player.Character.mobility.Value = player.Character.mobility.Value - fightMobilityCost
        itemUIModule:OpenUItoFight(0, monsterID)
        while (res == -1) do
            wait(1)
            res = playerItemDataModule.res
        end
    end


    -- if being defeat, retreat to original brick
    if res == 0 then
        local originalPlayerPartID = player.currentPartID.Value
        local originalPart = workspace.WaitForChild(originalPlayerPartID)
        humanoid:MoveTo(originalPart.Position)
        return 0
    end

    playerItemDataModule.res = -1

    -- collect item on the brick
    if part.itemID.Value ~= 0 then
        PlayerControlModule.collectItem(player, itemID) -- collect
        part.itemID.Value = 0 -- eliminate item from the brick
    end

    -- extract energy
    PlayerControlModule.gainEnergy(player, part)

    -- successfully arrived!
    return 1
end


function PlayerControlModule.collectItem(player, itemID)
    playerItemDataModule:addItem(player, itemID)
end

function PlayerControlModule.gainEnergy(player, part)
    player.Character.energyStorage.Value = player.Character.energyStorage + part.energy.Value
    print("gained"..tostring(part.energy.Value).."energy")
    part.energy.Value = 0
end

function PlayerControlModule.fightWithPlayer(player, opponentID)
    return 1
end

function PlayerControlModule.fightWithMonster(player, monsterID)

    return 1
end

return PlayerControlModule