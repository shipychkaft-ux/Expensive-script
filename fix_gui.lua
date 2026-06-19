-- fix_gui.lua - ПОЛНОСТЬЮ ОТКЛЮЧАЕМ СТАРЫЙ GUI И СОЗДАЕМ НОВЫЙ
print("[fix_gui.lua]: Запуск...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- 1. ПОЛНОСТЬЮ УДАЛЯЕМ ВСЕ GUI
-- ============================================
local function nukeAllGUI()
    -- Удаляем из PlayerGui
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui:Destroy()
                print("[fix_gui.lua]: Удален ScreenGui из PlayerGui:", gui.Name)
            end
        end
    end
    
    -- Удаляем из CoreGui
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "RobloxGui" then
            gui:Destroy()
            print("[fix_gui.lua]: Удален ScreenGui из CoreGui:", gui.Name)
        end
    end
end

-- ============================================
-- 2. СОЗДАЕМ НОВЫЙ GUI
-- ============================================
local function createFreshGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExpensiveGUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Enabled = true  -- ВКЛЮЧАЕМ СРАЗУ!
    
    if shared.expensive then
        shared.expensive.ScreenGui = screenGui
    end
    
    print("[fix_gui.lua]: Создан новый ScreenGui")
    return screenGui
end

-- ============================================
-- 3. ОБРАБОТЧИК RIGHT SHIFT
-- ============================================
local function setupHandler(screenGui)
    local isVisible = true
    
    -- Звуки
    local function playSound(id)
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = 0.3
        s.Parent = screenGui
        s:Play()
        task.delay(0.5, function() s:Destroy() end)
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
            isVisible = not isVisible
            
            if isVisible then
                screenGui.Enabled = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                UserInputService.MouseIconEnabled = false
                playSound("95856755098572") -- включение
                print("[fix_gui.lua]: GUI показан")
            else
                screenGui.Enabled = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
                playSound("74014422539208") -- выключение
                print("[fix_gui.lua]: GUI скрыт")
            end
        end
    end)
    
    print("[fix_gui.lua]: Обработчик установлен")
end

-- ============================================
-- 4. ЗАПУСК
-- ============================================
task.spawn(function()
    -- Ждем загрузки
    repeat task.wait(0.1) until LocalPlayer
    
    -- Удаляем все старые GUI
    nukeAllGUI()
    
    -- Создаем новый
    local screenGui = createFreshGUI()
    
    -- Настраиваем обработчик
    setupHandler(screenGui)
    
    print("[fix_gui.lua]: ГОТОВО! Нажми RightShift для открытия GUI")
end)

return true
