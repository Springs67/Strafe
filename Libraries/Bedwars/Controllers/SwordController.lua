local lplr = game:GetService('Players').LocalPlayer
local gameCamera = workspace.CurrentCamera

local swordController = {
    Name = 'SwordController',
    lastAttack = workspace:GetServerTimeNow()
}

local swingSwordSound = Instance.new('Sound', workspace)
swingSwordSound.SoundId = 'rbxassetid://6760544639'
swingSwordSound.Volume *= 0.4

local swingSwordAnim = Instance.new('Animation')
swingSwordAnim.AnimationId = 'rbxassetid://4947108314'

local swingSwordFPAnim = Instance.new('Animation')
swingSwordFPAnim.AnimationId = 'rbxassetid://8089691925'

local swordFPLoaded = gameCamera:WaitForChild('Viewmodel').Humanoid:LoadAnimation(swingSwordFPAnim)
swordFPLoaded.Looped = false

local swordLoaded = (lplr.Character and lplr.Character:FindFirstChild('Humanoid')) and lplr.Character:FindFirstChild('Humanoid').Animator:LoadAnimation(swingSwordAnim) or nil

lplr.CharacterAdded:Connect(function(character)
    repeat
        task.wait()
    until lplr.Character and lplr.Character:FindFirstChild('Humanoid')

    swordLoaded = lplr.Character:FindFirstChild('Humanoid'):WaitForChild('Animator'):LoadAnimation(swingSwordAnim)
end)

function swordController:playSwordEffect()
    if not lplr.Character then
        return
    end

    if not lplr.Character:FindFirstChild('Humanoid') then
        return
    end

    if not (lplr.Character:FindFirstChild('Humanoid').Health > 0) then
        return
    end

    swingSwordSound.SoundId = math.round(math.random(1, 2)) == 1 and 'rbxassetid://6760544639' or 'rbxassetid://6760544595'
    
    swordLoaded:Play()
    swordFPLoaded:Play()
    swingSwordSound:Play()
end

return swordController