local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
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

local GuiLibrary = shared.GuiLibrary
local fakeDamage = loadfile('Strafe/Libraries/FakeDamage.lua')()
local progressBar = loadfile('Strafe/Libraries/ProgressBar.lua')()
local entityLib = loadfile('Strafe/Libraries/Entity.lua')()

local Knit = {Controllers = {}}
local Client = loadfile('Strafe/Libraries/Bedwars/Client.lua')()
local InventoryUtil = loadfile('Strafe/Libraries/Bedwars/InventoryUtil.lua')()

local Bedwars = {
    ItemMeta = HttpService:JSONDecode(readfile('Strafe/Libraries/Bedwars/ItemMeta.json')).items,
    ProjectileMeta = loadfile('Strafe/Libraries/Bedwars/ProjectileMeta.lua')(),
    DamageType = loadfile('Strafe/Libraries/Bedwars/DamageType.lua')(),
    Images = loadfile('Strafe/Libraries/Bedwars/Images.lua')(),
    Sounds = loadfile('Strafe/Libraries/Bedwars/Sounds.lua')(),
}

for _, value in listfiles('Strafe/Libraries/Bedwars/Controllers') do
    local f = loadfile(value)()

    Knit.Controllers[f.Name] = f;
end

local Beds, Chests = {}, {}

for _, child: Instance in workspace:GetChildren() do
    if child.Name == 'bed' then
        table.insert(Beds, child)
    elseif child.Name == 'chest' then
        table.insert(Chests, child)
    end
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == 'bed' then
        table.insert(Beds, child)
    elseif child.Name == 'chest' then
        table.insert(Chests, child)
    end
end)

local getRoundedPos = function(Position: Vector3)
    local X = math.floor(Position.X / 3 + 0.5) * 3
    local Y = math.floor(Position.Y / 3) * 3
    local Z = math.floor(Position.Z / 3 + 0.5) * 3

    return Vector3.new(X, Y, Z)
end

local getServerPos = function(Position: Vector3)
    local X = math.round(Position.X / 3)
    local Y = math.round(Position.Y / 3)
    local Z = math.round(Position.Z / 3)

    return Vector3.new(X, Y, Z)
end

local getItem = function(item: string)
    for _, value in InventoryUtil.getInventory(lEntity) do
        if value.itemType == item then
            return value;
        end
    end
end

local getBestSword = function()
    local bestSword, bestDamage = nil, 0
    for index, value in Bedwars.ItemMeta do
        if value.sword and value.sword.damage > bestDamage and getItem(index) then
            bestDamage = value.sword.damage
            bestSword = getItem(index)
        end
    end
    return bestSword, bestDamage
end

local getNearestEntity = function(Range: number)
    local nearest, distance = nil, math.huge
    for index, value in CollectionService:GetTagged('entity') do
        if not entityLib.getModelAlive(value) then
            continue;
        end

        if value:GetAttribute('Team') == entityLib.char:GetAttribute('Team') then
            continue
        end

        local dist = lEntity:DistanceFromCharacter(value.PrimaryPart.Position)

        if dist < distance and dist <= Range then
            distance = dist
            nearest = value;
        end
    end

    return nearest, distance
end

local getcloserpos = function(Orig, NewPos, Amount)
	return (NewPos - Orig).Unit * math.min(Amount, (NewPos - Orig).Magnitude) + Orig
end

local getNearestBlock = function(Range: number, blocks: {string})
    local dist = math.huge
    for _, value in workspace:GetChildren() do
        if table.find(blocks, value.Name) and (value:IsA('Part') or value:IsA('BasePart') or value:IsA('MeshPart')) then
            local distance = lEntity:DistanceFromCharacter(value.Position)

            if distance < dist and distance <= Range then
                return value;
            end
        end
    end
end

local getBlockAtPos = function(pos: Vector3)
    local ray = workspace:Raycast(pos + Vector3.new(0, 2, 0), Vector3.new(0, -2, 0))

    if ray and ray.Instance then
        return ray.Instance;
    end

    return nil
end

local getPlaceable = function()
    for index, value in InventoryUtil.getInventory(lEntity).items do
        local itemMeta = Bedwars.ItemMeta[value.itemType]

        if itemMeta and itemMeta.block then
            return value;
        end
    end

    return nil
end

