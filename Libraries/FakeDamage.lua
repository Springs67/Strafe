local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local fakeDamage = {}

local damageEffect = Instance.new('Sound')
damageEffect.Parent = SoundService
damageEffect.SoundId = 'rbxassetid://73369656122118'

function fakeDamage.new()
    local tilt = math.rad(12)
    local start = tick()

    damageEffect.TimePosition = 0.1
    damageEffect:Play()
    RunService:BindToRenderStep('CameraDamageEffect', 9999, function(dt)
        if (tick() - start) > 0.2 then
            RunService:UnbindFromRenderStep('CameraDamageEffect')
        end

        workspace.CurrentCamera.CFrame *= CFrame.Angles(0, 0, tilt * (1 - ((tick() - start) / 0.2)))
    end)
end

return fakeDamage