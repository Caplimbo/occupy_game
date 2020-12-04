local SelectTeamUIModule = {}

SelectTeamUI = script.Parent

-- remote Event
local SelectTeamEvent = game.ReplicatedStorage:WaitForChild("SelectTeamEvent")

SelectTeamUI.Team1Button.Activated:Connect(function()
    print("player choose team 1!")
    SelectTeamEvent:FireServer(1)
    SelectTeamUI.Enabled = false
    --SelectCharacterUI.Enabled = true
end)

SelectTeamUI.Team2Button.Activated:Connect(function()
    print("player choose team 2!")
    SelectTeamEvent:FireServer(2)
    SelectTeamUI.Enabled = false
    --SelectCharacterUI.Enabled = true
end)


SelectTeamUI.Team3Button.Activated:Connect(function()
    print("player choose team 3!")
    SelectTeamEvent:FireServer(3)
    SelectTeamUI.Enabled = false
    --SelectCharacterUI.Enabled = true
end)

return SelectTeamUIModule