local players = game:GetService('Players')
local runService = game:GetService('RunService')
local soundService = game:GetService('SoundService')
local TextService = game:GetService("TextService")
local TweenService = game:GetService('TweenService')
local userInputService = game:GetService('UserInputService')

local GuiLibrary = shared.GuiLibrary
local entityLib = loadfile('Strafe/Libraries/Entity.lua')()

GuiLibrary:getWindow('Visual'):getModule('Nametags'):Remove();

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

Flight = GuiLibrary:registerModule({
    ['Name'] = 'Flight',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return 'Vanilla'
    end,
    ['Callback'] = function(callback)
        if callback then
            local startTick = tick()
            runService:BindToRenderStep('Flight', 9999, function(dt)
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                local flyVal = 1
                if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyVal = 50
                elseif userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyVal = -50
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, flyVal, entityLib.root.AssemblyLinearVelocity.Z)
            end)
        else
            runService:UnbindFromRenderStep('Flight')
        end
    end
})

local getSpeed = function(val: number)
    val -= entityLib.hum.WalkSpeed

    return val
end

Speed = GuiLibrary:registerModule({
    ['Name'] = 'Speed',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return 'CFrame'
    end,
    ['Callback'] = function(callback)
        if callback then
            runService:BindToRenderStep('Speed', 9999, function(dt)
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                entityLib.root.CFrame += (entityLib.hum.MoveDirection * getSpeed(SpeedValue and SpeedValue.Value or 26) * dt)
            end)
        else
            runService:UnbindFromRenderStep('Speed')
        end
    end
})
SpeedValue = Speed:registerSlider({
    ['Name'] = 'Value',
    ['Minimum'] = 16,
    ['Maximum'] = 27,
    ['Default'] = 26,
})

Strafe = GuiLibrary:registerModule({
    ['Name'] = 'Strafe',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return 'Velocity'
    end,
    ['Callback'] = function(callback)
        if callback then
            runService:BindToRenderStep('Strafe', 999, function()
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.hum.MoveDirection.X * entityLib.hum.WalkSpeed, entityLib.root.AssemblyLinearVelocity.Y, entityLib.hum.MoveDirection.Z * entityLib.hum.WalkSpeed)
            end)
        else
            runService:UnbindFromRenderStep('Strafe')
        end
    end
})


local currFolder = Instance.new('Folder', workspace)

local function toColor3(brickColor: BrickColor)
	local r = math.round(brickColor.r * 255)
	local g = math.round(brickColor.g * 255)
	local b = math.round(brickColor.b * 255)
	
	return Color3.fromRGB(r, g, b)
end

local function getRole(plr: Player)
    for index, value in plr.Backpack:GetChildren() do
        if value.Name == 'Knife' then
            return 'Murderer'
        elseif value.Name == 'Gun' then
            return 'Sheriff'
        end
    end
end

local addNametags = function(plr: Player)
    if not plr or not plr.Character or not plr.Character:FindFirstChild('Head') then
        return
    end

    local Background = Instance.new('BillboardGui')
    Background.Parent = currFolder
    Background.AlwaysOnTop = true
    Background.StudsOffset = Vector3.new(0, 1.35, 0)
    Background.Size = UDim2.fromScale(1, 1)
    Background.Adornee = plr.Character:WaitForChild('Head', 5)
    Background.Name = plr.UserId

    local Text = Instance.new('TextLabel')
    Text.Parent = Background
    Text.AnchorPoint = Vector2.new(0.5, 0.5)
    Text.BackgroundTransparency = 0.5
    Text.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextSize = 16
    Text.Text = plr.DisplayName
    Text.Font = Enum.Font.BuilderSansMedium

    Text.Size = UDim2.fromOffset(TextService:GetTextSize(Text.Text, Text.TextSize, Text.Font, Vector2.zero).X + 4, 20)

    if plr.Character and plr.Character:WaitForChild('Humanoid', 1) then
        plr.Character:FindFirstChildOfClass('Humanoid').DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    if plr.Team == players.LocalPlayer.Team and ESPTeam.Enabled then
        Background.Enabled = false
    end
end

