--[[
    Credits to anyones code i used or looked at
    Made by Maanaaaa and Wowzers
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ✅ БЕЗОПАСНОЕ ОЖИДАНИЕ ПЕРСОНАЖА ПЕРЕД ИНИЦИАЛИЗАЦИЕЙ ПЕРЕМЕННЫХ
repeat task.wait(0.1) 
until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local teleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local NetworkClient = game:GetService("NetworkClient")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local virtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local debris = game:GetService("Debris")

local localPlayer = Players.LocalPlayer
local lplr = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local workspace = workspace
local Workspace = workspace
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local Backpack = LocalPlayer.Backpack
local Animate = LocalPlayer.Character:FindFirstChild("Animate")
local LightingTime = Lighting.TimeOfDay
local workspaceGravity = workspace.Gravity
local PlayerWalkSpeed = Humanoid.WalkSpeed
local PlayerJumpPower = Humanoid.JumpPower
local PlayerHipHeight = Humanoid.HipHeight
local OldCameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
local PlaceId = game.PlaceId
local JobId = game.JobId
local CurrentTool = nil
local allplayers = {}

-- ✅ ИСПРАВЛЕНО: shared.Mana → shared.expensive
local Mana = shared.expensive
local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions
local RunLoops = Mana.RunLoops
local connections = Mana.Connections
local friends = Mana.Friends
local playersHandler = Mana.PlayersHandler
local toolHandler = Mana.ToolHandler
local espLibrary = Mana.EspLibrary

-- ✅ ИСПРАВЛЕНО: проверка на nil
local guifont = GuiLibrary and GuiLibrary.Font or Enum.Font.Arial
Mana.StartTick = startTick

playersHandler:start()
toolHandler:start()
CurrentTool = toolHandler.currentTool

local getasset = getcustomasset
local function runFunction(func) func() end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

local requestfunc = http and http.request or http_request or request or function(tab)
    if tab.Method == "GET" then
        return {
            Body = game:HttpGet(tab.Url, true),
            Headers = {},
            StatusCode = 200
        }
    else
        return {
            Body = "bad exploit",
            Headers = {},
            StatusCode = 404
        }
    end
end 

local betterisfile = function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil
end

local cachedassets = {}
local function GetCustomAsset(path)
    if Mana.Developer then
        return getasset("NewMana/" .. path)
    else
        if not betterisfile(path) then
            spawn(function()
                local textlabel = Instance.new("TextLabel")
                textlabel.Size = UDim2.new(1, 0, 0, 36)
                textlabel.Text = "Downloading "..path
                textlabel.BackgroundTransparency = 1
                textlabel.TextStrokeTransparency = 0
                textlabel.TextSize = 30
                textlabel.Font = GuiLibrary.Font
                textlabel.TextColor3 = Color3.new(1, 1, 1)
                textlabel.Position = UDim2.new(0, 0, 0, -36)
                textlabel.Parent = GuiLibrary.ScreenGui
                repeat wait() until betterisfile(path)
                textlabel:Remove()
            end)
            local req = requestfunc({
                Url = "https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. path:gsub("Mana/Assets", "Assets"),
                Method = "GET"
            })
            writefile(path, req.Body)
        end
        if cachedassets[path] == nil then
            cachedassets[path] = getasset(path) 
        end
        return cachedassets[path]
    end
end

local function CreateCoreNotification(title, text, duration)
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration,
	})
end

-- Players handler part
local function isAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

local function TargetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isPlayerTargetable(plr, target)
    return plr ~= LocalPlayer and plr and isAlive(plr) and TargetCheck(plr, target)
end

local function getClosestPlayer(MaxDisance, TeamCheck)
	local MaximumDistance = MaxDisance
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if TeamCheck then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end

	return Target
end

local function GetColorFromPlayer(Player) 
    if Player.Team ~= nil then return Player.TeamColor.Color end
end

local function ConvertHealthToColor(Health, MaxHealth)
    if type(Health) ~= "number" or type(MaxHealth) ~= "number" then
        return Color3.fromRGB(255, 255, 255)
    end
    
    if MaxHealth <= 0 then
        return Color3.fromRGB(255, 0, 0)
    end
    
    if Health <= 0 then
        return Color3.fromRGB(255, 0, 0)
    end
    
    local Percent = math.clamp((Health / MaxHealth) * 100, 0, 100)
    
    if Percent >= 70 then
        return Color3.fromRGB(96, 253, 48)
    elseif Percent >= 45 then
        return Color3.fromRGB(255, 196, 0)
    else
        return Color3.fromRGB(255, 71, 71)
    end
end

local function getCharacter(plr)
    plr = plr or lplr
    return plr.Character or plr.CharacterAdded:Wait()
end

local function getPlrByCharacter(character)
    for _, plr in next, Players:GetPlayers() do
        if plr.Character == character then
            return plr
        end
    end
end

local function getHumanoid(plr)
    plr = plr or lplr
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChildOfClass("Humanoid")
    end
end

local function getHumanoidRootPart(plr)
    plr = plr or lplr
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("HumanoidRootPart")
    end
end

local function getHead(plr)
    plr = plr or lplr
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("Head")
    end
end

local function IsVisible(Position, WallCheck, ...)
    if not WallCheck then
        return true
    end
    return #Camera:GetPartsObscuringTarget({Position}, {Camera, LocalPlayer.Character, ...}) == 0
end

local function getClosestPlayerToMouse(Fov, TeamCheck, AimPart, WallCheck)
    local AimFov = Fov
    local TargetPosition = nil
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if isAlive(Player) and Character:FindFirstChild(AimPart) then
                if not TeamCheck or ((TeamCheck and Player.Team ~= LocalPlayer.Team) or (TeamCheck and (Player.Team == nil or Player.Team == "nil") and Player.Neutral == true)) then
                    local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Character[AimPart].Position)
                    if OnScreen then
                        local ScreenPosition2D = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                        local NewMagnitude = (ScreenPosition2D - UserInputService:GetMouseLocation()).Magnitude
                        if NewMagnitude < AimFov and IsVisible(Character[AimPart].Position, WallCheck, Character) then
                            AimFov = NewMagnitude
                            TargetPosition = Player
                        end
                    end
                end
            end
        end
    end
    return TargetPosition
end

local function AimAt(Target, Smoothness, AimPart)
    local AimPart = Target.Character:FindFirstChild(AimPart)
    if AimPart then
        local LookAt = nil
        local Distance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Target.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
        local AdjustedDistance = Distance / 10
        LookAt = Camera.CFrame:PointToWorldSpace(Vector3.new(0, 0, -Smoothness * AdjustedDistance)):Lerp(AimPart.Position, 0.01)
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, LookAt)
    end
end

local function CheckForAllAnimateParams(Animate)
    print("[Universal.lua]: Checking Animate parameters for CustomAnimations...")

    if not Animate then
        warn("[Universal.lua]: CustomAnimations can't be loaded, 'Animate' script is missing!")
        return false
    end

    local requiredAnimations = {
        {"idle", "Animation1", "AnimationId"},
        {"idle", "Animation2", "AnimationId"},
        {"walk", "WalkAnim", "AnimationId"},
        {"run", "RunAnim", "AnimationId"},
        {"jump", "JumpAnim", "AnimationId"},
        {"fall", "FallAnim", "AnimationId"},
        {"climb", "ClimbAnim", "AnimationId"},
        {"swim", "Swim", "AnimationId"},
    }

    for _, path in ipairs(requiredAnimations) do
        local current = Animate
        for _, step in ipairs(path) do
            if not current:FindFirstChild(step) then
                warn("[Universal.lua]: CustomAnimations can't be loaded, missing: " .. table.concat(path, "."))
                return false
            end
            current = current[step]
        end
    end

    print("[Universal.lua]: All Animate parameters are valid, CustomAnimations can be loaded.")
    return true
end

local function FindTouchInterest(Tool)
    return Tool and Tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end

local function findToolWithTouchInterest(plr)
    for _, tool in next, plr.Backpack do
        local touchInterest = FindTouchInterest(tool)
        if touchInterest then
            return tool
        end
    end
    return
end

local function CanClick()
    local MousePosition = UserInputService:GetMouseLocation() - Vector2.new(0, 36)
    for i,v in pairs(PlayerGui:GetGuiObjectsAtPosition(MousePosition.X, MousePosition.Y)) do
        if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
            return false
        end
    end
    for i,v in pairs(CoreGui:GetGuiObjectsAtPosition(MousePosition.X, MousePosition.Y)) do
        if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
            return false
        end
    end
    return true
end

local function GetNearInstances(Radius, Player, RequiredInstance, IgnoreInstances)
    local Instances = {}
    local UselessInstances = {}

    local function IsIgnored(Instance)
        if IgnoreInstances == nil then
            return false
        end
        for _, v in pairs(IgnoreInstances) do
            if Instance:IsA(v) then
                return true
            end
        end
        return false
    end

    for _, Instance in next, workspace:GetDescendants() do
        if (not RequiredInstance or Instance:IsA(RequiredInstance)) and not IsIgnored(Instance) then
            if Instance:IsA("ClickDetector") and RequiredInstance == not "ClickDetector" then
                Instance = Instance.Parent
            end
            local Distance = (Instance.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if Distance <= Radius then
                table.insert(Instances, Instance)
            end
        else
            if IsIgnored(Instance) then
                table.insert(UselessInstances, Instance)
            end
        end
    end

    return Instances
end

local function isFriend(name)
    for _, friend in next, playersHandler.players do
        if friend == name or name == friend then
            return true
        end
    end
    return false
end

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

-- ============================================
-- COMBAT TAB
-- ============================================

runFunction(function()
    local aimAssist = {Enabled = false}
    local aimPart = {Value = "Head"}
    local held = {Value = "RMB"}
    local smoothness = {Value = 100}
    local circle = {Value = false}
    local circleTransparency = {Value = 0}
    local circleFilled = {Value = false}
    local fov = {Value = 70}
    local highlightTarget = {Value = false}
    local highlightMode = {Value = "AimPart"}
    local highlightOutline = {Value = false}
    local highlightOutlineColor = {Value = "255, 255, 255"}
    local highlightOutlineTransparency = {Value = 0}
    local highlightFill = {Value = false}
    local highlightFillColor = {Value = "255, 255, 255"}
    local highlightFillTransparency = {Value = 0}
    local highlightTeamColor = {Value = false}
    local firstCamCheck = {Value = false}
    local wallCheck = {Value = false}
    local teamCheck = {Value = false}
    local autoFire = {Value = false}
    local toolCheck = {Value = false}
    local circleObj
    local CircleUpdateConnection
    local MouseClicked
    local connection
    local leftConnection
    local rightConnection
    local highlight
    local espLibrary = espLibrary:create("AimAssist")
    espLibrary.Mode = "Highlight"

    local function fireShoot(ToolCheck)
        local Player = getClosestPlayerToMouse(fov.Value, teamCheck.Value, aimPart.Value, wallCheck.Value)
        if ToolCheck and toolHandler.currentTool == nil then return end

        if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
            if Player then
                if CanClick() and GuiLibrary.Toggled == false and not UserInputService:GetFocusedTextBox() then
                    if MouseClicked then mouse1release() else mouse1press() end
                    MouseClicked = not MouseClicked
                else
                    if MouseClicked then mouse1release() end
                    MouseClicked = false
                end
            else
                if MouseClicked then mouse1release() end
                MouseClicked = false
            end
        end
    end

    local function UpdateCircle()
        if circle.Value then
            if not circleObj then
                circleObj = Drawing.new("Circle")
                circleObj.Filled = circleFilled.Value
                circleObj.Thickness = 3
                circleObj.Radius = fov.Value
                circleObj.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                circleObj.Visible = true
                circleObj.Transparency = circleTransparency.Value

                CircleUpdateConnection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                    circleObj.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                end)
            end
        else
            if circleObj then
                circleObj:Destroy()
                circleObj = nil
            end
            if CircleUpdateConnection then
                CircleUpdateConnection:Disconnect()
            end
        end
    end

    aimAssist = Tabs.Combat:CreateToggle({
        Name = "AimAssist",
        HoverText = "Automatically aims at the closest player to your mouse.",
        Callback = function(callback)
            if callback then
                RunService:BindToRenderStep("AimAssist", Enum.RenderPriority.Camera.Value + 1, function()
                    local leftConnection = held.Value == "LMB" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                    local rightConnection = held.Value == "RMB" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

                    if rightConnection or leftConnection then
                        if firstCamCheck.Value and getHead().LocalTransparencyModifier ~= 1 then return end
                        local plr = getClosestPlayerToMouse(fov.Value, teamCheck.Value, aimPart.Value, wallCheck.Value)
                        if plr and isAlive(plr, aimPart.Value == "Head") then
                            AimAt(plr, smoothness.Value, aimPart.Value)
                            if autoFire.Value then fireShoot(toolCheck.Value) end
                        end
                    end
                end)
            else
                betterDisconnect(connection)
                espLibrary:removeAllEspObjects()
                RunService:UnbindFromRenderStep("AimAssist")
            end
        end
    })

    aimPart = aimAssist:CreateDropdown({
        Name = "Aim Part",
        Function = function(v) end,
        List = {"Head", "HumanoidRootPart"},
        Default = "Head",
    })

    held = aimAssist:CreateDropdown({
        Name = "Mouse Held",
        Function = function(v) end,
        List = {"LMB", "RMB"},
        Default = "RMB",
    })

    smoothness = aimAssist:CreateSlider({
        Name = "Smoothness",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0,
    })

    fov = aimAssist:CreateSlider({
        Name = "Fov",
        Function = function(v) end,
        Min = 1,
        Max = 120,
        Default = 70,
        Round = 0,
    })

    circle = aimAssist:CreateToggle({
        Name = "FOV Circle",
        Default = false,
        Function = function(v)
            if circleTransparency.MainObject then circleTransparency.MainObject.Visible = v end
            if circleFilled.MainObject then circleFilled.MainObject.Visible = v end
            if v then UpdateCircle() end
        end
    })

    circleTransparency = aimAssist:CreateSlider({
        Name = "Circle Transparency",
        Function = function(v) UpdateCircle() end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    circleFilled = aimAssist:CreateToggle({
        Name = "Circle Filled",
        Default = false,
        Function = function(v) UpdateCircle() end
    })

    firstCamCheck = aimAssist:CreateToggle({
        Name = "1st Person Check",
        Default = false,
        Function = function(v) end
    })

    teamCheck = aimAssist:CreateToggle({
        Name = "Team Check",
        Default = false,
        Function = function(v) end
    })

    wallCheck = aimAssist:CreateToggle({
        Name = "Wall Check",
        Default = false,
        Function = function(v) end
    })

    autoFire = aimAssist:CreateToggle({
        Name = "Auto Fire",
        Default = false,
        Function = function(v)
            if toolCheck.MainObject then toolCheck.MainObject.Visible = v end
        end
    })

    toolCheck = aimAssist:CreateToggle({
        Name = "Tool Check",
        Default = false,
        Function = function(v) end
    })
    toolCheck.MainObject.Visible = false
end)

runFunction(function()
    local autoClicker = {Enabled = false}
    local mode = {Value = "Click"}
    local cps = {Value = 15}

    local autoClickerToggle = Tabs.Combat:CreateToggle({
        Name = "AutoClicker",
        HoverText = "Automatically clicks for you.",
        Callback = function(callback)
            if callback then
                spawn(function()
                    repeat
                        if mode.Value == "Click" or mode.Value == "RightClick" then
                            if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
                                if GuiLibrary.Toggled == false and not UserInputService:GetFocusedTextBox() then
                                    local ClickFunction = (mode.Value == "Click" and mouse1click or mouse2click)
                                    ClickFunction()
                                end
                            end
                        elseif mode.Value == "Tool" then
                            if toolHandler.currentTool == not nil and CurrentTool:IsA("Tool") and CanClick() then
                                toolHandler.currentTool:Active()
                            end
                        end
                        wait(1 / cps.Value)
                    until not autoClickerToggle.Enabled
                end)
            end
        end
    })

    mode = autoClickerToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Click", "RightClick", "Tool"},
        Default = "Click"
    })

    cps = autoClickerToggle:CreateSlider({
        Name = "CPS",
        Function = function() end,
        Min = 0,
        Max = 20,
        Default = 13,
        Round = 0
    })
end)

