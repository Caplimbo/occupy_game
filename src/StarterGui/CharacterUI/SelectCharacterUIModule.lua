local CharacterUIModule = {}

-- ================================================================================
-- VARIABLES
-- ================================================================================
local characterUI = script.Parent

-- RemoteEvent
local SelectCharacterEvent = game.ReplicatedStorage:WaitForChild("SelectCharacterEvent")

-- ModuleScript
local characterConfigs = require(game.ReplicatedStorage.Config.CharacterConfigs)

local currentSelectCharacterID = 0

local characterInfoItemList = {}

local TeamID = 0

-- ================================================================================
-- FUNCTIONS
-- ================================================================================
--[[
	刷新CharacterInfoFrame，初始化或者点击背包内宠物头像时调用
]]--
local function RefreshCharacterInfoFrame(index, teamID, characterInfoObj)
    -- 先取消老的选中角色的高亮
    if currentSelectCharacterID ~= 0 then
        local currentCharacterInfo = characterInfoItemList[currentSelectCharacterID]
        currentCharacterInfo.obj.Select.Visible = false
        currentCharacterInfo.obj.Bg.Visible = true
    end

    -- 高亮新选中的角色
    currentSelectCharacterID = index
    characterInfoObj.Select.Visible = true
    characterInfoObj.Bg.Visible = false

    local characterConfig = characterConfigs.CharacterConfig[teamID][index]
    -- 显示选中角色的信息
    characterUI.Root.MainFrame.CharacterInfoFrame.CharacterDesc:FindFirstChild("Description").Text = characterConfig.desc

    characterUI.Root.MainFrame.CharacterInfoFrame.CharacterNameLabel.Text = characterConfig.name
    characterUI.Root.MainFrame.CharacterInfoFrame.CharacterIcon.Image = characterConfig.icon
end

--[[
	初始化角色UI
]]--
local function Init(teamID)
    local teamCharacterData = characterConfigs.CharacterConfig[teamID]
    TeamID = teamID
    for index = 1, #teamCharacterData do
        local characterInfoItem = {}
        local characterInfoObj = characterUI.Root.MainFrame.CharacterList.CharacterInfo:Clone()
        characterInfoObj.Visible = true
        characterInfoObj.Parent = characterUI.Root.MainFrame.CharacterList

        local characterConfig = teamCharacterData[index]
        characterInfoObj.CharacterName.Text = characterConfig.name
        characterInfoObj.Icon.Image = characterConfig.icon
        characterInfoItem.obj = characterInfoObj
        characterInfoItem.id = index

        characterInfoItemList[index] = characterInfoItem

        local lindex = index
        local teamid = teamID
        --绑定点击事件
        characterInfoObj.Button.MouseButton1Click:Connect(function()
            -- 展示角色信息
            RefreshCharacterInfoFrame(lindex, teamid, characterInfoObj)
        end)

    end

    currentSelectCharacterID = 0
    characterUI.Root.MainFrame.CharacterInfoFrame.CharacterDesc:FindFirstChild("Description").Text = ""

    characterUI.Enabled = true
end

characterUI.Root.MainFrame.CharacterInfoFrame.ChooseButton.MouseButton1Click:Connect(function()
    print("choose character! ")
    if currentSelectCharacterID == 0 then
        print("please choose a character!")
        return
    end
    SelectCharacterEvent:FireServer(currentSelectCharacterID, TeamID)
    characterUI.Enabled = false
end)

game.ReplicatedStorage.OpenCharacterUIEvent.OnClientEvent:Connect(function(teamID)
    Init(teamID)
end)


return CharacterUIModule