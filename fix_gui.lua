-- fix_gui.lua - Исправление GUI
-- Выполнить этот скрипт ПЕРВЫМ!

print("[fix_gui.lua]: Исправление GUI...")

-- 1. Отключаем все обработчики из expensiv_3_1.lua
local function disableOldHandlers()
    -- Ищем и отключаем скрипты open и destroyer из старого GUI
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "expa" then
            -- Отключаем все LocalScript внутри
            for _, script in pairs(gui:GetDescendants()) do
                if script:IsA("LocalScript") and (script.Name == "open" or script.Name == "destroyer" or script.Name == "drag") then
                    script.Disabled = true
                    print("[fix_gui.lua]: Отключен скрипт:", script.Name)
                end
            end
        end
    end
end

-- 2. Создаем правильный обработчик для GUI
local function createProperGuiHandler()
    local UIS = game:GetService("UserInputService")
    local guiVisible = true
    local screenGui = shared.expensive and shared.expensive.ScreenGui
    
    -- Если ScreenGui не найден, ищем его
    if not screenGui then
        local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui.Name == "expa" then
                screenGui = gui
                if shared.expensive then
                    shared.expensive.ScreenGui = gui
                end
                break
            end
        end
    end
    
    -- Если все еще не найден, создаем новый ScreenGui
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ExpensiveGUI"
        screenGui.Parent = game:GetService("CoreGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        if shared.expensive then
            shared.expensive.ScreenGui = screenGui
        end
        print("[fix_gui.lua]: Создан новый ScreenGui")
    end
    
    -- Убеждаемся, что GUI видим
    screenGui.Enabled = true
    
    -- Обработчик клавиши RightShift
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
            guiVisible = not guiVisible
            
            if guiVisible then
                -- Показываем GUI, скрываем мышку
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
                UIS.MouseIconEnabled = false
                screenGui.Enabled = true
                
                -- Звук включения
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://95856755098572"
                sound.Volume = 0.5
                sound.Parent = screenGui
                sound:Play()
                task.delay(0.5, function() sound:Destroy() end)
            else
                -- Скрываем GUI, показываем мышку
                UIS.MouseBehavior = Enum.MouseBehavior.Default
                UIS.MouseIconEnabled = true
                screenGui.Enabled = false
                
                -- Звук выключения
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://74014422539208"
                sound.Volume = 0.5
                sound.Parent = screenGui
                sound:Play()
                task.delay(0.5, function() sound:Destroy() end)
            end
        end
    end)
    
    print("[fix_gui.lua]: Обработчик GUI установлен")
    return screenGui
end

-- 3. Выполняем исправления
task.spawn(function()
    -- Ждем загрузки игрока
    repeat task.wait(0.1) until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    
    -- Отключаем старые обработчики
    disableOldHandlers()
    
    -- Создаем новый обработчик
    local screenGui = createProperGuiHandler()
    
    -- Показываем уведомление
    if shared.expensive and shared.expensive.GuiLibrary then
        task.wait(0.5)
        shared.expensive.GuiLibrary:CreateNotification(
            "GUI Fixed",
            "Press RightShift to toggle GUI",
            3,
            "Info"
        )
    end
    
    print("[fix_gui.lua]: Исправление GUI завершено!")
end)

return true
