local model=script.parent;
mobility=Instance.new("IntValue");		--行动力
mobility.Parent=model;
mobility.Name="mobility";
mobility.Value=3;

currentPartID=Instance.new("StringValue");	--所在位置
currentPartID.Parent=model;
currentPartID.Name="currentPartID";
currentPartID.Value="55";

energyStorage=Instance.new("IntValue");	--所在位置
energyStorage.Parent=model;
energyStorage.Name="energyStorage";
energyStorage.Value=0;
