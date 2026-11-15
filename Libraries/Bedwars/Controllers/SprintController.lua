local ContextActionService = game:GetService('ContextActionService')
local tweenService = game:GetService('TweenService')
local gameCamera = workspace.CurrentCamera
local lplr = game:GetService('Players').LocalPlayer

local sprintController = {
    Name = 'SprintController',
    blockSprint = false,
    sprinting = false,
};

function sprintController:setBlocked(bool: boolean)
    self.blockSprint = bool;

    if self.sprinting and self.blockSprint then
        self:stopSprinting()
    end
end

function sprintController.setSpeed(val: number)
    if not lplr.Character then
        return
    end

    if not lplr.Character:FindFirstChild('Humanoid') then
        return
    end

    if not (lplr.Character:FindFirstChild('Humanoid').Health > 0) then
        return
    end

    lplr.Character:FindFirstChild('Humanoid').WalkSpeed = val;
end

function sprintController:startSprinting()
    if self.blockSprint or self.sprinting then
        return
    end

    self.sprinting = true;
    lplr:SetAttribute('Sprinting', self.sprinting)

    tweenService:Create(gameCamera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        FieldOfView = 100
    }):Play()
    self.setSpeed(20);
end

function sprintController:stopSprinting()
    if not self.sprinting then
        return
    end

    self.sprinting = false;
    lplr:SetAttribute('Sprinting', self.sprinting)

    tweenService:Create(gameCamera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        FieldOfView = 90
    }):Play()
    self.setSpeed(14);
end

ContextActionService:BindActionAtPriority('Sprinting', function(_, inputState: Enum.UserInputState, inputObject: InputObject)
    if inputState == Enum.UserInputState.Begin then
        sprintController:startSprinting()
    elseif inputState == Enum.UserInputState.End then
        sprintController:stopSprinting()
    end
    return Enum.ContextActionResult.Sink
end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.LeftShift)

return sprintController;