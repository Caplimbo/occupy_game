local PlayerControlModule = {}

function PlayerControlModule.rightClickOnBrick(player, part)
    local humanoid = player.Character:WaitForChild("Humanoid")
    local res = 1
    -- move to the target brick
    humanoid:MoveTo(part.Position)

    -- check if there is a fight
    -- with another player
    if part.playerID.Value == 1 then
        res = PlayerControlModule.fightWithPlayer(player, playerID)
    end

    -- with a monster
    if part.monsterID.Value == 1 then
        res = PlayerControlModule.fightWithMonster(player, monsterID)
    end

    -- if being defeat, retreat to original brick
    if res == 0 then
        local originalPlayerPartID = player.currentPartID.Value
        local originalPart = workspace.WaitForChild(originalPlayerPartID)
        humanoid:MoveTo(originalPart.Position)
        return 0
    end

    -- collect item on the brick
    if part.itemID.Value == 1 then
        PlayerControlModule.collectItem(player, itemID) -- collect
        part.itemID.Value = 0 -- eliminate item from the brick
    end

    -- extract energy
    PlayerControlModule.gainEnergy(player, part)
end


function PlayerControlModule.fightWithPlayer(player, opponentID)
    -- first open itemUI
    player.PlayerGui.item.Enabled = true
    local opponent = game:GetService("Players"):GetPlayerByUserId(opponentID)
    opponent.PlayerGui.item.Enabled = true
    -- let UI operations do the rest
end

function PlayerControlModule.fightWithMonster(player, monsterID)

end

function PlayerControlModule.collectItem(player, item)
    player.Character.itemID.Value = item
end

function PlayerControlModule.gainEnergy(player, part)
    player.Character.energyStorage.Value = player.Character.energyStorage + part.energy.Value
    part.energy.Value = 0
    -- maybe output something?
end

return PlayerControlModule