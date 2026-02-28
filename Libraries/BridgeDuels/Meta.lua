local Constants = game:GetService("ReplicatedStorage"):WaitForChild('Constants')

DamageMeta = {
    ["REACH_IN_STUDS"] = 9,
    ["COOLDOWN"] = 0.4,
    ["OFFSET"] = Vector3.new(0, 1.5, 0),
    ["DAMAGE"] = {
        ["WoodenSword"] = 15,
        ["Sword"] = 25,
        ["GoldSword"] = 35,
        ["DiamondSword"] = 45,
        ["Hammer"] = 25
    },
    ["isInRange"] = function(p1, p2, p3)
        return (p3 or DamageMeta.REACH_IN_STUDS) + 2.4 >= (p1 + DamageMeta.OFFSET - p2).Magnitude
    end
}
Constants.Melee.Reach:GetPropertyChangedSignal("Value"):Connect(function()
    DamageMeta.REACH_IN_STUDS = Constants.Melee.Reach.Value
end)

DamageMeta.REACH_IN_STUDS = Constants.Melee.Reach.Value

return DamageMeta