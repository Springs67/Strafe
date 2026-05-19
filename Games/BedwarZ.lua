local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local lEntity = Players.LocalPlayer

if not lEntity.Character then
    lEntity.CharacterAdded:Wait()
    repeat task.wait() until lEntity.Character

    lEntity.Character:WaitForChild('Humanoid', 999)
    lEntity.Character:WaitForChild('HumanoidRootPart', 999)
end

lEntity:WaitForChild('Settings')

local GuiLibrary = shared.GuiLibrary
local fakeDamage = loadfile('Strafe/Libraries/FakeDamage.lua')()
local progressBar = loadfile('Strafe/Libraries/ProgressBar.lua')()
local entityLib = loadfile('Strafe/Libraries/Entity.lua')()
local Remotes = loadfile('Strafe/Libraries/Network.lua')()

local getRoundedPos = function(Position: Vector3)
    local X = math.floor(Position.X / 3 + 0.5) * 3
    local Y = math.floor(Position.Y / 3) * 3
    local Z = math.floor(Position.Z / 3 + 0.5) * 3

    return Vector3.new(X, Y, Z)
end


-- my goat dev forums
local function worldCFrameToC0ObjectSpace(motor6DJoint,worldCFrame)
	local part1CF = motor6DJoint.Part1.CFrame
	local c1Store = motor6DJoint.C1
	local c0Store = motor6DJoint.C0
	local relativeToPart1 =c0Store*c1Store:Inverse()*part1CF:Inverse()*worldCFrame*c1Store
	relativeToPart1 -= relativeToPart1.Position

	local goalC0CFrame = relativeToPart1+c0Store.Position
	return goalC0CFrame
end

local getNearestBed = function(Range: number)
    local nearest, nearestDist

    if workspace:FindFirstChild('BedsContainer') then
        for _, value in workspace.BedsContainer:GetChildren() do
            local Hitbox = value:FindFirstChild('BedHitbox')

            if Hitbox then
                local Distance = lEntity:DistanceFromCharacter(Hitbox.Position)

                if Distance <= Range and (not nearestDist or Distance < nearestDist) then
                    nearest = Hitbox
                    nearestDist = Distance
                end
            end
        end
    end

    return nearest, nearestDist
end

local getNearestAttackable = function(Range: number)
    local Nearest, Distance = nil, math.huge

    for i, v in Players:GetPlayers() do
        if v == lEntity or not v:GetAttribute('PVP') or not lEntity:GetAttribute('PVP') then continue end
        if not entityLib.getAlive(lEntity) or not entityLib.getAlive(v) then continue end

        if tostring(lEntity.Team.Name) ~= 'Spectators' and v.Team == lEntity.Team then
            continue
        end

        local dist = lEntity:DistanceFromCharacter(v.Character.PrimaryPart.Position)

        if dist <= Range and dist < Distance then
            Nearest = v
            Distance = dist
        end
    end

    return Nearest, Distance
end

local f = {}
local InventoryUtil = {
    getInventory = function(plr: Player)
        plr = plr or lEntity

        table.clear(f)

        for _, v in (plr:FindFirstChild('Backpack') or Instance.new('Folder')):GetChildren() do
            table.insert(f, {
                itemType = v.Name,
                tool = v,
            })
        end

        for i, v in plr.Character:GetChildren() do
            if v.ClassName == 'Model' and v:FindFirstChild('Handle') then
                table.insert(f, {
                    itemType = v.Name,
                    tool = v,
                })
            end
        end

        return {
            items = f,
        }
    end,
}

local function hasItem(item: string, plr)
    local Inventory = InventoryUtil.getInventory(plr or lEntity)

    if Inventory then
        for i, v in Inventory.items do
            if v.itemType:lower():find(item) then
                return true
            end
        end
    end

    return false
end

local function getItem(item: string, plr)
    local Inventory = InventoryUtil.getInventory(plr or lEntity)

    if Inventory then
        for i, v in Inventory.items do
            if v.itemType:lower():find(item) then
                return v
            end
        end
    end

    return nil
end

local function switchHand(name: string)
    return Remotes:Get('EquipTool'):SendToServer(name)
end

