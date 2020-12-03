local NextTurnUIModule = {}

local nextTurnUI = script.Parent

-- remote event
NextTurnEvent = game.ReplicatedStorage:WaitForChild("NextTurnEvent")

itemUI.NextTurnButton.MouseButton1Click:Connect(function()
    print("Next Turn!")
    NextTurnEvent:FireServer()
end)

return NextTurnUIModule