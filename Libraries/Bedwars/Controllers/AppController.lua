local lplr = game:GetService('Players').LocalPlayer

local appController = {
    Name = 'AppController',
}

function appController.isAppOpen(name: string)
    return lplr.PlayerGui:FindFirstChild(name) and lplr.PlayerGui:FindFirstChild(name).Enabled
end

return appController