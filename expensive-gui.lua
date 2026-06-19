local GuiLibrary = shared.expensive.GuiLibrary
if not GuiLibrary then
    return
end

local Tabs = shared.expensive.Tabs or {}
local Connections = shared.expensive.Connections or {}
local Universal = shared.expensive.Universal
local PlayersHandler = shared.expensive.PlayersHandler
local ToolHandler = shared.expensive.ToolHandler
local EspLibrary = shared.expensive.EspLibrary
local RunLoops = shared.expensive.RunLoops

local Window = GuiLibrary:CreateWindow()

-- ============================================
-- COMBAT TAB
-- ============================================
Tabs.Combat = GuiLibrary:CreateTab({
    Name = "Combat",
    Color = Color3.fromRGB(79, 87, 159)
})

-- KillAura
local killAura = Tabs.Combat:CreateToggle({
    Name = "KillAura",
    HoverText = "Automatically kills nearby players",
    Callback = function(enabled)
        shared.expensive.KillAuraEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartKillAura()
            else
                Universal:StopKillAura()
            end
        end
    end
})

killAura:CreateSlider({
    Name = "Distance",
    Min = 0,
    Max = 15,
    Default = 10,
    Round = 1,
    Callback = function(v)
        shared.expensive.KillAuraDistance = v
        if Universal then Universal.KillAuraDistance = v end
    end
})

killAura:CreateDropdown({
    Name = "Mode",
    List = {"Long", "Short", "Medium"},
    Default = "Long",
    Callback = function(v)
        shared.expensive.KillAuraMode = v
        if Universal then Universal.KillAuraMode = v end
    end
})

-- Aimbot
Tabs.Combat:CreateToggle({
    Name = "Aimbot",
    HoverText = "Automatically aims at players",
    Callback = function(enabled)
        shared.expensive.AimbotEnabled = enabled
        if Universal then Universal.AimbotEnabled = enabled end
    end
})

-- AutoClicker
Tabs.Combat:CreateToggle({
    Name = "AutoClicker",
    HoverText = "Automatically clicks for you",
    Callback = function(enabled)
        shared.expensive.AutoClickerEnabled = enabled
        if Universal then Universal.AutoClickerEnabled = enabled end
    end
})

-- Reach
Tabs.Combat:CreateToggle({
    Name = "Reach",
    HoverText = "Expands hitboxes of other players",
    Callback = function(enabled)
        shared.expensive.ReachEnabled = enabled
        if Universal then Universal.ReachEnabled = enabled end
    end
})

-- ============================================
-- MOVEMENT TAB
-- ============================================
Tabs.Movement = GuiLibrary:CreateTab({
    Name = "Movement",
    Color = Color3.fromRGB(79, 87, 159)
})

-- Speed
local speed = Tabs.Movement:CreateToggle({
    Name = "Speed",
    HoverText = "Makes you faster",
    Callback = function(enabled)
        shared.expensive.SpeedEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartSpeed()
            else
                Universal:StopSpeed()
            end
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
        shared.expensive.SpeedValue = v
        if Universal then Universal.SpeedValue = v end
    end
})

-- Infinity Jump
Tabs.Movement:CreateToggle({
    Name = "Infinity Jump",
    HoverText = "Allows you to jump infinitely",
    Callback = function(enabled)
        shared.expensive.InfinityJumpEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartInfinityJump()
            else
                Universal:StopInfinityJump()
            end
        end
    end
})

-- AutoWalk
Tabs.Movement:CreateToggle({
    Name = "AutoWalk",
    HoverText = "Automatically walks forward",
    Callback = function(enabled)
        shared.expensive.AutoWalkEnabled = enabled
        if Universal then Universal.AutoWalkEnabled = enabled end
    end
})

-- ClickTP
Tabs.Movement:CreateToggle({
    Name = "ClickTP",
    HoverText = "Teleports you to where you click",
    Callback = function(enabled)
        shared.expensive.ClickTPEnabled = enabled
        if Universal then Universal.ClickTPEnabled = enabled end
    end
})

-- FastFall
Tabs.Movement:CreateToggle({
    Name = "FastFall",
    HoverText = "Makes you fall faster",
    Callback = function(enabled)
        shared.expensive.FastFallEnabled = enabled
        if Universal then Universal.FastFallEnabled = enabled end
    end
})

-- Fly
Tabs.Movement:CreateToggle({
    Name = "Fly",
    HoverText = "Makes you fly",
    Callback = function(enabled)
        shared.expensive.FlyEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartFly()
            else
                Universal:StopFly()
            end
        end
    end
})

