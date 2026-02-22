local replicatedStorage = game:GetService('ReplicatedStorage')

local Client = {}
Client.Cache = {}

for _, v in replicatedStorage:GetDescendants() do
    if v:IsA('RemoteEvent') or v:IsA('RemoteFunction') or v:IsA('UnreliableRemoteEvent') then
        Client.Cache[v.Name] = v
    end
end

function Client:Get(Name: string)
    for i,v in Client.Cache do
        if i == Name then
            if v.ClassName == 'RemoteEvent' or v.ClassName == 'UnreliableRemoteEvent' then
                return {
                    SendToServer = function(self, ...)
                        v:FireServer(...)
                    end,
                    instance = v,
                }
            elseif v.ClassName == 'RemoteFunction' then
                return {
                    CallToServer = function(self, ...)
                        v:InvokeServer(...)
                    end,
                    instance = v,
                }
            end
        end
    end
end

function Client:GetNamespace(NSpace: string)
    return {
        Get = function(self, Name: string)
            for i,v in Client.Cache do
                if i == NSpace..'/'..Name then
                    if v.ClassName == 'RemoteEvent' then
                        return {
                            SendToServer = function(self, ...)
                                v:FireServer(...)
                            end,
                            instance = v,
                        }
                    elseif v.ClassName == 'RemoteFunction' then
                        return {
                            CallToServer = function(self, ...)
                                v:InvokeServer(...)
                            end,
                            instance = v,
                        }
                    end
                end
            end
        end
    }
end

return Client