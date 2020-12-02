-- ================================================================================
-- ItemUIModule
-- ================================================================================
--[[
	道具界面
]]--
local ItemUIModule = {}

-- ================================================================================
-- VARIABLES
-- ================================================================================
local petUI = script.Parent

-- RemoteEvent
local EquipPetEvent = game.ReplicatedStorage:WaitForChild("EquipPetEvent")
local UnEquipPetEvent = game.ReplicatedStorage:WaitForChild("UnEquipPetEvent")
local ReleasePetEvent = game.ReplicatedStorage:WaitForChild("ReleasePetEvent")

-- BindableEvent
local PetUIRefreshBindableEvent = game.ReplicatedStorage:WaitForChild("PetUIRefreshBindableEvent")

-- ModuleScript
local playerPetData = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerPetData"))
local petConfigs = require(game.ReplicatedStorage.Config.PetConfigs)

-- 当前选择的宠物ID
local currentSelectPetID = 0

-- 宠物信息列表
local petInfoItemList = {}

-- 等待宠物信息
wait()
local testBaseData = playerPetData:GetBaseData()
while testBaseData == nil do
    wait()
    testBaseData = playerPetData:GetBaseData()
end

-- ================================================================================
-- FUNCTIONS
-- ================================================================================
--[[
	刷新PetInfoFrame，初始化或者点击背包内宠物头像时调用
]]--
local function RefreshPetInfoFrame(petData, petInfoObj)
    if petInfoObj.Equiped.Visible then
        petUI.Root.MainFrame.PetInfoFrame.EquipButton.Visible = false
        petUI.Root.MainFrame.PetInfoFrame.UnEquipButton.Visible = true
    else
        petUI.Root.MainFrame.PetInfoFrame.EquipButton.Visible = true
        petUI.Root.MainFrame.PetInfoFrame.UnEquipButton.Visible = false
    end

    if currentSelectPetID ~= 0 then
        local currentPetInfo = petInfoItemList[currentSelectPetID]
        currentPetInfo.obj.Select.Visible = false
        currentPetInfo.obj.Bg.Visible = true
    end

    currentSelectPetID = petData.ID
    petInfoObj.Select.Visible = true
    petInfoObj.Bg.Visible = false

    local petConfig = petConfigs.PetConfig[petData.templateID]

    for proIndex = 1, 2, 1 do
        petUI.Root.MainFrame.PetInfoFrame.PetDesc:FindFirstChild("Pro" .. proIndex).Text = petConfig.desc[proIndex][2]
        if petConfig.desc[proIndex][3] then
            petUI.Root.MainFrame.PetInfoFrame.PetDesc:FindFirstChild("Pro" .. proIndex .. "Num").Text = "+" .. petConfig[petConfig.desc[proIndex][1]]
        else
            petUI.Root.MainFrame.PetInfoFrame.PetDesc:FindFirstChild("Pro" .. proIndex .. "Num").Text = "+" .. petConfig[petConfig.desc[proIndex][1]] * 100 .. "%"
        end
    end
    petUI.Root.MainFrame.PetInfoFrame.PetNameLabel.Text = petConfig.name
    petUI.Root.MainFrame.PetInfoFrame.PetIcon.Image = petConfig.icon
end

