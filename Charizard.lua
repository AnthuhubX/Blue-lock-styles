-- Ultimate Fire Football Abilities Script
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Load Knit and StatesController for speed boost
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local StatesController = Knit.GetController("StatesController")

-- Load VFX assets
local dragonVFX = ReplicatedStorage.Effects.PowerShot.Dragon.Attachment

-- Function to display ability text
local function displayAbilityText(text, duration)
    local gui = player.PlayerGui:FindFirstChild("InGameUI")
    if gui then
        local abilityText = gui:FindFirstChild("AbilityText")
        if abilityText then
            abilityText.Text = text
            abilityText.Visible = true
            task.delay(duration, function()
                abilityText.Visible = false
            end)
        end
    end
end

-- Button creation function
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

-- Flame Kick Ability (170 power)
local function performFlameKick()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://18723315763"
    humanoid:LoadAnimation(anim):Play()

    -- Dragon VFX
    local vfx = dragonVFX:Clone()
    vfx.Parent = rootPart
    for _, emitter in ipairs(vfx:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = true
        end
    end
    Debris:AddItem(vfx, 1.5)

    wait(0.5) -- Animation timing

    -- Shoot with 170 power
    ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot:FireServer(170)
    displayAbilityText("Flame Kick", 1.5)
end

-- Inferno Glide Ability (Zigzag with dragon VFX)
local function performInfernoGlide()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://99916870664377"
    local animTrack = humanoid:LoadAnimation(anim)
    animTrack:Play()
    animTrack:AdjustSpeed(1.5)

    -- Zigzag movement with fire VFX
    local segments = 5
    local duration = 0.40
    local distance = 24

    local function zigzag(count)
        if count > segments then
            animTrack:Stop()
            return
        end

        -- Movement calculation
        local dir = (count % 2 == 1) and 1 or -1
        local fwd = rootPart.CFrame.LookVector
        local right = rootPart.CFrame.RightVector
        local targetPos = rootPart.Position + (fwd * distance + dir * right * distance)

        -- Spawn dragon VFX at each zigzag
        local vfx = dragonVFX:Clone()
        vfx.Parent = rootPart
        for _, emitter in ipairs(vfx:GetDescendants()) do
            if emitter:IsA("ParticleEmitter") then
                emitter.Enabled = true
            end
        end
        Debris:AddItem(vfx, duration*2)

        -- Movement tween
        local tween = TweenService:Create(
            rootPart,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(targetPos, targetPos + fwd)}
        )
        tween:Play()

        -- Continue sequence
        tween.Completed:Connect(function()
            zigzag(count + 1)
        end)
    end

    zigzag(1) -- Start zigzag
    displayAbilityText("Inferno Glide", 2)
end

-- Blazing Rush Ability (Speed boost with fire VFX)
local function performBlazingRush()
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Dragon VFX
    local vfx = dragonVFX:Clone()
    vfx.Parent = rootPart
    for _, emitter in ipairs(vfx:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = true
        end
    end
    Debris:AddItem(vfx, 10)

    -- Activate speed boost
    StatesController.OwnWalkState = true
    StatesController.SpeedBoost = 40
    displayAbilityText("Blazing Rush", 2)

    -- Reset after 10 seconds
    task.delay(10, function()
        StatesController.SpeedBoost = 0
    end)
end

-- Firestorm Smash Ability (230 power with single VFX)
local function performFirestormSmash()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://18723315763"
    humanoid:LoadAnimation(anim):Play()

    -- Single dragon VFX attached to player
    local vfx = dragonVFX:Clone()
    vfx.Parent = rootPart
    for _, emitter in ipairs(vfx:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = true
        end
    end
    Debris:AddItem(vfx, 1.5)

    wait(0.5) -- Animation timing

    -- Shoot with 230 power
    ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot:FireServer(230)
    displayAbilityText("FIRESTORM SMASH!", 2)
end

-- Create ability buttons
createAbilityButton("FlameKickButton", "K", "Flame Kick", performFlameKick)
createAbilityButton("InfernoGlideButton", "V", "Inferno Glide", performInfernoGlide)
createAbilityButton("BlazingRushButton", "F", "Blazing Rush", performBlazingRush)
createAbilityButton("FirestormSmashButton", "G", "Firestorm Smash", performFirestormSmash)

-- Keyboard controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.K then
            performFlameKick()
        elseif input.KeyCode == Enum.KeyCode.V then
            performInfernoGlide()
        elseif input.KeyCode == Enum.KeyCode.F then
            performBlazingRush()
        elseif input.KeyCode == Enum.KeyCode.G then
            performFirestormSmash()
        end
    end
end)
