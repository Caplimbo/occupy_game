local PlayerControlModule = {}

fightMobilityCost = 1

-- remoteEvent
local OpenUIEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
OpenUIEvent.Name = "OpenUIEvent"


playerItemDataModule = require(game.ServerScriptService.Modules.PlayerItemDataModule)

function PlayerControlModule:rightClickOnBrick(player, part)
    -- check valid move
    -- same brick, no action
    if player.Character.currentPartID.Value == part.Name or player.inAction.Character.Value then
        return 0
    end
    -- need to be adjacent bricks
    local newID = tonumber(part.Name)
    local originalID = tonumber(player.Character.currentPartID.Value)
    if newID ~= originalID + 10 and newID ~= originalID + 1 and newID ~= originalID - 10 and newID ~= originalID -1 then
        print("invalid move!")
        return -1
    end


    -- check mobility
    local attachedMobilityRequirement = 0
    if part.playerID.Value ~= 0 or part.monsterID.Value ~= 0 then
        attachedMobilityRequirement = fightMobilityCost
    end
    local neededMobility = part.mobilityRequirement.Value + attachedMobilityRequirement
    if player.Character.mobility.Value < neededMobility then
        print("Lack of mobility!")
        return -1
    end

    player.Character.inAction.Value = true
    local humanoid = player.Character:WaitForChild("Humanoid")
    -- move to the target brick
    humanoid:MoveTo(part.Position)
    player.Character.mobility.Value = player.Character.mobility.Value - part.mobilityRequirement.Value
    -- temporary line here!
    player.Character.currentPartID.Value = part.Name

    local res = -1

    -- check if there is a fight
    -- with another player
    if part.playerID.Value ~= 0 then
        player.Character.mobility.Value = player.Character.mobility.Value - fightMobilityCost
        print("current mobility "..player.Character.mobility.Value)
        game.ReplicatedStorage.OpenUIEvent:FireClient(player,part.playerID.Value, 0)
        while (res == -1) do
            wait(1)
            res = playerItemDataModule.res
        end
    end

    -- with a monster
    if part.monsterID.Value ~= 0 then
        print("fight with a monster!")
        player.Character.mobility.Value = player.Character.mobility.Value - fightMobilityCost
        game.ReplicatedStorage.OpenUIEvent:FireClient(player, 0, part.monsterID.Value)
        while (res == -1) do
            print("In loop!")
            wait(1)
            res = playerItemDataModule.res
        end
        print("end of fight! You win.")
    end


    -- if being defeat, retreat to original brick
    if res == 0 then
        local originalPlayerPartID = player.currentPartID.Value
        local originalPart = workspace:WaitForChild(originalPlayerPartID)
        humanoid:MoveTo(originalPart.Position)
        player.Character.inAction.Value = false
        return 0
    end

    -- successfully landed
    part.monsterID.Value = 0
    part.playerID.Value = player.userId
    playerItemDataModule.res = -1
    player.Character.currentPartID.Value = part.Name
    print("currentPartID is ".. player.Character.currentPartID.Value)

    -- collect item on the brick
    if part.itemID.Value ~= 0 then
        PlayerControlModule:collectItem(player, part.itemID.Value) -- collect
        part.itemID.Value = 0 -- eliminate item from the brick
    end

    -- extract energy
    PlayerControlModule:gainEnergy(player, part)

    -- successfully arrived!
    player.Character.inAction.Value = false
    return 1
end


function PlayerControlModule:collectItem(player, itemID)
    playerItemDataModule:addItem(player, itemID)
end

function PlayerControlModule:gainEnergy(player, part)
    player.Character.energyStorage.Value = player.Character.energyStorage.Value + part.energy.Value
    print("gained"..tostring(part.energy.Value).."energy")
    part.energy.Value = 0
end

function PlayerControlModule:fightWithPlayer(player, opponentID)
    return 1
end

function PlayerControlModule:fightWithMonster(player, monsterID)
    return 1
end



return PlayerControlModule