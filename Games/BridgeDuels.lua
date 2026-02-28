local GuiLibrary = shared.GuiLibrary

local ContextActionService = game:GetService("ContextActionService")
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
    task.wait(0.2)
end

local fakeDamage = loadfile('Strafe/Libraries/FakeDamage.lua')()
local progressBar = loadfile('Strafe/Libraries/ProgressBar.lua')()
local entityLib = loadfile('Strafe/Libraries/Entity.lua')()
--local Client = loadfile('Strafe/Libraries/BridgeDuels/Client.lua')()
local Meta = loadfile('Strafe/Libraries/BridgeDuels/Meta.lua')()

local getEntities = ReplicatedStorage.Modules.Knit.Services.EntityService.RF.GetEntities

local f = {}
local InventoryUtil = {
    getInventory = function(plr: Player)
        plr = plr or lEntity

        table.clear(f)
        for _, v in plr.Backpack:GetChildren() do
            table.insert(f, v)
        end

        for _, v in plr.Character:GetChildren() do
            if v:IsA('Tool') then
                table.insert(f, v)
            end
        end

        return f
    end
}

local function getItem(item: string, plr: Player)
    plr = plr or lEntity

    for i,v in InventoryUtil.getInventory(plr) do
        if v.Name == item then
            return v
        end
    end
end

local function hasItem(item: string, plr: Player)
    plr = plr or lEntity

    for i,v in InventoryUtil.getInventory(plr) do
        if v.Name == item then
            return true
        end
    end

    return false
end

local function getBestWeapon()
    local bestWeapon, bestDamage = 'WoodenSword', 15

    for i, v in Meta.DAMAGE do
        if hasItem(i) and v > bestDamage then
            bestWeapon = i
            bestDamage = v
        end
    end

    return getItem(bestWeapon)
end

local lastTarget = nil
local targets = {}
local function getEntitiesInRange(Range: number)
    table.clear(targets)

    for i, v in Players:GetPlayers() do
        if v == lEntity then
            continue
        end

        if not entityLib.getAlive(v) or not entityLib.getAlive(lEntity) then
            continue
        end

        local dist = lEntity:DistanceFromCharacter(v.Character.PrimaryPart.Position)

        if dist <= Range then
            table.insert(targets, v.Character)
        end
    end

    return targets
end

