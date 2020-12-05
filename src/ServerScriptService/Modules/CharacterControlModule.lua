local CharacterControlModule = {}

--modules
OccupyStatusControlModule = require(game.ServerScriptService.Modules.OccupyStatusControlModule)


local selectedPlayerNum = 0
-- configs
local characterConfigs = require(game.ReplicatedStorage.Config.CharacterConfigs)

-- remote events
local SelectCharacterEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
SelectCharacterEvent.Name = "SelectCharacterEvent"

local OpenCharacterUIEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
OpenCharacterUIEvent.Name = "OpenCharacterUIEvent"

SelectCharacterEvent.OnServerEvent:Connect(function(player, selectCharacterID, teamID)
    local character = characterConfigs.CharacterConfig[teamID][selectCharacterID]

    selectedPlayerNum = selectedPlayerNum + 1
    player.start.Value = true
    -- 所有写完后取消注释
    --[[
    if selectedPlayerNum == 3 then -- 全部玩家都准备完了
        OccupyStatusControlModule:init()
        for _, player in pairs(game.Players:GetPlayers()) do
            player.start.Value = true
        end
    end
    ]]--
    OccupyStatusControlModule:init()

    character.activateFun(player, teamID, selectCharacterID)
    -- 直接在模块中先初始化，这里注释掉
end)



return CharacterControlModule