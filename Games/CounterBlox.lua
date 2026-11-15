local players = game:GetService('Players')
local runService = game:GetService('RunService')
local soundService = game:GetService('SoundService')
local userInputService = game:GetService('UserInputService')

local GuiLibrary = shared.GuiLibrary
local entityLib = loadfile('Strafe/Libraries/Entity.lua')()

GuiLibrary:getWindow('Visual'):getModule('Atmosphere'):Remove()

local getNearestToMouse = function(range: number)
    local nearest, distance = nil, math.huge

    for index, value: Player in players:GetPlayers() do
        if value == players.LocalPlayer then
            continue
        end

        if value.Team == players.LocalPlayer.Team then
            continue
        end

        if not entityLib.getAlive(value) then
            continue
        end

        local sPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(value.Character.PrimaryPart.CFrame.Position)

        if onScreen and sPos.Z > 0 then
            local dist = (userInputService:GetMouseLocation() - Vector2.new(sPos.X, sPos.Y)).Magnitude

            if dist < distance and dist <= range then
                nearest = value
                distance = dist
            end
        end
    end

    return nearest, distance
end

local removeY = function(vec3: Vector3)
	return Vector3.new(vec3.X, 0, vec3.Z)
end

local resolvePos = function(entity: Model, distance: number)
	return entityLib.root.CFrame.Position + (removeY(entityLib.root.AssemblyLinearVelocity) * 0.07 + distance)
end

local resolveNewPos = function(entity: Model, targetEntity: Model, distance: number)
	local expected = resolvePos(entity, distance)
	local dataPos = (entity.PrimaryPart.CFrame.Position - targetEntity.PrimaryPart.CFrame.Position)
	
	local rayCheck = workspace:Raycast(expected, dataPos.Unit * (removeY(dataPos).Magnitude))
	
	if rayCheck then
		return expected
	end
	
	return entity.PrimaryPart.CFrame.Position
end

local button2Down = false
players.LocalPlayer:GetMouse().Button2Down:Connect(function()
    button2Down = true
end)
players.LocalPlayer:GetMouse().Button2Up:Connect(function()
    button2Down = false
end)

local FOVInstance = Instance.new('Frame')
FOVInstance.Parent = GuiLibrary.screen
FOVInstance.Position = UDim2.fromScale(0.5, 0.5)
FOVInstance.AnchorPoint = Vector2.new(0.5, 0.5)
FOVInstance.Size = UDim2.fromOffset(30, 30)
FOVInstance.BackgroundTransparency = 1
FOVInstance.Visible = false
local FOVInstanceStroke = Instance.new('UIStroke')
FOVInstanceStroke.Parent = FOVInstance
FOVInstanceStroke.Color = Color3.fromRGB(255, 255, 255)
FOVInstanceStroke.Thickness = 1
local FOVInstanceRound = Instance.new('UICorner')
FOVInstanceRound.Parent = FOVInstance
FOVInstanceRound.CornerRadius = UDim.new(1, 0)

GuiLibrary.GuiChange.Event:Connect(function(val)
    FOVInstanceStroke.Color = val
end)

Ragebot = GuiLibrary:registerModule({
    ['Name'] = 'Ragebot',
    ['Window'] = 'Combat',
    ['Callback'] = function(callback)
        if callback then
            runService:BindToRenderStep('Ragebot', 9999, function(dt: number)
                if not entityLib.isAlive then
                    return
                end

                local nearest = getNearestToMouse(RagebotFOV and RagebotFOV.Value or 20)

                if nearest and button2Down then
                    workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, nearest.Character.Head.CFrame.Position)
                end
            end)
        else
            runService:UnbindFromRenderStep('Ragebot')
        end
    end
})
SilentAim = Ragebot:registerToggle({
    ['Name'] = 'Silent Aim',
})
AutoShoot = Ragebot:registerToggle({
    ['Name'] = 'Auto Shoot',
})
RagebotFOV = Ragebot:registerSlider({
    ['Name'] = 'Field of View',
    ['Minimum'] = 1,
    ['Maximum'] = 360,
    ['Default'] = 90,
    ['Callback'] = function(val)
        FOVInstance.Size = UDim2.fromOffset(val * 1.5, val * 1.5)
    end
})
ShowFOV = Ragebot:registerToggle({
    ['Name'] = 'Show FOV',
    ['Callback'] = function(callback)
        FOVInstance.Visible = callback
    end
})