runFunction(function()
    local reach = {Enabled = false}
    local expandPart = {Value = "Head"}
    local expand = {Value = 0}
    local connection

    local function updatePlayer(plr)
        if plr == LocalPlayer then return end
        if isAlive(plr, expandPart.Value == "Head") and isPlayerTargetable(plr, true) then
            local humanoidRootPart = getHumanoidRootPart(plr)
            if expandPart.Value == "HumanoidRootPart" then
                getHumanoidRootPart(plr).Size = Vector3.new(2 * (expand.Value / 10), 2 * (expand.Value / 10), 1 * (expand.Value / 10))
            elseif expandPart.Value == "Head" then
                getHead(plr).Size = Vector3.new((expand.Value / 10), (expand.Value / 10), (expand.Value / 10))
            end
        end
    end

    local reachToggle = Tabs.Combat:CreateToggle({
        Name = "Reach",
        HoverText = "Expands hitboxes of other players.",
        Callback = function(callback)
            if callback then
                for _, plr in next, Players:GetPlayers() do
                    updatePlayer(plr)
                end
                connection = Players.PlayerAdded:Connect(function(plr)
                    updatePlayer(plr)
                end)
            else
                if connection then
                    connection:Disconnect()
                end
                for _, plr in next, Players:GetPlayers() do
                    if plr == LocalPlayer then return end
                    getHumanoidRootPart(plr).Size = Vector3.new(2, 2, 1)
                    getHead(plr).Size = Vector3.new(1, 1, 1)
                end
            end
        end
    })

    expandPart = reachToggle:CreateDropdown({
        Name = "Expand Part",
        Function = function(v) end,
        List = {"HumanoidRootPart", "Head"},
        Default = "HumanoidRootPart"
    })

    expand = reachToggle:CreateSlider({
        Name = "Expand Size",
        Min = 1,
        Max = 20,
        Round = 1, 
        Function = function(v) end,
    })
end)

-- ============================================
-- MOVEMENT TAB
-- ============================================

runFunction(function()
    local autoWalk = {Enabled = false}
    local autoWalkToggle = Tabs.Movement:CreateToggle({
        Name = "AutoWalk",
        HoverText = "Automatically walks forward for you.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AutoWalk", function()
                    if isAlive() then
                        getHumanoid(LocalPlayer):Move(Vector3.new(0, 0, -1), true)
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AutoWalk")
            end
        end
    })
end)

runFunction(function()
    local clickTP = {Enabled = false}
    local mode = {Value = "Click"}
    local tool
    local connection
    local connection2
    local function tp()
        if isAlive() then
            getHumanoidRootPart(LocalPlayer).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
        end 
    end
    local clickTPToggle = Tabs.Movement:CreateToggle({
        Name = "ClickTP",
        HoverText = "Teleports you to where you clicked.",
        Callback = function(callback) 
            if callback then
                if mode.Value == "Tool" then
                    tool = Instance.new("Tool")
                    tool.Name = "TPTool"
                    tool.Parent = Backpack
                    tool.RequiresHandle = false
                    tool.Activated:Connect(tp)
                elseif mode.Value == "Click" then
                    connection = Mouse.Button1Down:Connect(tp)
                elseif mode.Value == "RightClick" then
                    connection2 = Mouse.Button2Down:Connect(tp)
                end
            else
                if connection then 
                    connection:Disconnect()
                    connection = nil
                end
                if connection2 then 
                    connection2:Disconnect()
                    connection2 = nil
                end
                if tool then
                    tool:Destroy()
                end
            end
        end
    })

    mode = clickTPToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v)
            if clickTPToggle.Enabled then clickTPToggle:ReToggle() end
        end,
        List = {"Click", "RightClick", "Tool"},
        Default = "Click"
    })
end)

runFunction(function()
    local fastFall = {Enabled = false}
    local height = {Value = 5}
    local ticks = {Value = 5}
    local fastFallToggle = Tabs.Movement:CreateToggle({
        Name = "FastFall",
        HoverText = "Makes you fall faster.",
        Callback = function(callback)
            if callback then
                spawn(function() 
                    repeat task.wait()
                        if isAlive() then
                            local humanoid = getHumanoid(LocalPlayer)
                            local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                            local params = RaycastParams.new()
                            params.FilterDescendantsInstances = {LocalPlayer.Character}
                            params.FilterType = Enum.RaycastFilterType.Blacklist
                            local raycast = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -height.Value * 3, 0), params)
                            if raycast and raycast.Instance then 
                                local velocity = humanoidRootPart.Velocity
                                if humanoid:GetState() == Enum.HumanoidStateType.Freefall and velocity.Y < 0 then 
                                    humanoidRootPart.Velocity = Vector3.new(velocity.X, -(ticks.Value * 30), velocity.Z)
                                end
                            end
                        end
                    until not fastFallToggle.Enabled
                end)
            end
        end
    })
    
    height = fastFallToggle:CreateSlider({
        Name = "FallHeight",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 7,
        Round = 1
    })

    ticks = fastFallToggle:CreateSlider({
        Name = "Ticks",
        Function = function(v) end,
        Min = 1,
        Max = 5,
        Default = 1,
        Round = 0
    })
end)

runFunction(function()
    local fly = {Enabled = false}
    local mode = {Value = "Normal"}
    local keyboardMode = {Value = "LeftShift+Space"}
    local speed = {Value = 23}
    local verticalSpeed = {Value = 20}
    local linearVelocity
    local flyToggle = Tabs.Movement:CreateToggle({
        Name = "Fly",
        HoverText = "Makes you fly.\nFPS based, recommended FPS is 60.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("Fly", function(Delta)
                    local humanoid = getHumanoid(LocalPlayer)
                    local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                    local moveDirection = humanoid.MoveDirection
                    local velocity = humanoidRootPart.Velocity
                    local xDirection = moveDirection.X * speed.Value
                    local zDirection = moveDirection.Z * speed.Value
                    local yDirection = 0
                    local yVelocity = (math.abs(yDirection) < 0.1 and (workspace.Gravity * Delta * 0.6325)) or yDirection

                    if verticalSpeed.Value > 0 then
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and (keyboardMode.Value == "LeftShift+Space" or keyboardMode.Value == "LeftCtrl+Space") then
                            yDirection = verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.E) and keyboardMode.Value == "Q+E" then
                            yDirection = verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and keyboardMode.Value == "LeftShift+Space" then
                            yDirection = -verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and keyboardMode.Value == "LeftShift+Space" then
                            yDirection = -verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) and keyboardMode.Value == "Q+E" then
                            yDirection = -verticalSpeed.Value
                        end
                    end

                    if mode.Value == "AssemblyAngularVelocity" then
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(xDirection, yVelocity, zDirection)
                    elseif mode.Value == "AssemblyLinearVelocity" then
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(xDirection, yVelocity, zDirection)
                    elseif mode.Value == "LinearVelocity" then
                        linearVelocity = linearVelocity or Instance.new("LinearVelocity", humanoidRootPart)
                        linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
                        linearVelocity.MaxForce = math.huge
                        linearVelocity.VectorVelocity = Vector3.new(xDirection, yDirection, zDirection)
                    elseif mode.Value == "Velocity" then
                        humanoidRootPart.Velocity = Vector3.new(xDirection, yVelocity, zDirection)
                    elseif mode.Value == "CFrame" then
                        local factor = speed.Value - humanoid.WalkSpeed
                        local newMoveDirection = (moveDirection * factor) * Delta
                        local newCFrame = humanoidRootPart.CFrame + Vector3.new(newMoveDirection.X, yDirection * Delta, newMoveDirection.Z)
                        humanoidRootPart.CFrame = newCFrame
                        humanoidRootPart.Velocity = Vector3.zero
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("Fly")
                if linearVelocity then
                    linearVelocity:Destroy()
                    linearVelocity = nil
                end
            end
        end
    })

    mode = flyToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) 
            if speed.Container then speed.Container.Visible = v == "CFrame" end
        end,
        List = {"AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "CFrame"},
        Default = "Velocity"
    })

    speed = flyToggle:CreateSlider({
        Name = "Speed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 23,
        Round = 0
    })
    speed.Container.Visible = false

    keyboardMode = flyToggle:CreateDropdown({
        Name = "KeyboardMode",
        Function = function(v) end,
        List = {"LeftShift+Space", "Q+E", "LeftCtrl+Space"},
        Default = "LeftShift+Space"
    })

    verticalSpeed = flyToggle:CreateSlider({
        Name = "VerticalSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })
end)

runFunction(function()
    local forwardTP = {Enabled = false}
    local studs = {Value = 5}
    local teleporting = false
    local forwardTPToggle = Tabs.Movement:CreateToggle({
        Name = "ForwardTP",
        HoverText = "Teleports you forward.",
        Callback = function(callback)
            if callback and not teleporting then
                teleporting = true
                if isAlive() then
                    local humanoid = getHumanoid(LocalPlayer)
                    local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                    local look = humanoidRootPart.CFrame.LookVector
                    if humanoid.MoveDirection.Magnitude > 0 or Humanoid:GetState() == Enum.HumanoidStateType.Running then
                        local forward = look * studs.Value
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame + forward
                    end
                end
                teleporting = false
                forwardTPToggle:Toggle(true, false)
            end
        end
    })
    
    studs = forwardTPToggle:CreateSlider({
        Name = "Studs",
        Function = function(v) end,
        Min = 1,
        Max = 50,
        Default = 5,
        Round = 0
    })
end)

runFunction(function()
    local highJump = {Enabled = false}
    local jumpMode = {Value = "Velocity"}
    local jumps = {Value = 5}
    local mode = {Value = "Toggle"}
    local height = {Value = 20}
    local connection
    local linearVelocity

    local function jump()
        local humanoid = getHumanoid(LocalPlayer)
        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
        if jumpMode.Value == "AssemblyAngularVelocity" then
            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "AssemblyLinearVelocity" then
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "LinearVelocity" then
            linearVelocity = Instance.new("LinearVelocity", humanoidRootPart)
            linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
            linearVelocity.MaxForce = math.huge
            linearVelocity.VectorVelocity = Vector3.new(0, height.Value, 0)
            task.wait(0.1)
            linearVelocity:Destroy()
        elseif jumpMode.Value == "Velocity" then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "TP" then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "Jump" then
            spawn(function()
                for i = 1, jumps.Value do
                    task.wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end

    local highJumpToggle = Tabs.Movement:CreateToggle({
        Name = "HighJump",
        HoverText = "Makes you jump higher.",
        Callback = function(callback)
            if callback then
                if mode.Value == "Toggle" then
                    jump()
                    highJumpToggle:Toggle(true)
                elseif mode.Value == "Normal" then
                    connection = table.insert(connections, UserInputService.JumpRequest:Connect(function()
                        jump()
                    end))
                end
            else
                betterDisconnect(connection)
            end
        end
    })

    jumpMode = highJumpToggle:CreateDropdown({
        Name = "JumpMode",
        Function = function(v) 
            if mode.MainObject then
                mode.MainObject.Visible = v == "Jump"
            end
        end,
        List = {"AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "TP", "Jump"},
        Default = "Velocity"
    })

    mode = highJumpToggle:CreateDropdown({
        Name = "Mode",
        Callback = function(v) end,
        List = {"Toggle", "Normal"},
        Default = "Toggle"
    })

    jumps = highJumpToggle:CreateSlider({
        Name = "Jumps",
        Function = function() end,
        Min = 0,
        Max = 100,
        Default = 5,
        Round = 0
    })

    height = highJumpToggle:CreateSlider({
        Name = "Height",
        Function = function() end,
        Min = 0,
        Max = 100,
        Default = 25,
        Round = 0
    })
end)

runFunction(function()
    local longJump = {Enabled = false}
    local mode = {Value = "Velocity"}
    local power = {Value = 50}

    local longJumpToggle = Tabs.Movement:CreateToggle({
        Name = "LongJump",
        HoverText = "Makes you jump forward.",
        Callback = function(callback)
            if callback then
                local humanoid = getHumanoid(LocalPlayer)
                local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                local oldCFrame = humanoidRootPart.CFrame
                local oldVelocity = humanoidRootPart.Velocity
                local direction = humanoidRootPart.CFrame.LookVector

                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                if mode.Value == "AssemblyAngularVelocity" then
                    humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(direction.X * power.Value, oldVelocity.Y, direction.Z * power.Value)
                elseif mode.Value == "AssemblyLinearVelocity" then
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(direction.X * power.Value, oldVelocity.Y, direction.Z * power.Value)
                elseif mode.Value == "LinearVelocity" then
                    local linearVelocity = Instance.new("LinearVelocity")
                    linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
                    linearVelocity.MaxForce = math.huge
                    linearVelocity.VectorVelocity = Vector3.new(direction.X * power.Value, oldVelocity.Y, direction.Z * power.Value)
                    linearVelocity.Parent = humanoidRootPart
                    task.wait(0.1)
                    linearVelocity:Destroy()
                elseif mode.Value == "Velocity" then
                    local NewVelocity = oldVelocity * power.Value
                    humanoidRootPart.Velocity = Vector3.new(NewVelocity.X, oldVelocity.Y, NewVelocity.X)
                elseif mode.Value == "CFrame" then
                    local newCFrame = oldCFrame * CFrame.new(direction.X * power.Value, 0, direction.Z * power.Value)
                    humanoidRootPart.CFrame = CFrame.new(newCFrame.X, oldCFrame.Y, newCFrame.Z)
                end

                longJumpToggle:Toggle(true)
            end
        end
    })

    mode = longJumpToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "CFrame"},
        Default = "Velocity"
    })

    power = longJumpToggle:CreateSlider({
        Name = "Power",
        Function = function(v) end,
        Min = 1,
        Max = 1000,
        Default = 100,
        Round = 0
    })
end)

