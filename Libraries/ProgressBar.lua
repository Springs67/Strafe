local TweenService = game:GetService("TweenService")
local GuiLibrary = shared.GuiLibrary

return {
    new = function(time: number)
        local TimerFrame = Instance.new('Frame')
        TimerFrame.Parent = GuiLibrary.screen
        TimerFrame.Position = UDim2.fromScale(0.5, 0.8)
        TimerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        TimerFrame.Size = UDim2.fromOffset(400, 24)
        TimerFrame.BorderSizePixel = 0
        TimerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        local InsideFrame = Instance.new('Frame')
        InsideFrame.Parent = TimerFrame
        InsideFrame.Position = UDim2.fromOffset(2, 2)
        InsideFrame.Size = UDim2.new(0, 0, 1, -4)
        InsideFrame.BorderSizePixel = 0
        InsideFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 255)

        local troll = GuiLibrary.GuiChange.Event:Connect(function(val)
            InsideFrame.BackgroundColor3 = val
        end)

        TweenService:Create(InsideFrame, TweenInfo.new(time), {Size = UDim2.new(1, -4, 1, -4)}):Play()

        task.delay(time, function()
            TweenService:Create(TimerFrame, TweenInfo.new(1), {Size = UDim2.fromOffset(0, 0)}):Play()
            TweenService:Create(InsideFrame, TweenInfo.new(1), {Size = UDim2.fromScale(1, 1)}):Play()

            task.delay(0.9, function()
                TimerFrame:Destroy()
                troll:Disconnect()
            end)
        end)
    end
}