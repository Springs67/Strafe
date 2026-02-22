local Players = game:GetService("Players")
local lEntity = Players.LocalPlayer

local Entity = {}
Entity.char = nil
Entity.root = nil
Entity.hum = nil
Entity.isAlive = false
Entity.getAlive = function(plr: Player)
    plr = plr or lEntity

    if plr.Character and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 and plr.Character.PrimaryPart then
        return true
    end

    return false
end

task.spawn(function()
    repeat
        task.wait()
        
        Entity.isAlive = Entity.getAlive()

        if Entity.getAlive() then
            Entity.char = lEntity.Character
            Entity.root = lEntity.Character.PrimaryPart
            Entity.hum = lEntity.Character.Humanoid
        end
    until false
end)

shared.EntityLib = Entity

return Entity