-- HighJump
Tabs.Movement:CreateToggle({
    Name = "HighJump",
    HoverText = "Makes you jump higher",
    Callback = function(enabled)
        shared.expensive.HighJumpEnabled = enabled
        if Universal then Universal.HighJumpEnabled = enabled end
    end
})

-- LongJump
Tabs.Movement:CreateToggle({
    Name = "LongJump",
    HoverText = "Makes you jump forward",
    Callback = function(enabled)
        shared.expensive.LongJumpEnabled = enabled
        if Universal then Universal.LongJumpEnabled = enabled end
    end
})

-- Phase
Tabs.Movement:CreateToggle({
    Name = "Phase",
    HoverText = "Makes you walk through walls",
    Callback = function(enabled)
        shared.expensive.PhaseEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartPhase()
            else
                Universal:StopPhase()
            end
        end
    end
})

-- SpinBot
Tabs.Movement:CreateToggle({
    Name = "SpinBot",
    HoverText = "Makes your character spin",
    Callback = function(enabled)
        shared.expensive.SpinBotEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartSpinBot()
            else
                Universal:StopSpinBot()
            end
        end
    end
})

-- ============================================
-- RENDER TAB
-- ============================================
Tabs.Render = GuiLibrary:CreateTab({
    Name = "Render",
    Color = Color3.fromRGB(79, 87, 159)
})

-- ESP
local esp = Tabs.Render:CreateToggle({
    Name = "ESP",
    HoverText = "Shows players through walls",
    Callback = function(enabled)
        if EspLibrary then
            if enabled then
                EspLibrary:start()
            else
                EspLibrary:stop()
            end
        end
    end
})

esp:CreateColorSlider({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(v)
        if EspLibrary then EspLibrary.color = v end
    end
})

esp:CreateSlider({
    Name = "ESP Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Round = 1,
    Callback = function(v)
        if EspLibrary then EspLibrary.transparency = v end
    end
})

-- Fullbright
Tabs.Render:CreateToggle({
    Name = "Fullbright",
    HoverText = "Makes everything bright",
    Callback = function(enabled)
        shared.expensive.FullbrightEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartFullbright()
            else
                Universal:StopFullbright()
            end
        end
    end
})

-- FOV Changer
Tabs.Render:CreateToggle({
    Name = "FOV Changer",
    HoverText = "Changes your field of view",
    Callback = function(enabled)
        shared.expensive.FOVChangerEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartFOVChanger()
            else
                Universal:StopFOVChanger()
            end
        end
    end
})

-- KeyStrokes
Tabs.Render:CreateToggle({
    Name = "KeyStrokes",
    HoverText = "Shows which keys you press",
    Callback = function(enabled)
        if GuiLibrary.APIs and GuiLibrary.APIs.KeyStrokes then
            if enabled then
                GuiLibrary.APIs.KeyStrokes:toggle()
            else
                GuiLibrary.APIs.KeyStrokes:toggle()
            end
        end
    end
})

-- NameTags
Tabs.Render:CreateToggle({
    Name = "NameTags",
    HoverText = "Shows nametags above players",
    Callback = function(enabled)
        shared.expensive.NameTagsEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartNameTags()
            else
                Universal:StopNameTags()
            end
        end
    end
})

-- Breadcrumbs
Tabs.Render:CreateToggle({
    Name = "Breadcrumbs",
    HoverText = "Creates a trail behind you",
    Callback = function(enabled)
        shared.expensive.BreadcrumbsEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartBreadcrumbs()
            else
                Universal:StopBreadcrumbs()
            end
        end
    end
})

-- ChinaHat
Tabs.Render:CreateToggle({
    Name = "ChinaHat",
    HoverText = "Puts a china hat on your head",
    Callback = function(enabled)
        shared.expensive.ChinaHatEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartChinaHat()
            else
                Universal:StopChinaHat()
            end
        end
    end
})

-- CrossHair
Tabs.Render:CreateToggle({
    Name = "CustomCrossHair",
    HoverText = "Changes your crosshair",
    Callback = function(enabled)
        shared.expensive.CrossHairEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartCrossHair()
            else
                Universal:StopCrossHair()
            end
        end
    end
})

-- RainbowSkin
Tabs.Render:CreateToggle({
    Name = "RainbowSkin",
    HoverText = "Makes your skin rainbow",
    Callback = function(enabled)
        shared.expensive.RainbowSkinEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartRainbowSkin()
            else
                Universal:StopRainbowSkin()
            end
        end
    end
})

