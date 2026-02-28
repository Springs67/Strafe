local InventoryUtil = {}
InventoryUtil.Name = 'InventoryUtil'

local function getIndex(obj)
    for ind, value in obj.Parent:GetChildren() do
        if value == obj then
            return ind
        end
    end

    return 1
end

local Cache = {}
function InventoryUtil.getInventory(plr: Player)
    plr = plr or game:GetService('Players').LocalPlayer

    local Inventory = game:GetService('ReplicatedStorage'):FindFirstChild('Inventories'):FindFirstChild(plr.Name)

    if Inventory then
        table.clear(Cache)

        return {
            items = (function()
                for ind, value in Inventory:GetChildren() do
                    table.insert(Cache, {
                        itemType = value.Name,
                        index = ind,
                        tool = value,
                    })
                end

                return Cache
            end)(),
            hand = (function()
                if not plr.Character then
                    return nil
                end

                local Hand = plr.Character:FindFirstChild('HandInvItem')
                if Hand and Hand.Value ~= nil then
                    return {
                        itemType = Hand.Value.Name,
                        index = getIndex(Hand.Value),
                        tool = Hand.Value,
                    }
                end

                return nil
            end)()
        }
    end
end

function InventoryUtil:findItem(item: string, plr: Player)
    plr = plr or game:GetService('Players').LocalPlayer

    local Inventory = self.getInventory(plr)

    for ind, value in Inventory.tools do
        if value.itemType == item then
            return value
        end
    end

    return nil
end

function InventoryUtil:hasItem(item: string, plr: Player)
    plr = plr or game:GetService('Players').LocalPlayer

    local Inventory = self.getInventory(plr)

    for ind, value in Inventory.tools do
        if value.itemType == item then
            return true
        end
    end

    return false
end

function InventoryUtil:getRelativeItem(relString: string, plr: Player)
    plr = plr or game:GetService('Players').LocalPlayer

    local Inventory = self.getInventory(plr)

    for ind, value in Inventory.tools do
        if value.itemType:lower():find(relString:lower()) then
            return value
        end
    end

    return nil
end

function InventoryUtil:hasRelativeItem(relString: string, plr: Player)
    plr = plr or game:GetService('Players').LocalPlayer

    local Inventory = self.getInventory(plr)

    for ind, value in Inventory.tools do
        if value.itemType:lower():find(relString:lower()) then
            return true
        end
    end

    return false
end

return InventoryUtil