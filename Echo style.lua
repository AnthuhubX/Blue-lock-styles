-- Echo Character Abilities (Preserved Original Implementations)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- VFX Assets
local sonicBoomVFX = ReplicatedStorage.Assets.Vfx.NagiKickImpact.VFX.Effects
local dashVFX = ReplicatedStorage.Effects.KaiserDribble.Move2.Start

-- Animation Setup
local dashAnim = Instance.new("Animation")
dashAnim.AnimationId = "rbxassetid://99916870664377" -- Dribble animation
local kickAnim = Instance.new("Animation")
kickAnim.AnimationId = "rbxassetid://18723315763" -- Shoot animation

-- ===== 1. ECHO DASH (UPDATED PARAMETERS ONLY) =====
local function echoDash()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Play animation
    local animTrack = humanoid:LoadAnimation(dashAnim)
    animTrack:Play()
    animTrack:AdjustSpeed(1.5)

    -- Updated parameters (only these changed)
    local segments = 12    -- Changed from 3 to 12
    local duration = 0.08  -- Changed from 0.50 to 0.08
    local distance = 7     -- Changed from 20 to 7

    local function zigzag(count)
        if count > segments then 
            animTrack:Stop()
            return 
        end

        -- Spawn VFX at each zigzag (original implementation)
        local vfx = dashVFX:Clone()
        vfx.Parent = rootPart
        Debris:AddItem(vfx, duration)
        for _, emitter in ipairs(vfx:GetDescendants()) do
            if emitter:IsA("ParticleEmitter") then
                emitter.Enabled = true
            end
        end

        -- Movement calculation (original implementation)
        local dir = (count % 2 == 1) and 1 or -1
        local fwd = rootPart.CFrame.LookVector
        local right = rootPart.CFrame.RightVector
        local targetPos = rootPart.Position + (fwd * distance + dir * right * distance)

        -- Movement (original implementation)
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

