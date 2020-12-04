local CharacterControlModule = {}

-- configs
local characterConfigs = require(game.ReplicatedStorage.Config.CharacterConfigs)

-- remote events
local SelectCharacterEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
SelectCharacterEvent.Name = "SelectCharacterEvent"

local OpenCharacterUIEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
OpenCharacterUIEvent.Name = "OpenCharacterUIEvent"

SelectCharacterEvent.OnServerEvent:Connect(function(player, selectCharacterID, teamID)
    local character = characterConfigs.CharacterConfig[teamID][selectCharacterID]
    character.activateFun(player, teamID, selectCharacterID)
end)



return CharacterControlModule