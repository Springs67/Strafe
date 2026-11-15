local Client = loadstring(readfile('Strafe/Libraries/Bedwars/Client.lua'))()

local queueController = {
    Name = 'QueueController'
}

function queueController:joinQueue(queue: string)
    Client:Get('joinQueue'):SendToServer({
		['queueType'] = queue
	})
end

return queueController