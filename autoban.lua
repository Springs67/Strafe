local textChatService = game:GetService('TextChatService')
local playerService = game:GetService('Players')

local excludedAccounts = {
    'HeyItsDaiPlayz',
    'ReidHaloRBX',
    'ohhiimnoobinarsenal2',
    'Ragebaitedimbanned',
    'ReaiPoyo',
    'il9e9',
    'GrumpGravySeerp',
    'GameMaster4268',
    'JuniorMoney4953',
    'GreenWatermelon3025',
    'LemonJuice5824',
    'flipthetop11111e'
}

for _, value: Player in playerService:GetPlayers() do
    if value == playerService.LocalPlayer then
        continue end;

    if table.find(excludedAccounts, value.Name) then
        continue end;

    textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('/ban ' .. value.Name)

end

playerService.PlayerAdded:Connect(function(value: Player)
    if table.find(excludedAccounts, value.Name) then
        return end;

    textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('/ban ' .. value.Name)
end)
