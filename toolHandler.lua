local players = game:GetService("Players")
local lplr = players.LocalPlayer
local connection
local connection2
local handler = {
    currentTool = nil,
    started = false
}

local function isAlive(Player, headCheck)
    local Player = Player or lplr
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

local function getCharacter(plr)
    return plr.Character or plr.CharacterAdded:Wait()
end

function handler:tryAgain()
    warn("[toolHandler.lua]: local player is not alive or realcharacter is missing, trying again in 2 seconds.")
    task.delay(2, function() handler:start() end)
end

function handler:start()
    if handler.started then return end -- Защита от спама запусков

    if not shared.expensive or not shared.expensive.PlayersHandler then
        warn("[toolHandler.lua]: PlayersHandler not found, waiting...")
        task.delay(2, function() handler:start() end) -- Асинхронный вызов вместо рекурсии
        return
    end
    
    if (not isAlive() and getCharacter(lplr) == nil) then
        handler:tryAgain()
        return 
    end
    
    local entityHandler = shared.expensive.PlayersHandler
    
    if not entityHandler.realcharacter then
        warn("[toolHandler.lua]: realcharacter is nil, waiting...")
        task.delay(2, function() handler:start() end)
        return
    end
    
    handler.started = true
    if connection then connection:Disconnect() end
    if connection2 then connection2:Disconnect() end

    connection = entityHandler.realcharacter.ChildAdded:Connect(function(Child)
        if Child:IsA("Tool") then
            handler.currentTool = Child
        end
    end)
    
    connection2 = entityHandler.realcharacter.ChildRemoved:Connect(function(Child)
        if Child:IsA("Tool") then
            handler.currentTool = nil
        end
    end)
end

function handler:start()
    -- Проверяем что PlayersHandler загружен (исправлено: PlayersHandler с большой 'P')
    if not shared.expensive or not shared.expensive.PlayersHandler then
        warn("[toolHandler.lua]: PlayersHandler not found, waiting 5 seconds...")
        task.wait(5)
        handler:start()
        return
    end
    
    -- Проверяем что персонаж существует
    if (not isAlive() and getCharacter(lplr) == nil) then
        handler:tryAgain()
        return 
    end
    
    local entityHandler = shared.expensive.PlayersHandler
    
    -- Проверяем что realcharacter существует
    if not entityHandler.realcharacter then
        warn("[toolHandler.lua]: realcharacter is nil, waiting...")
        task.wait(2)
        handler:start()
        return
    end
    
    handler.started = true
    if connection then connection:Disconnect() end
    if connection2 then connection2:Disconnect() end

    connection = entityHandler.realcharacter.ChildAdded:Connect(function(Child)
        if Child:IsA("Tool") then
            handler.currentTool = Child
        end
    end)
    
    connection2 = entityHandler.realcharacter.ChildRemoved:Connect(function(Child)
        if Child:IsA("Tool") then
            handler.currentTool = nil
        end
    end)
end

-- Ждём появления персонажа
task.spawn(function()
    repeat
        task.wait(0.5)
    until lplr.Character and lplr.Character:FindFirstChildOfClass("Humanoid")
    
    if handler.started then
        handler:start()
    end
end)

-- Также запускаем при добавлении персонажа
lplr.CharacterAdded:Connect(function()
    task.wait(1)
    if handler.started then
        handler:start()
    else
        handler:start()
    end
end)

return handler