local healthThread = nil
local lastDamaged = {}
local createHealthbar = function(obj: Instance)
    if healthThread then
        task.cancel(healthThread)
    end

    if obj.Name == 'bed' then
        return
    end

    if obj:FindFirstChild('BlockHealthbar') then
        return
    end

    local Part = Instance.new('Part')
    Part.Parent = obj
    Part.Name = "BlockHealthbar"
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CanCollide = false
    Part.CFrame = obj.CFrame

    local BillboardGui = Instance.new('BillboardGui')
    BillboardGui.Parent = Part
    BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    BillboardGui.MaxDistance = 40
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = Part
    BillboardGui.Size = UDim2.fromScale(4, 0.2)

    local Frame1 = Instance.new('Frame')
    Frame1.Parent = BillboardGui
    Frame1.BackgroundTransparency = 0.3
    Frame1.BorderSizePixel = 0
    Frame1.Size = UDim2.fromScale(1, 1)
    Frame1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

    local Frame2 = Instance.new('Frame')
    Frame2.Parent = Frame1
    Frame2.BackgroundColor3 = Color3.fromRGB(39, 231, 68)
    Frame2.BorderSizePixel = 0

    healthThread = task.spawn(function()
        repeat
            task.wait()
            Frame2.Size = UDim2.fromScale((obj:GetAttribute('Health') or 50) / (obj:GetAttribute('MaxHealth') or 100), 1)
        until (tick() - lastDamaged[Part]) > 5 or not Part
    end)
end

local breakBlock = function(pos: Vector3)
    local block = getBlockAtPos(pos);

    local s, ret = pcall(function()
        return Client:Get('DamageBlock'):CallServerAsync({
            hitNormal = Vector3.zero,
            hitPosition = pos,
            blockRef = {
                blockPosition = getServerPos(pos),
            }
        }).returned
    end)

    if ret == 'damaged' and block then
        createHealthbar(block)
        lastDamaged[block] = tick()
    end
end

