local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local GITHUB_USERNAME = "shipychkaft-ux"
local REPO_NAME = "Expensive-script"
local BRANCH = "main"

local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_USERNAME .. "/" .. REPO_NAME .. "/refs/heads/" .. BRANCH .. "/"

-- Создаём папки для конфигов
local function createFolders()
    local folders = {
        "expensive",
        "expensive/Config",
        "expensive/Assets",
        "expensive/Scripts"
    }
    for _, folder in ipairs(folders) do
        if not isfolder(folder) then
            pcall(makefolder, folder)
        end
    end
end
createFolders()

-- Инициализация shared.expensive
shared.expensive = shared.expensive or {
    Loaded = false,
    Connections = {},
    Tabs = {},
    Functions = {},
    Friends = {},
    Developer = false,
    StartTick = tick(),
    NotificationsEnabled = true,
    
    -- Состояния функций
    KillAuraEnabled = false,
    KillAuraDistance = 10,
    KillAuraMode = "Long",
    AimbotEnabled = false,
    AutoClickerEnabled = false,
    ReachEnabled = false,
    
    SpeedEnabled = false,
    SpeedValue = 50,
    InfinityJumpEnabled = false,
    AutoWalkEnabled = false,
    ClickTPEnabled = false,
    FastFallEnabled = false,
    FlyEnabled = false,
    HighJumpEnabled = false,
    LongJumpEnabled = false,
    PhaseEnabled = false,
    SpinBotEnabled = false,
    
    FullbrightEnabled = false,
    FOVChangerEnabled = false,
    NameTagsEnabled = false,
    BreadcrumbsEnabled = false,
    ChinaHatEnabled = false,
    CrossHairEnabled = false,
    RainbowSkinEnabled = false,
    SnowingEnabled = false,
    SoundPlayerEnabled = false,
    SpawnESPEnabled = false,
    UsernameHiderEnabled = false,
    ViewClipEnabled = false,
    
    AntiVoidEnabled = false,
    AtmosphereEnabled = false,
    GravityEnabled = false,
    LightingEnabled = false,
    SkyEnabled = false,
    TimeOfDayEnabled = false,
    
    AntiAFKEnabled = false,
    AntiFlingEnabled = false,
    AntiKickEnabled = false,
    AutoRejoinEnabled = false,
    CameraUnlockEnabled = false,
    ChatSpammerEnabled = false,
    CustomAnimationsEnabled = false,
    ConsoleCommandsEnabled = false,
    FPSUnlockerEnabled = false,
    
    RunLoops = {
        _bindings = {},
        _steppedBindings = {},
        
        BindToHeartbeat = function(self, name, func)
            if self._bindings[name] then
                self._bindings[name]:Disconnect()
            end
            self._bindings[name] = RunService.Heartbeat:Connect(func)
        end,
        
        UnbindFromHeartbeat = function(self, name)
            if self._bindings[name] then
                self._bindings[name]:Disconnect()
                self._bindings[name] = nil
            end
        end,
        
        BindToRenderStep = function(self, name, priority, func)
            RunService:BindToRenderStep(name, priority or 0, func)
        end,
        
        UnbindFromRenderStep = function(self, name)
            RunService:UnbindFromRenderStep(name)
        end,
        
        BindToStepped = function(self, name, func)
            if self._steppedBindings[name] then
                self._steppedBindings[name]:Disconnect()
            end
            self._steppedBindings[name] = RunService.Stepped:Connect(func)
        end,
        
        UnbindFromStepped = function(self, name)
            if self._steppedBindings[name] then
                self._steppedBindings[name]:Disconnect()
                self._steppedBindings[name] = nil
            end
        end
    },
    
    ObjectsToSave = {
        Tabs = {},
        Toggles = {},
        Options = {}
    }
}

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

local function loadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua"
    
    local success, result = pcall(function()
        local code = game:HttpGet(url)
        return loadstring(code)()
    end)
    
    if success and result then
        return result
    end
    return nil
end

-- Загружаем модули в правильном порядке
print("[Main.lua]: Загрузка модулей...")

-- 1. GuiLibrary
local GuiLibrary = loadModule("GuiLibrary")
if GuiLibrary then
    shared.expensive.GuiLibrary = GuiLibrary
    print("[Main.lua]: GuiLibrary загружен")
else
    warn("[Main.lua]: Ошибка загрузки GuiLibrary")
    return
end

-- 2. espLibrary
local espLibrary = loadModule("espLibrary")
if espLibrary then
    shared.expensive.EspLibrary = espLibrary
    print("[Main.lua]: EspLibrary загружен")
end

local playersHandler = loadModule("playerHandler")  -- без 's'
if playersHandler then
    shared.expensive.PlayersHandler = playersHandler  -- с 's' для совместимости
    print("[Main.lua]: PlayersHandler загружен")
end

-- 4. toolHandler
local toolHandler = loadModule("toolHandler")
if toolHandler then
    shared.expensive.ToolHandler = toolHandler
    print("[Main.lua]: ToolHandler загружен")
end

-- 5. Universal (основные функции)
local Universal = loadModule("Universal")
if Universal then
    shared.expensive.Universal = Universal
    print("[Main.lua]: Universal загружен")
end

-- Запускаем обработчики
if playersHandler then
    pcall(function() playersHandler:start() end)
end

if toolHandler then
    pcall(function() toolHandler:start() end)
end

-- 6. expensive-gui (интерфейс)
local expensiveGui = loadModule("expensive-gui")
if expensiveGui then
    print("[Main.lua]: expensive-gui загружен")
end

shared.expensive.Loaded = true

print("[Main.lua]: Все модули загружены!")

-- Уведомление о загрузке
task.spawn(function()
    task.wait(1)
    if GuiLibrary and GuiLibrary.CreateNotification then
        GuiLibrary:CreateNotification(
            "Expensive Script",
            "Loaded successfully! Press RightShift to open GUI.",
            5,
            "Info"
        )
    end
end)

return true
