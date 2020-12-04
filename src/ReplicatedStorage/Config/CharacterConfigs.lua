local CharacterConfigs = {}

CharacterConfigs.CharacterConfig = {}

local CharactersPerGame = 2
function templateActivationFun(player, teamID, characterID)
    print("activate with team "..teamID.." and character "..characterID)
end
-- character configs
Team1Characters = {
    [1] = {desc = "I am character1 of team1", name = "character1", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
    [2] = {desc = "I am character2 of team1", name = "character2", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
    [3] = {desc = "I am character3 of team1", name = "character3", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
}

Team2Characters = {
    [1] = {desc = "I am character1 of team2", name = "character1", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
    [2] = {desc = "I am character2 of team2", name = "character2", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
    [3] = {desc = "I am character3 of team2", name = "character3", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
}

Team3Characters = {
    [1] = {desc = "I am character1 of team3", name = "character1", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
    [2] = {desc = "I am character2 of team3", name = "character2", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
    [3] = {desc = "I am character3 of team3", name = "character3", icon = "rbxassetid://4633238082"
    , activateFun = templateActivationFun},
}

CharacterConfigs.CharacterConfig[1] = Team1Characters
CharacterConfigs.CharacterConfig[2] = Team2Characters
CharacterConfigs.CharacterConfig[3] = Team3Characters

return CharacterConfigs


