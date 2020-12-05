local OccupyStatusControlModule = {}

-- remote event
OccupyPartEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
OccupyPartEvent.Name = "OccupyPartEvent"

showShipLocationEvent = game.ReplicatedStorage.ShowShipLocationEvent

-- module scripts
shipLocationConfigs = require(game.ReplicatedStorage.Config.ShipLocationConfigs)

local RegionPerSide = 3
local RegionNum = RegionPerSide * RegionPerSide

OccupyStatusControlModule.occupyStatusList = {}

OccupyStatusControlModule.occupyRegionNumList = {}

local BrickColorForTeams = {
    [1] = BrickColor.Blue(),
    [2] = BrickColor.Yellow(),
    [3] = BrickColor.Black(),
}

-- 游戏开始时要调用！！
function OccupyStatusControlModule:init()
    for _, player in pairs(game.Players:GetPlayers()) do
        OccupyStatusControlModule.occupyRegionNumList[player.UserId] = 0
        OccupyStatusControlModule.occupyStatusList[player.UserId] = {}
        for index=1, RegionNum do
            OccupyStatusControlModule.occupyStatusList[player.UserId][index] = 0
        end
    end

end


-- 暂时9*9， 故不需额外储存
function findRegionByID(ID)
    local id = tonumber(ID)
    print("part id is "..id)
    local ten = math.floor(id/10)
    print("ten is "..ten)
    local unit = id % 10
    print("unit is "..unit)
    local region = math.floor((ten-1)/RegionPerSide) * RegionPerSide + math.floor((unit-1)/RegionPerSide) + 1
    return region
end

function updateOccupyStatusWhenTake(player, partID)
    local playerOccupyStatus = OccupyStatusControlModule.occupyStatusList[player.UserId]
    local regionNum = findRegionByID(partID)
    print("current region is ".. regionNum)
    playerOccupyStatus[regionNum] = playerOccupyStatus[regionNum] + 1
    if playerOccupyStatus[regionNum] == 5 then
        return true
    end
    return false
end

function updateOccupyStatusWhenTaken(player, partID)
    -- return true if lose control of a big part due to current operation
    local playerOccupyStatus = OccupyStatusControlModule.occupyStatusList[player.UserId]
    local regionNum = findRegionByID(partID)
    playerOccupyStatus[regionNum] = playerOccupyStatus[regionNum] - 1
    if playerOccupyStatus[regionNum] == 4 then
        return true
    end
    return false
end

OccupyPartEvent.OnServerEvent:Connect(function(player)
    -- 本地以进行行动力的判断

    local partId = player.currentPartID.Value
    -- 检查是否可以进行占领
    local part = workspace:WaitForChild(partId)
    -- 若块为自己占领的或未被占领
    if part.occupyPlayer.Value == player.UserId or part.occupyPlayer.Value == 0 then
        part.occupyPlayer.Value = player.UserId
        part.occupyLevel.Value = part.occupyLevel.Value + player.mobility.Value
        player.mobility.Value = 0
        part.BrickColor = BrickColorForTeams[player.team.Value]
        occupyPart(player, partId)
        player.controlPartNum.Value = player.controlPartNum.Value + 1
        -- 块本来是别人的
    else
        part.occupyLevel.Value = part.occupyLevel.Value - player.mobility.Value
        player.mobility.Value = 0
        if part.occupyLevel.Value == 0 then -- 归属权恰好被抵消
            local originalPlayer = game.Players:GetPlayerByUserId(part.occupyPlayer.Value)
            deOccupyPart(originalPlayer, partId)
            originalPlayer.controlPartNum = originalPlayer.controlPartNum - 1
            part.occupyPlayer.Value = 0
        elseif part.occupyLevel.Value < 0 then -- 归属权转换
            part.occupyLevel.Value = -part.occupyLevel.Value
            local originalPlayer = game.Players:GetPlayerByUserId(part.occupyPlayer.Value)
            deOccupyPart(originalPlayer, partId)
            originalPlayer.controlPartNum = originalPlayer.controlPartNum - 1
            part.occupyPlayer.Value = player.UserId
            occupyPart(player, partId)
            part.BrickColor = BrickColorForTeams[player.team.Value]
            player.controlPartNum.Value = player.controlPartNum.Value + 1
        end
    end
end)

-- 用户占点后针对大点占据情况的判断
function occupyPart(player, partId)
    if OccupyStatusControlModule.occupyRegionNumList[player.UserId] >= 3 then
        return
    end
    local partID = tonumber(partId)
    local flag = updateOccupyStatusWhenTake(player, partID)
    if flag then
        OccupyStatusControlModule.occupyRegionNumList[player.UserId] = OccupyStatusControlModule.occupyRegionNumList[player.UserId] + 1
        -- fireClient 小地图做相应操作
        local partNum = OccupyStatusControlModule.occupyRegionNumList[player.UserId]
        if partNum >= 1 then
            local shipLocationInfo = shipLocationConfigs.combinedLocation[partNum]
            showShipLocationEvent:FireClient(player, shipLocationInfo)
        end
        print("You have occupy "..partNum.." regions!")
    end
end

-- 用户占点后，原用户控制点被占去后的处理
function deOccupyPart(player, partId)
    if OccupyStatusControlModule.occupyRegionNumList[player.UserId] >= 3 then
        return
    end
    local partID = tonumber(partId)
    local flag = updateOccupyStatusWhenTaken(player, partID)
    if flag then
        OccupyStatusControlModule.occupyRegionNumList[player.UserId] = OccupyStatusControlModule.occupyRegionNumList[player.UserId] - 1
        -- fireClient 小地图做相应操作
    end
end

return OccupyStatusControlModule