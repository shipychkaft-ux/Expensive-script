local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local GITHUB_USERNAME = "shipychkaft-ux"
local REPO_NAME = "expensive-script"

local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_USERNAME .. "/" .. REPO_NAME .. "/main/"

shared.expensive = shared.expensive or {
    Loaded = false,
    Connections = {},
    Tabs = {},
    Functions = {},
    Friends = {},
    Developer = false,
    StartTick = tick(),
    
    RunLoops = {
        _bindings = {},
        _renderBindings = {},
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
    
    Device = "PC",
    Scale = 1,
    MobileScale = 0.45,
    Sounds = true,
    SoundsVolume = 1,
    GuiKeybind = "RightShift",
    Toggled = false,
    NotificationsMode = "Built-in",
    SliderRightClick = false,
    SliderCanOverride = false,
    uiCornersRadius = 0,
    hoverText = {
        Enabled = true,
        Position = "Above mouse"
    },
    Objects = {},
    APIs = {},
    pinnedobjects = {},
    rainbowObjects = {},
    ColorBox = Color3.fromRGB(170, 0, 170),
    ScreenGui = nil,
    ClickGui = nil,
    keyStrokesGui = nil,
    hoverTextGui = nil,
    SearchFrame = nil,
    UIScale = nil,
    TabsFrame = nil,
    Notifications = true,
    ConfigLoaded = false,
    CanLoadConfig = false,
    CanSaveConfig = true,
    autoSaveDelay = 5,
    
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

local function spawn(func)
    return coroutine.wrap(func)()
end

local function runFunction(func)
    return func()
end

local loadedModules = {}
local failedModules = {}

local function loadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua"
    
    local success, result = pcall(function()
        local code = game:HttpGet(url)
        return loadstring(code)()
    end)
    
    if success and result then
        loadedModules[moduleName] = result
        return result
    else
        failedModules[moduleName] = result
        return nil
    end
end

local GuiLibrary = loadModule("GuiLibrary")
if GuiLibrary then
    shared.expensive.GuiLibrary = GuiLibrary
    GuiLibrary:CreateWindow()
end

local espLibrary = loadModule("espLibrary")
if espLibrary then
    shared.expensive.EspLibrary = espLibrary
end

local playersHandler = loadModule("playersHandler")
if playersHandler then
    shared.expensive.PlayersHandler = playersHandler
end

local toolHandler = loadModule("toolHandler")
if toolHandler then
    shared.expensive.ToolHandler = toolHandler
end

local Universal = loadModule("Universal")
if Universal then
    shared.expensive.Universal = Universal
end

local MM2Module = loadModule("142823291")
if MM2Module then
    shared.expensive.MM2Module = MM2Module
end

if playersHandler then
    playersHandler:start()
end

if toolHandler then
    toolHandler:start()
end

shared.expensive.Loaded = true

task.wait(0.5)

if GuiLibrary and GuiLibrary.LoadConfig then
    GuiLibrary:LoadConfig()
end
