local Images = loadstring(readfile('Strafe/Libraries/Bedwars/Images.lua'))()
local Client = loadstring(readfile('Strafe/Libraries/Bedwars/Client.lua'))()

local blockController = {
    Name = 'BlockController'
}

local function clientBlockPlace(itemType: string, position: Vector3)
    local Part = Instance.new('Part')
    Part.Parent = workspace
    Part.Size = Vector3.new(2.99, 2.99, 2.99)
    Part.Transparency = 0
    Part.CanCollide = true
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Anchored = true
    Part.CFrame = CFrame.new(position)

    for _, value in Enum.NormalId:GetEnumItems() do
        local Texture = Instance.new('Decal')
        Texture.Parent = Part
        Texture.ZIndex = 2
        Texture.Texture = Images[itemType] or ''
        Texture.Face = value
    end

    task.delay(0.5, function()
        Part:Destroy()
    end)
end

local function correctClientPosition(Pos: Vector3)
    local X = math.floor(Pos.X / 3 + 0.5) * 3
    local Y = math.floor(Pos.Y / 3) * 3
    local Z = math.floor(Pos.Z / 3 + 0.5) * 3

    return Vector3.new(X, Y, Z)
end

function blockController.correctBlockPosition(Pos: Vector3)
    local X = math.round(Pos.X) / 3
    local Y = math.round(Pos.Y) / 3
    local Z = math.round(Pos.Z) / 3

    return Vector3.new(X, Y, Z)
end

function blockController:placeBlock(data: {
        itemType: string,
        position: Vector3,
    })

    clientBlockPlace(data.itemType, correctClientPosition(data.position))

    data.position = self.correctBlockPosition(data.position);

    return Client:Get('PlaceBlock'):CallServerAsync({
        position = data.position,
        blockType = data.itemType,
        blockData = 0,
        mouseBlockInfo = {
            placementPosition = data.position,
        }
    }).returned;
end

return blockController