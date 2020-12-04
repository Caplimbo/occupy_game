local SelectTeamUIModule = {}

SelectTeamUI.Team1Button.MouseButton1Click:Connect(function()
    print("player choose team 1!")
    SelectTeamEvent:FireServer(1)
end)

SelectTeamUI.Team2Button.MouseButton1Click:Connect(function()
    print("player choose team 2!")
    SelectTeamEvent:FireServer(2)
end)

SelectTeamUI.Team3Button.MouseButton1Click:Connect(function()
    print("player choose team 3!")
    SelectTeamEvent:FireServer(3)
end)
return SelectTeamUIModule