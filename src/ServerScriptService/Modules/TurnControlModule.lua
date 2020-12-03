local TurnControlModule = {}

-- remote event
local NextTurnEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
NextTurnEvent.Name = "NextTurnEvent"

local totalTurnNum = 1

local readyPlayerNum = 0

NextTurnEvent.OnServerEvent:Connect(function(player)
    local allPlayers=game.Players:GetChildren()
    player.Character.nextTurn.Value = true
    readyPlayerNum = readyPlayerNum + 1
    if readyPlayerNum == #allPlayers then
        print("Next Turn Begins!")
        totalTurnNum = totalTurnNum + 1 -- 总回合数+1
        for i=1, #allPlayers do
            people[i].Character.mobility.Value = people[i].Character.maxMobility.Value
            -- 玩家在结束回合后不能动，需要额外代码吗？
            -- people[i].Character.endTurn.Value = false
        end
        readyPlayerNum = 0
    end
    return 0
end)

return TurnControlModule