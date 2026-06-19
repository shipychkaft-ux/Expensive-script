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

-- Создаём окно
local Window = GuiLibrary:CreateWindow()

-- ============================================
-- ЗВУКИ ДЛЯ GUI
-- ============================================
local function PlayGUISound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = 0.5
    sound.Parent = game:GetService("CoreGui")
    sound:Play()
    task.delay(sound.TimeLength or 0.5, function()
        sound:Destroy()
    end)
end

local SOUND_ENABLE = "95856755098572"  -- звук включения
local SOUND_DISABLE = "74014422539208" -- звук выключения

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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopKillAura()
                PlayGUISound(SOUND_DISABLE)
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
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
    end
})

-- AutoClicker
Tabs.Combat:CreateToggle({
    Name = "AutoClicker",
    HoverText = "Automatically clicks for you",
    Callback = function(enabled)
        shared.expensive.AutoClickerEnabled = enabled
        if Universal then Universal.AutoClickerEnabled = enabled end
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
    end
})

-- Reach
Tabs.Combat:CreateToggle({
    Name = "Reach",
    HoverText = "Expands hitboxes of other players",
    Callback = function(enabled)
        shared.expensive.ReachEnabled = enabled
        if Universal then Universal.ReachEnabled = enabled end
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopSpeed()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopInfinityJump()
                PlayGUISound(SOUND_DISABLE)
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
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
    end
})

-- ClickTP
Tabs.Movement:CreateToggle({
    Name = "ClickTP",
    HoverText = "Teleports you to where you click",
    Callback = function(enabled)
        shared.expensive.ClickTPEnabled = enabled
        if Universal then Universal.ClickTPEnabled = enabled end
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
    end
})

-- FastFall
Tabs.Movement:CreateToggle({
    Name = "FastFall",
    HoverText = "Makes you fall faster",
    Callback = function(enabled)
        shared.expensive.FastFallEnabled = enabled
        if Universal then Universal.FastFallEnabled = enabled end
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopFly()
                PlayGUISound(SOUND_DISABLE)
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
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
    end
})

-- LongJump
Tabs.Movement:CreateToggle({
    Name = "LongJump",
    HoverText = "Makes you jump forward",
    Callback = function(enabled)
        shared.expensive.LongJumpEnabled = enabled
        if Universal then Universal.LongJumpEnabled = enabled end
        if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopPhase()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopSpinBot()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                EspLibrary:stop()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopFullbright()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopFOVChanger()
                PlayGUISound(SOUND_DISABLE)
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
            GuiLibrary.APIs.KeyStrokes:toggle()
            if enabled then PlayGUISound(SOUND_ENABLE) else PlayGUISound(SOUND_DISABLE) end
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopNameTags()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopBreadcrumbs()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopChinaHat()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopCrossHair()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopRainbowSkin()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopSnowing()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopSoundPlayer()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopSpawnESP()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopUsernameHider()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopViewClip()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopAntiVoid()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopAtmosphere()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopGravity()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopLighting()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopSky()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopTimeOfDay()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopAntiAFK()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopAntiFling()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopAntiKick()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopAutoRejoin()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopCameraUnlock()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopChatSpammer()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopCustomAnimations()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopConsoleCommands()
                PlayGUISound(SOUND_DISABLE)
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
                PlayGUISound(SOUND_ENABLE)
            else
                Universal:StopFPSUnlocker()
                PlayGUISound(SOUND_DISABLE)
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
            PlayGUISound(SOUND_DISABLE)
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
        PlayGUISound(SOUND_ENABLE)
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- ServerHop
Tabs.Utility:CreateButton({
    Name = "Server Hop",
    Callback = function()
        PlayGUISound(SOUND_ENABLE)
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
            PlayGUISound(SOUND_DISABLE)
            GuiLibrary.CanSaveConfig = false
            for _, table in next, GuiLibrary.ObjectsToSave.Toggles do
                if table.API.Enabled and table.API.Name ~= "Panic" then
                    table.API:Toggle(true)
                end
            end
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
-- ОБРАБОТЧИК ОТКРЫТИЯ GUI (ИСПРАВЛЕННЫЙ)
-- ============================================
local function setupGuiToggle()
    local UIS = game:GetService("UserInputService")
    local guiVisible = true  -- GUI изначально видим
    local screenGui = shared.expensive.ScreenGui
    
    if not screenGui then
        screenGui = GuiLibrary and GuiLibrary.ScreenGui
        if screenGui then
            shared.expensive.ScreenGui = screenGui
        end
    end
    
    -- Убедимся, что GUI видим при старте
    if screenGui then
        screenGui.Enabled = true
    end
    
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            guiVisible = not guiVisible
            
            if guiVisible then
                -- GUI видим, мышка в игре
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
                UIS.MouseIconEnabled = false
                if screenGui then
                    screenGui.Enabled = true
                end
                PlayGUISound(SOUND_ENABLE)
            else
                -- GUI скрыт, мышка свободна
                UIS.MouseBehavior = Enum.MouseBehavior.Default
                UIS.MouseIconEnabled = true
                if screenGui then
                    screenGui.Enabled = false
                end
                PlayGUISound(SOUND_DISABLE)
            end
        end
    end)
end

-- Запускаем обработчик
task.spawn(setupGuiToggle)

-- Сохраняем Tabs
shared.expensive.Tabs = Tabs

print("[expensive-gui.lua]: GUI загружен успешно!")
