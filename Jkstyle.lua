-- Ultimate Football Abilities Script (10 Second Run Kick)
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

-- Load Knit and StatesController
local Knit = require(ReplicatedStorage.Packages.Knit)
local StatesController = Knit.GetController("StatesController")

-- VFX Assets
local runVFX = ReplicatedStorage.Effects.KaiserImpact.Start.Start
local ravageVFX = ReplicatedStorage.Effects.KaiserImpact.Start.Start
local dribbleVFX = {
    ReplicatedStorage.Effects.KaiserVolley.Start.Start,
    ReplicatedStorage.Effects.KaiserVolley.End.End.Attachment,
    ReplicatedStorage.Effects.KaiserDribble.Move2.Start,
    ReplicatedStorage.Effects.KaiserDribble.Move2Shoot.End.Bl,
    ReplicatedStorage.Effects.KaiserImpact.End.End.End
}

-- Animation Setup
local dribbleAnim = Instance.new("Animation")
dribbleAnim.AnimationId = "rbxassetid://99916870664377" -- KJ Dribble

local ravageAnim = Instance.new("Animation")
ravageAnim.AnimationId = "rbxassetid://18723315763" -- Ravage Kick

-- ===== 20-20-20 RUN KICK (10 SECONDS) =====
local function runKick()
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Speed boost (5x normal speed)
    StatesController.OwnWalkState = true
    StatesController.SpeedBoost = 30

    -- Run VFX
    local vfx = runVFX:Clone()
    vfx.Parent = rootPart
    for _, emitter in ipairs(vfx:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = true
        end
    end

    -- End after 10 seconds (updated duration)
    task.delay(10, function()
        StatesController.SpeedBoost = 0
        Debris:AddItem(vfx, 0.5)
    end)
end

-- ===== RAVAGE KICK =====
local function ravageKick()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Play animation
    local animTrack = humanoid:LoadAnimation(ravageAnim)
    animTrack:Play()

    -- Ravage VFX
    local vfx = ravageVFX:Clone()
    vfx.Parent = rootPart
    for _, emitter in ipairs(vfx:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = true
        end
    end

    -- Shoot with 180 power
    task.delay(0.5, function()
        ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot:FireServer(180)
        animTrack:Stop()
        Debris:AddItem(vfx, 1)
    end)
end

-- ===== KJ DRIBBLE =====
local function kjDribble()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Play animation
    local animTrack = humanoid:LoadAnimation(dribbleAnim)
    animTrack:Play()
    animTrack:AdjustSpeed(1.5)

    -- Spawn all dribble VFX
    local vfxInstances = {}
    for _, vfx in ipairs(dribbleVFX) do
        local instance = vfx:Clone()
        instance.Parent = rootPart
        table.insert(vfxInstances, instance)
        for _, emitter in ipairs(instance:GetDescendants()) do
            if emitter:IsA("ParticleEmitter") then
                emitter.Enabled = true
            end
        end
    end

    local segments = 12
    local duration = 0.08
    local distance = 7

    local function zigzag(count)
        if count > segments then 
            animTrack:Stop()
            for _, vfx in ipairs(vfxInstances) do
                Debris:AddItem(vfx, 0.5)
            end
            return 
        end

        -- Movement calculation
        local dir = (count % 2 == 1) and 1 or -1
        local fwd = rootPart.CFrame.LookVector
        local right = rootPart.CFrame.RightVector
        local targetPos = rootPart.Position + (fwd * distance + dir * right * distance)

        -- Movement
        local tween = TweenService:Create(
            rootPart,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(targetPos, targetPos + fwd)}
        )
        tween:Play()
        tween.Completed:Connect(function() zigzag(count + 1) end)
    end
    zigzag(1)
end

-- ===== BUTTON CREATION =====
local function createAbilityButton(buttonName, keybindText, displayText, abilityFunction)
    local bottomAbilities = player.PlayerGui.InGameUI.Bottom.Abilities
    local templateButton = bottomAbilities["1"]:Clone()
    templateButton.Name = buttonName
    templateButton.Parent = bottomAbilities
    templateButton.Keybind.Text = keybindText
    templateButton.Timer.Text = displayText
    templateButton.ActualTimer.Text = ""
    if templateButton:FindFirstChild("Cooldown") then
        templateButton.Cooldown:Destroy()
    end
    templateButton.Activated:Connect(abilityFunction)
    return templateButton
end

-- Initialize when character exists
player.CharacterAdded:Connect(function()
    -- Wait for UI to load
    repeat task.wait() until player.PlayerGui:FindFirstChild("InGameUI")
    
    -- Create all buttons
    createAbilityButton("RunKickButton", "Q", "30-30-30 Run", runKick)
    createAbilityButton("RavageKickButton", "E", "JK Kick", ravageKick)
    createAbilityButton("KJDribbleButton", "R", "JK Dribble", kjDribble)
end)

-- Keyboard controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        runKick()
    elseif input.KeyCode == Enum.KeyCode.E then
        ravageKick()
    elseif input.KeyCode == Enum.KeyCode.R then
        kjDribble()
    end
end)

-- Initial button creation if character already exists
if player.Character and player.PlayerGui:FindFirstChild("InGameUI") then
    createAbilityButton("RunKickButton", "Q", "30-30-30 Run", runKick)
    createAbilityButton("RavageKickButton", "E", "JK Kick", ravageKick)
    createAbilityButton("KJDribbleButton", "R", "JK Dribble", kjDribble)
end