local function getViewmodelSword()
    local Sword = getItem('sword')

    if Sword then
        if workspace.CurrentCamera.ViewModel:FindFirstChild(Sword.itemType) then
            if workspace.CurrentCamera.ViewModel[Sword.itemType]:FindFirstChild('ViewModelRootPart') then
                return workspace.CurrentCamera.ViewModel[Sword.itemType]
            end
        end
    end
end

local function placeBlock(pos: Vector3, shouldCollide: boolean)
    local Wool = getItem('wool') or getItem('fake block')

    if Wool then
        pos = getRoundedPos(pos)

        Remotes:Get('PlaceBlock'):SendToServer(Wool.itemType, 1, pos)

        local Clone = ReplicatedStorage.Blocks[Wool.itemType]:Clone()
        Clone.Parent = workspace:FindFirstChildWhichIsA('Folder')
        Clone.Position = pos
        Clone.CanCollide = shouldCollide or true

        task.delay(0.5, function()
            Clone:Destroy()
            Clone = nil
        end)

        return Clone
    end
end

UICleanup = GuiLibrary:registerModule({
    ['Name'] = 'UI Cleanup',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        lEntity.PlayerGui:WaitForChild('TopbarButtonsGui', 999999999).Enabled = not callback
        lEntity.PlayerGui:WaitForChild('KillLogGui', 99999999).Enabled = not callback
    end
})

local startY = 0
local startPosY = Vector3.zero
Longjump = GuiLibrary:registerModule({
    ['Name'] = 'Longjump',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return 'BedFight'
    end,
    ['Callback'] = function(callback)
        if callback then
            entityLib.root.CFrame += Vector3.new(0, 3, 0)
            fakeDamage.new()

            if not Longjump.Enabled then
                return
            end

            local startDir = entityLib.root.CFrame.LookVector
            local startSpeed = 28
            local startTick = tick()
            startY = 50
            startPosY = entityLib.root.CFrame.Y
            RunService:BindToRenderStep('Longjump', 9999, function(dt)
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                startSpeed = 28

                if (tick() - startTick) < (LongjumpBoostTime and LongjumpBoostTime.Value or 0.2) then
                    startSpeed = (LongjumpSpeed and LongjumpSpeed.Value or 300)
                end
                startY -= (workspace.Gravity * dt) / 2

                entityLib.root.AssemblyLinearVelocity = Vector3.new((LongjumpFreeMove.Enabled and entityLib.hum.MoveDirection or startDir).X * startSpeed, (tick() - startTick) < 0.8 and 1 or -5, (LongjumpFreeMove.Enabled and entityLib.hum.MoveDirection or startDir).Z * startSpeed)

                if (tick() - startTick) > (LongjumpDisableTime and LongjumpDisableTime.Value or 0.85) and Longjump.Enabled and LongjumpAutoDisable.Enabled then
                    RunService:UnbindFromRenderStep('Longjump')
                    Longjump:Toggle()
                end
            end)
        else
            RunService:UnbindFromRenderStep('Longjump')
            --entityLib.root.CFrame = CFrame.new(Vector3.new(entityLib.root.CFrame.X, startPosY, entityLib.root.CFrame.Z))
        end
    end
})
LongjumpFreeMove = Longjump:registerToggle({
    ['Name'] = 'Free Move',
})
LongjumpAutoDisable = Longjump:registerToggle({
    ['Name'] = 'Auto Disable',
})
LongjumpSpeed = Longjump:registerSlider({
    ['Name'] = 'Boost Speed',
    ['Step'] = 1,
    ['Minimum'] = 28,
    ['Maximum'] = 600,
    ['Default'] = 550,
})
LongjumpBoostTime = Longjump:registerSlider({
    ['Name'] = 'Boost Time',
    ['Step'] = 0.01,
    ['Minimum'] = 0,
    ['Maximum'] = 0.3,
    ['Default'] = 0.2,
})
LongjumpDisableTime = Longjump:registerSlider({
    ['Name'] = 'Auto Disable Time',
    ['Step'] = 0.025,
    ['Minimum'] = 0.25,
    ['Maximum'] = 1,
    ['Default'] = 0.85,
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
            RunService:BindToRenderStep('Flight', 9999, function(dt)
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                local flyVal = 1
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyVal = 50
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyVal = -50
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, (tick() - startTick) < 1 and flyVal or -5, entityLib.root.AssemblyLinearVelocity.Z)
            end)
        else
            RunService:UnbindFromRenderStep('Flight')
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
        return 'BedFight'
    end,
    ['Callback'] = function(callback)
        if callback then
            RunService:BindToRenderStep('Speed', 9999, function(dt)
                if not entityLib.isAlive or Longjump.Enabled or not isnetworkowner(entityLib.root) then
                    return
                end

                entityLib.root.CFrame += (entityLib.hum.MoveDirection * getSpeed(SpeedValue and SpeedValue.Value or 26) * dt)
            end)
        else
            RunService:UnbindFromRenderStep('Speed')
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
            RunService:BindToRenderStep('Strafe', 999, function()
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.hum.MoveDirection.X * entityLib.hum.WalkSpeed, entityLib.root.AssemblyLinearVelocity.Y, entityLib.hum.MoveDirection.Z * entityLib.hum.WalkSpeed)
            end)
        else
            RunService:UnbindFromRenderStep('Strafe')
        end
    end
})

