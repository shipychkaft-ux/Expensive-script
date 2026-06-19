--[[
    cool esp Library
    made this in order to optimize and evade copying and pasting the same code in game supports

    Fixed & Optimized
]]
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local library = {}

local function isAlive(plr, headCheck)
    local Player = plr or localPlayer
    if Player and Player.Character and (Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    end
    return false
end

local function getCharacter(plr)
    return plr.Character or plr.CharacterAdded:Wait()
end

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

function library:create(name, oneObject, custom)
    local connections = {}
    local api = {
        name = name,
        enabled = false,
        mode = "Highlight",
        color = Color3.fromRGB(255, 255, 255),
        adorneePart = "HumanoidRootPart",
        boxHandleAlwaysOnTop = true,
        highlightAlwaysOnTop = true,
        outline = true,
        outlineMode = "Custom",
        outlineColor = Color3.fromRGB(255, 255, 255),
        outlineTransparency = 0,
        fill = false,
        fillMode = "Custom",
        fillColor = Color3.fromRGB(255, 255, 255),
        fillTransparency = 0,
        transparency = 0,
        useTeamColor = false,
        teammates = false,
        modesList = {
            "BoxHandleAdornment",
            "Highlight"
        },
        objectNames = {
            "BoxHandleAdornmentObject",
            "HighlightObject"
        }
    }

    function api:removeEspObject(plr, obj)
        local character
        if custom then
            character = obj
        else
            character = plr and plr.Character
        end
        if not character then return end
        for _, objName in ipairs(api.objectNames) do
            local espObj = character:FindFirstChild(api.name..objName)
            if espObj then
                espObj:Destroy()
            end
        end
    end

    function api:removeAllEspObjects()
        for _, plr in next, players:GetPlayers() do
            api:removeEspObject(plr)
        end
    end

    function api:updateEspObject(plr, obj)
        local adorneePart, character, color
        if custom then
            adorneePart = obj
            character = obj
        else
            if plr == localPlayer then return end
            character = plr.Character
            if not character then return end

            color = (api.useTeamColor and plr.Team and plr.TeamColor.Color) or api.color
            adorneePart = ((api.adorneePart == "Character" or obj == character) and character) or (api.adorneePart == "HRP" and character:FindFirstChild("HumanoidRootPart")) or (obj and character:FindFirstChild(obj.Name)) or character:FindFirstChild(api.adorneePart)
        end

        if not adorneePart then return end

        if api.mode == "BoxHandleAdornment" then
            local object
            if oneObject then
                object = character:FindFirstChild(api.name.."BoxHandleAdornmentObject")
            end
            if not object then
                object = Instance.new("BoxHandleAdornment")
                object.Name = api.name.."BoxHandleAdornmentObject"
                object.Parent = character
            end

            if object.Adornee ~= adorneePart then
                object.Adornee = adorneePart
            end

            object.Size = ((api.adorneePart == "Full Character" or adorneePart:IsA("Model")) and adorneePart:GetExtentsSize()) or adorneePart.Size
            object.AlwaysOnTop = api.boxHandleAlwaysOnTop
            object.Color3 = color
            object.Transparency = api.transparency
        elseif api.mode == "Highlight" then
            local object
            if oneObject then
                object = character:FindFirstChild(api.name.."HighlightObject")
            end
            if not object then
                object = Instance.new("Highlight")
                object.Name = api.name.."HighlightObject"
                object.Parent = character
            end

            object.Adornee = adorneePart or character
            object.OutlineColor = (api.useTeamColor and plr.Team and plr.TeamColor.Color) or api.outlineColor
            object.OutlineTransparency = api.outline and api.outlineTransparency or 1
            object.FillColor = (api.useTeamColor and plr.Team and plr.TeamColor.Color) or api.fillColor
            object.FillTransparency = api.fill and api.fillTransparency or 1
            object.DepthMode = api.highlightAlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        end
    end

    function api:updateAll()
        for _, plr in next, players:GetPlayers() do
            if isAlive(plr) then
                api:updateEspObject(plr)
            end
        end
    end

    -- Вспомогательная функция для регистрации игрока (исправляет баг захода новых игроков)
    local function setupPlayer(plr)
        if plr == localPlayer then return end
        
        -- Обновляем ESP, если у него уже есть персонаж
        if isAlive(plr) then
            api:updateEspObject(plr)
        end
        
        -- Подключаем отслеживание респавна персонажа
        local chAdded = plr.CharacterAdded:Connect(function()
            task.wait(0.1) -- Небольшая задержка, чтобы части тела успели загрузиться
            if api.enabled then
                api:updateEspObject(plr)
            end
        end)
        table.insert(connections, chAdded)
    end

    function api:start()
        api.enabled = true
        -- Настраиваем всех текущих игроков на сервере
        for _, plr in next, players:GetPlayers() do
            setupPlayer(plr)
        end
        
        -- Исправлено: теперь новые игроки корректно получают слушатель CharacterAdded
        local pAdded = players.PlayerAdded:Connect(function(plr)
            setupPlayer(plr)
        end)
        table.insert(connections, pAdded)
    end

    function api:stop()
        api.enabled = false
        for _, connection in next, connections do
            betterDisconnect(connection)
        end
        table.clear(connections)
        api:removeAllEspObjects()
    end

    return api
end

return library
