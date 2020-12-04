local TeamControlModule = {}

-- remote event
local SelectTeamEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
SelectTeamEvent.Name = "SelectTeamEvent"

TeamControlModule.TeamStatusList = {}

TeamStatusList[1] = {maxMobility = 3, attack = 20, defense = 10, health = 100, startLocation = '55'}
TeamStatusList[2] = {maxMobility = 3, attack = 20, defense = 10, health = 100, startLocation = '11'}
TeamStatusList[3] = {maxMobility = 4, attack = 15, defense = 5, health = 100, startLocation = '99'}
SelectTeamEvent.OnServerEvent:Connect(function(player, teamID)
    -- 玩家的队伍选择后，将玩家的各属性直接保存在player下
    mobility=Instance.new("IntValue");		--行动力
    mobility.Parent=player;
    mobility.Name="mobility";
    mobility.Value=100;

    energyStorage=Instance.new("IntValue");
    energyStorage.Parent=player;
    energyStorage.Name="energyStorage";
    energyStorage.Value=0;

    inAction = Instance.new("BoolValue")
    inAction.Parent = player
    inAction.Name = "inAction"
    inAction.Value = false

    nextTurn = Instance.new("BoolValue")
    nextTurn.Parent = player
    nextTurn.Name = "nextTurn"
    nextTurn.Value = false

    -- 各阵营不同的属性
    maxMobility=Instance.new("IntValue");		--最大行动力
    maxMobility.Parent=player;
    maxMobility.Name="maxMobility";
    maxMobility.Value=TeamControlModule.TeamStatusList[teamID].maxMobility;

    currentPartID=Instance.new("StringValue");	--起始位置
    currentPartID.Parent=player;
    currentPartID.Name="currentPartID";
    currentPartID.Value=TeamControlModule.TeamStatusList[teamID].startLocation;

    attack=Instance.new("IntValue");	--攻击力
    attack.Parent=player;
    attack.Name="attack";
    attack.Value=TeamControlModule.TeamStatusList[teamID].attack;

    defense = Instance.new("IntValue")
    defense.Parent = player
    defense.Name = "defense"
    defense.Value = TeamControlModule.TeamStatusList[teamID].defense

    health = Instance.new("IntValue")
    health.Parent = player
    health.Name = "health"
    health.Value = TeamControlModule.TeamStatusList[teamID].health
end)

return TeamControlModule