local swingFPAnimation = Instance.new('Animation'); swingFPAnimation.AnimationId = 'rbxassetid://80138703077151'
local swingFPLoaded = nil;

local swingAnimation = Instance.new('Animation'); swingAnimation.AnimationId = 'rbxassetid://123800159244236'
local swingLoaded = nil;

if entityLib.isAlive then
    swingLoaded = entityLib.hum.Animator:LoadAnimation(swingAnimation)
end

lEntity.CharacterAdded:Connect(function(char)
    repeat task.wait() until lEntity.Character and char and entityLib.isAlive

    swingLoaded = entityLib.hum.Animator:LoadAnimation(swingAnimation)
end)

if workspace.CurrentCamera:FindFirstChild('ViewModel') and workspace.CurrentCamera:FindFirstChild('ViewModel'):FindFirstChild('AnimationController') then
    swingFPLoaded = workspace.CurrentCamera:FindFirstChild('ViewModel'):FindFirstChild('AnimationController').Animator:LoadAnimation(swingFPAnimation)
end

local toolHandlers = game:GetService("ReplicatedStorage").ToolHandlers
local oldC0 = lEntity.Character.Head.Neck.C0
KillAura = GuiLibrary:registerModule({
    ['Name'] = 'SilentAura',
    ['Window'] = 'Combat',
    ['ArrayText'] = function()
        return AuraRange.Value
    end,
    ['Callback'] = function(callback)
        if callback then
            local lastSwitch = tick()
            local lastAttacked = tick()
            RunService:BindToRenderStep('KillAura', 9999, function()
                if not entityLib.isAlive then
                    return
                end

                local Entity = getNearestAttackable(AuraRange and AuraRange.Value or 22)
                local Sword = getItem('sword')

                if Entity and Sword then
                    if HoldItemCheck.Enabled and not lEntity.Character:FindFirstChild(Sword.itemType) then
                        return
                    end

                    if DoRotations.Enabled then
                        lEntity.Character.Head.Neck.C0 = worldCFrameToC0ObjectSpace(lEntity.Character.Head.Neck, CFrame.lookAt(entityLib.root.CFrame.Position, Entity.Character.PrimaryPart.CFrame.Position))
                        entityLib.root.CFrame = CFrame.lookAt(entityLib.root.CFrame.Position, Vector3.new(Entity.Character.PrimaryPart.CFrame.Position.X, entityLib.root.CFrame.Y, Entity.Character.PrimaryPart.CFrame.Position.Z))
                    end

                    if (tick() - lastSwitch) > 0.4 and (AutoSwitch and AutoSwitch.Enabled or false) then
                        lastSwitch = tick()
                        switchHand(Sword.itemType)
                    end

                    if (tick() - lastAttacked) < (AuraDelay and AuraDelay.Value or 0.285) then
                        return
                    end

                    if PlaySwingAnim.Enabled then
                        if not swingLoaded then
                            swingLoaded = entityLib.hum.Animator:LoadAnimation(swingAnimation)
                        end

                        swingLoaded:Play()
                        swingFPLoaded:Play()
                    end

                    if PlaySwingSound.Enabled then
                        local var = tostring(math.round(math.random(1, 2)))

                        if entityLib.root:FindFirstChild('Swing'..var) then
                            entityLib.root:FindFirstChild('Swing'..var):Play()
                        else
                            toolHandlers.Sword.Sounds.Default['Swing'..var]:Clone().Parent = entityLib.root
                        end
                    end
                    
                    lastAttacked = tick()
                    Remotes:Get('SwordHit'):SendToServer(Entity.Character, Sword.itemType)
                else
                    lEntity.Character.Head.Neck.C0 = oldC0
                end
            end)
        else
            RunService:UnbindFromRenderStep('KillAura')
            lEntity.Character.Head.Neck.C0 = oldC0
        end
    end
})
AuraRange = KillAura:registerSlider({
    ['Name'] = 'Range',
    ['Step'] = 1,
    ['Minimum'] = 10,
    ['Maximum'] = 22,
    ['Default'] = 20,
})
AuraDelay = KillAura:registerSlider({
    ['Name'] = 'Delay',
    ['Step'] = 0.005,
    ['Minimum'] = 0,
    ['Maximum'] = 0.5,
    ['Default'] = 0.285,
})
AutoSwitch = KillAura:registerToggle({
    ['Name'] = 'Switch To Weapon'
})
PlaySwingAnim = KillAura:registerToggle({
    ['Name'] = 'Play Animation'
})
PlaySwingSound = KillAura:registerToggle({
    ['Name'] = 'Play Sound'
})
DoRotations = KillAura:registerToggle({
    ['Name'] = 'Rotations'
})
HoldItemCheck = KillAura:registerToggle({
    ['Name'] = 'Hand Check'
})

