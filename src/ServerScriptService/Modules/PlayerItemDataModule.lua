-- ================================================================================
-- PlayerItemDataModule
-- ================================================================================
--[[
	玩家道具数据管理模块
]]--
local PlayerItemDataModule = {}

-- ================================================================================
-- VARIABLES
-- ================================================================================
-- RemoteEvent
local ItemInfoEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
ItemInfoEvent.Name = "ItemInfoEvent"

local UseItemEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
UseItemEvent.Name = "UseItemEvent"

-- ModuleScript
local itemConfigs = require(game.ReplicatedStorage.Config.ItemConfigs)

-- 所有玩家的道具数据列表
local playerItemDataList = {}

-- 标志战斗结果， 1胜0负，-1表示战斗还未完成
PlayerItemDataModule.res = -1

-- 查找列表，只是为了加快查找速度，道具很多时有用
local ownedItemLookUpDictList = {}


-- ================================================================================
-- FUNCTIONS
-- ================================================================================
--[[
	获得对应玩家的道具数据
	player 玩家
]]--
function PlayerItemDataModule:GetPlayerData(player)
    if playerItemDataList[player.UserId] then
        return playerItemDataList[player.UserId]
    end
    return nil
end


--[[
	通过道具ID获得道具配置
	player 玩家
	itemID 道具ID
]]--
function PlayerItemDataModule:GetItemConfigByItemID(player, itemID)
    local playerItemData = playerItemDataList[player.UserId]
    local ownedItemLookUpDict = ownedItemLookUpDictList[player.UserId]

    if playerItemData and ownedItemLookUpDict then
        return itemConfigs.ItemConfig[ownedItemLookUpDict[itemID]]
    end
    return nil
end

--[[
	添加道具
	player 玩家
	id 道具的配置ID
]]--
function PlayerItemDataModule:AddItem(player, id)
    local playerItemData = playerItemDataList[player.UserId]
    local ownedItemLookUpDict = ownedItemLookUpDictList[player.UserId]

    if playerItemData and ownedItemLookUpDict then
        playerItemData.maxItemID = playerItemData.maxItemID + 1
        table.insert(playerItemData.ownedItemList, {ID = playerItemData.maxItemID, templateID = itemConfigs.ItemConfig[id].ID})
        ownedItemLookUpDict[playerItemData.maxItemID] = itemConfigs.ItemConfig[id].ID
        ItemInfoEvent:FireClient(player, playerItemData.ownedItemList)
        ownedItemLookUpDictList[player.UserId] = ownedItemLookUpDict
    end
end

--[[
	CharacterAdded回调方法
	character 玩家的model
]]--
function CharacterAdded(character)
    local player = game.Players:GetPlayerFromCharacter(character)
    local playerItemData = playerItemDataList[player.UserId]

    if playerItemData == nil then
        -- 玩家道具数据类
        playerItemData = {}

        -- 玩家拥有的道具
        playerItemData.ownedItemList = {}

        -- 道具实例ID，玩家每创建一个道具自增1，
        playerItemData.maxItemID = 1

        playerItemDataList[player.UserId] = playerItemData
        ItemInfoEvent:FireClient(player, playerItemData.ownedItemList)
    else
        ItemInfoEvent:FireClient(player, playerItemData.ownedItemList)
        wait(1)
    end

    local ownedItemLookUpDict = ownedItemLookUpDictList[player.UserId]
    if ownedItemLookUpDict == nil then
        ownedItemLookUpDict = {}
        for index = 1, #playerItemData.ownedItemList, 1 do
            local itemData = playerItemData.ownedItemList[index]
            ownedItemLookUpDict[itemData.ID] = itemData.templateID
        end
        ownedItemLookUpDictList[player.UserId] = ownedItemLookUpDict
    end
end


--[[
	PlayerAdd回调方法
	player 玩家
]]--
local function PlayerAdd(player)
    player.CharacterAdded:Connect(CharacterAdded)
end

--[[
	PlayerExit回调方法
	player 玩家
]]--
local function PlayerExit(player)
    playerItemDataList[player.UserId] = nil
    ownedItemLookUpDictList[player.UserId] = nil
end

for _, player in pairs(game.Players:GetPlayers()) do
    PlayerAdd(player)
end

-- ================================================================================
-- CONNECTIONS
-- ================================================================================

game.Players.PlayerAdded:Connect(PlayerAdd)
game.Players.PlayerRemoving:Connect(PlayerExit)


--[[
	监听客户端使用道具消息
	player 玩家
	itemID 道具ID
]]--
UseItemEvent.OnServerEvent:Connect(function(player, itemID, opponentID, monsterID)
    local playerItemData = playerItemDataList[player.UserId]
    local ownedItemLookUpDict = ownedItemLookUpDictList[player.UserId]

    if playerItemData and ownedItemLookUpDict then
        if ownedItemLookUpDict[itemID] ~= nil then
            -- 战斗
            -- 这里怎么获得实际的id呢？目前暂时让item建表时两个id必须匹配

            -- 如何阻塞直到对手也完成激活？
            local itemConfig = PlayerItemDataModule:GetItemConfigByItemID(player, itemID)

            -- 激活，战斗，取消效果
            itemConfig.activateFun(player)
            if opponentID == 0 then
                PlayerItemDataModule.res = game.ServerScriptService.Modules.PlayerItemDataModule:fightWithMonster(player, monsterID)
            else
                PlayerItemDataModule.res = game.ServerScriptService.Modules.PlayerItemDataModule:fightWithPlayer(player, opponentID)
            end
            itemConfig.deactivateFun(player)

            -- 删除道具
            for index = 1, #playerItemData.ownedItemList, 1 do
                if playerItemData.ownedItemList[index].ID == itemID then
                    table.remove(playerItemData.ownedItemList, index)
                    ownedItemLookUpDict[itemID] = nil
                    break
                end
            end

            spawn(function()
                UseItemEvent:FireClient(player, itemID, playerItemData.ownedItemList)
            end)
        end
    end
end)

return PlayerItemDataModule