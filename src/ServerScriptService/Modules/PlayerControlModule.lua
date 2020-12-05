local PlayerControlModule = {}

local fightMobilityCost = 1

-- remoteEvent
local OpenUIInFightEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
OpenUIInFightEvent.Name = "OpenUIInFightEvent"

local EndTurnEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
EndTurnEvent.Name = "EndTurnEvent"

local CloseOccupyUIEvent = game.ReplicatedStorage.CloseOccupyUIEvent

playerItemDataModule = require(game.ServerScriptService.Modules.PlayerItemDataModule)

function PlayerControlModule:rightClickOnBrick(player, part)
    -- check valid move
    -- same brick, no action
    if player.currentPartID.Value == part.Name or player.inAction.Value or not player.start then
        return 0
    end
    -- need to be adjacent bricks
    local newID = tonumber(part.Name)
    local originalID = tonumber(player.currentPartID.Value)
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
    if player.mobility.Value < neededMobility then
        print("Lack of mobility!")
        return -1
    end

    player.inAction.Value = true
    local humanoid = player.Character:WaitForChild("Humanoid")
    -- move to the target brick
    humanoid:MoveTo(part.Position)
    player.mobility.Value = player.mobility.Value - part.mobilityRequirement.Value

    local res = -1

    -- check if there is a fight
    -- with another player
    if part.playerID.Value ~= 0 then
        player.mobility.Value = player.mobility.Value - fightMobilityCost
        print("current mobility "..player.mobility.Value)
        game.ReplicatedStorage.OpenUIInFightEvent:FireClient(player,part.playerID.Value, 0)
        while (res == -1) do
            print("wait for fight result with player "..part.playerID.Value)
            wait(1)
            res = playerItemDataModule.res
        end
    end

    -- with a monster
    if part.monsterID.Value ~= 0 then
        print("fight with a monster!")
        player.mobility.Value = player.mobility.Value - fightMobilityCost
        game.ReplicatedStorage.OpenUIInFightEvent:FireClient(player, 0, part.monsterID.Value)
        while (res == -1) do
            print("wait for fight result with monster "..part.monsterID.Value)
            wait(1)
            res = playerItemDataModule.res
        end
    end

    local originalPlayerPartID = player.currentPartID.Value
    local originalPart = workspace:WaitForChild(originalPlayerPartID)

    -- if being defeat, retreat to original brick
    if res == 0 then
        print("You lossssssse!")
        humanoid:MoveTo(originalPart.Position)
        player.inAction.Value = false
        return 0
    end

    -- successfully landed
    if part.monsterID.Value ~= 0 then
        part.Monster:Destroy()
    end
    playerItemDataModule.res = -1
    originalPart.playerID.Value = 0
    part.monsterID.Value = 0
    part.playerID.Value = player.userId
    playerItemDataModule.res = -1
    player.currentPartID.Value = part.Name
    print("currentPartID is ".. player.currentPartID.Value)
    print("player left part "..originalPart.Name.." with now playerid ".. originalPart.playerID.Value)

    -- collect item on the brick
    if part.itemID.Value ~= 0 then
        PlayerControlModule:collectItem(player, part.itemID.Value) -- collect
        part.itemID.Value = 0 -- eliminate item from the brick
        part.Item:Destroy()
    end

    -- extract energy
    PlayerControlModule:gainEnergy(player, part)

    -- 当行动力为0时，关闭占点UI
    if player.mobility == 0 then
        CloseOccupyUIEvent:FireClient(player)
    end

    -- successfully arrived!
    player.inAction.Value = false
    return 1
end


function PlayerControlModule:collectItem(player, itemID)
    print("begin collecting item "..itemID)
    playerItemDataModule:AddItem(player, itemID)
end

function PlayerControlModule:gainEnergy(player, part)
    player.energyStorage.Value = player.energyStorage.Value + part.energy.Value
    print("gained"..tostring(part.energy.Value).."energy")
    part.energy.Value = 0
end



return PlayerControlModule