local blacklistParams = RaycastParams.new()
blacklistParams.FilterType = Enum.RaycastFilterType.Exclude
blacklistParams.FilterDescendantsInstances = {entityLib.char}

players.LocalPlayer.CharacterAdded:Connect(function(character)
    repeat task.wait() until character and entityLib.char
    task.wait(1)
    blacklistParams.FilterDescendantsInstances = {entityLib.char}
end)

local currentSpeedValue = 16
local oldGrav = workspace.Gravity
BHop = GuiLibrary:registerModule({
    ['Name'] = 'BunnyHop',
    ['Window'] = 'Movement',
    ['Callback'] = function(callback)
        if callback then
            local speedVal = 16
            runService:BindToRenderStep('BunnyHop', 999, function(dt: number)
                if not entityLib.isAlive then
                    return
                end

                local onGround = workspace:Raycast(entityLib.root.CFrame.Position - Vector3.new(0, 3, 0), Vector3.new(0, -0.75, 0), blacklistParams)

                if userInputService:IsKeyDown(Enum.KeyCode.Space) and onGround and not RageMode.Enabled then
                    entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, 22, entityLib.root.AssemblyLinearVelocity.Z)
                    return
                end

                if userInputService:IsKeyDown(Enum.KeyCode.Space) and currentSpeedValue < (RageMaxSpeed and RageMaxSpeed.Value or 16) then
                    currentSpeedValue += dt * 6
                end
                
                if userInputService:IsKeyDown(Enum.KeyCode.Space) and onGround then
                    entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, 19, entityLib.root.AssemblyLinearVelocity.Z)
                end

                if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    workspace.Gravity = 60
                else
                    workspace.Gravity = oldGrav
                    if currentSpeedValue > 16 then
                        currentSpeedValue -= dt * 6
                    end

                    if onGround then
                        currentSpeedValue = 16
                    end
                end

                if entityLib.char:FindFirstChild('Crouched') and onGround and not userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    currentSpeedValue = 10
                end

                if entityLib.char.ADS.Value and onGround and not userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    currentSpeedValue = 9
                end

                if workspace:GetServerTimeNow() - entityLib.char:GetAttribute('LastSpawn') < 6 then
                    currentSpeedValue = 0
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.hum.MoveDirection.X * currentSpeedValue, entityLib.root.AssemblyLinearVelocity.Y, entityLib.hum.MoveDirection.Z * currentSpeedValue)

                if not userInputService:IsKeyDown(Enum.KeyCode.W) and not userInputService:IsKeyDown(Enum.KeyCode.A) and not userInputService:IsKeyDown(Enum.KeyCode.S) and not userInputService:IsKeyDown(Enum.KeyCode.D) then
                    entityLib.root.AssemblyLinearVelocity = Vector3.new(0, entityLib.root.AssemblyLinearVelocity.Y, 0)
                end
            end)
        else
            runService:UnbindFromRenderStep('BunnyHop')
        end
    end
})
RageMode = BHop:registerToggle({
    ['Name'] = 'Rage',
})
RageMaxSpeed = BHop:registerSlider({
    ['Name'] = 'Max Speed',
    ['Minimum'] = 16,
    ['Maximum'] = 32,
    ['Default'] = 28,
})

--[[local lastConnectionFlash = nil
local lastConnectionFlash2 = nil
local lastConnectionFlash3 = nil
AntiFlash = GuiLibrary:registerModule({
    ['Name'] = 'AntiFlash',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        if callback then
            lastConnectionFlash = players.LocalPlayer.PlayerGui.Blind.Full:GetPropertyChangedSignal('Value'):Connect(function()
                players.LocalPlayer.PlayerGui.Blind.Duration.Value = 0
            end)
            lastConnectionFlash3 = players.LocalPlayer.PlayerGui.Blind.Duration:GetPropertyChangedSignal('Value'):Connect(function()
                players.LocalPlayer.PlayerGui.Blind.Duration.Value = 0
            end)
            lastConnectionFlash2 = soundService.Sounds.Flashbang:GetPropertyChangedSignal('Enabled'):Connect(function()
                soundService.Sounds.Flashbang.Enabled = false
            end)
        else
            lastConnectionFlash:Disconnect();
            lastConnectionFlash2:Disconnect();
            lastConnectionFlash3:Disconnect();

            lastConnectionFlash = nil
            lastConnectionFlash2 = nil
            lastConnectionFlash3 = nil
        end
    end
})]]