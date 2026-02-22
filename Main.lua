local GuiLibrary = loadfile('Strafe/GuiLibrary.lua')()
local Games = loadfile('Strafe/Games.lua')()
loadfile('Strafe/Universal.lua')()

shared.didQueue = false
game:GetService('Players').LocalPlayer.OnTeleport:Connect(function()
    if shared.didQueue then
        return
    end

    shared.didQueue = true
    queue_on_teleport([[
        loadfile('Strafe/Main.lua')()
    ]])
end)


for i, v in Games do
    for _, id in v do
        if game.PlaceId == id then
            loadfile('Strafe/Games/'..i..'.lua')()
        end
    end
end