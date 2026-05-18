-- only used on moderator accounts in bedfight

local textChatService = game:GetService('TextChatService')
local playerService = game:GetService('Players')

for _, value: Player in playerService:GetPlayers() do
    if value == playerService.LocalPlayer then
        continue end;

    textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('/ban ' .. value.Name)
    task.wait(1)
end

playerService.PlayerAdded:Connect(function(player: Player)
    textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('/ban ' .. value.Name)
end)