runFunction(function()
    local phase = {Enabled = false}
    local parts = {}
    local phaseToggle = Tabs.Movement:CreateToggle({
        Name = "Phase",
        HoverText = "Makes you walk through walls.",
        Callback = function(callback) 
            if callback then 
                if isAlive() then
                    RunLoops:BindToStepped("Phase", function()
                        for i, v in pairs(getCharacter(LocalPlayer):GetChildren()) do 
                            if v:IsA("BasePart") and v.CanCollide then 
                                parts[v] = v
                                v.CanCollide = false
                            end
                        end
                    end)
                end
            else
                for i, v in next, parts do
                    v.CanCollide = true
                end
                parts = {}
                RunLoops:UnbindFromStepped("Phase")
            end
        end
    })
end)

runFunction(function()
    local speed = {Enabled = false}
    local mode = {Value = "Normal"}
    local value = {Value = 16}
    local autoJump = {Value = false}
    local jumpMode = {Value = "Normal"}
    local autoJumpPower = {Value = 25}
    local jumpPower = {Value = 50}
    local noAnim = {Value = false}
    local shiftHold = {Value = false}
    local linearVelocity
    local connection
    local connection2
    local holdingShift = false
    local speedToggle = Tabs.Movement:CreateToggle({
        Name = "Speed",
        HoverText = "Makes you walk faster.",
        Callback = function(callback)
            if callback then
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if input.KeyCode == Enum.KeyCode.LeftShift and not gameProcessed then
                        holdingShift = true
                    end
                end)
                connection2 = UserInputService.InputEnded:Connect(function(input, gameProcessed)
                    if input.KeyCode == Enum.KeyCode.LeftShift and not gameProcessed then
                        holdingShift = false
                    end
                end)
                RunLoops:BindToHeartbeat("Speed", function(Delta)
                    if isAlive() and (not shiftHold.Value or (shiftHold.Value and holdingShift)) then
                        local humanoid = getHumanoid(LocalPlayer)
                        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                        if not humanoid or not humanoidRootPart then return end
                        local moveDirection = humanoid.MoveDirection
                        local VelocityX = humanoidRootPart.Velocity.X
                        local VelocityZ = humanoidRootPart.Velocity.Z

                        if jumpPower.Value > humanoid.JumpPower then
                            humanoid.JumpPower = jumpPower.Value
                            humanoid.UseJumpPower = true
                        end

                        if mode.Value == "Velocity" then
                            local Velocity = Humanoid.MoveDirection * (value.Value * 5) * Delta
                            Character:TranslateBy(Vector3.new(Velocity.X / 10, 0, Velocity.Z / 10))
                        elseif mode.Value == "CFrame" then
                            local Factor = value.Value - humanoid.WalkSpeed
                            local MoveDirection = (moveDirection * Factor) * Delta
                            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(MoveDirection.X, 0, MoveDirection.Z)
                        elseif mode.Value == "Normal" then
                            humanoid.WalkSpeed = value.Value
                        end

                        if autoJump.Value and (humanoid.FloorMaterial ~= Enum.Material.Air) and humanoid.MoveDirection ~= Vector3.zero then
                            if jumpMode == "Normal" then
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            else
                                humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, autoJumpPower.Value, humanoidRootPart.Velocity.Z)
                            end
                        end

                        if noAnim.Value then
                            Character.Animate.Disabled = true
                        end
                        if linearVelocity then
                            linearVelocity:Destroy()
                        end
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("Speed")
                getHumanoid().WalkSpeed = PlayerWalkSpeed
                getHumanoid().JumpPower = PlayerJumpPower
                getCharacter().Animate.Disabled = false
                betterDisconnect(connection)
                betterDisconnect(connection2)
            end
        end
    })

    mode = speedToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) 
            if speedToggle.Enabled then 
                speedToggle:ReToggle(true)
            end
        end,
        List = {"Velocity", "CFrame", "Normal"},
        Default = "Velocity"
    })

    value = speedToggle:CreateSlider({
        Name = "Speed",
        Function = function(v) 
            if speedToggle.Enabled and mode.Value == "Normal" then
                getHumanoid(LocalPlayer).WalkSpeed = v
            end
        end,
        Min = 0,
        Max = 200,
        Default = 16,
        Round = 0
    })

    autoJumpPower = speedToggle:CreateSlider({
        Name = "AutoJumpPower",
        Function = function(v) end,
        Min = 0,
        Max = 30,
        Default = 25,
        Round = 0
    })

    jumpPower = speedToggle:CreateSlider({
        Name = "JumpPower",
        Function = function(v) 
            if speedToggle.Enabled then
                getHumanoid(LocalPlayer).JumpPower = v
            end
        end,
        Min = 0,
        Max = 200,
        Default = 50,
        Round = 0
    })

    autoJump = speedToggle:CreateToggle({
        Name = "AutoJump",
        Default = false,
        Function = function(v)
            if jumpMode.MainObject then jumpMode.MainObject.Visible = v end
        end
    })

    jumpMode = speedToggle:CreateDropdown({
        Name = "AutoJumpMode",
        Function = function(v) 
            if autoJumpPower.MainObject then
                autoJumpPower.MainObject.Visible = v == "Velocity"
            end
            if speedToggle.Enabled then
                speedToggle:ReToggle(true)
            end
        end,
        List = {"Normal", "Velocity"},
        Default = "Normal"
    })
    jumpMode.Container1.Visible = false

    noAnim = speedToggle:CreateToggle({
        Name = "NoAnimation",
        Default = false,
        Function = function(v)
            if speedToggle.Enabled then
                getCharacter(LocalPlayer).Animate.Disabled = v
            end
        end
    })

    shiftHold = speedToggle:CreateToggle({
        Name = "ShiftHold",
        Default = false,
        Function = function(v)
            holdingShift = false
            if speedToggle.Enabled then
                speedToggle:ReToggle(true)
            end
        end
    })
end)

runFunction(function()
    local spinBot = {Enabled = false}
    local mode = {Value = "Velocity"}
    local spinBotSpeed = {Value = 20}
    local spinBotX = {Value = false}
    local spinBotY = {Value = false}
    local spinBotZ = {Value = false}
    local velocityX
    local velocityY
    local velocityZ
    local angularX
    local angularY
    local angularZ
    local angularVelocity = Instance.new("AngularVelocity")
    local spinBotToggle = Tabs.Movement:CreateToggle({
        Name = "SpinBot",
        HoverText = "Makes your character spin.\nDoesn't work in first person.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("SpinBot", function()
                    if isAlive() then
                        local humanoid = getHumanoid(LocalPlayer)
                        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                        local oldVelocity = humanoidRootPart.AssemblyAngularVelocity
                        velocityX = (spinBotX.Value and spinBotSpeed.Value) or oldVelocity.X
                        velocityY = (spinBotY.Value and spinBotSpeed.Value) or oldVelocity.Y
                        velocityZ = (spinBotZ.Value and spinBotSpeed.Value) or oldVelocity.Z
                        angularX = (spinBotX.Value and math.huge) or 0
                        angularY = (spinBotY.Value and math.huge) or 0
                        angularZ = (spinBotZ.Value and math.huge) or 0

                        humanoid.AutoRotate = false
                        if mode.Value == "RotVelocity" then
                            humanoidRootPart.RotVelocity = Vector3.new(velocityX, velocityY, velocityZ)
                        elseif mode.Value == "AssemblyAngularVelocity" then
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(velocityX, velocityY, velocityZ)
                        end
                    end
                end)
            else
                getHumanoid(LocalPlayer).AutoRotate = true
                RunLoops:UnbindFromHeartbeat("SpinBot")
            end
        end
    })

    mode = spinBotToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"RotVelocity", "AssemblyAngularVelocity"},
        Default = "AssemblyAngularVelocity"
    })

    spinBotSpeed = spinBotToggle:CreateSlider({
        Name = "SpinSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })

    spinBotX = spinBotToggle:CreateToggle({
        Name = "Spin X",
        Default = false,
        Function = function(v) end
    })

    spinBotY = spinBotToggle:CreateToggle({
        Name = "Spin Y",
        Default = false,
        Function = function(v) end
    })

    spinBotZ = spinBotToggle:CreateToggle({
        Name = "Spin Z",
        Default = false,
        Function = function(v) end
    })
end)

-- ============================================
-- RENDER TAB
-- ============================================

runFunction(function()
    local breadcrumbs = {Enabled = false}
    local mode = {Value = "Trail"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local startColor = {Value = Color3.fromRGB(255, 255, 255)}
    local endColor = {Value = Color3.fromRGB(255, 255, 255)}
    local size = {Value = 0.5}
    local distance = {Value = 1}
    local lifeTime = {Value = 20}
    local transparency = {Value = 0}
    local objects = Instance.new("Folder", workspace)
    objects.Name = "breadcrumbsObjects"
    local trail
	local attachment
	local attachment2
    local lastPos
    local breadcrumbsToggle = Tabs.Render:CreateToggle({
        Name = "Breadcrumbs",
        HoverText = "Creates a trail behind you.",
        Callback = function(callback)
            if callback then
                task.spawn(function()
					repeat
						if isAlive() then
                            local humanoidRootPart = getHumanoidRootPart()
                            if mode.Value == "Trail" then
                                if not trail then
                                    attachment = Instance.new("Attachment")
                                    attachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
                                    attachment2 = Instance.new("Attachment")
                                    attachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
                                    trail = Instance.new("Trail")
                                    trail.Attachment0 = attachment
                                    trail.Attachment1 = attachment2
                                    trail.Color = ColorSequence.new(startColor.Value, endColor.Value)
                                    trail.FaceCamera = true
                                    trail.Lifetime = lifeTime.Value / 10
                                    trail.Enabled = true
                                else
                                    local Succes = pcall(function()
                                        attachment.Parent = humanoidRootPart
                                        attachment2.Parent = humanoidRootPart
                                        trail.Parent = Camera
                                    end)
                                    if not Succes then
                                        if trail then trail:Destroy() trail = nil end
                                        if attachment then attachment:Destroy() attachment = nil end
                                        if attachment2 then attachment2:Destroy() attachment2 = nil end
                                    end
                                end
                            elseif mode.Value == "Spheres" then
                                if (lastPos and (humanoidRootPart.Position - lastPos).Magnitude > distance.Value) or not lastPos then
                                    local sphere = Instance.new("Part", objects)
                                    sphere.Shape = Enum.PartType.Ball
                                    sphere.Size = Vector3.new(0.5, 0.5, 0.5)
                                    sphere.Color = color.Value
                                    sphere.Material = Enum.Material.Plastic
                                    sphere.CanCollide = false
                                    sphere.Anchored = true
                                    sphere.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, 0)
                                    sphere.Transparency = transparency.Value
                                    sphere.TopSurface = Enum.SurfaceType.Smooth
                                    sphere.BottomSurface = Enum.SurfaceType.Smooth
                                    sphere.FrontSurface = Enum.SurfaceType.Smooth
                                    sphere.BackSurface = Enum.SurfaceType.Smooth
                                    sphere.LeftSurface = Enum.SurfaceType.Smooth
                                    sphere.RightSurface = Enum.SurfaceType.Smooth
                                    debris:AddItem(sphere, lifeTime.Value)
                                    lastPos = humanoidRootPart.Position
                                end
                            elseif mode.Value == "Cubes" then
                                if (lastPos and (humanoidRootPart.Position - lastPos).Magnitude > distance.Value) or not lastPos then
                                    local cube = Instance.new("Part", objects)
                                    cube.Size = Vector3.new(0.5, 0.5, 0.5)
                                    cube.Color = color.Value
                                    cube.Material = Enum.Material.Plastic
                                    cube.CanCollide = false
                                    cube.Anchored = true
                                    cube.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, 0)
                                    cube.Transparency = transparency.Value
                                    cube.TopSurface = Enum.SurfaceType.Smooth
                                    cube.BottomSurface = Enum.SurfaceType.Smooth
                                    cube.FrontSurface = Enum.SurfaceType.Smooth
                                    cube.BackSurface = Enum.SurfaceType.Smooth
                                    cube.LeftSurface = Enum.SurfaceType.Smooth
                                    cube.RightSurface = Enum.SurfaceType.Smooth
                                    debris:AddItem(cube, lifeTime.Value)
                                    lastPos = humanoidRootPart.Position
                                end
                            end
						end
                        task.wait()
					until not breadcrumbsToggle.Enabled
				end)
            else
                if trail then
                    trail:Destroy()
                    trail = nil
                end
				if attachment then
                    attachment:Destroy()
                    attachment = nil
                end
				if attachment2 then
                    attachment2:Destroy()
                    attachment2 = nil
                end
                for _, object in pairs(objects) do
                    object:Destroy()
                end
            end
        end
    })

    mode = breadcrumbsToggle:CreateDropdown({
        Name = "Mode",
        List = {"Trail", "Spheres", "Cubes"},
        Default = "Trail",
        Function = function(v)
            if startColor.MainObject then startColor.MainObject.Visible = v == "Trail" end
            if endColor.MainObject then endColor.MainObject.Visible = v == "Trail" end
            if color.MainObject then color.MainObject.Visible = v ~= "Trail" end
            if size.MainObject then size.MainObject.Visible = v ~= "Trail" end
            if distance.MainObject then distance.MainObject.Visible = v ~= "Trail" end
        end
    })

    startColor = breadcrumbsToggle:CreateColorSlider({
        Name = "Start color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if trail then
                trail.Color = ColorSequence.new(v, endColor.Value)
            end
        end
    })

    endColor = breadcrumbsToggle:CreateColorSlider({
        Name = "End color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if trail then
                trail.Color = ColorSequence.new(startColor.Value, v)
            end
        end
    })

    color = breadcrumbsToggle:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if breadcrumbsToggle.Enabled then
                for _, obj in next, objects:GetChildren() do
                    obj.Color = v
                end
            end
        end
    })
    color.MainObject.Visible = false

    size = breadcrumbsToggle:CreateSlider({
        Name = "Size",
        Function = function(v)
            if breadcrumbsToggle.Enabled then
                for _, obj in next, objects:GetChildren() do
                    obj.Size = Vector3.new(v, v, v)
                end
            end
        end,
        Min = 0.1,
        Max = 5,
        Default = 1,
        Round = 1
    })
    size.MainObject.Visible = false

    distance = breadcrumbsToggle:CreateSlider({
        Name = "Distance",
        Function = function(v) end,
        Min = 0.1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    lifeTime = breadcrumbsToggle:CreateSlider({
        Name = "LifeTime",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0
    })

    transparency = breadcrumbsToggle:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            if breadcrumbsToggle.Enabled then
                for _, obj in next, objects:GetChildren() do
                    obj.Transparency = v
                end
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
end)

runFunction(function()
    local camFix = {Enabled = false}
    local camFixToggle = Tabs.Render:CreateToggle({
        Name = "CameraFix",
        HoverText = "Changes camera zooming.",
        Callback = function(callback) 
            spawn(function()
                repeat
                    UserSettings():GetService("UserGameSettings").RotationType = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
                    task.wait()
                until not camFixToggle.Enabled
            end)
        end
    })
end)

runFunction(function()
    local chinaHat = {Enabled = false}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local chinaHatTrail
    local chinaHatToggle = Tabs.Render:CreateToggle({
        Name = "ChinaHat",
        HoverText = "Puts a china hat on your head.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("chinaHat", function()
					if isAlive() then
                        local head = getHead(LocalPlayer)
						if chinaHatTrail == nil or chinaHatTrail.Parent == nil then
							chinaHatTrail = Instance.new("Part")
							chinaHatTrail.CFrame =  head.CFrame * CFrame.new(0, 1.1, 0)
							chinaHatTrail.Size = Vector3.new(3, 0.7, 3)
							chinaHatTrail.Name = "ChinaHat"
							chinaHatTrail.Material = Enum.Material.Neon
							chinaHatTrail.CanCollide = false
							chinaHatTrail.Transparency = 0.3
                            chinaHatTrail.Color = color.Value
							local chinaHatMesh = Instance.new("SpecialMesh")
							chinaHatMesh.Parent = chinaHatTrail
							chinaHatMesh.MeshType = "FileMesh"
							chinaHatMesh.MeshId = "http://www.roblox.com/asset/?id=1778999"
							chinaHatMesh.Scale = Vector3.new(3, 0.6, 3)
							chinaHatTrail.Parent = workspace.Camera
						end
						chinaHatTrail.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
						chinaHatTrail.Velocity = Vector3.zero
						chinaHatTrail.LocalTransparencyModifier = head.LocalTransparencyModifier
					else
						if chinaHatTrail then
							chinaHatTrail:Destroy()
							chinaHatTrail = nil
						end
					end
				end)
            else
                RunLoops:UnbindFromHeartbeat("chinaHat")
				if chinaHatTrail then
					chinaHatTrail:Destroy()
					chinaHatTrail = nil
				end
            end
        end
    })

    color = chinaHatToggle:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if chinaHatTrail then
                chinaHatTrail.Color = v
            end
        end
    })