local Longjump; Longjump = GuiLibrary:registerModule({
    ['Name'] = 'Longjump',
    ['Window'] = 'Movement',
    ['ArrayText'] = function()
        return 'Heatseeker'
    end,
    ['Callback'] = function(callback)
        if callback then
            entityLib.root.Anchored = true;
            progressBar.new(LongjumpDelayTimer and LongjumpDelayTimer.Value or 1);
            task.wait(LongjumpDelayTimer and LongjumpDelayTimer.Value or 1);

            entityLib.root.Anchored = false;
            fakeDamage.new()
            if not Longjump.Enabled then
                return;
            end

            local startSpeed = (LongjumpBoostSpeed.Value);
            local startY = 27;
            local origDir = entityLib.root.CFrame.LookVector
            entityLib.root.CFrame += Vector3.new(0, 2.5, 0)
            RunService:BindToRenderStep('Longjump', 999, function(dt: number)
                if not entityLib.isAlive or not isnetworkowner(entityLib.root) then
                    return
                end

                startY -= (workspace.Gravity * dt)
                startSpeed -= (LongjumpFriction.Value * dt)

                if startSpeed < LongjumpDefaultSpeed.Value then
                    startSpeed = LongjumpDefaultSpeed.Value
                end

                entityLib.root.Velocity = Vector3.new(0, 1, 0)
                entityLib.root.CFrame += (origDir * startSpeed * dt)
            end)
        else
            RunService:UnbindFromRenderStep('Longjump')
        end
    end
})
LongjumpBoostSpeed = Longjump:registerSlider({
    ['Name'] = 'Boost Speed',
    ['Step'] = 1,
    ['Minimum'] = 23,
    ['Maximum'] = 100,
    ['Default'] = 42,
})
LongjumpDefaultSpeed = Longjump:registerSlider({
    ['Name'] = 'Default Speed',
    ['Step'] = 1,
    ['Minimum'] = 16,
    ['Maximum'] = 23,
    ['Default'] = 23,
})
LongjumpFriction = Longjump:registerSlider({
    ['Name'] = 'Friction SPS',
    ['Step'] = 1,
    ['Minimum'] = 1,
    ['Maximum'] = 100,
    ['Default'] = 20,
})
LongjumpDelayTimer = Longjump:registerSlider({
    ['Name'] = 'Boost Time',
    ['Step'] = 0.05,
    ['Minimum'] = 0,
    ['Maximum'] = 2,
    ['Default'] = 0,
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
        return 'Heatseeker'
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

UICleanup = GuiLibrary:registerModule({
    ['Name'] = 'UI Cleanup',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('TopBarAppGui').TopBarApp.Visible = not callback
        Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ActionBarScreenGui').Enabled = not callback
        Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ServerRegionDisplay').Enabled = not callback
    end
})

NoFall = GuiLibrary:registerModule({
    ['Name'] = 'NoFall',
    ['Window'] = 'Player',
    ['Callback'] = function(callback)
        if callback then
            NoFall:Clean(RunService.Heartbeat:Connect(function(dt: number)
                if entityLib.isAlive and isnetworkowner(entityLib.root) then
					local root = entityLib.root
					local v = root.Velocity

					if root.Velocity.Y < -15 and not Flight.Enabled then
						root.Velocity = Vector3.new(0,2.5,0)
						entityLib.hum:ChangeState(Enum.HumanoidStateType.Landed)
						RunService.PreRender:Wait()
						root.Velocity = v
					end
				end
            end))
        else
            RunService:UnbindFromRenderStep('NoFall')
        end
    end
})

SilentAura = GuiLibrary:registerModule({
    ['Name'] = 'SilentAura',
    ['Window'] = 'Combat',
    ['Callback'] = function(callback)
        if callback then
            repeat
                task.wait()
                if not entityLib.isAlive then
                    continue
                end

                local Nearest = getNearestEntity(SilentAuraRange.Value)

                if Nearest then
                    local Sword = getBestSword()

                    if (math.random(1, 100) > HitChance.Value) and HitChanceEnabled.Enabled then
                        continue
                    end

                    if not Sword then
                        continue
                    end

                    Client:Get('SwordHit'):SendToServer({
                        weapon = Sword.tool,
                        entityInstance = Nearest,
                        chargedAttack = {chargeRatio = 0},
                        validate = {
                            selfPosition = {value = getcloserpos(entityLib.root.CFrame.Position, Nearest.PrimaryPart.CFrame.Position, 5)},
                            targetPosition = {value = getcloserpos(Nearest.PrimaryPart.CFrame.Position, entityLib.root.CFrame.Position, 4)},
                        }
                    })

                    Knit.Controllers.SwordController:playSwordEffect()
                    task.wait(0.111)
                end
            until not SilentAura.Enabled
        end
    end
})
SilentAuraRange = SilentAura:registerSlider({
    ['Name'] = 'Range',
    ['Minimum'] = 1,
    ['Maximum'] = 20,
    ['Default'] = 18,
})
HitChanceEnabled = SilentAura:registerToggle({
    ['Name'] = 'Hit Chance Enabled'
})
HitChance = SilentAura:registerSlider({
    ['Name'] = 'Hit Chance',
    ['Minimum'] = 1,
    ['Maximum'] = 100,
    ['Default'] = 100,
})

Breaker = GuiLibrary:registerModule({
    ['Name'] = 'Breaker',
    ['Window'] = 'Player',
    ['Callback'] = function(callback)
        if callback then
            repeat
                task.wait(0.25)
                if not entityLib.isAlive then
                    continue
                end

                local Bed = getNearestBlock(22, {'bed'})
                local Ore = getNearestBlock(22, {'iron_ore_mesh_block'})

                if Bed and Bed:GetAttribute('TeamId') ~= lEntity:GetAttribute('Team') then
                    local Inst = workspace:Raycast(Bed.Position + Vector3.new(0, 30, 0), Vector3.new(0, -30, 0))

                    if Inst and Inst.Instance then
                        breakBlock(Inst.Position - Vector3.new(0, 1, 0))
                        continue
                    end
                end

                if Ore then
                    breakBlock(Ore.Position)
                end
            until not Breaker.Enabled
        end
    end
})

Scaffold = GuiLibrary:registerModule({
    ['Name'] = 'Scaffold',
    ['Window'] = 'Misc',
    ['Callback'] = function(callback)
        if callback then
            repeat
                task.wait(0.01)
                if not entityLib.isAlive then
                    continue
                end

                local blocks = getPlaceable()

                if blocks then
                    Knit.Controllers.BlockController:placeBlock({
                        itemType = blocks.itemType,
                        position = entityLib.root.CFrame.Position + (entityLib.hum.MoveDirection * 3) - Vector3.new(0, 4, 0)
                    })
                end
            until not Scaffold.Enabled
        end
    end
})