v_u_4 = {
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
        return (p3 or v_u_4.REACH_IN_STUDS) + 2.4 >= (p1 + v_u_4.OFFSET - p2).Magnitude
    end
}
game:GetService("ReplicatedStorage").Constants.Melee.Reach:GetPropertyChangedSignal("Value"):Connect(function()
    v_u_4.REACH_IN_STUDS = game:GetService("ReplicatedStorage").Constants.Melee.Reach.Value
end)
v_u_4.REACH_IN_STUDS = game:GetService("ReplicatedStorage").Constants.Melee.Reach.Value
return v_u_4
