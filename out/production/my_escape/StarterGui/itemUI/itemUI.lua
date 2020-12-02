-- activation func for a button

script.Parent.Activated:Connect(function()
    print("Firing!")
    local id = game.Players.LocalPlayer.character.itemid.Value
    print("local id is ", id)
    game.ReplicatedStorage.ItemControl.TryItem:FireServer(id)
    -- how to pass the id outside?
    return id
end)
