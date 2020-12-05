NextTurnEvent = game.ReplicatedStorage:WaitForChild("NextTurnEvent")
nextTurnButton = script.Parent

nextTurnButton.Activated:Connect(function()
    print("Next Turn!")
    NextTurnEvent:FireServer()
end)