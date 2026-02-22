local base = 'https://raw.githubusercontent.com/Springs67/Strafe/refs/heads/Main/'
local function getContents(link: string)
    local suc, ret = pcall(function()
        return game:HttpGet(base .. link .. "?t=" .. tick())
    end)
    return suc and ret or nil
end

local function ensureFolder(path)
    local parts = path:split("/")
    local current = ""
    for i = 1, #parts do
        current = current .. parts[i] .. "/"
        if not isfolder(current) then
            makefolder(current)
    end
end

local function syncFile(fileName: string)
    local localPath = "Strafe/" .. fileName .. ".lua"
    local webPath = fileName .. ".lua"
    
    local remoteContent = getContents(webPath)
    if not remoteContent then 
        warn("Strafe Failed to fetch " .. fileName)
        return 
    end

    local folder = localPath:match("(.+)/[^/]+$")
    if folder then ensureFolder(folder) end

    if not isfile(localPath) or readfile(localPath) ~= remoteContent then
        writefile(localPath, remoteContent)
        print("Strafe Updated " .. localPath)
    end
end

ensureFolder("Strafe/Configs")

local Contents = {
    'Main',
    'Games',
    'Universal',
    'GuiLibrary',
    'Libraries/Entity',
    'Libraries/Network',
    'Libraries/FakeDamage',
    'Libraries/ProgressBar',
    'Libraries/BridgeDuels/Meta',
    'Games/BedwarZ',
    'Games/BridgeDuels',
}

for _, v in ipairs(Contents) do
    syncFile(v)
end

local GuiLibrary = loadfile('Strafe/GuiLibrary.lua')()
local Games = loadfile('Strafe/Games.lua')()
loadfile('Strafe/Universal.lua')()

shared.didQueue = false
game:GetService('Players').LocalPlayer.OnTeleport:Connect(function()
    if not shared.didQueue then
        shared.didQueue = true
        if queue_on_teleport then
            queue_on_teleport([[loadfile('Strafe/Main.lua')()]])
        end
    end
end)

for i, v in pairs(Games) do
    for _, id in ipairs(v) do
        if game.PlaceId == id then
            loadfile('Strafe/Games/'..i..'.lua')()
        end
    end
end