local ResultNoticeUI = script.Parent

local winnerNoticeEvent = game.ReplicatedStorage.WinnerNoticeEvent
local loserNoticeEvent = game.ReplicatedStorage.LoserNoticeEvent

winnerNoticeEvent.OnClientEvent:Connect(function()
    ResultNoticeUI.Enabled = true
    ResultNoticeUI.Frame.TextLabel.Text = "Congratulations! You win!"
end)

loserNoticeEvent.OnClientEvent:Connect(function()
    ResultNoticeUI.Enabled = true
    ResultNoticeUI.Frame.TextLabel.Text = "You lose!"
end)