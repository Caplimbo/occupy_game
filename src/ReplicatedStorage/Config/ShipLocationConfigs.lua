local ShipLocationConfigs = {}
MapConfigs = require(game.ReplicatedStorage.Config.MapConfigs)

mapSize = MapConfigs.rowNum * MapConfigs.colNum
smallRangeSize = 4
bigRangeSize = 9

local function getRandomNumList(max)
    local rsList = {}
    for i=1, max do
        table.insert(rsList,i)
    end
    local num,tmp
    for i = 1,max do
        num = math.random(1,max)
        tmp = rsList[i]
        rsList[i] = rsList[num]
        rsList[num] = tmp
    end
    return rsList
end

local function getFirstNElement(list, n)
    local res = {}
    for i=1, n do
        res[i] = list[i]
    end
    return res
end

-- 生成位置及逐步揭露的位置集合
math.randomseed(os.time())
local shipLocationList = getRandomNumList(mapSize)
local shipLocation = getFirstNElement(shipLocationList, 1)
local shipSmallRange = getFirstNElement(shipLocationList, smallRangeSize)
local shipBigRange = getFirstNElement(shipLocationList, bigRangeSize)

ShipLocationConfigs.combinedLocation = {}
ShipLocationConfigs.combinedLocation[1] = shipBigRange
ShipLocationConfigs.combinedLocation[2] = shipSmallRange
ShipLocationConfigs.combinedLocation[3] = shipLocation

return ShipLocationConfigs