--[[
	初始化宠物UI
]]--
local function Init()
    for key, value in pairs(petInfoItemList) do
        value.obj:Destroy()
    end

    local currentPetData = playerPetData:GetBaseData()

    petInfoItemList = {}
    petUI.Root.MainFrame.PetInfoFrame.ReleaseButton.Visible = true

    for index = 1, #currentPetData.ownedPetList, 1 do
        local petInfoItem = {}
        local petInfoObj = petUI.Root.MainFrame.PetList.PetInfo:Clone()
        petInfoObj.Visible = true
        petInfoObj.Parent = petUI.Root.MainFrame.PetList

        local petConfig = petConfigs.PetConfig[currentPetData.ownedPetList[index].templateID]

        petInfoObj.PetName.Text = petConfig.name
        petInfoObj.Icon.Image = petConfig.icon
        petInfoItem.obj = petInfoObj
        petInfoItem.id = currentPetData.ownedPetList[index].ID

        petInfoItemList[petInfoItem.id] = petInfoItem

        for currentIndex = 1, #currentPetData.currentPetList, 1 do
            if currentPetData.currentPetList[currentIndex] == currentPetData.ownedPetList[index].ID then
                petInfoObj.Equiped.Visible = true
                break
            end
        end

        --绑定点击事件
        petInfoObj.Button.MouseButton1Click:Connect(function()
            RefreshPetInfoFrame(currentPetData.ownedPetList[index], petInfoObj)
        end)
    end

    if #currentPetData.ownedPetList == 0 then
        currentSelectPetID = 0
        petInfoItemList = {}
        petUI.Root.MainFrame.PetInfoFrame.EquipButton.Visible = false
        petUI.Root.MainFrame.PetInfoFrame.UnEquipButton.Visible = false
        petUI.Root.MainFrame.PetInfoFrame.ReleaseButton.Visible = false
        petUI.Root.MainFrame.PetInfoFrame.PetNameLabel.Text = ""
        for proIndex = 1, 2, 1 do
            petUI.Root.MainFrame.PetInfoFrame.PetDesc:FindFirstChild("Pro" .. proIndex).Text = ""
            petUI.Root.MainFrame.PetInfoFrame.PetDesc:FindFirstChild("Pro" .. proIndex .. "Num").Text = ""
        end
    else
        currentSelectPetID = currentPetData.ownedPetList[1].ID
        local currentPetInfo = petInfoItemList[currentSelectPetID]
        RefreshPetInfoFrame(currentPetData.ownedPetList[1], currentPetInfo.obj)
    end
end

--[[
	对外接口，打开宠物UI
]]--
function PetUIModule:OpenUI()
    Init()
end

-- ================================================================================
-- CONNECTIONS
-- ================================================================================
--[[
	点击装备宠物按钮响应
]]--
petUI.Root.MainFrame.PetInfoFrame.EquipButton.MouseButton1Click:Connect(function()

    local currentPetData = playerPetData:GetBaseData()

    if currentPetData.canEquipNum > #currentPetData.currentPetList then
        if currentSelectPetID ~= 0 then
            EquipPetEvent:FireServer(currentSelectPetID)
        end
    end
end)

--[[
	点击卸载宠物按钮响应
]]--
petUI.Root.MainFrame.PetInfoFrame.UnEquipButton.MouseButton1Click:Connect(function()
    if currentSelectPetID ~= 0 then
        UnEquipPetEvent:FireServer(currentSelectPetID)
    end
end)

--[[
	点击释放宠物按钮响应
]]--
petUI.Root.MainFrame.PetInfoFrame.ReleaseButton.MouseButton1Click:Connect(function()
    if currentSelectPetID ~= 0 then
        ReleasePetEvent:FireServer(currentSelectPetID)
    end
end)

--[[
	点击关闭按钮响应
]]--
petUI.Root.CloseButton.MouseButton1Click:Connect(function()
    petUI.Enabled = false
end)

--[[
	响应刷新宠物界面，只监听装备，卸载，释放操作
]]--
PetUIRefreshBindableEvent.Event:Connect(function(operate, petID)
    if operate == 1 then
        local currentPetInfo = petInfoItemList[petID]
        if petID == currentSelectPetID then
            petUI.Root.MainFrame.PetInfoFrame.EquipButton.Visible = false
            petUI.Root.MainFrame.PetInfoFrame.UnEquipButton.Visible = true
        end
        currentPetInfo.obj.Equiped.Visible = true
    elseif operate == 2 then
        local currentPetInfo = petInfoItemList[petID]
        if petID == currentSelectPetID then
            petUI.Root.MainFrame.PetInfoFrame.EquipButton.Visible = true
            petUI.Root.MainFrame.PetInfoFrame.UnEquipButton.Visible = false
        end
        currentPetInfo.obj.Equiped.Visible = false
    elseif operate == 3 then
        Init()
    end
end)

return ItemUIModule