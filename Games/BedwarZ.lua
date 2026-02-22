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

local getNearestBed = function(Range: number)
    local nearest, nearestDist

    if workspace:FindFirstChild("BedsContainer") then
        for i, v in ipairs(workspace.BedsContainer:GetChildren()) do
            local hitbox = v:FindFirstChild("BedHitbox")
            if hitbox then
                local dist = lEntity:DistanceFromCharacter(hitbox.Position)
                if dist <= Range and (not nearestDist or dist < nearestDist) then
                    nearest, nearestDist = hitbox, dist
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

local function getHoldingHand()
    local Inventory = InventoryUtil.getInventory(lEntity)

    if Inventory.hand then
        return Inventory.hand
    end
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

local function placeBlock(pos: Vector3)
    local Wool = getItem('wool') or getItem('fake block')

    if Wool then
        pos = getRoundedPos(pos)

        Remotes:Get('PlaceBlock'):SendToServer(Wool.itemType, 1, pos)

        local Clone = ReplicatedStorage.Blocks[Wool.itemType]:Clone()
        Clone.Parent = workspace:FindFirstChildWhichIsA('Folder')
        Clone.Position = pos

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
        lEntity.PlayerGui:WaitForChild('TopbarButtonsGui').Enabled = not callback
        lEntity.PlayerGui:WaitForChild('KillLogGui').Enabled = not callback
    end
})

local startY = 0
Longjump = GuiLibrary:registerModule({
    ['Name'] = 'Longjump',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return 'BedFight'
    end,
    ['Callback'] = function(callback)
        if callback then
            progressBar.new(0.75)
            entityLib.root.Anchored = true
            task.wait(0.75)
            entityLib.root.CFrame += Vector3.new(0, 3, 0)
            entityLib.root.Anchored = false
            fakeDamage.new()

            if not Longjump.Enabled then
                return
            end

            local startDir = entityLib.root.CFrame.LookVector
            local startSpeed = 28
            local startTick = tick()
            startY = 50
            RunService:BindToRenderStep('Longjump', 9999, function(dt)
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                startSpeed = 28

                if (tick() - startTick) < (LongjumpBoostTime and LongjumpBoostTime.Value or 0.2) then
                    startSpeed = (LongjumpSpeed and LongjumpSpeed.Value or 300)
                end
                startY -= (workspace.Gravity * dt) / 2

                entityLib.root.AssemblyLinearVelocity = Vector3.new(startDir.X * startSpeed, 1, startDir.Z * startSpeed)

                if (tick() - startTick) > (LongjumpDisableTime and LongjumpDisableTime.Value or 0.85) and Longjump.Enabled then
                    RunService:UnbindFromRenderStep('Longjump')
                    Longjump:Toggle()
                end
            end)
        else
            RunService:UnbindFromRenderStep('Longjump')
            entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, startY, entityLib.root.AssemblyLinearVelocity.Z)
        end
    end
})
LongjumpSpeed = Longjump:registerSlider({
    ['Name'] = 'Boost Speed',
    ['Step'] = 1,
    ['Minimum'] = 28,
    ['Maximum'] = 1000,
    ['Default'] = 300,
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

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.root.AssemblyLinearVelocity.X, flyVal, entityLib.root.AssemblyLinearVelocity.Z)
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

KillAura = GuiLibrary:registerModule({
    ['Name'] = 'KillAura',
    ['Window'] = 'Combat',
    ['ArrayText'] = function()
        return '22'
    end,
    ['Callback'] = function(callback)
        if callback then
            local lastSwitch = tick()
            local lastAttacked = tick()
            RunService:BindToRenderStep('KillAura', 9999, function()
                if not entityLib.isAlive then
                    return
                end

                local Entity = getNearestAttackable(22)
                local Sword = getItem('sword')

                if Entity and Sword then
                    if (tick() - lastSwitch) > 0.4 and (AutoSwitch and AutoSwitch.Enabled or false) then
                        lastSwitch = tick()
                        switchHand(Sword.itemType)
                    end

                    if (tick() - lastAttacked) < 0.275 then
                        return
                    end
                    
                    lastAttacked = tick()
                    Remotes:Get('SwordHit'):SendToServer(Sword.itemType, Entity.Character)
                end
            end)
        else
            RunService:UnbindFromRenderStep('KillAura')
        end
    end
})
AutoSwitch = KillAura:registerToggle({
    ['Name'] = 'Switch To Weapon'
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

Disabler = GuiLibrary:registerModule({
    ['Name'] = 'Disabler',
    ['Window'] = 'Misc',
    ['ArrayText'] = function()
        return 'BedFight'
    end,
    ['Callback'] = function(callback)
        if callback then
            ReplicatedStorage.Remotes.AdminRemotes.RemoteEvent:Destroy()
        end
    end
})

NoKnockback = GuiLibrary:registerModule({
    ['Name'] = 'NoKnockback',
    ['Window'] = 'Combat',
    ['Callback'] = function(callback)
        if callback then
            if not Disabler.Enabled then
                repeat task.wait() until Disabler.Enabled
            end
            lEntity:WaitForChild('PlayerScripts'):WaitForChild('KnockbackScript').Enabled = false
        else
            lEntity:WaitForChild('PlayerScripts'):WaitForChild('KnockbackScript').Enabled = true
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

                local Bed = getNearestBed(30)
                local Pickaxe = getItem('pickaxe')

                if Bed and Pickaxe then
                    if (tick() - lastSwitched) > 0.2 then
                        lastSwitched = tick()
                        switchHand(Pickaxe.itemType)
                    end

                    Remotes:Get('MineBlock'):SendToServer(
                        Pickaxe.itemType,
                        Bed.Parent,
                        Bed.Position,
                        Bed.Position + Vector3.new(0, 3, 0),
                        Vector3.new(0, -3, 0)
                    )
                end
            until not Breaker.Enabled
        end
    end
})

local oldFOV = lEntity:FindFirstChild('Settings').FOV.Value
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

            RunService:BindToRenderStep('Sprinting', 99999, function()
                if not entityLib.isAlive then
                    return
                end

                workspace.CurrentCamera.FieldOfView = oldFOV + 15
                entityLib.hum.WalkSpeed = 20
            end)

        else
            RunService:UnbindFromRenderStep('Sprinting')

            TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.1), {FieldOfView = oldFOV}):Play()
            entityLib.hum.WalkSpeed = 16
        end
    end
})

local teams = {"Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink", "Brown"}
Stealer = GuiLibrary:registerModule({
    ['Name'] = 'Stealer',
    ['Window'] = 'Player',
    ['Callback'] = function(callback)
        if callback then
            repeat
                task.wait()
                for _, clr in teams do
                    for i = 1, 20 do
                        Remotes:Get('TakeItemFromChest'):SendToServer(clr, i, '1')
                        task.wait(0.02)
                    end
                end
            until not Stealer.Enabled
        end
    end
})


game:GetService('LogService'):ClearOutput()
