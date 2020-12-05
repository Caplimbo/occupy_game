local occupyButton = script.Parent
local occupyUI = occupyButton.Parent

local OccupyPartEvent = game.ReplicatedStorage:WaitForChild("OccupyPartEvent")
local CloseOccupyUIEvent = game.ReplicatedStorage:WaitForChild("CloseOccupyUIEvent")
local OpenOccupyUIEvent = game.ReplicatedStorage:WaitForChild("OpenOccupyUIEvent")


occupyButton.Activated:Connect(function()
    -- 本地进行移动力的判断，甚至可以更进一步设置为移动力0时UI不可见
    --[[
    player = Players.LocalPlayer
    if player.mobility.Value == 0 then
        print("No mobility to occupy!")
        return
    end
    ]]--
    OccupyPartEvent:FireServer()
    -- 每回合至多占点一次
    occupyUI.Enabled = false
end)

CloseOccupyUIEvent.OnClientEvent:Connect(function()
    occupyUI.Enabled = false
end)

OpenOccupyUIEvent.OnClientEvent:Connect(function()
    occupyUI.Enabled = true
end)