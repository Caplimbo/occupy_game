-- attach this to ServerScriptService.MapGeneration folder
AllBrickModule = require(game.ServerScriptService.Modules.AllBrickModule)

-- basic configs, take from AllBrickModule
rowNum = AllBrickModule.rowNum
colNum = AllBrickModule.colNum
brickSideLength = AllBrickModule.brickSideLength
brickHeight = AllBrickModule.brickHeight

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
        if ran < 0.2 then
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
        clickDetector.RightMouseClick:connect(rightClickOnBrick(player)) -- right click, move?
        clickDetector.MouseClick:connect(showInfoOfBrick()) -- left click, show detailed info

        -- set basic properties
        part.Anchored = true
        part.Parent = game.Workspace
        part.Shape = Enum.PartType.Block
        part.Color = Color3.new(1, 1, 1)
        part.Size = Vector3.new(brickSideLength, brickHeight, brickSideLength)
        part.Position = Vector3.new((x-5)*brickSideLength + 0.5*(x-5), brickHeight/2, (y-5)*brickSideLength + 0.5*(i-5))
        part.Name = "_"..x..y

        -- energy on the brick
        value = Instance.new("IntValue")
        value.Parent = part
        value.Name = "energy"
        value.Value = random(maxEnergyLevel//8)

        -- player on the brick
        value = Instance.new("IntValue")
        value.Parent = part
        value.Name = "playerID"
        value.Value = 0

        local brickID = x*colNum + y
        -- generate items
        --if monsterTable[brickID] ~= nil then
            value = Instance.new("IntValue")
            value.Parent = part
            value.Name = "monsterID"
            value.Value = monsterTable[brickID]
        --end
        -- generate monsters
        --if itemTable[itemID] ~= nil then
            value = Instance.new("IntValue")
            value.Parent = part
            value.Name = "itemID"
            value.Value = itemTable[brickID]
        --end


    end
end