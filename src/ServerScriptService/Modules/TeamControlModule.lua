local TeamControlModule = {}

-- remote event
local SelectTeamEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
SelectTeamEvent.Name = "SelectTeamEvent"

TeamControlModule.TeamStatusList = {}

TeamControlModule.TeamStatusList[1] = {maxMobility = 3, attack = 20, defense = 10, health = 100, startLocation = '55'}
TeamControlModule.TeamStatusList[2] = {maxMobility = 3, attack = 20, defense = 10, health = 100, startLocation = '11'}
TeamControlModule.TeamStatusList[3] = {maxMobility = 4, attack = 15, defense = 5, health = 100, startLocation = '99'}


SelectTeamEvent.OnServerEvent:Connect(function(player, teamID)
    -- 玩家的队伍选择后，将玩家的各属性直接保存在player下
    local mobility=Instance.new("IntValue");		--行动力
    mobility.Parent=player;
    mobility.Name="mobility";
    mobility.Value=100;

    local energyStorage=Instance.new("IntValue");
    energyStorage.Parent=player;
    energyStorage.Name="energyStorage";
    energyStorage.Value=0;

    local inAction = Instance.new("BoolValue")
    inAction.Parent = player
    inAction.Name = "inAction"
    inAction.Value = false

    local nextTurn = Instance.new("BoolValue")
    nextTurn.Parent = player
    nextTurn.Name = "nextTurn"
    nextTurn.Value = false

    local start = Instance.new("BoolValue")
    start.Parent = player
    start.Name = "start"
    start.Value = false

    -- 各阵营不同的属性
    local maxMobility=Instance.new("IntValue");		--最大行动力
    maxMobility.Parent=player;
    maxMobility.Name="maxMobility";
    maxMobility.Value=TeamControlModule.TeamStatusList[teamID].maxMobility;

    local currentPartID=Instance.new("StringValue");	--起始位置
    currentPartID.Parent=player;
    currentPartID.Name="currentPartID";
    currentPartID.Value=TeamControlModule.TeamStatusList[teamID].startLocation;

    local attack=Instance.new("IntValue");	--攻击力
    attack.Parent=player;
    attack.Name="attack";
    attack.Value=TeamControlModule.TeamStatusList[teamID].attack;

    local defense = Instance.new("IntValue")
    defense.Parent = player
    defense.Name = "defense"
    defense.Value = TeamControlModule.TeamStatusList[teamID].defense

    local health = Instance.new("IntValue")
    health.Parent = player
    health.Name = "health"
    health.Value = TeamControlModule.TeamStatusList[teamID].health

    -- 设置玩家出生位置
    local initialPart = workspace:WaitForChild(currentPartID.Value)
    local humanoid = player.Character:WaitForChild("Humanoid")
    -- 理论上不能用moveTo……
    humanoid:moveTo(initialPart.Position)

    -- 让玩家开始选择角色
    game.ReplicatedStorage.OpenCharacterUIEvent:FireClient(player, teamID)
end)

return TeamControlModule