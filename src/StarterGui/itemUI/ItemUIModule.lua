-- ================================================================================
-- ItemUIModule
-- ================================================================================
--[[
	道具界面
	有两种情况下会打开道具界面：
	1）玩家直接查看自己的道具栏。此时inFight参数为false（不显示使用按钮，显示所有道具）
	2）在对战中唤起道具栏。此时inFight参数为true（显示使用按钮，显示可使用的道具）

	first version completed on 2/12/2020
]]--

local ItemUIModule = {}

-- ================================================================================
-- VARIABLES
-- ================================================================================
local itemUI = script.Parent

-- RemoteEvent
local UseItemEvent = game.ReplicatedStorage:WaitForChild("UseItemEvent")
local DumpItemEvent = game.ReplicatedStorage:WaitForChild("DumpItemEvent")


--[I am here! ]--


-- ModuleScript
local playerItemData = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerItemData"))
local itemConfigs = require(game.ReplicatedStorage.Config.ItemConfigs)

-- 当前选择的宠物ID
local currentSelectItemID = 0

-- 宠物信息列表
local itemInfoItemList = {}

-- 对手信息
local OpponentID = 0
local MonsterID = 0

-- 等待宠物信息
wait()
local testBaseData = playerItemData:GetBaseData()
while testBaseData == nil do
    wait()
    testBaseData = playerItemData:GetBaseData()
end

-- ================================================================================
-- FUNCTIONS
-- ================================================================================
--[[
	刷新ItemInfoFrame，初始化或者点击背包内宠物头像时调用
]]--
local function RefreshItemInfoFrame(itemData, itemInfoObj)
    -- 先取消老的选中道具的高亮
    if currentSelectItemID ~= 0 then
        local currentItemInfo = itemInfoItemList[currentSelectItemID]
        currentItemInfo.obj.Select.Visible = false
        currentItemInfo.obj.Bg.Visible = true
    end

    -- 高亮新选中的道具
    currentSelectItemID = itemData.ID
    itemInfoObj.Select.Visible = true
    itemInfoObj.Bg.Visible = false

    local itemConfig = itemConfigs.ItemConfig[itemData.templateID]
    -- 显示选中道具的信息
    itemUI.Root.MainFrame.ItemInfoFrame.ItemDesc:FindFirstChild("Description").Text = itemConfig.desc

    itemUI.Root.MainFrame.ItemInfoFrame.ItemNameLabel.Text = itemConfig.name
    itemUI.Root.MainFrame.ItemInfoFrame.ItemIcon.Image = itemConfig.icon
end

--[[
	初始化宠物UI
]]--
local function Init(inFight, opponentID, monsterID)
    for key, value in pairs(itemInfoItemList) do
        value.obj:Destroy()
    end

    local currentItemData = playerItemData:GetBaseData()
    if inFight then
        itemUI.Root.MainFrame.ItemInfoFrame.UseButton.Visible = true
        OpponentID = opponentID
        MonsterID = monsterID
    else
        itemUI.Root.MainFrame.ItemInfoFrame.UseButton.Visible = false
    end
    itemInfoItemList = {}
    local index = 1
    while (index <= #cnturreItemData.ownedItemList) do
        local itemInfoItem = {}
        local itemInfoObj = itemUI.Root.MainFrame.ItemList.ItemInfo:Clone()
        itemInfoObj.Visible = true
        itemInfoObj.Parent = itemUI.Root.MainFrame.ItemList
        local itemConfig = itemConfigs.ItemConfig[currentItemData.ownedItemList[index].templateID]
        -- 若在战斗中打开，只显示可使用道具
        if inFight then
            while (~itemConfig.usable and index <= #currentItemData.ownedItemList)do
                index = index + 1
            end
        end
        itemInfoObj.ItemName.Text = itemConfig.name
        itemInfoObj.Icon.Image = itemConfig.icon
        itemInfoItem.obj = itemInfoObj
        itemInfoItem.id = currentItemData.ownedItemList[index].ID

        itemInfoItemList[itemInfoItem.id] = itemInfoItem


        --绑定点击事件
        itemInfoObj.Button.MouseButton1Click:Connect(function()
            -- 展示道具信息
            RefreshItemInfoFrame(currentItemData.ownedItemList[index], itemInfoObj)
        end)
        index = index + 1
    end

    -- 若当前没有持有道具，不显示道具详细信息
    -- 默认选中1号物品，暂时注释掉，不太合理，若需要则点开if和else注释
    -- if #currentItemData.ownedItemList == 0 then
    currentSelectItemID = 0
    itemInfoItemList = {}
    itemUI.Root.MainFrame.ItemInfoFrame.ItemDesc:FindFirstChild("Description").Text = ""

    --[[
    else
        currentSelectItemID = currentItemData.ownedItemList[1].ID
        local currentItemInfo = itemInfoItemList[currentSelectItemID]
        RefreshItemInfoFrame(currentItemData.ownedItemList[1], currentItemInfo.obj)
        ]]--
    -- end
    player.PlayerGui.item.Enabled = true
end

--[[
	对外接口，打开宠物UI
]]--
function ItemUIModule:OpenUItoCheck()
    Init(false, 0, 0)
end

function ItemUIModule:OpenUItoFight(opponentID, monsterID)
    Init(true, opponentID, monsterID)
end

-- ================================================================================
-- CONNECTIONS
-- ================================================================================

--[[
	对战调用时，点击使用按钮响应
	若点击时没有选定，则不使用道具（暂时如此）
]]--
ItemUI.Root.MainFrame.ItemInfoFrame.UseButton.MouseButton1Click:Connect(function()
    UseItemEvent:FireServer(currentSelectItemID, OpponentID, MonsterID)
end)

return ItemUIModule