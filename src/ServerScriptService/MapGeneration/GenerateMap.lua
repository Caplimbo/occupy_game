print("start generating map")
mapConfigs = require(game.ReplicatedStorage.Config.MapConfigs)
itemConfigs = require(game.ReplicatedStorage.Config.ItemConfigs)
monsterConfigs = require(game.ReplicatedStorage.Config.MonsterConfigs)

playerControlModule = require(game.ServerScriptService.Modules.PlayerControlModule)

-- basic configs, take from mapConfigs
rowNum = mapConfigs.rowNum
colNum = mapConfigs.colNum
brickSideLength = mapConfigs.brickSideLength
brickHeight = mapConfigs.brickHeight


-- the Num of items & monsters that need to generate
itemNum = 2
monsterNum = 2
allItemNum = itemConfigs.allItemNum
allMonsterNum = monsterConfigs.allMonsterNum

maxEnergyLevel = 100

local function getRandomNumList(len)
    local rsList = {}
    for i=1, len do
        table.insert(rsList,i)
    end
    local num,tmp
    for i = 1,len do
        num = math.random(1,len)
        tmp = rsList[i]
        rsList[i] = rsList[num]
        rsList[num] = tmp
    end
    return rsList
end


-- randomly generate items/monsters to brickID
function randomTableGeneration(num, indexNum, max)
    -- num: num of items/monsters that needs generation
    -- max: num of bricks
    print("generating!")
    local flag = true
    res = {}
    local ran = 0
    local i = 1
    local ranIndexList = getRandomNumList(indexNum)
    local ranTargetList = getRandomNumList(max)
    for index=1, num do
        print("index "..ranIndexList[index].."with target "..ranTargetList[index])
        res[ranIndexList[index]] = ranTargetList[index]
    end
    return res
end


-- alternate generation method: each block has a 0.2 possibility of having item/monster
-- if use this, give all bricks monsterID and itemID.
function randomTableGeneration_alternate(num, max)
    res = {}
    local ran = 0
    local i = 1
    for index = 1, max do
        ran = math.random()
        -- actually should check whether exceed limit, revise later!
        if ran < 0.1 and i <= num then
            res[index] = i  -- also need to change to random later
            i = i + 1
        else
            res[index] = 0
        end
    end
    return res
end

-- generate monsters, items on the map
math.randomseed(os.time())
monsterTable = randomTableGeneration(monsterNum, rowNum*colNum, allMonsterNum)
itemTable = randomTableGeneration(itemNum, rowNum*colNum, allItemNum)


-- generate the map
for x=1, rowNum do
    for y=1, colNum do
        local part = Instance.new("Part")

        local clickDetector = Instance.new("ClickDetector", part)
        clickDetector.RightMouseClick:connect(function (player)
            playerControlModule:rightClickOnBrick(player, part)
        end)
        clickDetector.MouseHoverEnter:Connect(function(player)
            message = "Monster: "..part.monsterID.Value.."\nPlayer: "..part.playerID.Value..
                    "\n Require Mobility: "..part.mobilityRequirement.Value
            game.ReplicatedStorage.ShowInfoBoardEvent:FireClient(player, part.Name, message)
        end)

        clickDetector.MouseHoverLeave:Connect(function(player)
            game.ReplicatedStorage.HideInfoBoardEvent:FireClient(player)
        end)
        --clickDetector.MouseClick:connect(showInfoOfBrick()) -- left click, show detailed info

        -- set basic properties
        part.Anchored = true
        part.Parent = game.Workspace
        part.Shape = Enum.PartType.Block
        part.Color = Color3.new(1, 1, 1)
        part.Size = Vector3.new(brickSideLength, brickHeight, brickSideLength)
        part.Position = Vector3.new((x-5)*brickSideLength + 0.5*(x-5), brickHeight/2, (y-5)*brickSideLength + 0.5*(y-5))
        part.Name = tostring(x*10 + y)

        -- energy on the brick
        energy = Instance.new("IntValue")
        energy.Parent = part
        energy.Name = "energy"
        energy.Value = math.random(math.floor(maxEnergyLevel / 8))

        -- mobility requirement of the brick
        mobilityRequirement = Instance.new("IntValue")
        mobilityRequirement.Parent = part
        mobilityRequirement.Name = "mobilityRequirement"
        mobilityRequirement.Value = math.random(2)

        -- occupy status of the brick
        occupyPlayer = Instance.new("IntValue")
        occupyPlayer.Parent = part
        occupyPlayer.Name = "occupyPlayer"
        occupyPlayer.Value = 0

        occupyLevel = Instance.new("IntValue")
        occupyLevel.Parent = part
        occupyLevel.Name = "occupyLevel"
        occupyLevel.Value = 0

        -- player on the brick
        playerID = Instance.new("IntValue")
        playerID.Parent = part
        playerID.Name = "playerID"
        playerID.Value = 0

        local brickID = (x-1)*colNum + y
        -- generate items
        -- use the following code if use _alternate method
        --[[
        monsterID = Instance.new("IntValue")
        monsterID.Parent = part
        monsterID.Name = "monsterID"
        monsterID.Value = monsterTable[brickID]
        --end
        -- generate monsters
        --if itemTable[itemID] ~= nil then
        itemID = Instance.new("IntValue")
        itemID.Parent = part
        itemID.Name = "itemID"
        itemID.Value = itemTable[brickID]
        --end
        ]]--

        monsterID = Instance.new("IntValue")
        monsterID.Parent = part
        monsterID.Name = "monsterID"
        if not monsterTable[brickID] then
            monsterID.Value = 0
        else
            monsterID.Value = monsterTable[brickID]
        end

        itemID = Instance.new("IntValue")
        itemID.Parent = part
        itemID.Name = "itemID"
        if not itemTable[brickID] then
            itemID.Value = 0
        else
            itemID.Value = itemTable[brickID]
        end


        -- add models to bricks
        if monsterID.Value ~= 0 then
            local monsterConfig = monsterConfigs.monsterConfig[monsterID.Value]
            monster = game.ReplicatedStorage.Monster[monsterConfig.modelName]:Clone()
            monster.Parent = part
            monster.Name = "Monster"
            monster.MonsterName.TextLabel.Text = monsterConfig.modelName
            monster:MoveTo(Vector3.new((x-5)*brickSideLength + 0.5*(x-5), brickHeight/2 + 5, (y-5)*brickSideLength + 0.5*(y-5)))
            --monster:SetPrimaryPartCFrame(CFrame.new(part.Position))
        end

        -- add items to bricks
        if itemID.Value ~= 0 then
            local itemConfig = itemConfigs.itemConfig[itemID.Value]
            item = game.ReplicatedStorage.Item[itemConfig.modelName]:Clone()
            item.Parent = part
            item.Name = "Item"
            item.ItemName.TextLabel.Text = itemConfig.modelName
            item:MoveTo(Vector3.new((x-5)*brickSideLength + 0.5*(x-5), brickHeight/2 + 5, (y-5)*brickSideLength + 0.5*(y-5)))
        end
    end
end