end)

runFunction(function()
    local crossHair = {Enabled = false}
    local id = {Value = ""}
    local crossHairToggle = Tabs.Render:CreateToggle({
        Name = "CustomCrossHair",
        HoverText = "Changes your crosshair.",
        Callback = function(callback)
            if callback then
                Mouse.Icon = "rbxassetid://" .. id.Value
            else
                Mouse.Icon = ""
            end
        end
    })

    id = crossHairToggle:CreateTextBox({
        Name = "CrossHairID",
        PlaceholderText = "Asset ID",
        DefaultValue = "",
        Function = function(v) end,
    })
end)

runFunction(function()
    local esp = {Enabled = false}
    local adorneePart = {Value = "HumanoidRootPart"}
    local mode = {Value = "SelectionBox"}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local color = {Value = Color3.fromRGB(255, 0, 0)}
    local transparency = {Value = 0}
    local useTeamColor = {Value = false}
    local teammates = {Value = false}
    local alwaysOnTop = {Value = true}
    local connection
    local connection2

    local espLibrary = espLibrary:create("ESP")

    local espToggle = Tabs.Render:CreateToggle({
        Name = "ESP",
        HoverText = "Shows people through walls.",
        Callback = function(callback)
            if callback then
                espLibrary:start()
            else
                espLibrary:stop()
            end
        end
    })

    adorneePart = espToggle:CreateDropdown({
        Name = "Attach Part",
        List = {"Head", "HumanoidRootPart", "Full Character"},
        Default = "Full Character",
        Function = function(v)
            espLibrary.adorneePart = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end
    })

    mode = espToggle:CreateDropdown({
        Name = "Mode",
        List = {"BoxHandleAdornment", "Highlight"},
        Default = "Highlight",
        Callback = function(v)
            espLibrary.mode = v
            if color.Container then color.Container.Visible = v == "BoxHandleAdornment" end
            if transparency.Container then transparency.Container.Visible = v == "BoxHandleAdornment" end
            if outline.Container then outline.Container.Visible = v == "Highlight"; outline:ReToggle() end
            if fill.Container then fill.Container.Visible = v == "Highlight"; fill:ReToggle() end
            if espToggle.Enabled then
                espToggle:ReToggle(true)
                espLibrary:updateAll()
            end
        end
    })

    outline = espToggle:CreateToggle({
        Name = "Outline",
        Default = false,
        Function = function(v)
            espLibrary.outline = v
            if outlineColor.Container then outlineColor.Container.Visible = v end
            if outlineTransparency.Container then outlineTransparency.Container.Visible = v end
        end
    })

    outlineColor = espToggle:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.outlineColor = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end
    })
    outlineColor.Container.Visible = false

    outlineTransparency = espToggle:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v)
            espLibrary.outlineTransparency = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.Container.Visible = false

    fill = espToggle:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            espLibrary.fill = v
            if fillColor.Container then fillColor.Container.Visible = v end
            if fillTransparency.Container then fillTransparency.Container.Visible = v end
        end
    })

    fillColor = espToggle:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.fillColor = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end
    })
    fillColor.Container.Visible = false

    fillTransparency = espToggle:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v)
            espLibrary.fillTransparency = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.Container.Visible = false

    color = espToggle:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.color = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end
    })
    color.Container.Visible = false

    transparency = espToggle:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            espLibrary.transparency = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    transparency.Container.Visible = false

    alwaysOnTop = espToggle:CreateToggle({
        Name = "AlwaysOnTop",
        Default = true,
        Function = function(v)
            if mode.Value == "BoxHandleAdornment" then
                esp.boxHandleAlwaysOnTop = v
            elseif mode.Value == "Highlight" then
                esp.highlightAlwaysOnTop = v
            end
        end
    })

    useTeamColor = espToggle:CreateToggle({
        Name = "TeamColor",
        Default = false,
        Function = function(v)
            espLibrary.useTeamColor = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end
    })

    teammates = espToggle:CreateToggle({
        Name = "Teammates",
        Default = false,
        Function = function(v)
            espLibrary.teammates = v
            if espToggle.Enabled then
                espLibrary:updateAll()
            end
        end
    })
end)

runFunction(function()
    local fovChanger = {Enabled = false}
    local fov = {Value = 80}
    local oldfov
    local fovChangerToggle = Tabs.Render:CreateToggle({
        Name = "FOVChanger",
        HoverText = "Changes your field of view.",
        Callback = function(callback)
            if callback then
                oldfov = Camera.FieldOfView
                Camera.FieldOfView = fov.Value
            else
                Camera.FieldOfView = oldfov
            end
        end
    })
    
    fov = fovChangerToggle:CreateSlider({
        Name = "FOV",
        Function = function(v) end,
        Min = 1,
        Max = 150,
        Default = 80,
        Round = 0
    })
end)

runFunction(function()
    local fullbright = {Enabled = false}
    local params = {}
	local changed = false
    local connection
    local fullbrightToggle = Tabs.Render:CreateToggle({
        Name = "Fullbright",
        HoverText = "Makes everything brigher.",
        Callback = function(callback)
            if callback then
                params.Brightness = Lighting.Brightness
                params.ClockTime = Lighting.ClockTime
                params.FogEnd = Lighting.FogEnd
                params.GlobalShadows = Lighting.GlobalShadows
                params.OutdoorAmbient = Lighting.OutdoorAmbient
                changed = true
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                changed = false
                connection = table.insert(connections, Lighting.Changed:Connect(function()
                    if not changed and callback then
                        params.Brightness = Lighting.Brightness
                        params.ClockTime = Lighting.ClockTime
                        params.FogEnd = Lighting.FogEnd
                        params.GlobalShadows = Lighting.GlobalShadows
                        params.OutdoorAmbient = Lighting.OutdoorAmbient
                        changed = true
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 100000
                        Lighting.GlobalShadows = false
                        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                        changed = false
                    end
                end))
            else
                if connection then
                    connection:Disconnect()
                end
                for Name, Value in pairs(params) do
                    Lighting[Name] = Value
                end
            end
        end
    })  
end)

runFunction(function()
    local keyStrokes = {Enabled = false}
    local mode = {Value = "Letters"}
    local textSize = {Value = 15}
    local spaceTextSize = {Value = 17}
    local size = {Value = 1}
    local transparency = {Value = 0.5}
    local showMouseButtons = {Value = false}
    local textXAllignment = {Value = "Left"}
    local textYAllignment = {Value = "Top"}

    local keyStrokesToggle = Tabs.Render:CreateToggle({
        Name = "KeyStrokes",
        HoverText = "Creates ui with keys and shows which ones you held.",
        Callback = function(callback)
            Mana.KeyStrokes:toggle()
        end
    })

    mode = keyStrokesToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) 
            Mana.KeyStrokes:changeSymbols(v)
        end,
        List = {"Letters", "Directions", "Directions2", "Arrows"},
        Default = "Letters"
    })

    textSize = keyStrokesToggle:CreateSlider({
        Name = "Text Size",
        Function = function(v) 
            Mana.KeyStrokes:updateTextSize(v)
        end,
        Min = 10,
        Max = 30,
        Default = 15,
        Round = 0
    })

    spaceTextSize = keyStrokesToggle:CreateSlider({
        Name = "Space Text Size",
        Function = function(v) 
            Mana.KeyStrokes:updateSpaceTextSize(v)
        end,
        Min = 10,
        Max = 30,
        Default = 17,
        Round = 0
    })

    size = keyStrokesToggle:CreateSlider({
        Name = "Size",
        Function = function(v) 
            Mana.KeyStrokes:updateSize(v)
        end,
        Min = 0.1,
        Max = 5,
        Default = 1,
        Round = 2
    })

    transparency = keyStrokesToggle:CreateSlider({
        Name = "Transparency",
        Function = function(v) 
            Mana.KeyStrokes:updateBackgroundTransparency(v)
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 1
    })

    showMouseButtons = keyStrokesToggle:CreateToggle({
        Name = "Mouse Buttons",
        Default = false,
        Function = function(v) 
            Mana.KeyStrokes:toggleMouseButtons(v)
        end
    })

    textXAllignment = keyStrokesToggle:CreateDropdown({
        Name = "Text X Pos",
        Function = function(v) 
            Mana.KeyStrokes:updateTextPosition(v, textYAllignment.Value)
        end,
        List = {"Left", "Center", "Right"},
        Default = "Left"
    })

    textYAllignment = keyStrokesToggle:CreateDropdown({
        Name = "Text Y Pos",
        Function = function(v) 
            Mana.KeyStrokes:updateTextPosition(textXAllignment.Value, v)
        end,
        List = {"Top", "Center", "Bottom"},
        Default = "Top"
    })
end)

