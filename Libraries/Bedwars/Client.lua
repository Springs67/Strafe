--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
local Client, Remotes = {}, {};

local cloneref = cloneref or function(obj) return obj end;
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local playersService = game:GetService('Players')

repeat task.wait() until playersService.LocalPlayer and playersService.LocalPlayer.Character and playersService.LocalPlayer.Character:FindFirstChild('Humanoid') and ReplicatedStorage:FindFirstChild('Inventories') and ReplicatedStorage:FindFirstChild('Inventories'):FindFirstChild(playersService.LocalPlayer.Name)

for _, value: RemoteEvent | RemoteFunction in ReplicatedStorage:GetDescendants() do
    if value:IsA('RemoteEvent') then
        table.insert(Remotes, {
            inst = value,
            SendToServer = function(self, ...)
                value:FireServer(...);
            end,
            Connect = function(self, func: () -> nil)
                return value.OnClientEvent:Connect(func);
            end,
        })
    elseif value:IsA('RemoteFunction') then
        table.insert(Remotes, {
            inst = value,
            CallServerAsync = function(self, ...)
                local val = value:InvokeServer(...);

                return {
                    andThen = function(self, func)
                        func(val)
                    end,
                    returned = val,
                }
            end,
            Connect = function(self, func: () -> nil)
                value.OnClientInvoke = func;
            end,
        })
    end
end

function Client:Get(Name: string)
    for _, value in Remotes do
        if value.inst.Name == Name then
            return value;
        end
    end

    return nil;
end

function Client:WaitFor(Name: string)
    for _, value in Remotes do
        if value.inst.Name == Name then
            return value;
        end
    end

    return nil;
end

function Client:GetNamespace(name: string)
    return {
        Get = function(self, Name: string)
            for _, value in Remotes do
                if value.inst.Name == name..'/'..Name then
                    return value;
                end
            end

            return nil;
        end,
    }
end

return Client