Scaffold = GuiLibrary:registerModule({
    ['Name'] = 'Scaffold',
    ['Window'] = 'Player',
    ['Callback'] = function(callback)
        if callback then
            RunService:BindToRenderStep('Scaffold', 999, function()
                if not entityLib.isAlive then
                    return
                end

                placeBlock(entityLib.root.CFrame.Position - Vector3.new(0, 3, 0))
            end)
        else
            RunService:UnbindFromRenderStep('Scaffold')
        end
    end
})

local aided2;
local aided3;
Disabler = GuiLibrary:registerModule({
    ['Name'] = 'Disabler',
    ['Window'] = 'Misc',
    ['ArrayText'] = function()
        return 'Knockback'
    end,
    ['Callback'] = function(callback)
        if callback then
            lEntity:WaitForChild('Kit').Value = 'Hacker'

            aided2 = lEntity:WaitForChild('Kit'):GetPropertyChangedSignal('Value'):Connect(function()
                lEntity:WaitForChild('Kit').Value = 'Hacker'
            end)

            lEntity:WaitForChild('PlayerGui'):WaitForChild('AbilitiesGui').Enabled = false
            lEntity.PlayerGui:WaitForChild('HackGui').Enabled = false

            aided3 = lEntity.PlayerGui:WaitForChild('HackGui'):GetPropertyChangedSignal('Enabled'):Connect(function()
                lEntity.PlayerGui:WaitForChild('HackGui').Enabled = false
            end)
        else
            aided3:Disconnect()
            aided2:Disconnect()

            lEntity:WaitForChild('Kit').Value = 'None'
        end
    end
})

local aided = nil
NoKnockback = GuiLibrary:registerModule({
    ['Name'] = 'NoKnockback',
    ['Window'] = 'Combat',
    ['Callback'] = function(callback)
        if callback then
            if not Disabler.Enabled then
                repeat task.wait() until Disabler.Enabled
            end

            if not NoKnockback.Enabled then
                return
            end

            if lEntity.Character then
                lEntity.Character:WaitForChild('Humanoid', 99)

                if lEntity.Kit.Value ~= 'Hacker' then
                    repeat task.wait() until lEntity.Kit.Value == 'Hacker'
                end

                lEntity.Character.Humanoid:SetAttribute('KnockbackDisabled', true)
            end

            aided = lEntity.CharacterAdded:Connect(function(char)
                char:WaitForChild('Humanoid', 999)

                if lEntity.Kit.Value ~= 'Hacker' then
                    repeat task.wait() until lEntity.Kit.Value == 'Hacker'
                end

                lEntity.Character.Humanoid:SetAttribute('KnockbackDisabled', true)
            end)
        else
            if lEntity.Character then
                lEntity.Character:WaitForChild('Humanoid', 99)

                lEntity.Character.Humanoid:SetAttribute('KnockbackDisabled', false)
            end

            if aided then
                aided:Disconnect()
                aided = nil
            end
        end
    end
})