-- Snowing
Tabs.Render:CreateToggle({
    Name = "Snowing",
    HoverText = "Makes it snow in game",
    Callback = function(enabled)
        shared.expensive.SnowingEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartSnowing()
            else
                Universal:StopSnowing()
            end
        end
    end
})

-- SoundPlayer
Tabs.Render:CreateToggle({
    Name = "SoundPlayer",
    HoverText = "Plays music",
    Callback = function(enabled)
        shared.expensive.SoundPlayerEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartSoundPlayer()
            else
                Universal:StopSoundPlayer()
            end
        end
    end
})

-- SpawnESP
Tabs.Render:CreateToggle({
    Name = "SpawnESP",
    HoverText = "Highlights spawn locations",
    Callback = function(enabled)
        shared.expensive.SpawnESPEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartSpawnESP()
            else
                Universal:StopSpawnESP()
            end
        end
    end
})

-- UsernameHider
Tabs.Render:CreateToggle({
    Name = "UsernameHider",
    HoverText = "Hides your username",
    Callback = function(enabled)
        shared.expensive.UsernameHiderEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartUsernameHider()
            else
                Universal:StopUsernameHider()
            end
        end
    end
})

-- ViewClip
Tabs.Render:CreateToggle({
    Name = "ViewClip",
    HoverText = "Makes camera go through objects",
    Callback = function(enabled)
        shared.expensive.ViewClipEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartViewClip()
            else
                Universal:StopViewClip()
            end
        end
    end
})

-- ============================================
-- WORLD TAB
-- ============================================
Tabs.World = GuiLibrary:CreateTab({
    Name = "World",
    Color = Color3.fromRGB(79, 87, 159)
})

-- AntiVoid
Tabs.World:CreateToggle({
    Name = "AntiVoid",
    HoverText = "Prevents falling into void",
    Callback = function(enabled)
        shared.expensive.AntiVoidEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartAntiVoid()
            else
                Universal:StopAntiVoid()
            end
        end
    end
})

-- Atmosphere
Tabs.World:CreateToggle({
    Name = "Atmosphere",
    HoverText = "Customizes atmosphere",
    Callback = function(enabled)
        shared.expensive.AtmosphereEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartAtmosphere()
            else
                Universal:StopAtmosphere()
            end
        end
    end
})

-- Gravity
Tabs.World:CreateToggle({
    Name = "Gravity",
    HoverText = "Changes game gravity",
    Callback = function(enabled)
        shared.expensive.GravityEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartGravity()
            else
                Universal:StopGravity()
            end
        end
    end
})

-- Lighting
Tabs.World:CreateToggle({
    Name = "Lighting",
    HoverText = "Customizes lighting",
    Callback = function(enabled)
        shared.expensive.LightingEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartLighting()
            else
                Universal:StopLighting()
            end
        end
    end
})

-- Sky
Tabs.World:CreateToggle({
    Name = "Sky",
    HoverText = "Customizes sky",
    Callback = function(enabled)
        shared.expensive.SkyEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartSky()
            else
                Universal:StopSky()
            end
        end
    end
})

-- TimeOfDay
Tabs.World:CreateToggle({
    Name = "TimeOfDay",
    HoverText = "Changes time of day",
    Callback = function(enabled)
        shared.expensive.TimeOfDayEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartTimeOfDay()
            else
                Universal:StopTimeOfDay()
            end
        end
    end
})

-- ============================================
-- UTILITY TAB
-- ============================================
Tabs.Utility = GuiLibrary:CreateTab({
    Name = "Utility",
    Color = Color3.fromRGB(79, 87, 159)
})

-- AntiAFK
Tabs.Utility:CreateToggle({
    Name = "AntiAFK",
    HoverText = "Prevents being kicked for idling",
    Callback = function(enabled)
        shared.expensive.AntiAFKEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartAntiAFK()
            else
                Universal:StopAntiAFK()
            end
        end
    end
})

-- AntiFling
Tabs.Utility:CreateToggle({
    Name = "AntiFling",
    HoverText = "Prevents being flung",
    Callback = function(enabled)
        shared.expensive.AntiFlingEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartAntiFling()
            else
                Universal:StopAntiFling()
            end
        end
    end
})

-- AntiKick
Tabs.Utility:CreateToggle({
    Name = "AntiKick",
    HoverText = "Prevents client kicks",
    Callback = function(enabled)
        shared.expensive.AntiKickEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartAntiKick()
            else
                Universal:StopAntiKick()
            end
        end
    end
})