runFunction(function()
    local nameTags = {Enabled = false}
    local mode = {Value = "Username"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local teamColor = {Value = false}
    local showHP = {Value = false}
    local showDistance = {Value = false}
    local maxDistance = {Value = 1000}
    local billboardGuis = {}
    local nameTagConnections = {}
    local nameTagsFolder = Instance.new("Folder")
    nameTagsFolder.Name = "NameTagsFolder"
    nameTagsFolder.Parent = CoreGui or workspace
    local lastFullUpdate

    for _, existing in pairs(CoreGui:GetChildren()) do
        if existing.Name == "NameTagsFolder" and existing ~= nameTagsFolder then
            existing:Destroy()
        end
    end

    local function CleanupPlayerNameTag(plr)
        local playerName = typeof(plr) == "string" and plr or plr.Name

        if billboardGuis[playerName] then
            if billboardGuis[playerName].Parent then
                billboardGuis[playerName]:Destroy()
            end
            billboardGuis[playerName] = nil
        end
    end

    local textLabelProps = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextStrokeTransparency = 0.4,
        TextYAlignment = Enum.TextYAlignment.Center,
        RichText = true,
        Name = "NameTagText"
    }

    local function CreateNameTag(plr)
        if not isAlive(plr, true) then
            return nil
        end

        CleanupPlayerNameTag(plr)

        local billboardGui = Instance.new("BillboardGui")
        local textLabel = Instance.new("TextLabel")

        billboardGui.Name = "NameTag_" .. plr.Name
        billboardGui.Adornee = plr.Character.Head
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 1.2, 0)
        billboardGui.MaxDistance = maxDistance.Value
        billboardGui.Parent = nameTagsFolder

        for prop, value in pairs(textLabelProps) do
            textLabel[prop] = value
        end
        textLabel.Parent = billboardGui

        billboardGuis[plr.Name] = billboardGui
        return billboardGui
    end

    local function UpdateNameTag(plr)
        if not isAlive(plr) then return end

        local billboardGui = billboardGuis[plr.Name]
        if not billboardGui or not billboardGui.Parent then return end

        local character = getCharacter(plr)
        local humanoid = getHumanoid(plr)
        local humanoidRootPart = getHumanoidRootPart(plr)
        local localHumanoidRootPart = getHumanoidRootPart()

        local textLabel = billboardGui:FindFirstChild("NameTagText")
        if not textLabel then return end

        local nameText = mode.Value == "Username" and plr.Name or plr.DisplayName
        local parts = {}

        table.insert(parts, string.format("<font color=\"rgb(%d, %d, %d)\">%s</font>",
            color.Value.R * 255,
            color.Value.G * 255,
            color.Value.B * 255,
        nameText))

        if showHP.Value then
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            local healthColor = ConvertHealthToColor(health, maxHealth)

            table.insert(parts, string.format(" <font color=\"rgb(%d,%d,%d)\">%d HP</font>", 
                math.floor(healthColor.R * 255), 
                math.floor(healthColor.G * 255), 
                math.floor(healthColor.B * 255), 
            health))
        end

        if showDistance.Value and isAlive() then
            local distance = math.floor((localHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
            table.insert(parts, string.format(" [%dm]", distance))
        end

        textLabel.Text = table.concat(parts)

        if showDistance.Value and isAlive() then
            local distance = (localHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            local scaleFactor = math.clamp(1 - (distance / maxDistance.Value) * 0.5, 0.5, 1)
            if math.abs(textLabel.TextSize - (16 * scaleFactor)) > 0.5 then
                textLabel.TextSize = 16 * scaleFactor
            end
        end
    end

    local function UpdateAllNameTags()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and isAlive(plr) then
                if billboardGuis[plr.Name] and billboardGuis[plr.Name].Parent then
                    UpdateNameTag(plr)
                else
                    CreateNameTag(plr)
                end
            end
        end
    end

    local function CleanupAllNameTags()
        for name, gui in pairs(billboardGuis) do
            if gui and gui.Parent then
                gui:Destroy()
            end
            billboardGuis[name] = nil
        end
    end

    local nameTagsToggle = Tabs.Render:CreateToggle({
        Name = "NameTags",
        HoverText = "Adds nametag above every player.",
        Callback = function(callback)
            if callback then
                table.insert(nameTagConnections, Players.PlayerRemoving:Connect(function(plr)
                    CleanupPlayerNameTag(plr)
                end))
                lastFullUpdate = 0
                RunLoops:BindToRenderStep("NameTags", function()
                    local now = tick()
                    if now - lastFullUpdate > 0.5 then
                        lastFullUpdate = now
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer then
                                if isAlive(plr) and (not billboardGuis[plr.Name] or not billboardGuis[plr.Name].Parent) then
                                    CreateNameTag(plr)
                                    table.insert(nameTagConnections, plr.CharacterRemoving:Connect(function()
                                        CleanupPlayerNameTag(plr)
                                    end))
                                elseif (not isAlive(plr)) and billboardGuis[plr.Name] then
                                    CleanupPlayerNameTag(plr)
                                end
                            end

                        end
                    end
                    for name, gui in pairs(billboardGuis) do
                        local plr = Players:FindFirstChild(name)
                        if plr and gui.Parent and isAlive(plr) then
                            UpdateNameTag(plr)
                        end
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("NameTags")
                for _, connection in next, nameTagConnections do
                    betterDisconnect(connection)
                end
                CleanupAllNameTags()
            end
        end
    })

    mode = nameTagsToggle:CreateDropdown({
        Name = "Name Mode",
        List = {"Username", "DisplayName"},
        Default = "Username",
        Function = function(v)
            if nameTagsToggle.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    color = nameTagsToggle:CreateColorSlider({
        Name = "Name Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if nameTagsToggle.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    teamColor = nameTagsToggle:CreateToggle({
        Name = "Team Color",
        Default = false,
        Function = function(v)
            if nameTagsToggle.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    showHP = nameTagsToggle:CreateToggle({
        Name = "Health",
        Default = false,
        Function = function(v)
            if nameTagsToggle.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    showDistance = nameTagsToggle:CreateToggle({
        Name = "Distance",
        Default = false,
        Function = function(v)
            if nameTagsToggle.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    maxDistance = nameTagsToggle:CreateSlider({
        Name = "Max Distance",
        Min = 100,
        Max = 10000,
        Default = 1000,
        Round = 0,
        Function = function(v)
            if nameTagsToggle.Enabled then
                UpdateAllNameTags()
            end
        end
    })
end)

runFunction(function()
    local rainbowSkin = {Enabled = false}
    local mode = {Value = "FullCharacter"}
    local colorMode = {Value = "Random"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local delay = {Value = 0.1}
    local newColor

    local rainbowSkinToggle = Tabs.Render:CreateToggle({
        Name = "RainbowSkin",
        HoverText = "Makes your skin rainbow/random color.",
        Callback = function(callback)
            repeat
                for _, part in next, getCharacter():GetDescendants() do
                    if part:IsA("BasePart") then
                        if mode.Value == "FullCharacter" then
                            part.Color = (colorMode.Value == "Random") and Color3.new(math.random(), math.random(), math.random()) or color.Value
                        else
                            part.Color = (colorMode.Value == "Random") and Color3.new(math.random(), math.random(), math.random()) or color.Value
                        end
                    end
                end
                wait(delay.Value)
            until not rainbowSkinToggle.Enabled
        end
    })

    mode = rainbowSkinToggle:CreateDropdown({
        Name = "Mode",
        List = {"FullCharacter", "PerPart"},
        Default = "PerPart",
        Function = function(v) end
    })

    colorMode = rainbowSkinToggle:CreateDropdown({
        Name = "ColorMode",
        List = {"Random", "Custom"},
        Default = "Random",
        Function = function(v)
            if delay.MainObject then
                delay.MainObject.Visible = v == "Random"
            end
        end
    })

    color = rainbowSkinToggle:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) end
    })

    delay = rainbowSkinToggle:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0.1,
        Max = 5,
        Default = 0.1,
        Round = 1
    })
end)

runFunction(function()
    local snowing = {Enabled = false}
    local speed = {Value = 15}
    local rate = {Value = 1000}
    local part, effect, connection

    local snowingToggle = Tabs.Render:CreateToggle({
        Name = "Snowing",
        HoverText = "Makes it snow in game.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("snowing", function(dt)
                    if isAlive() then
                        local head = getHead()
                        part = part or Instance.new("Part", Camera)
                        part.Size = Vector3.new(300, 2, 300)
                        part.CFrame = head.CFrame * CFrame.new(0, 100, 0)
                        part.Transparency = 1
                        part.Anchored = true
                        part.CanCollide = false
                        effect = effect or Instance.new("ParticleEmitter", part)
                        effect.EmissionDirection = Enum.NormalId.Bottom
                        effect.Lifetime = NumberRange.new(30, 35)
                        effect.Rate = rate.Value
                        effect.Speed = NumberRange.new(speed.Value - 5, speed.Value + 5)
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("snowing")
                if part then
                    part:Destroy()
                    part = nil
                end
                if effect then
                    effect:Destroy()
                    effect = nil
                end
            end
        end
    })

    speed = snowingToggle:CreateSlider({
        Name = "Speed",
        Min = 1,
        Max = 50,
        Default = 15,
        Round = 0
    })

    rate = snowingToggle:CreateSlider({
        Name = "Rate",
        Min = 500,
        Max = 2000,
        Default = 1000,
        Round = 0
    })
end)

runFunction(function()
    local soundPlayer = {Enabled = false}
    local mode = {Value = "Random"}
    local sounds = {List = {}}
    local volume = {Value = 1}
    local sound
    local current, max = 1, 1
    local currentID

    local soundPlayerToggle = Tabs.Render:CreateToggle({
        Name = "SoundPlayer",
        HoverText = "Plays music.",
        Callback = function(callback)
            repeat
                if mode.Value == "Random" then
                    currentID = #sounds.List > 0 and sounds.List[math.random(1, #sounds.List)] or "142376088"
                elseif mode.Value == "Order" then
                    max = #sounds.List
                    currentID = sounds.List[current] or "142376088"
                    current = current + 1
                    if current > max then current = 1 end
                end
                if currentID and currentID ~= "" then
                    if sound then
                        sound:Stop()
                        sound:Destroy()
                    end

                    sound = Instance.new("Sound")
                    sound.SoundId = tonumber(currentID) and "rbxassetid://" .. currentID or currentID
                    sound.Volume = volume.Value
                    sound.Parent = workspace
                    sound:Play()

                    repeat task.wait() until sound.IsLoaded

                    sound.Ended:Wait()
                end
            until not soundPlayerToggle.Enabled
            if not soundPlayerToggle.Enabled and sound then
                sound:Stop()
                sound:Destroy()
                sound = nil
            end
        end
    })

    mode = soundPlayerToggle:CreateDropdown({
        Name = "Mode",
        List = {"Random", "Order"},
        Default = "Random",
        Function = function(v) end
    })

    sounds = soundPlayerToggle:CreateTextList({
        Name = "Sounds",
        PlaceholderText = "sound id",
        List = {},
        Default = "",
        Function = function(v) end
    })

    volume = soundPlayerToggle:CreateSlider({
        Name = "Volume",
        Function = function(v)
            if sound then
                sound.Volume = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })
end)

runFunction(function()
    local spawnEsp = {Enabled = false}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local objects = {}
    local connection

    local function addHighlight(obj)
        if obj:FindFirstChild("SpawnESP") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "SpawnESP"
        highlight.Adornee = obj
        highlight.Parent = obj
        highlight.FillColor = fillColor.Value
        highlight.FillTransparency = fill.Value and fillTransparency.Value or 1
        highlight.OutlineColor = outlineColor.Value
        highlight.OutlineTransparency = outline.Value and outlineTransparency.Value or 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(objects, highlight)
    end

    local spawnEspToggle = Tabs.Render:CreateToggle({
        Name = "SpawnESP",
        HoverText = "Highlights every spawn that has 0 transparency.",
        Callback = function(callback)
            if callback then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("SpawnLocation") then
                        addHighlight(obj)
                    end
                end
                connection = workspace.ChildAdded:Connect(function(child)
                    if child:IsA("SpawnLocation") then
                        addHighlight(child)
                    end
                end)
            else
                for _, obj in pairs(objects) do
                    if obj and obj.Parent then
                        obj:Destroy()
                    end
                end
                table.clear(objects)
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    })

    outline = spawnEspToggle:CreateToggle({
        Name = "Outline",
        Default = true,
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.OutlineTransparency = v and outlineTransparency.Value or 1
                end
            end
            if outlineColor.Container then
                outlineColor.Container.Visible = v
            end
            if outlineTransparency.Container then
                outlineTransparency.Container.Visible = v
            end
        end
    })

    outlineColor = spawnEspToggle:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.OutlineColor = v
                end
            end
        end
    })
    outlineColor.Container.Visible = false

    outlineTransparency = spawnEspToggle:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.OutlineTransparency = outline.Value and v or 1
                end
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.Container.Visible = false

    fill = spawnEspToggle:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.FillTransparency = v and fillTransparency.Value or 1
                end
            end
            if fillColor.Container then
                fillColor.Container.Visible = v
            end
            if fillTransparency.Container then
                fillTransparency.Container.Visible = v
            end
        end
    })

    fillColor = spawnEspToggle:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.FillColor = v
                end
            end
        end
    })
    fillColor.Container.Visible = false

    fillTransparency = spawnEspToggle:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.FillTransparency = fill.Value and v or 1
                end
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.Container.Visible = false
end)

runFunction(function()
    local usernameHider = {Enabled = false}
    local mode = {Value = "DisplayName"}
    local customName = {Value = ""}
    local changedObjects = {}
    local usernameHiderConnections = {}
    local function hide(obj)
        if obj.Text:find(localPlayer.Name) then
            local originalText = obj.Text
            obj.Text = obj.Text:gsub(localPlayer.Name, (mode.Value == "DisplayName" and localPlayer.DisplayName) or customName.Value)
            changedObjects[obj] = originalText
        end
    end
    local usernameHiderToggle = Tabs.Render:CreateToggle({
        Name = "UsernameHider",
        HoverText = "Hides your username and if choosed then display name too.\nNote that this is client sided.",
        Callback = function(callback)
            if callback then
                for _, obj in next, CoreGui:GetDescendants() do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        hide(obj)
                        table.insert(usernameHiderConnections, obj:GetPropertyChangedSignal("Text"):Connect(function()
                            hide(obj)
                        end))
                    end
                end
                for _, obj in next, PlayerGui:GetDescendants() do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        hide(obj)
                        table.insert(usernameHiderConnections, obj:GetPropertyChangedSignal("Text"):Connect(function()
                            hide(obj)
                        end))
                    end
                end
                table.insert(usernameHiderConnections, game.DescendantAdded:Connect(function(obj)
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        hide(obj)
                        table.insert(usernameHiderConnections, obj:GetPropertyChangedSignal("Text"):Connect(function()
                            hide(obj)
                        end))
                    end
                end))
                table.insert(usernameHiderConnections, TextChatService.MessageReceived:Connect(function(msg)
                    hide(msg)
                end))
            else
                for _, connection in next, usernameHiderConnections do
                    betterDisconnect(connection)
                end
                usernameHiderConnections = {}
                for obj, originalText in pairs(changedObjects) do
                    if obj and obj.Parent then
                        obj.Text = originalText
                    end
                end
                changedObjects = {}
            end
        end
    })

    mode = usernameHiderToggle:CreateDropdown({
        Name = "Change to",
        List = {"DisplayName", "Custom"},
        Default = "DisplayName",
        Function = function(v)
            if customName.Container then customName.Container.Visible = v == "Custom" end
            if usernameHiderToggle.Enabled then
                usernameHiderToggle:Toggle(true)
                usernameHiderToggle:Toggle(true)
            end
        end
    })

    customName = usernameHiderToggle:CreateTextBox({
        Name = "Custom Name",
        PlaceholderText = "Custom name",
        Default = "",
        Function = function(v)
            if usernameHiderToggle.Enabled then
                for obj, _ in pairs(changedObjects) do
                    hide(obj)
                end
            end
        end
    })
    customName.Container.Visible = false
end)

runFunction(function()
    local viewClip = {Enabled = false}
    local viewClipToggle = Tabs.Render:CreateToggle({
        Name = "ViewClip",
        HoverText = "Makes your camera go through objects.",
        Callback = function(callback)
            LocalPlayer.DevCameraOcclusionMode = callback and "Invisicam" or "Zoom"
        end
    })
end)

-- ============================================
-- UTILITY TAB
-- ============================================

runFunction(function()
    local antiAFK = {Enabled = false}
    local mode = {Value = "AutoClick"}
    local connection
    local antiAFKToggle = Tabs.Utility:CreateToggle({
        Name = "AntiAFK",
        HoverText = "Makes you able to idle for inf amount of time,\nAutoClick clicks when you idle.\nDisableConnections disables connections and requires getconnections function.",
        Callback = function(callback) 
            if callback then
                if mode.Value == "AutoClick" then
                connection = localPlayer.Idled:Connect(function()
                    virtualUser:Button2Down(Vector2.new(0, 0))
                    task.wait(0.1)
                    virtualUser:Button2Up(Vector2.new(0, 0))
                end)
                elseif mode.Value == "DisableConnections" then
                    if getconnections then
                        for i,v in next, getconnections(LocalPlayer.Idled) do
                            v:Disable()
                        end
                    else
                        GuiLibrary:CreateNotification("AntiAFK", "Missing getconnections function.", 10, "Error")
                        antiAFKToggle:Toggle(true)
                    end
                end
            else
                if getconnections then
                    for i,v in next, getconnections(LocalPlayer.Idled) do
                        v:Enable()
                    end
                end
            end
        end
    })

    mode = antiAFKToggle:CreateDropdown({
        Name = "Mode",
        List = {"AutoClick", "DisableConnections"},
        Default = "AutoClick",
        Function = function(v) end
    })
end)

runFunction(function()
    local antiFling = {Enabled = false}
    local antiFlingToggle = Tabs.Utility:CreateToggle({
        Name = "AntiFling",
        HoverText = "Makes people unable to push/fling you.\nDisables collision.",
        Callback = function(callback) 
            if callback then 
                RunLoops:BindToHeartbeat("AntiFling", function()
                    for _, part in next, getCharacter():GetChildren() do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("AntiFling")
                for _, part in next, getCharacter():GetChildren() do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    })
end)

runFunction(function()
    local antiKick = {Enabled = false}
	local first = false
    local oldNameCall
    local antiKickToggle = Tabs.Utility:CreateToggle({
        Name = "AntiKick",
        HoverText = "Removes client sided kicks.\nRequires hookmetamethod function.",
        Callback = function(callback) 
            if callback then
                if hookmetamethod then
                    oldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
                        local NameCallMethod = getnamecallmethod()
        
                        if tostring(string.lower(NameCallMethod)) == "kick" and callback and not first then
                            GuiLibrary:CreateNotification("AntiKick", "Detected kick attempt.", 7, "Warning")
                            return nil
                        end
        
                        return oldNameCall(Self, ...)
                    end)
                    if not first then
                        first = true
                    end
                else
                    GuiLibrary:CreateNotification("AntiKick", "Missing hookmetamethod function.", 10, "Error")
                    antiKickToggle:Toggle(true)
                    return
                end
            end
        end
    })
end)

runFunction(function()
    local autoRejoin = {Enabled = false}
    local delay = {Value = 5}
    local sameServer = {Value = false}
    local autoRejoinToggle = Tabs.Utility:CreateToggle({
        Name = "AutoRejoin",
        HoverText = "Automatically rejoins when you get kicked for idling.",
        Callback = function(callback) 
            if callback then 
                repeat wait(delay.Value) until autoRejoinToggle.Enabled == false or #CoreGui.RobloxPromptGui.promptOverlay:GetChildren() ~= 0
                if autoRejoinToggle.Enabled and sameServer then 
                    if #Players:GetPlayers() <= 1 then
                        localPlayer:Kick("\nRejoining...")
                        task.wait()
                        teleportService:Teleport(PlaceId, localPlayer)
                    else
                        teleportService:TeleportToPlaceInstance(PlaceId, JobId, localPlayer)
                    end
                else
                    if #Players:GetPlayers() <= 1 then
                        localPlayer:Kick("\nRejoining...")
                        task.wait()
                        teleportService:Teleport(PlaceId, localPlayer)
                    end
                end
            end
        end
    })

    delay = autoRejoinToggle:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0,
        Max = 60,
        Default = 5,
        Round = 0
    })

    sameServer = autoRejoinToggle:CreateToggle({
        Name = "SameServer",
        Default = true,
        Function = function() end
    })
