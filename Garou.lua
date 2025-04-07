-- Douma Character Abilities Script

local player = game:GetService("Players").LocalPlayer

local UserInputService = game:GetService("UserInputService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")

local Debris = game:GetService("Debris")

local RunService = game:GetService("RunService")

local Players = game:GetService("Players")

-- Load Knit and StatesController

local Knit = require(ReplicatedStorage.Packages.Knit)

local StatesController = Knit.GetController("StatesController")

-- VFX Assets

local volleyStartVFX = ReplicatedStorage.Effects.KaiserVolley.Start.Start

local volleyEndVFX = ReplicatedStorage.Effects.KaiserVolley.End.End.Attachment

local ravenDribbleVFX = ReplicatedStorage.Effects.RavenDribble.EmitGround.Raycast

-- Animation Setup

local kickAnim = Instance.new("Animation")

kickAnim.AnimationId = "rbxassetid://18723315763" -- Same as JK Kick

local dribbleAnim = Instance.new("Animation")

dribbleAnim.AnimationId = "rbxassetid://99916870664377" -- Dribble animation

-- ===== 1. NEBULA BOOST =====

local function nebulaBoost()

    local character = player.Character

    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not rootPart then return end

    -- Speed boost

    StatesController.OwnWalkState = true

    StatesController.SpeedBoost = 30

    -- VFX

    local vfx = volleyStartVFX:Clone()

    vfx.Parent = rootPart

    for _, emitter in ipairs(vfx:GetDescendants()) do

        if emitter:IsA("ParticleEmitter") then

            emitter.Enabled = true

        end

    end

    -- End after 10 seconds

    task.delay(10, function()

        StatesController.SpeedBoost = 0

        Debris:AddItem(vfx, 0.5)

    end)

end

-- ===== 2. GALAXY SHOOT =====

local function galaxyShoot()

    local character = player.Character

    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")

    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then return end

    -- Play animation

    local animTrack = humanoid:LoadAnimation(kickAnim)

    animTrack:Play()

    -- Add VFX

    local vfx = volleyEndVFX:Clone()

    vfx.Parent = rootPart

    for _, emitter in ipairs(vfx:GetDescendants()) do

        if emitter:IsA("ParticleEmitter") then

            emitter.Enabled = true

        end

    end

    -- Shoot with 180 power after animation delay

    task.delay(0.5, function()

        ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot:FireServer(180)

        animTrack:Stop()

        Debris:AddItem(vfx, 1)

    end)

end

-- ===== 3. PLASMA PASS =====

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

local function plasmaPass()

    if not playerHasBall() then return end

    

    local targetPlayer = findNearestTeammate()

    if not targetPlayer then return end

    

    local targetChar = targetPlayer.Character

    if not targetChar then return end

    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

    if not targetHRP then return end

    

    local shootEvent = ReplicatedStorage:WaitForChild("Packages")

        :WaitForChild("Knit")

        :WaitForChild("Services")

        :WaitForChild("BallService")

        :WaitForChild("RE")

        :WaitForChild("Shoot")

    

    if shootEvent then

        local direction = (targetHRP.Position - player.Character.HumanoidRootPart.Position).Unit

        shootEvent:FireServer(200, nil, nil, direction)

        

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

    end

end

-- ===== 4. STAR TELEPORT =====

local function starTeleport()

    local character = player.Character

    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not rootPart then return end

    local ball = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")

    if not ball then return end

    -- Teleport to ball with slight vertical offset

    rootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 3, 0), ball.Position)

end

-- ===== 5. GAROU DRIBBLE (WITH RAVEN VFX) =====

