-- fix_gui.lua - ПОЛНОЕ исправление GUI
print("[fix_gui.lua]: Запуск исправления GUI...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- 1. ПОЛНОСТЬЮ УДАЛЯЕМ СТАРЫЙ GUI
-- ============================================
local function removeOldGUI()
    -- Удаляем из PlayerGui
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name == "expa" or gui.Name == "Expensive" then
                gui:Destroy()
                print("[fix_gui.lua]: Удален старый GUI из PlayerGui:", gui.Name)
            end
        end
    end
    
    -- Удаляем из CoreGui
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "expa" or gui.Name == "Expensive" or gui.Name == "ExpensiveGUI" then
            gui:Destroy()
            print("[fix_gui.lua]: Удален старый GUI из CoreGui:", gui.Name)
        end
    end
end

-- ============================================
-- 2. СОЗДАЕМ НОВЫЙ SCREENGUI
-- ============================================
local function createNewGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExpensiveGUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    
    -- Сохраняем в shared
    if shared.expensive then
        shared.expensive.ScreenGui = screenGui
    end
    
    print("[fix_gui.lua]: Создан новый ScreenGui")
    return screenGui
end

-- ============================================
-- 3. ОБРАБОТЧИК КЛАВИШИ RIGHT SHIFT
-- ============================================
local function setupKeyHandler(screenGui)
    local guiVisible = true
    
    -- Убеждаемся, что GUI видим
    screenGui.Enabled = true
    
    -- Функция для воспроизведения звука
    local function playSound(soundId)
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = screenGui
        sound:Play()
        task.delay(0.5, function() 
            if sound and sound.Parent then
                sound:Destroy() 
            end
        end)
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
            guiVisible = not guiVisible
            
            if guiVisible then
                -- Показываем GUI, скрываем мышку
                screenGui.Enabled = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                UserInputService.MouseIconEnabled = false
                playSound("95856755098572") -- звук включения
                print("[fix_gui.lua]: GUI показан")
            else
                -- Скрываем GUI, показываем мышку
                screenGui.Enabled = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
                playSound("74014422539208") -- звук выключения
                print("[fix_gui.lua]: GUI скрыт")
            end
        end
    end)
    
    print("[fix_gui.lua]: Обработчик клавиш установлен")
end

-- ============================================
-- 4. ПЕРЕМЕЩАЕМ ВСЕ ЭЛЕМЕНТЫ ИЗ СТАРОГО GUI В НОВЫЙ
-- ============================================
local function migrateOldElements(newScreenGui)
    -- Ищем старый GUI в PlayerGui
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name == "expa" or gui.Name == "Expensive" then
                -- Переносим все элементы в новый GUI
                for _, child in pairs(gui:GetChildren()) do
                    child.Parent = newScreenGui
                end
                -- Удаляем пустой старый GUI
                gui:Destroy()
                print("[fix_gui.lua]: Элементы перенесены из старого GUI")
                break
            end
        end
    end
end

-- ============================================
-- 5. ВЫПОЛНЕНИЕ
-- ============================================
task.spawn(function()
    -- Ждем загрузки игрока
    repeat task.wait(0.1) until LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    
    -- Удаляем старый GUI
    removeOldGUI()
    
    -- Создаем новый
    local screenGui = createNewGUI()
    
    -- Настраиваем обработчик клавиш
    setupKeyHandler(screenGui)
    
    -- Даем время на загрузку других модулей
    task.wait(0.5)
    
    -- Если GuiLibrary загружен, создаем уведомление
    if shared.expensive and shared.expensive.GuiLibrary then
        shared.expensive.GuiLibrary:CreateNotification(
            "GUI Fixed",
            "Press RightShift to toggle GUI",
            3,
            "Info"
        )
    end
    
    print("[fix_gui.lua]: GUI полностью исправлен!")
end)

-- Экспортируем функцию для доступа из других скриптов
return {
    ScreenGui = shared.expensive and shared.expensive.ScreenGui
}