local function getNearestEntity(Range: number)
    local Nearest, Distance = nil, math.huge
    local Ents = getEntitiesInRange(Range)

    for _, tab in getEntities:InvokeServer() do
        for ind, value in tab do
            if ind == 'Character' and value ~= nil and entityLib.getAlive(lEntity) and value ~= entityLib.char then
                if (AuraMode.Value == 'Switch' and value == lastTarget and #Ents > 1) then
                    continue
                end

                lastTarget = value
                local Dist = lEntity:DistanceFromCharacter(value.PrimaryPart.Position)

                if Dist <= Range and Dist < Distance then
                    Distance = Dist
                    Nearest = tab
                end
            end
        end
    end

    return Nearest
end

local function getCurrentViewmodelItem()
    if workspace.CurrentCamera:FindFirstChild('Viewmodel') then
        local Obj = workspace.CurrentCamera.Viewmodel:FindFirstChildWhichIsA('Model')

        if Obj and Obj:FindFirstChild('Handle') then
            return Obj
        end
    end
end

if not getCurrentViewmodelItem() then
    repeat task.wait() until getCurrentViewmodelItem()
end

local Anims =  {
    ["SWORD"] = "rbxassetid://118350296235148",
    ["BOW"] = "rbxassetid://105929279132479"
}

local isBlocking = false
local oldGrip = getCurrentViewmodelItem().Handle.MainPart.C1
local function setBlocking(Weapon, Bool: boolean)
    local viewModel = getCurrentViewmodelItem()

    if viewModel and viewModel:FindFirstChild('Handle') then
       isBlocking = Bool
        ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(true, Weapon.Name)

        if Bool then
            viewModel.Handle.MainPart.C1 = oldGrip * CFrame.Angles(-180.01, 4, -42) + Vector3.new(-1, -0.5, -0.5)
        else
            viewModel.Handle.MainPart.C1 = oldGrip
        end
    end
end

local function sendAttackPacket(Nearest, Weapon)
    if not Nearest or not Nearest.Id then
        return
    end

    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(
        Nearest.Character,
        (Criticals.Enabled and true or entityLib.root.AssemblyLinearVelocity.Y < 0),
        Weapon.Name
    )
end

local function hasAnimationLoaded(Viewmodel)
    for i, v in Viewmodel.AnimationController.Animator:GetPlayingAnimationTracks() do
        if v.Animation.AnimationId == 'rbxassetid://81023102192808' then
            return true
        end
    end

    return false
end

local anim = Instance.new('Animation')
anim.AnimationId = 'rbxassetid://81023102192808'
KillAura = GuiLibrary:registerModule({
    ['Name'] = 'KillAura',
    ['Window'] = 'Combat',
    ['ArrayText'] = function()
        return AuraMode.Value
    end,
    ['Callback'] = function(callback)
        if callback then
            local lastAttacked = tick()
            local lastBlocked = tick()
            local funny2 = nil
            RunService:BindToRenderStep('KillAura', 9999, function(dt)
                if not entityLib.isAlive then
                    return
                end

                local Weapon = getBestWeapon()
                local Nearest = getNearestEntity(18)
                local Viewmodel = getCurrentViewmodelItem()

                if Weapon and getNearestEntity(18) and Viewmodel then
                    if (tick() - lastBlocked) > 0.3 then
                        lastBlocked = tick()
                        setBlocking(Weapon, AutoBlock.Enabled)
                    end

                    if (tick() - lastAttacked) < Meta.COOLDOWN then
                        return
                    end

                    if Animations.Enabled then
                        if not hasAnimationLoaded(Viewmodel) then
                            funny2 = Viewmodel.AnimationController.Animator:LoadAnimation(anim)
                        end

                        funny2:Play()
                    end

                    lastAttacked = tick()
                    sendAttackPacket(Nearest, Weapon)
                else
                    if isBlocking then
                        setBlocking(Weapon, false)
                    end
                end
            end)
        else
            RunService:UnbindFromRenderStep('KillAura')
            task.wait(0.1)
            setBlocking(getBestWeapon(), false)
        end
    end
})
AuraMode = KillAura:registerSelector({
    ['Name'] = 'Mode',
    ['Values'] = {'Single', 'Switch'}
})
AutoBlock = KillAura:registerToggle({
    ['Name'] = 'Auto Block'
})

Criticals = GuiLibrary:registerModule({
    ['Name'] = 'Criticals',
    ['Window'] = 'Combat',
})

local blackList = RaycastParams.new()
blackList.FilterType = Enum.RaycastFilterType.Exclude
blackList.FilterDescendantsInstances = {entityLib.char}
Speed = GuiLibrary:registerModule({
    ['Name'] = 'Speed',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return SpeedMode.Value
    end,
    ['Callback'] = function(callback)
        if callback then
            local currentSpeed = 20;
            local airTime = tick()
            RunService:BindToRenderStep('Speed', 9999, function(dt)
                if not entityLib.isAlive then
                    return
                end
                blackList.FilterDescendantsInstances = {entityLib.char}

                local onGround = workspace:Raycast(entityLib.root.CFrame.Position, Vector3.new(0, -3.65, 0), blackList)

                if onGround then
                    if SpeedMode.Value == 'Bolar' then
                        currentSpeed = 33
                    else
                        currentSpeed = GroundSpeed.Value
                    end

                    airTime = tick()
                else
                    currentSpeed -= ((SpeedMode.Value == 'Bolar' and 40 or (AirFriction.Value)) * dt)

                    if currentSpeed < 23 then
                        currentSpeed = 23
                    end

                    if (tick() - airTime) > (FastFallTime.Value - 0.05) and (tick() - airTime) < (FastFallTime.Value + 0.05) and FastFall.Enabled then
                        entityLib.root.AssemblyLinearVelocity = Vector3.new(0, -(SpeedMode.Value == 'Bolar' and FastFallVelocity.Value or 20), 0)
                    end
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.hum.MoveDirection.X * currentSpeed, (onGround and 27 or entityLib.root.AssemblyLinearVelocity.Y), entityLib.hum.MoveDirection.Z * currentSpeed)
            end)
        else
            RunService:UnbindFromRenderStep('Speed')
        end
    end
})
SpeedMode = Speed:registerSelector({
    ['Name'] = 'Mode',
    ['Values'] = {'Bolar', 'Bolar Custom'}
})
GroundSpeed = Speed:registerSlider({
    ['Name'] = 'Ground Speed',
    ['Step'] = 1,
    ['Minimum'] = 16,
    ['Maximum'] = 40,
    ['Default'] = 34,
})
AirFriction = Speed:registerSlider({
    ['Name'] = 'Air Friction',
    ['Step'] = 1,
    ['Minimum'] = 0,
    ['Maximum'] = 40,
    ['Default'] = 25,
})
FastFall = Speed:registerToggle({
    ['Name'] = 'Fast Fall'
})
FastFallTime = Speed:registerSlider({
    ['Name'] = 'Fall Time',
    ['Step'] = 0.05,
    ['Minimum'] = 0,
    ['Maximum'] = 1,
    ['Default'] = 0.2,
})
FastFallVelocity = Speed:registerSlider({
    ['Name'] = 'Fall Velocity',
    ['Step'] = 1,
    ['Minimum'] = 0,
    ['Maximum'] = 40,
    ['Default'] = 20,
})

Animations = GuiLibrary:registerModule({
    ['Name'] = 'Animations',
    ['Window'] = 'Visual',
})

ContextActionService:BindActionAtPriority('Flight', function(_, state)
    return Enum.ContextActionResult.Sink
end, false, 99999, Enum.KeyCode.R)

Flight = GuiLibrary:registerModule({
    ['Name'] = 'Flight',
    ['Window'] = 'Movement',
    ['Callback'] = function(callback)
        if callback then
            RunService:BindToRenderStep('Flight', 99999, function(dt)
                if not entityLib.isAlive then
                    return
                end

                local flyVal = 0

                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyVal = 50
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyVal = -50
                end

                entityLib.root.AssemblyLinearVelocity = Vector3.new(entityLib.hum.MoveDirection.X * 28, flyVal, entityLib.hum.MoveDirection.Z * 28)
            end)
        else
            RunService:UnbindFromRenderStep('Flight')
        end
    end
})