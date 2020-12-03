local model=script.parent;
mobility=Instance.new("IntValue");		--行动力
mobility.Parent=model;
mobility.Name="mobility";
mobility.Value=100;

maxMobility=Instance.new("IntValue");		--最大行动力，可能受阵营，item影响
maxMobility.Parent=model;
maxMobility.Name="maxMobility";
maxMobility.Value=100;

currentPartID=Instance.new("StringValue");	--所在位置
currentPartID.Parent=model;
currentPartID.Name="currentPartID";
currentPartID.Value="55";


energyStorage=Instance.new("IntValue");
energyStorage.Parent=model;
energyStorage.Name="energyStorage";
energyStorage.Value=0;

inAction = Instance.new("BoolValue")
inAction.Parent = model
inAction.Name = "inAction"
inAction.Value = false

nextTurn = Instance.new("BoolValue")
nextTurn.Parent = model
nextTurn.Name = "nextTurn"
nextTurn.Value = false