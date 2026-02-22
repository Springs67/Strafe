local base = 'https://raw.githubusercontent.com/Springs67/Strafe/refs/heads/Main/'
local function getContents(link: string)
    print(link)
    local suc, ret = pcall(function()
        return game:HttpGet(base .. link)
    end)

    return suc and ret or 'print("failed to recieve contents of "'..link..')'
end
local function install(file: string)
    if not isfile(file) then
        local oldFile = file
        file = file:gsub('Strafe/', '')

        writefile(oldFile, getContents(file))

        repeat task.wait() until isfile(oldFile)

        return readfile(oldFile)
    end

    return readfile(file)
end

if not isfolder('Strafe') then
    makefolder('Strafe')
    makefolder('Strafe/Games')
    makefolder('Strafe/Configs')
    makefolder('Strafe/Libraries')
    makefolder('Strafe/Libraries/Bedwars')
    makefolder('Strafe/Libraries/BedwarZ')
    makefolder('Strafe/Libraries/BridgeDuels')
end

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

for _, v in Contents do
    if not isfile('Strafe/'..v..'.lua') then
        install('Strafe/'..v..'.lua')
    end
end

--return loadstring(install('Strafe/Main.lua'))()

local GuiLibrary = loadfile('Strafe/GuiLibrary.lua')()
local Games = loadfile('Strafe/Games.lua')()
loadfile('Strafe/Universal.lua')()

shared.didQueue = false
game:GetService('Players').LocalPlayer.OnTeleport:Connect(function()
    if shared.didQueue then
        return
    end

    shared.didQueue = true
    queue_on_teleport([[
        loadfile('Strafe/Main.lua')()
    ]])
end)


for i, v in Games do
    for _, id in v do
        if game.PlaceId == id then
            loadfile('Strafe/Games/'..i..'.lua')()
        end
    end
end

