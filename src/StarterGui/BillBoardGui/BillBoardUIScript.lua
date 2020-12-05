game.ReplicatedStorage.ShowInfoBoardEvent.OnClientEvent:Connect(function(partName, message)
    local hoverPart = game.Workspace[partName]
    script.Parent.Adornee = hoverPart
    script.Parent.Enabled = true
    script.Parent.Frame.TextLabel.Text = message
end)


game.ReplicatedStorage.HideInfoBoardEvent.OnClientEvent:Connect(function()
    script.Parent.Enabled = false
end)