-- ===== 2. SONIC BOOM SHOT (ORIGINAL IMPLEMENTATION) =====
local function sonicBoomShot()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Play animation (original)
    local animTrack = humanoid:LoadAnimation(kickAnim)
    animTrack:Play()

    -- Attach VFX (original)
    local vfx = sonicBoomVFX:Clone()
    vfx.Parent = rootPart
    Debris:AddItem(vfx, 1.5)
    for _, emitter in ipairs(vfx:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = true
        end
    end

    -- Shoot event (original)
    local shootEvent = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("Knit")
        :WaitForChild("Services")
        :WaitForChild("BallService")
        :WaitForChild("RE")
        :WaitForChild("Shoot")

    -- Shoot timing (original)
    task.delay(0.5, function()
        if shootEvent then
            shootEvent:FireServer(200) -- Original power
        end
        animTrack:Stop()
    end)
end

-- ===== 3. VIBRATE PASS (YOUR EXACT ORIGINAL IMPLEMENTATION) =====
local function playerHasBall() 
    local char = player.Character 
    if not char then return false end 
    local valuesFolder = char:FindFirstChild("Values") 
    if not valuesFolder then return false end 
    local hasBallVal = valuesFolder:FindFirstChild("HasBall") 
    if not hasBallVal then return false end 
    return hasBallVal.Value == true 
end 

local function isPlayerInTeam(checkPlayer, teamFolder) 
    for _, obj in ipairs(teamFolder:GetChildren()) do 
        if obj:IsA("ObjectValue") then 
            if obj.Value == checkPlayer or obj.Name == checkPlayer.Name then 
                return true 
            end 
        end 
    end 
    return false 
end 

local function getPlayerTeam(checkPlayer) 
    local teamsFolder = ReplicatedStorage:WaitForChild("Teams") 
    local awayTeam = teamsFolder:WaitForChild("AwayTeam") 
    local homeTeam = teamsFolder:WaitForChild("HomeTeam") 
    
    if isPlayerInTeam(checkPlayer, awayTeam) then 
        return awayTeam 
    elseif isPlayerInTeam(checkPlayer, homeTeam) then 
        return homeTeam 
    else 
        return nil 
    end 
end 

local function findNearestTeammate() 
    local character = player.Character 
    if not character then return nil end 
    local hrp = character:FindFirstChild("HumanoidRootPart") 
    if not hrp then return nil end 
    
    local lookVector = hrp.CFrame.LookVector 
    local localTeam = getPlayerTeam(player) 
    local nearestTeammate, minDistance = nil, math.huge 
    
    for _, other in ipairs(Players:GetPlayers()) do 
        if other ~= player then 
            local otherTeam = getPlayerTeam(other) 
            if localTeam and otherTeam and localTeam == otherTeam then 
                local otherChar = other.Character 
                if otherChar then 
                    local otherHRP = otherChar:FindFirstChild("HumanoidRootPart") 
                    if otherHRP then 
                        local offset = otherHRP.Position - hrp.Position 
                        if offset.Magnitude > 5 and offset:Dot(lookVector) > 0.5 then 
                            if offset.Magnitude < minDistance then 
                                minDistance = offset.Magnitude 
                                nearestTeammate = other 
                            end 
                        end 
                    end 
                end 
            end 
        end 
    end 
    return nearestTeammate 
end 

local function vibratePass() 
    if not playerHasBall() then return end 
    
    local targetPlayer = findNearestTeammate() 
    if not targetPlayer then return end 
    
    local targetChar = targetPlayer.Character 
    if not targetChar then return end 
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart") 
    if not targetHRP then return end 
    
    -- Play animation (original)
    local animTrack = player.Character.Humanoid:LoadAnimation(kickAnim)
    animTrack:Play()

    -- Get shoot event (original)
    local shootEvent = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("Knit")
        :WaitForChild("Services")
        :WaitForChild("BallService")
        :WaitForChild("RE")
        :WaitForChild("Shoot")
    
    if not shootEvent then return end
    
    -- Pass timing (original)
    task.delay(0.5, function()
        local direction = (targetHRP.Position - player.Character.HumanoidRootPart.Position).Unit 
        shootEvent:FireServer(100, nil, nil, direction) 
        animTrack:Stop()
        
        -- Ball physics (original)
        task.spawn(function() 
            local ball, startTime = nil, tick() 
            repeat 
                task.wait() 
                ball = workspace:FindFirstChild("Football") 
            until (ball and ball:IsA("BasePart")) or tick() - startTime > 2 
            
            if ball then 
                local velocityEndTime = tick() + 3
                direction = (targetHRP.Position - ball.Position).Unit 
                ball.AssemblyLinearVelocity = (direction + Vector3.new(0, 0.25, 0)) * 250 
                
                while ball and ball.Parent and tick() < velocityEndTime do 
                    direction = (targetHRP.Position - ball.Position).Unit 
                    ball.AssemblyLinearVelocity = (direction + Vector3.new(0, 0.25, 0)) * 250 
                    task.wait() 
                end
            end 
        end) 
    end)
end

-- Create ability buttons (ORIGINAL IMPLEMENTATION)
local function createAbilityButtons()
    if not player.PlayerGui:FindFirstChild("InGameUI") then return end
    
    local bottomAbilities = player.PlayerGui.InGameUI.Bottom.Abilities
    local template = bottomAbilities:FindFirstChild("1")
    if not template then return end

    -- Echo Dash (Q) - Original button setup
    local dashButton = template:Clone()
    dashButton.Name = "EchoDash"
    dashButton.Parent = bottomAbilities
    dashButton.Keybind.Text = "Q"
    dashButton.Timer.Text = "Echo Dash"
    dashButton.ActualTimer.Text = ""
    dashButton.Activated:Connect(echoDash)

    -- Sonic Boom Shot (E) - Original button setup
    local shotButton = template:Clone()
    shotButton.Name = "SonicBoomShot"
    shotButton.Parent = bottomAbilities
    shotButton.Keybind.Text = "E"
    shotButton.Timer.Text = "Sonic Boom"
    shotButton.ActualTimer.Text = ""
    shotButton.Activated:Connect(sonicBoomShot)

    -- Vibrate Pass (R) - Original button setup
    local passButton = template:Clone()
    passButton.Name = "VibratePass"
    passButton.Parent = bottomAbilities
    passButton.Keybind.Text = "R"
    passButton.Timer.Text = "Vibrate Pass"
    passButton.ActualTimer.Text = ""
    passButton.Activated:Connect(vibratePass)
end

-- Initialize (ORIGINAL)
player.CharacterAdded:Connect(createAbilityButtons)
if player.Character and player.PlayerGui:FindFirstChild("InGameUI") then
    createAbilityButtons()
end

-- Keyboard controls (ORIGINAL)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        echoDash()
    elseif input.KeyCode == Enum.KeyCode.E then
        sonicBoomShot()
    elseif input.KeyCode == Enum.KeyCode.R then
        vibratePass()
    end
end)
