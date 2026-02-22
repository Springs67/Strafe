local Players = game:GetService("Players")
if not Players.LocalPlayer then
    repeat task.wait() until Players.LocalPlayer
end

local GuiLibrary = shared.GuiLibrary
local FakeDamage = loadfile('Strafe/Libraries/FakeDamage.lua')()

GuiLibrary:registerWindow('Combat')
GuiLibrary:registerWindow('Movement')
GuiLibrary:registerWindow('Player')
GuiLibrary:registerWindow('Visual')
GuiLibrary:registerWindow('Misc')

GuiLibrary.screen:FindFirstChild('Arraylist').Visible = false

local ModuleList = GuiLibrary:registerModule({
    ['Name'] = 'Module List',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        GuiLibrary.screen:FindFirstChild('Arraylist').Visible = callback
    end
})
ModuleList:registerSlider({
    ['Name'] = 'Transparency',
    ['Step'] = 0.05,
    ['Minimum'] = 0,
    ['Maximum'] = 1,
    ['Default'] = 1,
    ['Callback'] = function(Value)
        GuiLibrary.Arraylist.Transparency = Value
    end
})
ModuleList:registerToggle({
    ['Name'] = 'Outline',
    ['Callback'] = function(callback)
        GuiLibrary.Arraylist.Outline = callback
    end
})
ModuleList:registerToggle({
    ['Name'] = 'Shadow',
    ['Callback'] = function(callback)
        GuiLibrary.Arraylist.Shadow = callback
    end
})


local WatermarkInst = Instance.new('TextLabel')
WatermarkInst.Parent = GuiLibrary.screen
WatermarkInst.Position = UDim2.fromOffset(25, 25)
WatermarkInst.BackgroundTransparency = 0.35
WatermarkInst.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
WatermarkInst.TextXAlignment = Enum.TextXAlignment.Left
WatermarkInst.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkInst.TextSize = 25
WatermarkInst.Text = ' Strafe 1.0.0 | dev '
WatermarkInst.Font = Enum.Font.BuilderSansMedium
WatermarkInst.Visible = false
WatermarkInst.Size = UDim2.fromOffset(game:GetService('TextService'):GetTextSize(WatermarkInst.Text, WatermarkInst.TextSize, WatermarkInst.Font, Vector2.zero).X, 30)
local WatermarkTop = Instance.new('Frame')
WatermarkTop.Parent = WatermarkInst
WatermarkTop.Position = UDim2.fromOffset(0, -2)
WatermarkTop.Size = UDim2.new(1, 0, 0, 3)
WatermarkTop.BorderSizePixel = 1
WatermarkTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
WatermarkTop.BackgroundColor3 = Color3.fromRGB(0, 100, 255)

if game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('TopbarStandard') then
    game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('TopbarStandard').Enabled = false
end

game:GetService("CoreGui"):WaitForChild('TopBarApp'):WaitForChild('TopBarApp').Enabled = false

local Watermark = GuiLibrary:registerModule({
    ['Name'] = 'Watermark',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        WatermarkInst.Visible = callback
    end
})

--[[local Nametags = GuiLibrary:registerModule({
    ['Name'] = 'Nametags',
    ['Window'] = 'Visual',
    ['Callback'] = function(callback)
        if callback then
            
        end
    end
})]]