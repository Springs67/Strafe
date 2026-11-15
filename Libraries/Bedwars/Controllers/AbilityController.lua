local replicatedStorage = game:GetService('ReplicatedStorage')

local abilityController = {
    Name = 'AbilityController',
}

function abilityController:canUseAbility(Name: string)
    return true
end

function abilityController:useAbility(Name: string, ...)
    replicatedStorage["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer(name, ...)
end

return abilityController