local removeTags = function(plr: Player)
    if currFolder:FindFirstChild(plr.Name) then
        currFolder:FindFirstChild(plr.Name):Destroy()
    end
end

local refreshESP = function()
    for _, value in currFolder:GetChildren() do
        local plr = players:GetPlayerByUserId(tonumber(value.Name))

        --value.TextLabel.TextColor3 = toColor3(plr.TeamColor)
        if getRole(plr) == 'Murderer' then
            value.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        elseif getRole(plr) == 'Sheriff' then
            value.TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
        else
            value.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        if plr and plr.Team == players.LocalPlayer.Team and ESPTeam.Enabled then
            value.Enabled = false
        else
            value.Enabled = true
        end
    end
end

local Nametags; Nametags = GuiLibrary:registerModule({
    ['Name'] = 'Nametags',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        if callback then
            for _, value: Player in players:GetPlayers() do
                if value == players.LocalPlayer then
                    continue
                end

                if value.Character then
                    addNametags(value);
                    refreshESP()
                end

                value.CharacterAdded:Connect(function()
                    repeat task.wait() until value.Character
                    task.wait(2)
                    addNametags(value);
                    refreshESP()
                end)

                value.CharacterRemoving:Connect(function()
                    removeTags(value);
                    refreshESP()
                end)
            end

            players.PlayerAdded:Connect(function(value: Player)
                value.CharacterAdded:Connect(function()
                    repeat task.wait() until value.Character
                    task.wait(2)
                    addNametags(value);
                    refreshESP();
                end)

                value.CharacterRemoving:Connect(function()
                    removeTags(value);
                    refreshESP();
                end)
            end)

            players.PlayerRemoving:Connect(function(player: Player)
                removeTags(player)
                refreshESP();
            end)

            repeat
                task.wait(0.1)
                refreshESP();
            until not Nametags.Enabled
        else
            for index, value in currFolder:GetChildren() do
                value:Destroy();
            end
        end
    end
})

ESPTeam = Nametags:registerToggle({
    ['Name'] = 'Team Check',
    ['Callback'] = function(callback)
        refreshESP()
    end
})

local function getMap()
    for _, value in workspace:GetChildren() do
        if value:FindFirstChild('Spawns') and not value.Name:find('Lobby') then
            return value;
        end
    end

    return nil;
end

local function getNearestCoin()
    local map = getMap();

    if map then
        local nearest, distance = nil, math.huge;

        for index, value in map.CoinContainer:GetChildren() do
            local dist = players.LocalPlayer:DistanceFromCharacter(value.Position)

            if dist < distance then
                distance = dist
                nearest = value;
            end
        end

        return nearest, distance;
    end

end

--[[
local dist = players.LocalPlayer:DistanceFromCharacter(value.Position)
            local tween = TweenService:Create(entityLib.root, TweenInfo.new(dist / 40), {
                CFrame = value.CFrame + Vector3.new(0, 2, 0)
            })
            tween:Play()
            tween.Completed:Wait()]]

AutoCoin = GuiLibrary:registerModule({
    ['Name'] = 'Auto Coin',
    ['Window'] = 'Misc',
    ['Callback'] = function(state)
        if state then
            repeat
                task.wait()
                if not entityLib.isAlive then
                    continue
                end

                local nearestCoin, distance = getNearestCoin();

                if nearestCoin and distance < 100 then
                    local dist = players.LocalPlayer:DistanceFromCharacter(nearestCoin.Position)
                    local tween = TweenService:Create(entityLib.root, TweenInfo.new(dist / 40), {
                        CFrame = nearestCoin.CFrame + Vector3.new(0, 2, 0)
                    })
                    tween:Play()
                    tween.Completed:Wait()
                end
            until not AutoCoin.Enabled
        end
    end
})

AutoTool = GuiLibrary:registerModule({
    ['Name'] = 'Auto Tool',
    ['Window'] = 'Player',
    ['Callback'] = function(state)
        if state then
            repeat
                task.wait()

                local map = getMap();

                if map then
                    if map:FindFirstChild('Gun') then
                        
                    end
                end
            until not AutoTool.Enabled
        end
    end
})