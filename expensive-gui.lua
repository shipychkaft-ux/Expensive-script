local GuiLibrary = shared.expensive.GuiLibrary
if not GuiLibrary then
    return
end

local Tabs = shared.expensive.Tabs or {}
local Connections = shared.expensive.Connections or {}

local Window = GuiLibrary:CreateWindow()

Tabs.Combat = GuiLibrary:CreateTab({
    Name = "Combat",
    Color = Color3.fromRGB(79, 87, 159)
})

local killAura = Tabs.Combat:CreateToggle({
    Name = "KillAura",
    HoverText = "Automatically kills nearby players",
    Callback = function(enabled) end
})

killAura:CreateSlider({
    Name = "Distance",
    Min = 0,
    Max = 15,
    Default = 10,
    Round = 1,
    Callback = function(v) end
})

killAura:CreateDropdown({
    Name = "Mode",
    List = {"Long", "Short", "Medium"},
    Default = "Long",
    Callback = function(v) end
})

Tabs.Combat:CreateToggle({
    Name = "Aimbot",
    HoverText = "Automatically aims at players",
    Callback = function(enabled) end
})

Tabs.Movement = GuiLibrary:CreateTab({
    Name = "Movement",
    Color = Color3.fromRGB(79, 87, 159)
})

local speed = Tabs.Movement:CreateToggle({
    Name = "Speed",
    HoverText = "Makes you faster",
    Callback = function(enabled)
        if enabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

speed:CreateSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 200,
    Default = 50,
    Round = 0,
    Callback = function(v)
        if speed.Enabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

Tabs.Movement:CreateToggle({
    Name = "Infinity Jump",
    HoverText = "Allows you to jump infinitely",
    Callback = function(enabled)
        local plr = game.Players.LocalPlayer
        if enabled then
            _G.infinjump = true
            local m = plr:GetMouse()
            m.KeyDown:Connect(function(k)
                if _G.infinjump and k:byte() == 32 then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState("Jumping")
                        task.wait()
                        humanoid:ChangeState("Seated")
                    end
                end
            end)
        else
            _G.infinjump = false
        end
    end
})

Tabs.Render = GuiLibrary:CreateTab({
    Name = "Render",
    Color = Color3.fromRGB(79, 87, 159)
})

local esp = Tabs.Render:CreateToggle({
    Name = "ESP",
    HoverText = "Shows players through walls",
    Callback = function(enabled) end
})

esp:CreateColorSlider({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(v) end
})

esp:CreateSlider({
    Name = "ESP Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Round = 1,
    Callback = function(v) end
})

Tabs.Render:CreateToggle({
    Name = "Fullbright",
    HoverText = "Makes everything bright",
    Callback = function(enabled)
        local Lighting = game:GetService("Lighting")
        if enabled then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end
})

Tabs.Render:CreateToggle({
    Name = "FOV Changer",
    HoverText = "Changes your field of view",
    Callback = function(enabled)
        local Camera = workspace.CurrentCamera
        if enabled then
            Camera.FieldOfView = 120
        else
            Camera.FieldOfView = 70
        end
    end
})

Tabs.Utility = GuiLibrary:CreateTab({
    Name = "Utility",
    Color = Color3.fromRGB(79, 87, 159)
})

Tabs.Utility:CreateToggle({
    Name = "AntiAFK",
    HoverText = "Prevents you from being kicked for idling",
    Callback = function(enabled)
        local VirtualUser = game:GetService("VirtualUser")
        if enabled then
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

Tabs.Utility:CreateToggle({
    Name = "NoFallDamage",
    HoverText = "Removes fall damage",
    Callback = function(enabled) end
})

Tabs.Utility:CreateButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

Tabs.Utility:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId)
    end
})

Tabs.Utility:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end
})

shared.expensive.Tabs = Tabs
