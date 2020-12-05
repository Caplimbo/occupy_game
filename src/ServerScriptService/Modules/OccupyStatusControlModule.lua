local OccupyStatusControlModule = {}

-- remote event
OccupyPartEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
OccupyPartEvent.Name = "OccupyPartEvent"


OccupyStatusControlModule.occupyStatusList = {}

OccupyStatusControlModule.occupyBigPartNumList = {}

local BrickColorForTeams = {
    [1] = BrickColor.Blue(),
    [2] = BrickColor.Yellow(),
    [3] = BrickColor.Black(),
}

-- 游戏开始时要调用！！
function OccupyStatusControlModule:init()
    for _, player in pairs(game.Players:GetPlayers()) do
        OccupyStatusControlModule.occupyBigPartNumList[player.UserId] = 0
        OccupyStatusControlModule.occupyStatusList[player.UserId] = {}
        for index=1, 9 do
            OccupyStatusControlModule.occupyStatusList[player.UserId][index] = 0
        end
    end

end


for _, value in pairs(OccupyStatusControlModule.occupyBigPartNumList) do
    print("value is "..value)
end

function testNumInTable(num, table)
    for k, v in ipairs(table) do
        if v == num then
            return true
        end
    end
    return false
end

function updateOccupyStatusWhenTake(player, partID)
    local playerOccupyStatus = OccupyStatusControlModule.occupyStatusList[player.UserId]
    if testNumInTable(partID, {11, 12, 13, 21, 22, 23, 31, 32, 33}) then
        playerOccupyStatus[1] = playerOccupyStatus[1] + 1
        if playerOccupyStatus[1] == 5 then
            return true
        end
    elseif testNumInTable(partID, {41, 42, 43, 51, 52, 53, 61, 62, 63}) then
        playerOccupyStatus[2] = playerOccupyStatus[2] + 1
        if playerOccupyStatus[2] == 5 then
            return true
        end
    elseif testNumInTable(partID, {71, 72, 73, 81, 82, 83, 91, 92, 93}) then
        playerOccupyStatus[3] = playerOccupyStatus[3] + 1
        if playerOccupyStatus[3] == 5 then
            return true
        end
    elseif testNumInTable(partID, {14, 15, 16, 24, 25, 26, 34, 35, 36}) then
        playerOccupyStatus[4] = playerOccupyStatus[4] + 1
        if playerOccupyStatus[4] == 5 then
            return true
        end
    elseif testNumInTable(partID, {44, 45, 46, 54, 55, 56, 64, 65, 66}) then
        playerOccupyStatus[5] = playerOccupyStatus[5] + 1
        if playerOccupyStatus[5] == 5 then
            return true
        end
    elseif testNumInTable(partID, {74, 75, 76, 84, 85, 86, 94, 95, 96}) then
        playerOccupyStatus[6] = playerOccupyStatus[6] + 1
        if playerOccupyStatus[6] == 5 then
            return true
        end
    elseif testNumInTable(partID, {17, 18, 19, 27, 28, 29, 37, 38, 39}) then
        playerOccupyStatus[7] = playerOccupyStatus[7] + 1
        if playerOccupyStatus[7] == 5 then
            return true
        end
    elseif testNumInTable(partID, {47, 48, 49, 57, 58, 59, 67, 68, 69}) then
        playerOccupyStatus[8] = playerOccupyStatus[8] + 1
        if playerOccupyStatus[8] == 5 then
            return true
        end
    elseif testNumInTable(partID, {77, 78, 79, 87, 88, 89, 97, 98, 99}) then
        playerOccupyStatus[9] = playerOccupyStatus[9] + 1
        print("occupying region 9 with currently "..playerOccupyStatus[9].." parts taken")
        if playerOccupyStatus[9] == 5 then
            return true
        end
    end
end

function updateOccupyStatusWhenTaken(player, partID)
    -- return true if lose control of a big part due to current operation

    local playerOccupyStatus = OccupyStatusControlModule.occupyStatusList[player.UserId]
    if testNumInTable(partID, {11, 12, 13, 21, 22, 23, 31, 32, 33}) then
        playerOccupyStatus[1] = playerOccupyStatus[1] - 1
        if playerOccupyStatus[1] == 4 then
            return true
        end
    elseif testNumInTable(partID, {41, 42, 43, 51, 52, 53, 61, 62, 63}) then
        playerOccupyStatus[2] = playerOccupyStatus[2] - 1
        if playerOccupyStatus[2] == 4 then
            return true
        end
    elseif testNumInTable(partID, {71, 72, 73, 81, 82, 83, 91, 92, 93}) then
        playerOccupyStatus[3] = playerOccupyStatus[3] - 1
        if playerOccupyStatus[3] == 4 then
            return true
        end
    elseif testNumInTable(partID, {14, 15, 16, 24, 25, 26, 34, 35, 36}) then
        playerOccupyStatus[4] = playerOccupyStatus[4] - 1
        if playerOccupyStatus[4] == 4 then
            return true
        end
    elseif testNumInTable(partID, {44, 45, 46, 54, 55, 56, 64, 65, 66}) then
        playerOccupyStatus[5] = playerOccupyStatus[5] - 1
        if playerOccupyStatus[5] == 4 then
            return true
        end
    elseif testNumInTable(partID, {74, 75, 76, 84, 85, 86, 94, 95, 96}) then
        playerOccupyStatus[6] = playerOccupyStatus[6] - 1
        if playerOccupyStatus[6] == 4 then
            return true
        end
    elseif testNumInTable(partID, {17, 18, 19, 27, 28, 29, 37, 38, 39}) then
        playerOccupyStatus[7] = playerOccupyStatus[7] - 1
        if playerOccupyStatus[7] == 4 then
            return true
        end
    elseif testNumInTable(partID, {47, 48, 49, 57, 58, 59, 67, 68, 69}) then
        playerOccupyStatus[8] = playerOccupyStatus[8] - 1
        if playerOccupyStatus[8] == 4 then
            return true
        end
    elseif testNumInTable(partID, {77, 78, 79, 87, 88, 89, 97, 98, 99}) then
        playerOccupyStatus[9] = playerOccupyStatus[9] - 1
        if playerOccupyStatus[9] == 4 then
            return true
        end
    end
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
    if OccupyStatusControlModule.occupyBigPartNumList[player.UserId] >= 3 then
        return
    end
    local partID = tonumber(partId)
    local flag = updateOccupyStatusWhenTake(player, partID)
    if flag then
        OccupyStatusControlModule.occupyBigPartNumList[player.UserId] = OccupyStatusControlModule.occupyBigPartNumList[player.UserId] + 1
        -- fireClient 小地图做相应操作
        local partNum = OccupyStatusControlModule.occupyBigPartNumList[player.UserId]
        print("You have occupy "..partNum.." giant part!")
    end
end

-- 用户占点后，原用户控制点被占去后的处理
function deOccupyPart(player, partId)
    if OccupyStatusControlModule.occupyBigPartNumList[player.UserId] >= 3 then
        return
    end
    local partID = tonumber(partId)
    local flag = updateOccupyStatusWhenTaken(player, partID)
    if flag then
        OccupyStatusControlModule.occupyBigPartNumList[player.UserId] = OccupyStatusControlModule.occupyBigPartNumList[player.UserId] - 1
        -- fireClient 小地图做相应操作
    end
end

return OccupyStatusControlModule