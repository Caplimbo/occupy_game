showShipLocationUI = script.Parent

-- remote event
local showShipLocationEvent = game.ReplicatedStorage:WaitForChild("ShowShipLocationEvent")


showShipLocationEvent.OnClientEvent:Connect(function(possibleLocations)
    local message = "possible locations: "
    for _, v in pairs(possibleLocations) do
        message = message..v..", "
    end
    showShipLocationUI.Frame.TextLabel.Text = message
    showShipLocationUI.Enabled = true
    wait(3)
    showShipLocationUI.Enabled = false
end)