end)

runFunction(function()
    local cameraUnlock = {Enabled = false}
    local oldZoomDistance
    local cameraUnlockToggle = Tabs.Utility:CreateToggle({
        Name = "CameraUnlock",
        HoverText = "Makes you able to zoom out your camera very far.",
        Callback = function(callback)
            if callback then
                oldZoomDistance = localPlayer.CameraMaxZoomDistance
                localPlayer.CameraMaxZoomDistance = 99999999
            else
                localPlayer.CameraMaxZoomDistance = oldZoomDistance
            end
        end
    })
end)

runFunction(function()
    local chatSpammer = {Enabled = false}
    local mode = {Value = "Random"}
    local spamMessages = {List = {}}
    local delay = {Value = 1}
    local hideFloodMessage = {Value = false}
    local connection, max, current = nil, 0, 1
    local chatSpammerToggle = Tabs.Utility:CreateToggle({
        Name = "ChatSpammer",
        HoverText = "Automatically sends messages in chat.",
        Callback = function(callback) 
            if callback then
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    repeat
                        local msg
                        if mode.Value == "Random" then
                            if #spamMessages.List == 0 then
                                msg = "Hello world!"
                            else
                                msg = spamMessages.List[math.random(1, #spamMessages.List)]
                            end
                        elseif mode.Value == "Order" then
                            max = #spamMessages.List
                            if #spamMessages.List == 0 then
                                msg = "Hello world!"
                            end
                            if spamMessages.List[current] then
                                msg = spamMessages.List[current]
                                current = current + 1
                                if current > max then
                                    current = 1
                                end
                            else
                                current = 1
                            end
                        end
                        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
                        wait(delay.Value)
                    until not chatSpammerToggle.Enabled
                end
                if hideFloodMessage.Value then
                    local ExperienceChat = CoreGui:FindFirstChild("ExperienceChat")
                    if ExperienceChat then
                        local RCTScrollContentView = ExperienceChat:FindFirstChild("RCTScrollContentView")
                        if RCTScrollContentView then
                            connection = RCTScrollContentView.ChildAdded:Connect(function(msg)
                                if msg.ContentText == "You must wait before sending another message." then
                                    msg.Visible = false
                                end
                            end)
                        end
                    end
                end
            else
                if connection then
                    connection:Disconnect()
                end
            end
        end
    })

    mode = chatSpammerToggle:CreateDropdown({
        Name = "Mode",
        List = {"Random", "Order"},
        Default = "Random",
        Callback = function(v) end
    })

    spamMessages = chatSpammerToggle:CreateTextList({
        Name = "SpamMessages",
        PlaceholderText = "Messages to spam",
        DefaultList = {},
        Function = function(v) end,
    })

    delay = chatSpammerToggle:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0,
        Max = 10,
        Default = 1,
        Round = 1
    })

    hideFloodMessage = chatSpammerToggle:CreateToggle({
        Name = "HideFloodMessage",
        Default = false,
        Function = function(callback) end
    })
end)

runFunction(function()
    local customAnimations = {Enabled = false}
    local animations = {
        Animation1 = "idle",
        Animation2 = "idle",
        WalkAnim = "walk",
        RunAnim = "run",
        JumpAnim = "jump",
        FallAnim = "fall",
        ClimbAnim = "climb",
        SwimIdle = "swimidle",
        Swim = "swim"
    }
    local oldAnimations = {}
    local values = {}
    
    for name, path in next, animations do
        oldAnimations[name] = Animate:FindFirstChild(path):FindFirstChild(name).AnimationId
    end
    
    local customAnimationsToggle = Tabs.Utility:CreateToggle({
        Name = "CustomAnimations",
        HoverText = "Customizes your animations.",
        Callback = function(callback) 
            if callback then
                for name, path in next, animations do
                    Animate:FindFirstChild(path):FindFirstChild(name).AnimationId = values[name].Value ~= "" and (tonumber(values[name].Value) and "http://www.roblox.com/asset/?id=" .. values[name].Value or values[name].Value) or oldAnimations[name]
                end
            else
                for name, path in next, animations do
                    Animate:FindFirstChild(path):FindFirstChild(name).AnimationId = oldAnimations[name]
                end
            end
        end
    })

    for name, path in next, animations do
        values[name] = customAnimationsToggle:CreateTextBox({
            Name = name == "Animation1" and "Idle1" or name == "Animation2" and "Idle2" or name,
            PlaceholderText = name.." ID",
            DefaultValue = ""
        })
    end
end)

runFunction(function()
    local consoleCommands = {Enabled = false}
    local commandbar
    local connection
    local consoleCommandsToggle = Tabs.Utility:CreateToggle({
        Name = "ConsoleCommands",
        HoverText = "Creates a command bar in dev console.",
        Callback = function(callback)
            if callback then
                commandbar = Instance.new("Frame")
                local inputField = Instance.new("Frame")
                local textBox = Instance.new("TextBox")
                local arrow = Instance.new("TextLabel")

                commandbar.Name = "commandbar"
                commandbar.BackgroundColor3 = Color3.fromRGB(45.00000111758709, 45.00000111758709, 45.00000111758709)
                commandbar.BorderColor3 = Color3.fromRGB(184.00000423192978, 184.00000423192978, 184.00000423192978)
                commandbar.Position = UDim2.new(0, 0, 1, -30)
                commandbar.Size = UDim2.new(1, 0, 0, 30)
                commandbar.Parent = CoreGui.DevConsoleMaster.DevConsoleWindow

                inputField.Name = "inputfield"
                inputField.BackgroundTransparency = 1
                inputField.ClipsDescendants = true
                inputField.Position = UDim2.new(0, 30, 0, 0)
                inputField.Size = UDim2.new(1, -30, 0, 30)
                inputField.Parent = commandbar

                textBox.BackgroundTransparency = 1
                textBox.ClearTextOnFocus = false
                textBox.Font = Enum.Font.Code
                textBox.PlaceholderText = "command line"
                textBox.Text = ""
                textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textBox.TextSize = 15
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Size = UDim2.new(1, 0, 1, 0)
                textBox.Parent = inputField
                textBox.ZIndex = 50

                arrow.Name = "arrow"
                arrow.BackgroundTransparency = 1
                arrow.Font = Enum.Font.Code
                arrow.Text = "> "
                arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
                arrow.TextSize = 15
                arrow.TextXAlignment = Enum.TextXAlignment.Right
                arrow.Size = UDim2.new(0, 30, 1, 0)
                arrow.Parent = commandbar

                connection = table.insert(connections, textBox.FocusLost:Connect(function(enterpressed)
                    if enterpressed then
                        local suc, res = pcall(function()
                            loadstring(textBox.Text)()
                        end)
                        if not suc then
                            error(res)
                        end
                        textBox.Text = ""
                    end
                end))
            else
                commandbar:Destroy()
                betterDisconnect(connection)
            end
        end
    })
end)

