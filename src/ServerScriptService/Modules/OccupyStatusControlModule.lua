local OccupyStatusControlModule = {}

-- remote event
occupyPartEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
occupyPartEvent.Name = "occupyPartEvent"

OccupyStatusControlModule.occupyStatusList = {}

OccupyStatusControlModule.occupyBigPartNumList = {}

-- 游戏开始时要调用！！
function OccupyStatusControlModule: init()
    local allPlayers=game.Players:GetChildren()
    for p = 1, #allPlayers do
        OccupyStatusControlModule.occupyBigPartNumList[allPlayers[p].UserId] = 0
        for index=1, 9 do
            OccupyStatusControlModule.occupyStatusList[allPlayers[p].UserId][index] = 0
        end
    end

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

occupyPartEvent.OnServerEvent:Connect(function(player, partId)
    if OccupyStatusControlModule.occupyBigPartNumList[player.UserId] >= 3 then
        return
    end
    local partID = tonumber(partId)
    local flag = updateOccupyStatusWhenTake(player, partID)
    if flag then
       OccupyStatusControlModule.occupyBigPartNumList[player.UserId] = OccupyStatusControlModule.occupyBigPartNumList[player.UserId] + 1
       -- fireClient 小地图做相应操作
    end

end)

deOccupyPartEvent.OnServerEvent:Connect(function(player, partId)
    if OccupyStatusControlModule.occupyBigPartNumList[player.UserId] >= 3 then
        return
    end
    local partID = tonumber(partId)
    local flag = updateOccupyStatusWhenTaken(player, partID)
    if flag then
        OccupyStatusControlModule.occupyBigPartNumList[player.UserId] = OccupyStatusControlModule.occupyBigPartNumList[player.UserId] - 1
        -- fireClient 小地图做相应操作
    end
end)

return OccupyStatusControlModule