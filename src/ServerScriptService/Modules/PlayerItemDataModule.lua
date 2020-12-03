-- ================================================================================
-- PlayerItemData
-- ================================================================================
--[[
	玩家道具数据本地管理，用于保存玩家宠物数据，接受宠物相关服务器消息，通知界面刷新
]]--

local PlayerItemData = {}

-- ================================================================================
-- VARIABLES
-- ================================================================================
-- RemoteEvent
local UseItemEvent = game.ReplicatedStorage:WaitForChild("UseItemEvent")
local ItemInfoEvent = game.ReplicatedStorage:WaitForChild("ItemInfoEvent")



-- 玩家道具数据
local currentPlayerItemData = nil

-- ================================================================================
-- FUNCTIONS
-- ================================================================================
--[[
	获取玩家宠物数据
--]]
function PlayerItemData:GetBaseData()
    return currentPlayerItemData
end

-- ================================================================================
-- CONNECTIONS
-- ================================================================================
--[[
	用于处理服务器返回的道具数据
	ownedItemList 拥有的宠物列表
--]]
ItemInfoEvent.OnClientEvent:Connect(function(ownedItemList)
    currentPlayerItemData = {}
    currentPlayerItemData.ownedItemList = ownedItemList
end)

--[[
	用于处理战斗中使用道具后的结果
	itemID 装备的宠物
	currentItemList 当前装备的宠物列表
--]]
UseItemEvent.OnClientEvent:Connect(function(itemID, ownedItemList)
    -- 删掉该物品
    currentPlayerItemData.ownedItemList = ownedItemList
    local itemUIModule = require(game.Players.LocalPlayer.PlayerGui.ItemUI.ItemUIModule)
    itemUIModule.opponentID = 0
    itemUIModule.monsterID = 0
    print("client event for useItem")
end)




return PlayerItemData