local function garouDribble()

    local character = player.Character

    if not character then return end

    

    local humanoid = character:FindFirstChild("Humanoid")

    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then return end

    -- Load and attach VFX

    local vfx = ravenDribbleVFX:Clone()

    vfx.Parent = rootPart

    Debris:AddItem(vfx, 3) -- Clean up after 3 seconds

    -- Animation

    local animTrack = humanoid:LoadAnimation(dribbleAnim)

    animTrack:Play()

    animTrack:AdjustSpeed(1.5)

    -- Zigzag movement parameters

    local segments = 5

    local duration = 0.4

    local distance = 24

    local function zigzag(count)

        if count > segments then

            animTrack:Stop()

            if vfx and vfx.Parent then

                vfx:Destroy()

            end

            return

        end

        -- Trigger VFX at each segment

        if vfx and vfx.Parent then

            for _, emitter in ipairs(vfx:GetDescendants()) do

                if emitter:IsA("ParticleEmitter") then

                    emitter:Emit(20) -- Emit 20 particles per segment

                end

            end

        end

        -- Calculate movement direction

        local dir = (count % 2 == 1) and 1 or -1

        local fwd = rootPart.CFrame.LookVector

        local right = rootPart.CFrame.RightVector

        local targetPos = rootPart.Position + (fwd * distance + dir * right * distance)

        -- Create movement tween

        TweenService:Create(

            rootPart,

            TweenInfo.new(duration, Enum.EasingStyle.Linear),

            {CFrame = CFrame.new(targetPos, targetPos + fwd)}

        ):Play()

        -- Continue sequence

        task.delay(duration, function()

            zigzag(count + 1)

        end)

    end

    zigzag(1) -- Start the dribble

end

-- ===== 6. COSMIC CONTROLLER =====

local cosmicControllerActive = false

local ballConnection

local defaultSpeed = 125

local function findFootball()

    return workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")

end

local function cosmicController()

    local ball = findFootball()

    if not ball then return end

    

    if cosmicControllerActive then

        -- Stop controlling

        if ballConnection then

            ballConnection:Disconnect()

            ballConnection = nil

        end

        workspace.CurrentCamera.CameraSubject = player.Character

    else

        -- Start controlling

        workspace.CurrentCamera.CameraSubject = ball

        ballConnection = RunService.Heartbeat:Connect(function()

            if not ball or not ball.Parent then 

                if ballConnection then

                    ballConnection:Disconnect()

                end

                return 

            end

            ball.Velocity = workspace.CurrentCamera.CFrame.LookVector * defaultSpeed

        end)

    end

    cosmicControllerActive = not cosmicControllerActive

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

player.CharacterAdded:Connect(function(char)

    character = char

    humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    

    -- Wait for UI to load

    repeat task.wait() until player.PlayerGui:FindFirstChild("InGameUI")

    

    -- Create all ability buttons

    createAbilityButton("NebulaBoost", "E", "Nebula Boost", nebulaBoost)

    createAbilityButton("GalaxyShoot", "F", "Galaxy Shoot", galaxyShoot)

    createAbilityButton("PlasmaPass", "R", "Plasma Pass", plasmaPass)

    createAbilityButton("StarTeleport", "Q", "Star Teleport", starTeleport)

    createAbilityButton("GarouDribble", "V", "Garou Dribble", garouDribble)

    createAbilityButton("CosmicController", "C", "Cosmic Controller", cosmicController)

end)

-- Keyboard controls

UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then

        nebulaBoost()

    elseif input.KeyCode == Enum.KeyCode.F then

        galaxyShoot()

    elseif input.KeyCode == Enum.KeyCode.R then

        plasmaPass()

    elseif input.KeyCode == Enum.KeyCode.Q then

        starTeleport()

    elseif input.KeyCode == Enum.KeyCode.V then

        garouDribble()

    elseif input.KeyCode == Enum.KeyCode.C then

        cosmicController()

    end

end)

-- Initial button creation if character already exists

if player.Character and player.PlayerGui:FindFirstChild("InGameUI") then

    createAbilityButton("NebulaBoost", "E", "Nebula Boost", nebulaBoost)

    createAbilityButton("GalaxyShoot", "F", "Galaxy Shoot", galaxyShoot)

    createAbilityButton("PlasmaPass", "R", "Plasma Pass", plasmaPass)

    createAbilityButton("StarTeleport", "Q", "Star Teleport", starTeleport)

    createAbilityButton("GarouDribble", "V", "Garou Dribble", garouDribble)

    createAbilityButton("CosmicController", "C", "Cosmic Controller", cosmicController)

end
