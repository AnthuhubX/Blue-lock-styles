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
    ["Min85500"] = true,
    ["Lynwooo"] = true,
    ["Ramo_akh1"] = true,
    ["Soulshubfan"] = true,
    ["Nugifihack"] = true,
    ["mason72219"] = true,
    ["Mason722919292"] = true, 
    ["Nicholadthegoat"] = true
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
    Image = "rbxassetid://14389031238"
})
AddParagraph(Main, {"More Games Getting Supported Soon"})

local ScriptsTab = MakeTab({Name = "Scripts"})

AddButton(ScriptsTab, {
    Name = "Ball control",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nocturnal631/Main/refs/heads/main/Control%20ball%20script"))()
    end,
    Color = Color3.fromRGB(0, 102, 255)
})

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

local CustomStylesTab = MakeTab({Name = "Custom Styles Premium"})

AddButton(CustomStylesTab, {
    Name = "Undertaker style",
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
    Name = "Charizard style🔥",
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

AddButton(CustomStylesTab, {
    Name = "Douma style",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Blue-lock-styles/refs/heads/main/Douma"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})

AddButton(CustomStylesTab, {
    Name = "Goku style (key: SONGOKU)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/stylemakeritosh/Ace/refs/heads/main/GoatKu"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})

AddButton(CustomStylesTab, {
    Name = "Echo style",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthuhubX/Blue-lock-styles/refs/heads/main/Echo%20style.lua"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})

AddButton(CustomStylesTab, {
    Name = "Jinwoo style (key: KINGOFHUMANS)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/stylemakeritosh/Ace/refs/heads/main/Jinwoo"))()
    end,
    Color = Color3.fromRGB(0, 255, 255)
})