runFunction(function()
    local cache = {}
    local doing = false
    local waiting
    local godModeToggle = Tabs.Utility:CreateToggle({
        Name = "GodMode",
        HoverText = "Makes it almost impossible to kill you via deleteting humanoid.\n(does not bypass good anti cheats)",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("godMode", function()
                    if isAlive() then
                        local character = getCharacter()
                        local humanoid = getHumanoid()
                        if doing or (not humanoid or (humanoid and cache[humanoid] == true)) or not character then return end
                        doing = true
                        humanoid.Name = "oldone"
                        local new = humanoid:Clone()
                        cache[new] = true
                        new.Parent = character
                        new.Name = "Humanoid"
                        humanoid:Destroy()
                        Camera.CameraSubject = character
                        local animate = character:FindFirstChild("Animate")
                        waiting = tick()
                        repeat
                            task.wait()
                        until animate or tick() - waiting > 5
                        if not animate then
                            cache[new] = false
                            GuiLibrary:CreateNotification("GodMode", "Couldn't find animate script.", 5, "Error")
                        end
                        if animate then animate.Disabled = true end
                        task.wait(0.1)
                        if animate then animate.Disabled = false end
                        doing = false
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("godMode")
                GuiLibrary:CreateNotification("GodMode", "Reset to get humanoid back.", 5, "Info")
                cache = {}
            end
        end
    })
end)

runFunction(function()
    local fastProximityPrompts = {Enabled = false}
    local duration = {Value = 0.1}
    local objects = {}
    local fastProximityPromptsToggle = Tabs.Utility:CreateToggle({
        Name = "FastProximityPrompts",
        HoverText = "Makes you able to customize proximity prompt hold duration.",
        Callback = function(callback)
            if callback then
                for _, ProximityObject in pairs(workspace:GetDescendants()) do
                    if ProximityObject:IsA("ProximityPrompt") then
                        objects[ProximityObject] = ProximityObject.HoldDuration
                        ProximityObject.HoldDuration = duration.Value
                    end
                end
            else
                for ProximityObject, OriginalHoldDuration in pairs(objects) do
                    if ProximityObject:IsA("ProximityPrompt") then
                        ProximityObject.HoldDuration = OriginalHoldDuration
                    end
                end
                table.clear(objects)
            end
        end
    })

    duration = fastProximityPromptsToggle:CreateSlider({
        Name = "HoldDuration",
        Function = function(v)
            if fastProximityPromptsToggle.Enabled then
                for _, Object in pairs(workspace:GetDescendants()) do
                    if Object:IsA("ProximityPrompt") then
                        Object.HoldDuration = duration.Value
                    end
                end
            end
        end,
        Min = 0,
        Max = 10,
        Default = 0,
        Round = 1
    })
end)

runFunction(function()
    local fpsUnlocker = {Enabled = false}
    local fpsUnlockerToggle = Tabs.Utility:CreateToggle({
        Name = "FPSUnlocker",
        HoverText = "Unlocks your FPS.",
        Callback = function(callback)
            if callback then
                if setfpscap then
                    setfpscap(10000000)
                else
                    GuiLibrary:CreateNotification("FPSUnlocker", "Missing setfpscap function.", 10, "Error")
                    fpsUnlockerToggle:Toggle(true)
                    return
                end
            end
        end
    })
end)

runFunction(function()
    local infiniteJump = {Enabled = false}
    local connection
    local infiniteJumpToggle = Tabs.Utility:CreateToggle({
        Name = "InfinityJump",
        HoverText  = "Allows you to jump infinitely.",
        Callback = function(callback) 
            if callback then 
                connection = UserInputService.JumpRequest:Connect(function()
                    if callback then
                        getHumanoid():ChangeState(3)
                    end
                end)
            else
                betterDisconnect(connection)
            end
        end
    })
end)

runFunction(function()
    local panic = {Enabled = false}
    local panicToggle = Tabs.Utility:CreateToggle({
        Name = "Panic",
        HoverText = "Disables all toggles.\nNote that it disables saving, to start it again reinject.",
        Callback = function(callback)
            if callback then
                GuiLibrary.CanSaveConfig = false
                if GuiLibrary and GuiLibrary.ObjectsToSave and GuiLibrary.ObjectsToSave.Toggles then
                    for _, table in next, GuiLibrary.ObjectsToSave.Toggles do
                        if table.API and table.API.Enabled and table.API.Name ~= "Panic" then
                            table.API:Toggle(false)
                        end
                    end
                end
                -- Panic остается включенным
            end
        end
    })
end)

runFunction(function()
    local reset = {Enabled = false}
    local resetToggle = Tabs.Utility:CreateToggle({
        Name = "Reset",
        HoverText = "Resets your character.",
        Callback = function(callback)
            if callback then
                if isAlive() then
                    local humanoid = getHumanoid()
                    humanoid:TakeDamage(humanoid.MaxHealth)
                end
                resetToggle:Toggle(false)
            end
        end
    })
end)

runFunction(function()
    local rejoin = {Enabled = false}
    local rejoinToggle = Tabs.Utility:CreateToggle({
        Name = "Rejoin",
        HoverText = "Rejoins the same game to the same server.",
        Callback = function(callback) 
            if callback then 
                rejoinToggle:Toggle(false)
                teleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
            end
        end
    })
end)

runFunction(function()
    local serverHop = {Enabled = false}
    local serverHopToggle = Tabs.Utility:CreateToggle({
        Name = "ServerHop",
        HoverText = "Joins the same game but to the different server.",
        Callback = function(callback) 
            if callback then 
                serverHopToggle:Toggle(false)
                teleportService:Teleport(PlaceId)
            end
        end
    })
end)

-- ============================================
-- WORLD TAB
-- ============================================

runFunction(function()
    local antiVoid = {Enabled = false}
    local mode = {Value = "Jump"}
    local delay = {Value = 0.1}
    local bounceForce = {Value = 150}
    local tpToSpawnLocation = {Value = false}
    local LastSafePosition = nil
    local IsBeingRescued = false
    local AntiVoidPlatform = nil
    local voidYpos = -200
    local oldjumppower
    local connection

    local function isOnGround()
        if not isAlive() then return false end
        
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return false end
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local result = workspace:Raycast(
            rootPart.Position,
            Vector3.new(0, -10, 0),
            rayParams
        )
        
        return result ~= nil and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
    end
    
    local function savePosition()
        if not isAlive() or not isOnGround() then return end
        
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        LastSafePosition = rootPart.CFrame
    end
    
    local function RescueFromVoid()
        local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        oldjumppower = Humanoid.JumpPower
        if not isAlive() or IsBeingRescued then return end
        
        if RootPart.Position.Y <= voidYpos then
            IsBeingRescued = true
            
            if mode.Value == "Jump" and AntiVoidPlatform then
                AntiVoidPlatform.CFrame = CFrame.new(RootPart.Position.X, voidYpos, RootPart.Position.Z)
                
                Humanoid.JumpPower = bounceForce.Value
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            else
                if LastSafePosition then
                    RootPart.CFrame = LastSafePosition
                    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                else
                    local spawnLocation = nil
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("SpawnLocation") and obj.Enabled then
                            spawnLocation = obj
                            break
                        end
                    end
                    
                    if spawnLocation and tpToSpawnLocation.Value then
                        RootPart.CFrame = spawnLocation.CFrame * CFrame.new(0, 5, 0)
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    else
                        RootPart.CFrame = CFrame.new(RootPart.Position.X, math.abs(voidYpos), RootPart.Position.Z)
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
            
            task.delay(delay.Value, function()
                Humanoid.JumpPower = oldjumppower
                IsBeingRescued = false
            end)
        end
    end

    local antiVoidToggle = Tabs.World:CreateToggle({
        Name = "AntiVoid",
        HoverText = "Makes you unable to fall into the void.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AntiVoid", function()
                    if mode.Value == "Jump" then
                        if not AntiVoidPlatform then
                            AntiVoidPlatform = Instance.new("Part")
                            AntiVoidPlatform.Name = "AntiVoidPlatform"
                            AntiVoidPlatform.Size = Vector3.new(400, 1, 400)
                            AntiVoidPlatform.Anchored = true
                            AntiVoidPlatform.CanCollide = true
                            AntiVoidPlatform.Transparency = 1
                            AntiVoidPlatform.Parent = workspace
                        end
                    end
                end)
                connection = RunService.Stepped:Connect(function(deltaTime)
                    local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if antiVoidToggle.Enabled then
                        savePosition(deltaTime)
                        RescueFromVoid()
                        
                        if mode.Value == "Jump" and AntiVoidPlatform and RootPart and RootPart.Position.Y > (voidYpos + math.abs(voidYpos)) then
                            AntiVoidPlatform.CFrame = CFrame.new(RootPart.Position.X, voidYpos - 50, RootPart.Position.Z)
                        end
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AntiVoid")
                if AntiVoidPlatform then
                    AntiVoidPlatform:Destroy()
                end
                betterDisconnect(connection)
            end
        end
    })

    mode = antiVoidToggle:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Jump", "Teleport"},
        Default = "Jump"
    })

    delay = antiVoidToggle:CreateSlider({
        Name = "PosCheckDelay",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0.1,
        Round = 1
    })

    bounceForce = antiVoidToggle:CreateSlider({
        Name = "Bounce Force",
        Function = function(v) end,
        Min = 0,
        Max = 500,
        Default = 150,
        Round = 0
    })

    tpToSpawnLocation = antiVoidToggle:CreateToggle({
        Name = "TP to Spawn Location",
        Default = false,
        Function = function(v) end
    })
end)

runFunction(function()
    local atmosphereModule = {Enabled = false}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local decay = {Value = Color3.fromRGB(255, 255, 255)}
    local density = {Value = 0.5}
    local glare = {Value = 0.5}
    local haze = {Value = 0.5}
    local offset = {Value = 0.5}
    local atmosphere
    local old = {}

    local atmosphereToggle = Tabs.World:CreateToggle({
        Name = "Atmopshere",
        HoverText = "Customizes the atmosphere of the game.",
        Callback = function(callback)
            if callback then
                for i, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then
                        table.insert(old, v)
                        v.Parent = game
                    end
                end
                atmosphere = Instance.new("Atmosphere")
                atmosphere.Color = color.Value
                atmosphere.Decay = decay.Value
                atmosphere.Density = density.Value
                atmosphere.Glare = glare.Value
                atmosphere.Haze = haze.Value
                atmosphere.Offset = offset.Value
                atmosphere.Parent = Lighting

                Lighting.LightingChanged:Connect(function()
                    if Lighting:FindFirstChild("Atmosphere") then
                        local atmosphere = Lighting:FindFirstChild("Atmosphere")
                        atmosphere.Color = color.Value
                        atmosphere.Decay = decay.Value
                        atmosphere.Density = density.Value
                        atmosphere.Glare = glare.Value
                        atmosphere.Haze = haze.Value
                        atmosphere.Offset = offset.Value
                    else
                        atmosphere = Instance.new("Atmosphere")
                        atmosphere.Color = color.Value
                        atmosphere.Decay = decay.Value
                        atmosphere.Density = density.Value
                        atmosphere.Glare = glare.Value
                        atmosphere.Haze = haze.Value
                        atmosphere.Offset = offset.Value
                        atmosphere.Parent = Lighting
                    end
                end)
            else
                if atmosphere then
                    atmosphere:Destroy()
                end
                for i, v in pairs(old) do
                    v.Parent = Lighting
                end
                table.clear(old)
            end
        end
    })

    color = atmosphereToggle:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if atmosphere then
                atmosphere.Color = v
            end
        end
    })

    decay = atmosphereToggle:CreateColorSlider({
        Name = "Decay",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if atmosphere then
                atmosphere.Decay = v
            end
        end
    })

    density = atmosphereToggle:CreateSlider({
        Name = "Density",
        Function = function(v)
            if atmosphere then
                atmosphere.Density = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 3
    })

    glare = atmosphereToggle:CreateSlider({
        Name = "Glare",
        Function = function(v)
            if atmosphere then
                atmosphere.Glare = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 5,
        Round = 2
    })

    haze = atmosphereToggle:CreateSlider({
        Name = "Haze",
        Function = function(v)
            if atmosphere then
                atmosphere.Haze = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 5,
        Round = 2
    })

    offset = atmosphereToggle:CreateSlider({
        Name = "Offset",
        Function = function(v)
            if atmosphere then
                atmosphere.Offset = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 3
    })
end)

runFunction(function()
    local gravity = {Enabled = false}
    local value = {Value = 18}
    local oldGravity
    local gravityToggle = Tabs.World:CreateToggle({
        Name = "Gravity",
        HoverText = "Changes the game gravity.",
        Callback = function(callback)
            if callback then
                oldGravity = workspace.Gravity
                workspace.Gravity = value.Value
            else
                workspace.Gravity = oldGravity
            end
        end
    })
    
    value = gravityToggle:CreateSlider({
        Name = "Gravity",
        Function = function(v)
            if gravityToggle.Enabled then
                workspace.Gravity = v
            end
        end,
        Min = 1,
        Max = 200,
        Default = 196,
        Round = 0
    })
end)

runFunction(function()
    local customLighting = {Enabled = false}
    local oldLighting = {
        ShadowSoftness = Lighting.ShadowSoftness,
        Brightness = Lighting.Brightness
    }
    local shadowSoftness = {Value = 1}
    local brightness = {Value = 1}
    local sunRaysIntensity = {Value = 1}
    local spread = {Value = 1}
    local bloomIntensity = {Value = 1}
    local bloomSize = {Value = 1}
    local bloomObject
    local sunRaysObject
    local oldLightingObjects = {}
    local connection

    local customLightingToggle = Tabs.World:CreateToggle({
        Name = "Lighting",
        HoverText = "Customizes the lighting of the game.",
        Callback = function(callback)
            if callback then
                Lighting.ShadowSoftness = shadowSoftness.Value
                Lighting.Brightness = brightness.Value
                for i,v in pairs(Lighting:GetChildren()) do
					if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
						table.insert(oldLightingObjects, v)
						v.Parent = game
					end
				end
                bloomObject = Instance.new("BloomEffect")
                bloomObject.Name = "BloomObject"
                bloomObject.Parent = Lighting
                bloomObject.Intensity = bloomIntensity.Value
                bloomObject.Size = bloomSize.Value
                
                sunRaysObject = Instance.new("SunRaysEffect")
                sunRaysObject.Name = "SunRaysObject"
                sunRaysObject.Parent = Lighting
                sunRaysObject.Intensity = sunRaysIntensity.Value
                sunRaysObject.Spread = spread.Value

                connection = Lighting.LightingChanged:Connect(function()
                    if Lighting:FindFirstChild("BloomObject") then
                        local BloomObject = Lighting:FindFirstChild("BloomObject")
                        BloomObject.Parent = Lighting
                        BloomObject.Intensity = bloomIntensity.Value
                        BloomObject.Size = bloomSize.Value
                    else
                        bloomObject = Instance.new("BloomEffect")
                        bloomObject.Name = "BloomObject"
                        bloomObject.Parent = Lighting
                        bloomObject.Intensity = bloomIntensity.Value
                        bloomObject.Size = bloomSize.Value
                    end

                    if Lighting:FindFirstChild("SunRaysObject") then
                        local sunRaysObject = Lighting:FindFirstChild("SunRaysObject")
                        sunRaysObject = Instance.new("SunRaysEffect")
                        sunRaysObject.Name = "SunRaysObject"
                        sunRaysObject.Parent = Lighting
                        sunRaysObject.Intensity = sunRaysIntensity.Value
                        sunRaysObject.Spread = spread.Value
                    else
                        sunRaysObject = Instance.new("SunRaysEffect")
                        sunRaysObject.Name = "SunRaysObject"
                        sunRaysObject.Parent = Lighting
                        sunRaysObject.Intensity = sunRaysIntensity.Value
                        sunRaysObject.Spread = spread.Value
                    end
                end)
            else
                connection:Disconnect()
                Lighting.ShadowSoftness = oldLighting.ShadowSoftness
                Lighting.Brightness = oldLighting.Brightness
                if bloomObject then bloomObject:Destroy() end
                if sunRaysObject then sunRaysObject:Destroy() end
				for i,v in pairs(oldLightingObjects) do
					v.Parent = Lighting
				end
				table.clear(oldLightingObjects)
            end
        end
    })

    shadowSoftness = customLightingToggle:CreateSlider({
        Name = "ShadowSoftness",
        Function = function(v) 
            if customLightingToggle.Enabled then
                Lighting.ShadowSoftness = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 1
    })

    brightness = customLightingToggle:CreateSlider({
        Name = "Brightness",
        Function = function(v) 
            if customLightingToggle.Enabled then
                Lighting.Brightness = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 3,
        Round = 1
    })

    sunRaysIntensity = customLightingToggle:CreateSlider({
        Name = "SunRays Intensity",
        Function = function(v) 
            if customLightingToggle.Enabled then
                sunRaysObject.Intensity = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })

    spread = customLightingToggle:CreateSlider({
        Name = "SunRays Spread",
        Function = function(v) 
            if customLightingToggle.Enabled then
                sunRaysObject.Spread = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })

    bloomIntensity = customLightingToggle:CreateSlider({
        Name = "Bloom Intensity",
        Function = function(v) 
            if customLightingToggle.Enabled then
                bloomObject.Intensity = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 2
    })

    bloomSize = customLightingToggle:CreateSlider({
        Name = "Bloom Size",
        Function = function(v) 
            if customLightingToggle.Enabled then
                bloomObject.Size = v
            end
        end,
        Min = 0,
        Max = 56,
        Default = 56,
        Round = 0
    })
end)

