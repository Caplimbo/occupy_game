local model=script.parent;
mobility=Instance.new("IntValue");		--行动力
mobility.Parent=model;
mobility.Name="mobility";
mobility.Value=100;

currentPartID=Instance.new("StringValue");	--所在位置
currentPartID.Parent=model;
currentPartID.Name="currentPartID";
currentPartID.Value="55";

energyStorage=Instance.new("IntValue");	--所在位置
energyStorage.Parent=model;
energyStorage.Name="energyStorage";
energyStorage.Value=0;

energyStorage=Instance.new("IntValue");
energyStorage.Parent=model;
energyStorage.Name="energyStorage";
energyStorage.Value=0;

inAction = Instance.new("BoolValue")
inAction.Parent = model
inAction.Name = "inAction"
inAction.Value = false

endTurn = Instance.new("BoolValue")