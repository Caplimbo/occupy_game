local TurnControlModule = {}

-- remote event
local NextTurnEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
NextTurnEvent.Name = "NextTurnEvent"
local OpenOccupyUIEvent = game.ReplicatedStorage.OpenOccupyUIEvent

local winnerNoticeEvent = game.ReplicatedStorage.WinnerNoticeEvent
local loserNoticeEvent = game.ReplicatedStorage.LoserNoticeEvent

-- require modules
local playerItemDataModule = require(game.ServerScriptService.Modules.PlayerItemDataModule)
local itemConfigs = require(game.ReplicatedStorage.Config.ItemConfigs)

local totalTurnNum = 1
local MaxTurnNum = 100
local readyPlayerNum = 0

NextTurnEvent.OnServerEvent:Connect(function(player)
    local allPlayers=game.Players:GetPlayers()
    player.nextTurn.Value = true
    readyPlayerNum = readyPlayerNum + 1
    if readyPlayerNum == #allPlayers then
        print("Next Turn Begins!")
        totalTurnNum = totalTurnNum + 1 -- 总回合数+1
        if totalTurnNum == MaxTurnNum then
            -- 结束游戏，检查占点
            print("game ends at turn "..totalTurnNum)
            local maxIndex = 1
            local max = 0
            for index=1, #allPlayers do
                p = allPlayers[index]
                if p.controlPartNum.Value > max then
                    max = p.controlPartNum.Value
                    maxIndex = index
                end
                local winner = allPlayers[maxIndex]
                -- 给winner发送胜利消息，loser发失败消息，remoteEvent:FireClient打开一个小ui即可
            end
            for index=1, #allPlayers do
                if index == maxIndex then
                    winnerNoticeEvent:FireClient(allPlayers[index])
                else
                    loserNoticeEvent:FireClient(allPlayers[index])
                end
            end
            return 0
        end

        -- 设置每个玩家新回合的相关参数
        for _, p in pairs(allPlayers) do
            -- 打开占点UI
            OpenOccupyUIEvent:FireClient(p)
            -- 应当检查被动道具来更新玩家的其他属性，待完成
            -- 首先需要重置所有可能被修改过的变量？
            local itemList = playerItemDataModule:GetPlayerData(p).ownedItemList
            for index=1, #itemList do
                local itemConfig = itemConfigs.itemConfig[itemList[index].templateID]
                if itemConfig.passive and not itemConfig.used then
                    -- 检查是否为第一次使用，这里假定我们不做移除道具的功能，要的话需要多做判断
                    itemConfig.activateFun(player) -- 被动道具的激活方法必须包含所有可被修改的参数
                    itemConfig.used = true
                end
            end
            p.mobility.Value = p.maxMobility.Value
            -- 玩家在结束回合后不能动，需要额外代码吗？
            -- people[i].endTurn.Value = false
        end
        -- 重新开始回合结束计数
        readyPlayerNum = 0
    end
    return 0
end)

return TurnControlModule