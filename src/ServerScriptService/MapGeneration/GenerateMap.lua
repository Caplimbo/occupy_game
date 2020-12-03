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

maxEnergyLevel = 100

-- randomly generate items/monsters to brickID
function randomTableGeneration_alternate(num, max)
    -- num: num of items/monsters that needs generation
    -- max: num of bricks
    local flag = true
    res = {}
    local ran = 0
    local i = 1
    math.randomseed(os.time())
    while #res < num do
        print()
        flag = true
        ran = math.random(1, max)
        for index, v in ipairs(res) do
            if ran == v then
                flag = false
                break
            end
        end
        if flag then
            res[ran] = i -- store the id of the object, need to change to random gen later
            i = i+1
        end
    end
    return res
end


-- alternate generation method: each block has a 0.2 possibility of having item/monster
-- if use this, give all bricks monsterID and itemID.
function randomTableGeneration(num, max)
    res = {}
    local ran = 0
    local i = 1
    math.randomseed(os.time())
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
monsterTable = randomTableGeneration(monsterNum, rowNum*colNum)
itemTable = randomTableGeneration(itemNum, rowNum*colNum)


-- generate the map
for x=1, rowNum do
    for y=1, colNum do
        local part = Instance.new("Part")

        local clickDetector = Instance.new("ClickDetector", part)
        clickDetector.RightMouseClick:connect(function (player)
            playerControlModule:rightClickOnBrick(player, part)
        end)
        -- right click, move?
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

        -- player on the brick
        playerID = Instance.new("IntValue")
        playerID.Parent = part
        playerID.Name = "playerID"
        playerID.Value = 0

        local brickID = (x-1)*colNum + y
        -- generate items
        --if monsterTable[brickID] ~= nil then
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

        -- add models to bricks
        if monsterID.Value ~= 0 then
            local monsterConfig = monsterConfigs.monsterConfig[monsterTable[brickID]]
            monster = game.ReplicatedStorage.Monster[monsterConfig.modelName]:Clone()
            monster.Parent = game.Workspace.Monster
            monster.MonsterName.TextLabel.Text = monsterConfig.modelName
            monster:MoveTo(Vector3.new((x-5)*brickSideLength + 0.5*(x-5), brickHeight/2 + 5, (y-5)*brickSideLength + 0.5*(y-5)))
            --monster:SetPrimaryPartCFrame(CFrame.new(part.Position))
        end
    end
end