Breaker = GuiLibrary:registerModule({
    ['Name'] = 'Breaker',
    ['Window'] = 'Player',
    ['Callback'] = function(callback)
        if callback then
            local lastSwitched = tick()
            repeat
                task.wait()
                if not entityLib.isAlive then
                    continue
                end

                local Bed = getNearestBed(BreakerRange and BreakerRange.Value or 18)
                local Pickaxe = getItem('pickaxe')

                if Bed and Pickaxe then
                    if (tick() - lastSwitched) < (BreakerDelay and BreakerDelay.Value or 0.5) then
                        continue
                    end

                    lastSwitched = tick()
                    switchHand(Pickaxe.itemType)
                    task.wait(0.05)

                    Remotes:Get('MineBlock'):SendToServer(
                        Pickaxe.itemType,
                        Bed.Parent,
                        Bed.Position,
                        Bed.Position + Vector3.new(0, 2, 0),
                        Vector3.new(0, -1, 0)
                    )
                end
            until not Breaker.Enabled
        end
    end
})
BreakerRange = Breaker:registerSlider({
    ['Name'] = 'Range',
    ['Step'] = 1,
    ['Minimum'] = 10,
    ['Maximum'] = 22,
    ['Default'] = 20,
})
BreakerDelay = Breaker:registerSlider({
    ['Name'] = 'Delay',
    ['Step'] = 0.025,
    ['Minimum'] = 0,
    ['Maximum'] = 0.5,
    ['Default'] = 0.5,
})

local oldFOV = lEntity:FindFirstChild('Settings').FOV.Value
local aidscon
AutoSprint = GuiLibrary:registerModule({
    ['Name'] = 'AutoSprint',
    ['Window'] = 'Movement',
    ['Callback'] = function(callback)
        if callback then
            TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.1), {FieldOfView = oldFOV + 15}):Play()
            task.wait(0.1)

            if not AutoSprint.Enabled then
                return
            end

            aidscon = workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(function()
                if shared.Aiding then
                    return
                end
                
                workspace.CurrentCamera.FieldOfView = oldFOV + 15
            end)

            RunService:BindToRenderStep('Sprinting', 99999, function()
                if not entityLib.isAlive then
                    return
                end

                entityLib.hum.WalkSpeed = 20
            end)
        else
            RunService:UnbindFromRenderStep('Sprinting')

            TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.1), {FieldOfView = oldFOV}):Play()
            entityLib.hum.WalkSpeed = 16
            aidscon:Disconnect()
        end
    end
})

AntiVoid = GuiLibrary:registerModule({
    ['Name'] = 'AntiVoid',
    ['Window'] = 'Movement',
    ['Callback'] = function(callback)
        if callback then
            repeat
                task.wait()
                if not entityLib.isAlive then
                    continue
                end

                if entityLib.root.CFrame.Y < 0 then
                    entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, 100, entityLib.root.AssemblyLinearVelocity.Z)
                end
            until not AntiVoid.Enabled
        end
    end
})

NoFall = GuiLibrary:registerModule({
    ['Name'] = 'NoFall',
    ['Window'] = 'Player',
    ['Callback'] = function(callback)
        if callback then
            repeat
                task.wait()
                if not entityLib.isAlive then
                    continue
                end

                if entityLib.root.AssemblyLinearVelocity.Y < -90 then
                    entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, -30, entityLib.root.AssemblyLinearVelocity.Z)
                    placeBlock(entityLib.root.CFrame.Position - Vector3.new(0, 3, 0), false)
                    entityLib.root.CFrame -= Vector3.new(0, 4, 0)
                end
            until not NoFall.Enabled
        end
    end
})