runFunction(function()
    local customSky = {Enabled = false}
    local up = {Value = ""}
    local down = {Value = ""}
    local left = {Value = ""}
    local right = {Value = ""}
    local front = {Value = ""}
    local back = {Value = ""}
    local sun = {Value = ""}
    local sunSize = {Value = 11}
    local moon = {Value = ""}
    local moonSize = {Value = 11}
    local oldSkyObjects = {}
    local skyObject
    local connection

    local customSkyToggle = Tabs.World:CreateToggle({
        Name = "Sky",
        HoverText = "Customizes the sky of the game.",
        Callback = function(callback)
            if callback then
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("PostEffect") or (v:IsA("Sky") and v.Name ~= "SkyObject") then
                        table.insert(oldSkyObjects, v)
                        v.Parent = game
                    end
                end

                skyObject = Instance.new("Sky")
                skyObject.Name = "SkyObject"
                skyObject.Parent = Lighting
                skyObject.SkyboxBk = "rbxassetid://" .. back.Value
                skyObject.SkyboxDn = "rbxassetid://" .. down.Value
                skyObject.SkyboxFt = "rbxassetid://" .. front.Value
                skyObject.SkyboxLf = "rbxassetid://" .. left.Value
                skyObject.SkyboxRt = "rbxassetid://" .. right.Value
                skyObject.SkyboxUp = "rbxassetid://" .. up.Value
                skyObject.SunTextureId = "rbxassetid://" .. sun.Value
                skyObject.MoonTextureId = "rbxassetid://" .. moon.Value
                skyObject.SunAngularSize = sunSize.Value
                skyObject.MoonAngularSize = moonSize.Value

                connection = skyObject.Changed:Connect(function()
                    skyObject.Name = "SkyObject"
                    skyObject.Parent = Lighting
                    skyObject.SkyboxBk = "rbxassetid://" .. back.Value
                    skyObject.SkyboxDn = "rbxassetid://" .. down.Value
                    skyObject.SkyboxFt = "rbxassetid://" .. front.Value
                    skyObject.SkyboxLf = "rbxassetid://" .. left.Value
                    skyObject.SkyboxRt = "rbxassetid://" .. right.Value
                    skyObject.SkyboxUp = "rbxassetid://" .. up.Value
                    skyObject.SunTextureId = "rbxassetid://" .. sun.Value
                    skyObject.MoonTextureId = "rbxassetid://" .. moon.Value
                    skyObject.SunAngularSize = sunSize.Value
                    skyObject.MoonAngularSize = moonSize.Value
                end)
            else
                betterDisconnect(connection)
                if skyObject then skyObject:Destroy() end
                for _, v in pairs(oldSkyObjects) do
                    v.Parent = Lighting
                end
                table.clear(oldSkyObjects)
            end
        end
    })

    back = customSkyToggle:CreateTextBox({
        Name = "SkyBack",
        PlaceholderText = "Sky Back ID",
        DefaultValue = "6444884337",
        Function = function(v) back.Value = v end,
    })

    down = customSkyToggle:CreateTextBox({
        Name = "SkyDown",
        PlaceholderText = "Sky Down ID",
        DefaultValue = "6444884785",
        Function = function(v) down.Value = v end,
    })

    front = customSkyToggle:CreateTextBox({
        Name = "SkyFront",
        PlaceholderText = "Sky Front ID",
        DefaultValue = "6444884337",
        Function = function(v) front.Value = v end,
    })

    left = customSkyToggle:CreateTextBox({
        Name = "SkyLeft",
        PlaceholderText = "Sky Left ID",
        DefaultValue = "6444884337",
        Function = function(v) left.Value = v end,
    })

    right = customSkyToggle:CreateTextBox({
        Name = "SkyRight",
        PlaceholderText = "Sky Right ID",
        DefaultValue = "6444884337",
        Function = function(v) right.Value = v end,
    })

    up = customSkyToggle:CreateTextBox({
        Name = "SkyUp",
        PlaceholderText = "Sky Up ID",
        DefaultValue = "6412503613",
        Function = function(v) up.Value = v end,
    })

    sun = customSkyToggle:CreateTextBox({
        Name = "SkySun",
        PlaceholderText = "Sky Sun ID",
        DefaultValue = "6196665106",
        Function = function(v) sun.Value = v end,
    })

    moon = customSkyToggle:CreateTextBox({
        Name = "SkyMoon",
        PlaceholderText = "Sky Moon ID",
        DefaultValue = "6444320592",
        Function = function(v) moon.Value = v end,
    })

    sunSize = customSkyToggle:CreateSlider({
        Name = "SunSize",
        Function = function(v)
            sunSize.Value = v
            if customSkyToggle.Enabled and skyObject then
                skyObject.SunAngularSize = v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 11,
        Round = 0
    })

    moonSize = customSkyToggle:CreateSlider({
        Name = "MoonSize",
        Function = function(v)
            moonSize.Value = v
            if customSkyToggle.Enabled and skyObject then
                skyObject.MoonAngularSize = v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 11,
        Round = 0
    })
end)

runFunction(function()
    local timeOfDay = {Enabled = false}
    local hours = {Value = 13}
    local minutes = {Value = 0}
    local seconds = {Value = 0}
    local connection
    local oldTime
    local function updateTime()
        Lighting.TimeOfDay = hours.Value..":"..minutes.Value..":"..seconds.Value
    end
    local timeOfDayToggle = Tabs.World:CreateToggle({
        Name = "TimeOfDay",
        HoverText = "Customizes the time of the game.",
        Callback = function(callback)
            if callback then
                oldTime = Lighting.TimeOfDay
                updateTime()
                connection = Lighting.Changed:Connect(updateTime())
            else
                Lighting.TimeOfDay = oldTime
                betterDisconnect(connection)
            end
        end
    })

    hours = timeOfDayToggle:CreateSlider({
        Name = "Hours",
        Function = function(v)
            if timeOfDayToggle.Enabled then
                updateTime()
            end
        end,
        Min = 0,
        Max = 24,
        Default = 13,
        Round = 0
    })

    minutes = timeOfDayToggle:CreateSlider({
        Name = "Minutes",
        Function = function(v)
            if timeOfDayToggle.Enabled then
                updateTime()
            end
        end,
        Min = 0,
        Max = 60,
        Default = 0,
        Round = 0
    })

    seconds = timeOfDayToggle:CreateSlider({
        Name = "Seconds",
        Function = function(v)
            if timeOfDayToggle.Enabled then
                updateTime()
            end
        end,
        Min = 0,
        Max = 60,
        Default = 0,
        Round = 0
    })
end)

-- ============================================
-- ФУНКЦИИ ДЛЯ expensive-gui.lua
-- ============================================

local Universal = {}

Universal.StartKillAura = function()
    -- Логика KillAura из Universal
    print("[Universal]: KillAura started")
end

Universal.StopKillAura = function()
    print("[Universal]: KillAura stopped")
end

Universal.StartSpeed = function()
    -- Логика Speed
    print("[Universal]: Speed started")
end

Universal.StopSpeed = function()
    print("[Universal]: Speed stopped")
end

Universal.StartInfinityJump = function()
    _G.infinjump = true
    print("[Universal]: InfinityJump started")
end

Universal.StopInfinityJump = function()
    _G.infinjump = false
    print("[Universal]: InfinityJump stopped")
end

Universal.StartFly = function()
    print("[Universal]: Fly started")
end

Universal.StopFly = function()
    print("[Universal]: Fly stopped")
end

Universal.StartPhase = function()
    print("[Universal]: Phase started")
end

Universal.StopPhase = function()
    print("[Universal]: Phase stopped")
end

Universal.StartSpinBot = function()
    print("[Universal]: SpinBot started")
end

Universal.StopSpinBot = function()
    print("[Universal]: SpinBot stopped")
end

Universal.StartFullbright = function()
    print("[Universal]: Fullbright started")
end

Universal.StopFullbright = function()
    print("[Universal]: Fullbright stopped")
end

Universal.StartFOVChanger = function()
    print("[Universal]: FOVChanger started")
end

Universal.StopFOVChanger = function()
    print("[Universal]: FOVChanger stopped")
end

Universal.StartNameTags = function()
    print("[Universal]: NameTags started")
end

Universal.StopNameTags = function()
    print("[Universal]: NameTags stopped")
end

Universal.StartBreadcrumbs = function()
    print("[Universal]: Breadcrumbs started")
end

Universal.StopBreadcrumbs = function()
    print("[Universal]: Breadcrumbs stopped")
end

Universal.StartChinaHat = function()
    print("[Universal]: ChinaHat started")
end

Universal.StopChinaHat = function()
    print("[Universal]: ChinaHat stopped")
end

Universal.StartCrossHair = function()
    print("[Universal]: CrossHair started")
end

Universal.StopCrossHair = function()
    print("[Universal]: CrossHair stopped")
end

Universal.StartRainbowSkin = function()
    print("[Universal]: RainbowSkin started")
end

Universal.StopRainbowSkin = function()
    print("[Universal]: RainbowSkin stopped")
end

Universal.StartSnowing = function()
    print("[Universal]: Snowing started")
end

Universal.StopSnowing = function()
    print("[Universal]: Snowing stopped")
end

Universal.StartSoundPlayer = function()
    print("[Universal]: SoundPlayer started")
end

Universal.StopSoundPlayer = function()
    print("[Universal]: SoundPlayer stopped")
end

Universal.StartSpawnESP = function()
    print("[Universal]: SpawnESP started")
end

Universal.StopSpawnESP = function()
    print("[Universal]: SpawnESP stopped")
end

Universal.StartUsernameHider = function()
    print("[Universal]: UsernameHider started")
end

Universal.StopUsernameHider = function()
    print("[Universal]: UsernameHider stopped")
end

Universal.StartViewClip = function()
    print("[Universal]: ViewClip started")
end

Universal.StopViewClip = function()
    print("[Universal]: ViewClip stopped")
end

Universal.StartAntiVoid = function()
    print("[Universal]: AntiVoid started")
end

Universal.StopAntiVoid = function()
    print("[Universal]: AntiVoid stopped")
end

Universal.StartAtmosphere = function()
    print("[Universal]: Atmosphere started")
end

Universal.StopAtmosphere = function()
    print("[Universal]: Atmosphere stopped")
end

Universal.StartGravity = function()
    print("[Universal]: Gravity started")
end

Universal.StopGravity = function()
    print("[Universal]: Gravity stopped")
end

Universal.StartLighting = function()
    print("[Universal]: Lighting started")
end

Universal.StopLighting = function()
    print("[Universal]: Lighting stopped")
end

Universal.StartSky = function()
    print("[Universal]: Sky started")
end

Universal.StopSky = function()
    print("[Universal]: Sky stopped")
end

Universal.StartTimeOfDay = function()
    print("[Universal]: TimeOfDay started")
end

Universal.StopTimeOfDay = function()
    print("[Universal]: TimeOfDay stopped")
end

Universal.StartAntiAFK = function()
    print("[Universal]: AntiAFK started")
end

Universal.StopAntiAFK = function()
    print("[Universal]: AntiAFK stopped")
end

Universal.StartAntiFling = function()
    print("[Universal]: AntiFling started")
end

Universal.StopAntiFling = function()
    print("[Universal]: AntiFling stopped")
end

Universal.StartAntiKick = function()
    print("[Universal]: AntiKick started")
end

Universal.StopAntiKick = function()
    print("[Universal]: AntiKick stopped")
end

Universal.StartAutoRejoin = function()
    print("[Universal]: AutoRejoin started")
end

Universal.StopAutoRejoin = function()
    print("[Universal]: AutoRejoin stopped")
end

Universal.StartCameraUnlock = function()
    print("[Universal]: CameraUnlock started")
end

Universal.StopCameraUnlock = function()
    print("[Universal]: CameraUnlock stopped")
end

Universal.StartChatSpammer = function()
    print("[Universal]: ChatSpammer started")
end

Universal.StopChatSpammer = function()
    print("[Universal]: ChatSpammer stopped")
end

Universal.StartCustomAnimations = function()
    print("[Universal]: CustomAnimations started")
end

Universal.StopCustomAnimations = function()
    print("[Universal]: CustomAnimations stopped")
end

Universal.StartConsoleCommands = function()
    print("[Universal]: ConsoleCommands started")
end

Universal.StopConsoleCommands = function()
    print("[Universal]: ConsoleCommands stopped")
end

Universal.StartFPSUnlocker = function()
    print("[Universal]: FPSUnlocker started")
end

Universal.StopFPSUnlocker = function()
    print("[Universal]: FPSUnlocker stopped")
end

print("[Universal.lua]: Loaded in " .. tostring(tick() - startTick) .. " seconds.")

task.spawn(function()
    repeat task.wait() until GuiLibrary and GuiLibrary.ConfigLoaded
    GuiLibrary:CreateNotification("Universal", "Loaded successfully! Press RightShift to open GUI.", 5, "Info")
end)

return Universal
