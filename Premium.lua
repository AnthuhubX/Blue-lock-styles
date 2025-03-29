local players = game:GetService("Players")
local player = players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Main/refs/heads/main/UI%20premium"))()

local whitelist = {
    ["xlzzzmain"] = true,
    ["s3b1ka_400"] = true,
    ["s3b1ka_1002"] = true,
    ["s3b1k4"] = true,
    ["Dgfhdjdufhfbfhf"] = true,
    ["Master_AlanGG"] = true,
    ["Su_rzz"] = true,
    ["Alexleftcheek43"] = true,
    ["Woody1337SS"] = true,
    ["JanmiYT100"] = true,
    ["ShadIsBetterThanYou"] = true,
    ["TooBlindd"] = true,
    ["Broiamongs"] = true,
    ["Broiamon"] = true,
    ["NgHdang_7"] = true,
    ["Min85500"] = true
}

if not whitelist[player.Name] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Access Denied",
        Text = "Sorry, you're not whitelisted. You will be kicked out.",
        Duration = 5
    })
    wait(1)
    player:Kick("Sorry, you're not whitelisted :(")
    return
end

MakeWindow({
    Hub = {
        Title = "Neon Hub Premium made by Sae",
        Animation = "Thanks!"
    },
    Key = {
        KeySystem = false,
        Title = "XLZ Hub Premium made by Sae",
        Description = "Blue Lock Rivals (Updated)",
        Keys = {"Xlz"},
        Notifi = {
            Notifications = false,
        }
    },
    Theme = {
        Background = Color3.fromRGB(30, 30, 90),
        TopBar = Color3.fromRGB(50, 50, 200),
        TextColor = Color3.fromRGB(255, 255, 255),
        BorderColor = Color3.fromRGB(0, 0, 255),
    }
})

MinimizeButton({
    Size = {40, 40},
    Color = Color3.fromRGB(10, 10, 90),
    Corner = true,
    Stroke = true,
    StrokeColor = Color3.fromRGB(0, 0, 255)
})

local Main = MakeTab({Name = "INFO"})
AddImageLabel(Main, {
    Name = "Neon Hub premium",
    Image = "rbxassetid://17409640914"
})
AddParagraph(Main, {"More Games Getting Supported Soon"})

local MiscTab = MakeTab({Name = "Misc"})

AddButton(MiscTab, {
    Name = "No CD",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/D7wLcgFZ"))()
    end,
    Color = Color3.fromRGB(0, 102, 255)
})

AddButton(MiscTab, {
    Name = "GK Mode",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/CGtpASYq"))()
    end,
    Color = Color3.fromRGB(0, 76, 153)
})

AddButton(MiscTab, {
    Name = "Hitbox Expander",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RedJDarks/MAIN/refs/heads/main/HitboxExpander"))()
    end,
    Color = Color3.fromRGB(0, 51, 204)
})

local StyleFlowTab = MakeTab({Name = "Style/Flow"})
AddParagraph(StyleFlowTab, {"• Set your style or flow!"})

local function set_style(desired_style)
    if player:FindFirstChild("PlayerStats") then
        local playerStats = player.PlayerStats
        if playerStats:FindFirstChild("Style") then
            playerStats.Style.Value = desired_style
        end
    end
end

local function set_flow(desired_flow)
    if player:FindFirstChild("PlayerStats") then
        local playerStats = player.PlayerStats
        if playerStats:FindFirstChild("Flow") then
            playerStats.Flow.Value = desired_flow
        end
    end
end

local styleId
local StyleTextBox = AddTextBox(StyleFlowTab, {
    Name = "Style Name",
    Default = "",
    TextDisappear = false,
    PlaceholderText = "PUT STYLE NAME",
    ClearText = true,
    Callback = function(value)
        styleId = value
    end
})

AddButton(StyleFlowTab, {
    Name = "Get the Style (reo needed)",
    Callback = function()
        if styleId and styleId ~= "" then
            set_style(styleId)
            MakeNotifi({
                Title = "Success",
                Text = "You got the style!",
                Time = 5
            })
        else
            MakeNotifi({
                Title = "Error",
                Text = "Please enter a valid style name",
                Time = 5
            })
        end
    end
})

AddButton(StyleFlowTab, {
    Name = "Get Your Flow",
    Callback = function()
        if styleId and styleId ~= "" then
            set_flow(styleId)
            MakeNotifi({
                Title = "Success",
                Text = "You got the flow!",
                Time = 5
            })
        else
            MakeNotifi({
                Title = "Error",
                Text = "Please enter a valid flow name",
                Time = 5
            })
        end
    end
})

local CosmeticsTab = MakeTab({Name = "Cosmetics"})

AddButton(CosmeticsTab, {
    Name = "Dragon Cape (not working)",
    Callback = function()
        cloneref(game:GetService("ReplicatedStorage")).Packages.Knit.Services.CustomizationService.RE.Customize:FireServer("Cosmetics", "Dragon Cape")
    end,
    Color = Color3.fromRGB(0, 204, 255)
})

local CustomStylesTab = MakeTab({Name = "Custom Styles Premium"})

AddButton(CustomStylesTab, {
    Name = "undertaker style",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Main/refs/heads/main/Undertaker"))()
    end,
    Color = Color3.fromRGB(34, 139, 34)
})

AddButton(CustomStylesTab, {
    Name = "Loki style",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Blue-lock-styles/refs/heads/main/Loki%20obfuscated"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})

AddButton(CustomStylesTab, {
    Name = "charizard style🔥",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Blue-lock-styles/refs/heads/main/Charizard.lua"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})

AddButton(CustomStylesTab, {
    Name = "JK style",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Blue-lock-styles/refs/heads/main/Jkstyle.lua"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})

local TrollTab = MakeTab({Name = "Troll"})
AddButton(TrollTab, {
    Name = "REF HES KILLING PEOPLE (client sided)",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Grab-knife-v4-24753"))()
    end,
    Color = Color3.fromRGB(255, 0, 0)
})

local OthersTab = MakeTab({Name = "Others Made by Xlz"})
AddButton(OthersTab, {
    Name = "HB Expand Made by Xlz",
    Callback = function()
        local hitboxEnabled = false
        local hitboxSize = Vector3.new(12, 12, 12)
        local ballSize = Vector3.new(15, 15, 15)
        local function updateHitboxes()
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= game.Players.LocalPlayer and otherPlayer.Character then
                    local hitbox = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hitbox then
                        hitbox.Size = hitboxEnabled and hitboxSize or Vector3.new(2, 2, 1)
                        hitbox.Transparency = hitboxEnabled and 0.5 or 1
                        hitbox.Material = hitboxEnabled and Enum.Material.ForceField or Enum.Material.Plastic
                    end
                end
            end
        end
    end,
    Color = Color3.fromRGB(0, 153, 76)
})