-- AutoRejoin
Tabs.Utility:CreateToggle({
    Name = "AutoRejoin",
    HoverText = "Auto rejoins when kicked",
    Callback = function(enabled)
        shared.expensive.AutoRejoinEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartAutoRejoin()
            else
                Universal:StopAutoRejoin()
            end
        end
    end
})

-- CameraUnlock
Tabs.Utility:CreateToggle({
    Name = "CameraUnlock",
    HoverText = "Unlocks camera zoom",
    Callback = function(enabled)
        shared.expensive.CameraUnlockEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartCameraUnlock()
            else
                Universal:StopCameraUnlock()
            end
        end
    end
})

-- ChatSpammer
Tabs.Utility:CreateToggle({
    Name = "ChatSpammer",
    HoverText = "Automatically sends messages",
    Callback = function(enabled)
        shared.expensive.ChatSpammerEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartChatSpammer()
            else
                Universal:StopChatSpammer()
            end
        end
    end
})

-- CustomAnimations
Tabs.Utility:CreateToggle({
    Name = "CustomAnimations",
    HoverText = "Customizes your animations",
    Callback = function(enabled)
        shared.expensive.CustomAnimationsEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartCustomAnimations()
            else
                Universal:StopCustomAnimations()
            end
        end
    end
})

-- ConsoleCommands
Tabs.Utility:CreateToggle({
    Name = "ConsoleCommands",
    HoverText = "Creates command bar in dev console",
    Callback = function(enabled)
        shared.expensive.ConsoleCommandsEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartConsoleCommands()
            else
                Universal:StopConsoleCommands()
            end
        end
    end
})

-- FPSUnlocker
Tabs.Utility:CreateToggle({
    Name = "FPSUnlocker",
    HoverText = "Unlocks your FPS",
    Callback = function(enabled)
        shared.expensive.FPSUnlockerEnabled = enabled
        if Universal then
            if enabled then
                Universal:StartFPSUnlocker()
            else
                Universal:StopFPSUnlocker()
            end
        end
    end
})

-- Reset
Tabs.Utility:CreateToggle({
    Name = "Reset",
    HoverText = "Resets your character",
    Callback = function(enabled)
        if enabled then
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                plr.Character.Humanoid.Health = 0
            end
            -- Автоматически выключаем тоггл
            task.wait(0.1)
            for _, table in next, GuiLibrary.ObjectsToSave.Toggles do
                if table.API.Name == "Reset" then
                    table.API:Toggle(true)
                end
            end
        end
    end
})

-- Rejoin
Tabs.Utility:CreateButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- ServerHop
Tabs.Utility:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId)
    end
})

-- Panic
Tabs.Utility:CreateToggle({
    Name = "Panic",
    HoverText = "Disables all toggles",
    Callback = function(enabled)
        if enabled then
            GuiLibrary.CanSaveConfig = false
            for _, table in next, GuiLibrary.ObjectsToSave.Toggles do
                if table.API.Enabled and table.API.Name ~= "Panic" then
                    table.API:Toggle(true)
                end
            end
            -- Автоматически выключаем Panic
            task.wait(0.1)
            for _, table in next, GuiLibrary.ObjectsToSave.Toggles do
                if table.API.Name == "Panic" then
                    table.API:Toggle(true)
                end
            end
        end
    end
})

-- ============================================
-- ОБРАБОТЧИК ОТКРЫТИЯ GUI (ПОКАЗ МЫШКИ)
-- ============================================
local function handleGuiOpen()
    local UIS = game:GetService("UserInputService")
    local state = false
    local screenGui = shared.expensive.ScreenGui
    
    -- Если ScreenGui нет, ищем его
    if not screenGui then
        screenGui = GuiLibrary and GuiLibrary.ScreenGui
        if screenGui then
            shared.expensive.ScreenGui = screenGui
        end
    end
    
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            state = not state
            if state then
                -- Показываем мышку
                UIS.MouseBehavior = Enum.MouseBehavior.Default
                UIS.MouseIconEnabled = true
                
                -- Скрываем GUI
                if screenGui then
                    screenGui.Enabled = false
                end
            else
                -- Скрываем мышку (возвращаем в игру)
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
                UIS.MouseIconEnabled = false
                
                -- Показываем GUI
                if screenGui then
                    screenGui.Enabled = true
                end
            end
        end
    end)
end

task.spawn(handleGuiOpen)

-- Сохраняем Tabs
shared.expensive.Tabs = Tabs

