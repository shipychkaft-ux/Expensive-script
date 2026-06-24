-- GuiLibrary.lua
-- Базовый движок GUI

local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local textService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local guilibrary = {}

-- ============================================
-- ПАЛИТРА ЦВЕТОВ
-- ============================================
local guipallet = {
    Color1 = Color3.fromRGB(14, 14, 23),
    Color2 = Color3.fromRGB(47, 48, 64),
    Color3 = Color3.fromRGB(66, 68, 66),
    ToggleColor = Color3.fromRGB(0, 0, 0),
    ToggleColor2 = Color3.fromRGB(52, 235, 58),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Arial,
    PlaceholderColor = Color3.fromRGB(128, 128, 128)
}
guilibrary.GuiPallet = guipallet

-- ============================================
-- СОЗДАНИЕ GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Expensive"
ScreenGui.DisplayOrder = 999
ScreenGui.Enabled = true

local ClickGui = Instance.new("Frame", ScreenGui)
ClickGui.Name = "ClickGui"
ClickGui.BackgroundTransparency = 1
ClickGui.Size = UDim2.new(1, 0, 1, 0)

local notificationsGui = Instance.new("Folder", ScreenGui)
notificationsGui.Name = "Notifications"

local hoverTextGui = Instance.new("Folder", ScreenGui)
hoverTextGui.Name = "HoverTexts"

guilibrary.ScreenGui = ScreenGui
guilibrary.ClickGui = ClickGui
guilibrary.ObjectsToSave = {
    Tabs = {},
    Toggles = {},
    Options = {}
}
guilibrary.CanSaveConfig = true

local connections = {}

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

function guilibrary:CreateNotification(title, text, duration, mode)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Position = UDim2.new(0.7, 0, 0.8, 0)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notif.BorderSizePixel = 0
    notif.Parent = notificationsGui
    
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 6)
    
    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = guipallet.Font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local textLabel = Instance.new("TextLabel", notif)
    textLabel.Size = UDim2.new(1, 0, 0, 25)
    textLabel.Position = UDim2.new(0, 10, 0, 30)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or ""
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.TextSize = 14
    textLabel.Font = guipallet.Font
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    task.delay(duration or 3, function()
        notif:Destroy()
    end)
end

-- ============================================
-- DRAG FUNCTION
-- ============================================
local function dragGUI(gui)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================
-- CREATE WINDOW
-- ============================================
function guilibrary:CreateWindow()
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "Tabs"
    tabsFrame.Parent = ClickGui
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
    tabsFrame.Size = UDim2.new(1, 0, 1, 0)
    guilibrary.TabsFrame = tabsFrame
    
    return guilibrary
end

-- ============================================
-- CREATE TAB
-- ============================================
function guilibrary:CreateTab(argstable)
    local tabname = argstable.Name
    local color = argstable.Color or Color3.fromRGB(83, 214, 110)
    local tabsFrame = guilibrary.TabsFrame
    
    local tabtable = {
        Name = tabname,
        BaseColor = color,
        Toggles = {}
    }
    
    local tab = Instance.new("TextButton")
    tab.Name = tabname
    tab.Parent = tabsFrame
    tab.BackgroundColor3 = guipallet.Color1
    tab.BorderSizePixel = 0
    tab.Position = UDim2.new(0, 40, 0, 40)
    tab.Size = UDim2.new(0, 207, 0, 35)
    tab.Text = ""
    tab.Visible = false
    tab.AutoButtonColor = false
    tabtable.Container = tab
    dragGUI(tab)
    
    local tabtext = Instance.new("TextLabel")
    tabtext.Name = "tabName"
    tabtext.Parent = tab
    tabtext.BackgroundColor3 = guipallet.Color1
    tabtext.BorderSizePixel = 0
    tabtext.Position = UDim2.new(0, 0, 0, 3)
    tabtext.Size = UDim2.new(0, 207, 0, 29)
    tabtext.Font = guipallet.Font
    tabtext.Text = " " .. tabname
    tabtext.TextColor3 = color
    tabtext.TextSize = 22
    tabtext.TextXAlignment = Enum.TextXAlignment.Left
    
    local frame = Instance.new("ScrollingFrame")
    frame.Name = "TabToggles"
    frame.Parent = tab
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 0, 1, 0)
    frame.Size = UDim2.new(0, 207, 0, 600)
    frame.ScrollBarThickness = 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.ClipsDescendants = true
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = frame
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 0)
    
    -- ============================================
    -- CREATE TOGGLE
    -- ============================================
    function tabtable:CreateToggle(argstable)
        local name = argstable.Name
        local hoverText = argstable.HoverText
        local value = argstable.Default or false
        local callback = argstable.Callback or function() end
        
        local ToggleTable = {
            Name = name,
            Enabled = false,
            Callback = callback,
            Toggle = function(self, bool)
                bool = (bool == nil) and (not self.Enabled) or bool
                if bool == self.Enabled then return end
                self.Enabled = bool
                
                if bool then
                    toggle.BackgroundColor3 = color
                else
                    toggle.BackgroundColor3 = guipallet.ToggleColor
                end
                
                callback(bool)
            end,
            ReToggle = function(self)
                self:Toggle(true)
                self:Toggle(true)
            end
        }
        
        local toggle = Instance.new("TextButton")
        toggle.Name = name
        toggle.Parent = frame
        toggle.BackgroundColor3 = guipallet.ToggleColor
        toggle.BorderSizePixel = 0
        toggle.Size = UDim2.new(0, 207, 0, 40)
        toggle.Text = ""
        toggle.AutoButtonColor = false
        
        local togname = Instance.new("TextLabel")
        togname.Parent = toggle
        togname.BackgroundTransparency = 1
        togname.BorderSizePixel = 0
        togname.Position = UDim2.new(0.0338, 0, 0.163, 0)
        togname.Size = UDim2.new(0, 192, 0, 26)
        togname.Font = guipallet.Font
        togname.Text = name
        togname.TextColor3 = guipallet.TextColor
        togname.TextSize = 22
        togname.TextXAlignment = Enum.TextXAlignment.Left
        
        local optionsframebutton = Instance.new("ImageButton")
        optionsframebutton.Name = "OptionsFrameButton"
        optionsframebutton.Parent = toggle
        optionsframebutton.Position = UDim2.new(0, 175, 0, 2)
        optionsframebutton.Size = UDim2.new(0, 32, 0, 32)
        optionsframebutton.BackgroundTransparency = 1
        optionsframebutton.Image = "rbxassetid://17876016380"
        optionsframebutton.Rotation = 90
        
        local optionframe = Instance.new("Frame")
        optionframe.Name = name.."OptionFrame"
        optionframe.Parent = frame
        optionframe.BackgroundColor3 = guipallet.Color2
        optionframe.Size = UDim2.new(1, 0, 0, 0)
        optionframe.AutomaticSize = "Y"
        optionframe.Visible = false
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = optionframe
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
        
        ToggleTable.optionsFrame = optionframe
        ToggleTable.MainObject = toggle
        
        toggle.MouseButton1Click:Connect(function()
            ToggleTable:Toggle()
        end)
        
        optionsframebutton.MouseButton1Click:Connect(function()
            optionframe.Visible = not optionframe.Visible
        end)
        
        -- Сохраняем для Panic
        table.insert(guilibrary.ObjectsToSave.Toggles, {API = ToggleTable})
        
        -- ============================================
        -- CREATE SLIDER
        -- ============================================
        function ToggleTable:CreateSlider(argstable)
            local name = argstable.Name
            local value = argstable.Default or argstable.Min
            local min = argstable.Min
            local max = argstable.Max
            local round = argstable.Round or 0
            local callback = argstable.Callback or function() end
            
            local sliderapi = {
                Name = name,
                Value = value,
                Callback = callback,
                Set = function(self, val)
                    local SizeValue = math.floor((math.clamp(val, min, max) * (10 ^ round)) + 0.5) / (10 ^ round)
                    self.Value = SizeValue
                    slider_2.Size = UDim2.new((SizeValue - min) / (max - min), 0, 1, 0)
                    slidertext.Text = name .. ": " .. SizeValue
                    callback(SizeValue)
                end
            }
            
            local slider = Instance.new("TextButton")
            slider.Name = name
            slider.Parent = optionframe
            slider.BackgroundColor3 = guipallet.Color2
            slider.BorderSizePixel = 0
            slider.Size = UDim2.new(0, 180, 0, 34)
            slider.Text = ""
            slider.AutoButtonColor = false
            
            local slidertext = Instance.new("TextLabel")
            slidertext.Parent = slider
            slidertext.BackgroundTransparency = 1
            slidertext.BorderSizePixel = 0
            slidertext.Size = UDim2.new(0, 180, 0, 33)
            slidertext.Font = guipallet.Font
            slidertext.Text = name .. ": " .. value
            slidertext.TextColor3 = guipallet.TextColor
            slidertext.TextSize = 22
            slidertext.TextXAlignment = Enum.TextXAlignment.Left
            
            local slider_2 = Instance.new("Frame")
            slider_2.Name = "Slider_2"
            slider_2.Parent = slider
            slider_2.BackgroundColor3 = color
            slider_2.BorderSizePixel = 0
            slider_2.Position = UDim2.new(0.00786, 0, -0.008, 0)
            slider_2.Size = UDim2.new((value - min) / (max - min), 0, 0, 34)
            
            local sliding = false
            
            local function slide(input)
                local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local val = math.floor(((((max - min) * sizeX) + min) * (10 ^ round)) + 0.5) / (10 ^ round)
                
                slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
                sliderapi.Value = val
                slidertext.Text = name .. ": " .. val
                callback(val)
            end
            
            slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    slide(input)
                end
            end)
            
            slider.InputEnded:Connect(function()
                sliding = false
            end)
            
            userInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input)
                end
            end)
            
            sliderapi.MainObject = slider_2
            sliderapi.Container = slider
            
            return sliderapi
        end
        
        -- ============================================
        -- CREATE DROPDOWN
        -- ============================================
        function ToggleTable:CreateDropdown(argstable)
            local name = argstable.Name
            local list = argstable.List or {}
            local value = argstable.Default or list[1]
            local callback = argstable.Callback or function() end
            
            local dropdownapi = {
                Name = name,
                Value = value,
                List = list,
                Callback = callback,
                Select = function(self, option)
                    self.Value = option
                    dropdown.Text = name .. ": " .. option
                    callback(option)
                end
            }
            
            local dropdown = Instance.new("TextLabel")
            dropdown.Name = name
            dropdown.Parent = optionframe
            dropdown.BackgroundTransparency = 1
            dropdown.BorderSizePixel = 0
            dropdown.Size = UDim2.new(0, 175, 0, 25)
            dropdown.Font = guipallet.Font
            dropdown.Text = name .. ": " .. value
            dropdown.TextColor3 = guipallet.TextColor
            dropdown.TextSize = 22
            dropdown.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Name = "DropdownOptions"
            dropdownOptions.Parent = optionframe
            dropdownOptions.BackgroundTransparency = 1
            dropdownOptions.BorderSizePixel = 0
            dropdownOptions.Position = UDim2.new(0, 0, 0, 25)
            dropdownOptions.Size = UDim2.new(0, 175, 0, 25)
            dropdownOptions.Visible = false
            
            local dropdownList = Instance.new("UIListLayout")
            dropdownList.Parent = dropdownOptions
            dropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownList.Padding = UDim.new(0, 0)
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Name = "DropdownButton"
            dropdownButton.Parent = dropdown
            dropdownButton.BackgroundTransparency = 1
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Position = UDim2.new(0.942, 0, 0, 0)
            dropdownButton.Size = UDim2.new(0, 25, 0, 25)
            dropdownButton.Font = guipallet.Font
            dropdownButton.Text = ">"
            dropdownButton.Rotation = 90
            dropdownButton.TextColor3 = guipallet.TextColor
            dropdownButton.TextSize = 22
            
            for _, opt in pairs(list) do
                local btn = Instance.new("TextButton")
                btn.Name = opt
                btn.Parent = dropdownOptions
                btn.BackgroundColor3 = guipallet.Color1
                btn.BackgroundTransparency = 0.8
                btn.BorderSizePixel = 0
                btn.Size = UDim2.new(0, 175, 0, 25)
                btn.Font = guipallet.Font
                btn.Text = opt
                btn.TextColor3 = guipallet.TextColor
                btn.TextSize = 22
                
                btn.MouseButton1Click:Connect(function()
                    dropdownapi:Select(opt)
                    dropdownOptions.Visible = false
                    dropdownButton.Rotation = 90
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                if dropdownOptions.Visible then
                    dropdownOptions.Visible = false
                    dropdownButton.Rotation = 90
                else
                    dropdownOptions.Visible = true
                    dropdownButton.Rotation = -90
                end
            end)
            
            dropdownapi.MainObject = dropdown
            dropdownapi.Container = dropdownOptions
            
            return dropdownapi
        end
        
        -- ============================================
        -- CREATE COLOR SLIDER
        -- ============================================
        function ToggleTable:CreateColorSlider(argstable)
            local name = argstable.Name
            local value = argstable.Default or Color3.fromRGB(255, 255, 255)
            local callback = argstable.Callback or function() end
            
            local colorsliderapi = {
                Name = name,
                Value = value,
                Callback = callback,
                Set = function(self, color)
                    currentColor.BackgroundColor3 = color
                    self.Value = color
                    callback(color)
                end
            }
            
            local frame = Instance.new("Frame")
            frame.Name = name
            frame.Parent = optionframe
            frame.Size = UDim2.new(1, 0, 0, 44)
            frame.BackgroundTransparency = 1
            
            local currentColor = Instance.new("Frame")
            currentColor.Name = "CurrentColor"
            currentColor.Size = UDim2.new(0, 18, 0, 18)
            currentColor.Position = UDim2.new(1, -30, 0, 5)
            currentColor.BackgroundColor3 = value
            currentColor.BorderColor3 = Color3.fromRGB(30, 30, 30)
            currentColor.BorderSizePixel = 0
            currentColor.Parent = frame
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = currentColor
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0, 100, 0, 15)
            nameLabel.Position = UDim2.new(0, 10, 0, 5)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = name
            nameLabel.TextColor3 = guipallet.TextColor
            nameLabel.Font = guipallet.Font
            nameLabel.TextSize = 15
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = frame
            
            colorsliderapi.MainObject = frame
            colorsliderapi.Container = frame
            
            return colorsliderapi
        end
        
        -- ============================================
        -- CREATE BUTTON
        -- ============================================
        function ToggleTable:CreateButton(argstable)
            local name = argstable.Name
            local callback = argstable.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.Name = name
            button.Parent = optionframe
            button.BackgroundColor3 = guipallet.ToggleColor
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 0
            button.Size = UDim2.new(0, 175, 0, 25)
            button.Font = guipallet.Font
            button.Text = name
            button.TextColor3 = guipallet.TextColor
            button.TextSize = 22
            button.TextXAlignment = Enum.TextXAlignment.Center
            button.TextYAlignment = Enum.TextYAlignment.Center
            
            button.MouseButton1Click:Connect(callback)
            
            return {
                Name = name,
                Callback = callback
            }
        end
        
        -- ============================================
        -- CREATE TEXTBOX
        -- ============================================
        function ToggleTable:CreateTextBox(argstable)
            local name = argstable.Name
            local value = argstable.Default or ""
            local placeholder = argstable.PlaceholderText or ""
            local callback = argstable.Callback or function() end
            
            local textboxapi = {
                Name = name,
                Value = value,
                Callback = callback,
                Set = function(self, val)
                    textbox.Text = val
                    self.Value = val
                    callback(val)
                end
            }
            
            local frame = Instance.new("Frame")
            frame.Name = name
            frame.Parent = optionframe
            frame.BackgroundColor3 = color
            frame.BorderSizePixel = 0
            frame.Size = UDim2.new(0, 180, 0, 33)
            
            local textbox = Instance.new("TextBox")
            textbox.Name = name .. "TextBox"
            textbox.Parent = frame
            textbox.BackgroundTransparency = 1
            textbox.BorderSizePixel = 0
            textbox.Size = UDim2.new(0, 180, 0, 33)
            textbox.Font = guipallet.Font
            textbox.Text = value
            textbox.TextColor3 = guipallet.TextColor
            textbox.PlaceholderColor3 = guipallet.PlaceholderColor
            textbox.TextSize = 22
            textbox.PlaceholderText = placeholder
            textbox.ClearTextOnFocus = false
            
            textbox.FocusLost:Connect(function()
                textboxapi:Set(textbox.Text)
            end)
            
            textboxapi.MainObject = textbox
            textboxapi.Container = frame
            
            return textboxapi
        end
        
        -- ============================================
        -- CREATE TEXT LIST
        -- ============================================
        function ToggleTable:CreateTextList(argstable)
            local name = argstable.Name
            local list = argstable.List or {}
            local placeholder = argstable.PlaceholderText or ""
            local callback = argstable.Callback or function() end
            
            local textlistapi = {
                Name = name,
                List = list,
                Callback = callback,
                Add = function(self, text)
                    table.insert(self.List, text)
                    callback(self.List)
                    self:Update()
                end,
                Remove = function(self, index)
                    table.remove(self.List, index)
                    callback(self.List)
                    self:Update()
                end,
                Update = function(self)
                    -- Обновление UI
                end
            }
            
            local frame = Instance.new("Frame")
            frame.Name = name
            frame.Parent = optionframe
            frame.BackgroundColor3 = color
            frame.BorderSizePixel = 0
            frame.Size = UDim2.new(0, 180, 0, 33)
            
            local textbox = Instance.new("TextBox")
            textbox.Name = name .. "TextBox"
            textbox.Parent = frame
            textbox.BackgroundTransparency = 1
            textbox.BorderSizePixel = 0
            textbox.Size = UDim2.new(0, 180, 0, 33)
            textbox.Font = guipallet.Font
            textbox.Text = ""
            textbox.TextColor3 = guipallet.TextColor
            textbox.PlaceholderColor3 = guipallet.PlaceholderColor
            textbox.TextSize = 22
            textbox.PlaceholderText = placeholder
            textbox.ClearTextOnFocus = false
            
            textbox.FocusLost:Connect(function()
                if textbox.Text ~= "" then
                    textlistapi:Add(textbox.Text)
                    textbox.Text = ""
                end
            end)
            
            textlistapi.MainObject = textbox
            textlistapi.Container = frame
            
            return textlistapi
        end
        
        return ToggleTable
    end
    
    -- ============================================
    -- CREATE SLIDER IN TAB
    -- ============================================
    function tabtable:CreateSlider(argstable)
        local name = argstable.Name
        local value = argstable.Default or argstable.Min
        local min = argstable.Min
        local max = argstable.Max
        local round = argstable.Round or 0
        local callback = argstable.Callback or function() end
        
        local sliderapi = {
            Name = name,
            Value = value,
            Callback = callback,
            Set = function(self, val)
                local SizeValue = math.floor((math.clamp(val, min, max) * (10 ^ round)) + 0.5) / (10 ^ round)
                self.Value = SizeValue
                slider_2.Size = UDim2.new((SizeValue - min) / (max - min), 0, 1, 0)
                slidertext.Text = name .. ": " .. SizeValue
                callback(SizeValue)
            end
        }
        
        local slider = Instance.new("TextButton")
        slider.Name = name
        slider.Parent = frame
        slider.BackgroundColor3 = guipallet.Color2
        slider.BorderSizePixel = 0
        slider.Size = UDim2.new(0, 180, 0, 34)
        slider.Text = ""
        slider.AutoButtonColor = false
        
        local slidertext = Instance.new("TextLabel")
        slidertext.Parent = slider
        slidertext.BackgroundTransparency = 1
        slidertext.BorderSizePixel = 0
        slidertext.Size = UDim2.new(0, 180, 0, 33)
        slidertext.Font = guipallet.Font
        slidertext.Text = name .. ": " .. value
        slidertext.TextColor3 = guipallet.TextColor
        slidertext.TextSize = 22
        slidertext.TextXAlignment = Enum.TextXAlignment.Left
        
        local slider_2 = Instance.new("Frame")
        slider_2.Name = "Slider_2"
        slider_2.Parent = slider
        slider_2.BackgroundColor3 = color
        slider_2.BorderSizePixel = 0
        slider_2.Position = UDim2.new(0.00786, 0, -0.008, 0)
        slider_2.Size = UDim2.new((value - min) / (max - min), 0, 0, 34)
        
        local sliding = false
        
        local function slide(input)
            local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local val = math.floor(((((max - min) * sizeX) + min) * (10 ^ round)) + 0.5) / (10 ^ round)
            
            slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
            sliderapi.Value = val
            slidertext.Text = name .. ": " .. val
            callback(val)
        end
        
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = true
                slide(input)
            end
        end)
        
        slider.InputEnded:Connect(function()
            sliding = false
        end)
        
        userInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                slide(input)
            end
        end)
        
        sliderapi.MainObject = slider_2
        sliderapi.Container = slider
        
        return sliderapi
    end
    
    -- ============================================
    -- CREATE DROPDOWN IN TAB
    -- ============================================
    function tabtable:CreateDropdown(argstable)
        local name = argstable.Name
        local list = argstable.List or {}
        local value = argstable.Default or list[1]
        local callback = argstable.Callback or function() end
        
        local dropdownapi = {
            Name = name,
            Value = value,
            List = list,
            Callback = callback,
            Select = function(self, option)
                self.Value = option
                dropdown.Text = name .. ": " .. option
                callback(option)
            end
        }
        
        local dropdown = Instance.new("TextLabel")
        dropdown.Name = name
        dropdown.Parent = frame
        dropdown.BackgroundTransparency = 1
        dropdown.BorderSizePixel = 0
        dropdown.Size = UDim2.new(0, 175, 0, 25)
        dropdown.Font = guipallet.Font
        dropdown.Text = name .. ": " .. value
        dropdown.TextColor3 = guipallet.TextColor
        dropdown.TextSize = 22
        dropdown.TextXAlignment = Enum.TextXAlignment.Left
        
        local dropdownOptions = Instance.new("Frame")
        dropdownOptions.Name = "DropdownOptions"
        dropdownOptions.Parent = frame
        dropdownOptions.BackgroundTransparency = 1
        dropdownOptions.BorderSizePixel = 0
        dropdownOptions.Position = UDim2.new(0, 0, 0, 25)
        dropdownOptions.Size = UDim2.new(0, 175, 0, 25)
        dropdownOptions.Visible = false
        
        local dropdownList = Instance.new("UIListLayout")
        dropdownList.Parent = dropdownOptions
        dropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
        dropdownList.Padding = UDim.new(0, 0)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "DropdownButton"
        dropdownButton.Parent = dropdown
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.BorderSizePixel = 0
        dropdownButton.Position = UDim2.new(0.942, 0, 0, 0)
        dropdownButton.Size = UDim2.new(0, 25, 0, 25)
        dropdownButton.Font = guipallet.Font
        dropdownButton.Text = ">"
        dropdownButton.Rotation = 90
        dropdownButton.TextColor3 = guipallet.TextColor
        dropdownButton.TextSize = 22
        
        for _, opt in pairs(list) do
            local btn = Instance.new("TextButton")
            btn.Name = opt
            btn.Parent = dropdownOptions
            btn.BackgroundColor3 = guipallet.Color1
            btn.BackgroundTransparency = 0.8
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(0, 175, 0, 25)
            btn.Font = guipallet.Font
            btn.Text = opt
            btn.TextColor3 = guipallet.TextColor
            btn.TextSize = 22
            
            btn.MouseButton1Click:Connect(function()
                dropdownapi:Select(opt)
                dropdownOptions.Visible = false
                dropdownButton.Rotation = 90
            end)
        end
        
        dropdownButton.MouseButton1Click:Connect(function()
            if dropdownOptions.Visible then
                dropdownOptions.Visible = false
                dropdownButton.Rotation = 90
            else
                dropdownOptions.Visible = true
                dropdownButton.Rotation = -90
            end
        end)
        
        dropdownapi.MainObject = dropdown
        dropdownapi.Container = dropdownOptions
        
        return dropdownapi
    end
    
    -- ============================================
    -- CREATE COLOR SLIDER IN TAB
    -- ============================================
    function tabtable:CreateColorSlider(argstable)
        local name = argstable.Name
        local value = argstable.Default or Color3.fromRGB(255, 255, 255)
        local callback = argstable.Callback or function() end
        
        local colorsliderapi = {
            Name = name,
            Value = value,
            Callback = callback,
            Set = function(self, color)
                currentColor.BackgroundColor3 = color
                self.Value = color
                callback(color)
            end
        }
        
        local frame = Instance.new("Frame")
        frame.Name = name
        frame.Parent = frame
        frame.Size = UDim2.new(1, 0, 0, 44)
        frame.BackgroundTransparency = 1
        
        local currentColor = Instance.new("Frame")
        currentColor.Name = "CurrentColor"
        currentColor.Size = UDim2.new(0, 18, 0, 18)
        currentColor.Position = UDim2.new(1, -30, 0, 5)
        currentColor.BackgroundColor3 = value
        currentColor.BorderColor3 = Color3.fromRGB(30, 30, 30)
        currentColor.BorderSizePixel = 0
        currentColor.Parent = frame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = currentColor
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 100, 0, 15)
        nameLabel.Position = UDim2.new(0, 10, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = guipallet.TextColor
        nameLabel.Font = guipallet.Font
        nameLabel.TextSize = 15
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = frame
        
        colorsliderapi.MainObject = frame
        colorsliderapi.Container = frame
        
        return colorsliderapi
    end
    
    -- ============================================
    -- CREATE BUTTON IN TAB
    -- ============================================
    function tabtable:CreateButton(argstable)
        local name = argstable.Name
        local callback = argstable.Callback or function() end
        
        local button = Instance.new("TextButton")
        button.Name = name
        button.Parent = frame
        button.BackgroundColor3 = guipallet.ToggleColor
        button.BackgroundTransparency = 0.5
        button.BorderSizePixel = 0
        button.Size = UDim2.new(0, 175, 0, 25)
        button.Font = guipallet.Font
        button.Text = name
        button.TextColor3 = guipallet.TextColor
        button.TextSize = 22
        button.TextXAlignment = Enum.TextXAlignment.Center
        button.TextYAlignment = Enum.TextYAlignment.Center
        
        button.MouseButton1Click:Connect(callback)
        
        return {
            Name = name,
            Callback = callback
        }
    end
    
    -- ============================================
    -- CREATE TEXTBOX IN TAB
    -- ============================================
    function tabtable:CreateTextBox(argstable)
        local name = argstable.Name
        local value = argstable.Default or ""
        local placeholder = argstable.PlaceholderText or ""
        local callback = argstable.Callback or function() end
        
        local textboxapi = {
            Name = name,
            Value = value,
            Callback = callback,
            Set = function(self, val)
                textbox.Text = val
                self.Value = val
                callback(val)
            end
        }
        
        local frame = Instance.new("Frame")
        frame.Name = name
        frame.Parent = frame
        frame.BackgroundColor3 = color
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(0, 180, 0, 33)
        
        local textbox = Instance.new("TextBox")
        textbox.Name = name .. "TextBox"
        textbox.Parent = frame
        textbox.BackgroundTransparency = 1
        textbox.BorderSizePixel = 0
        textbox.Size = UDim2.new(0, 180, 0, 33)
        textbox.Font = guipallet.Font
        textbox.Text = value
        textbox.TextColor3 = guipallet.TextColor
        textbox.PlaceholderColor3 = guipallet.PlaceholderColor
        textbox.TextSize = 22
        textbox.PlaceholderText = placeholder
        textbox.ClearTextOnFocus = false
        
        textbox.FocusLost:Connect(function()
            textboxapi:Set(textbox.Text)
        end)
        
        textboxapi.MainObject = textbox
        textboxapi.Container = frame
        
        return textboxapi
    end
    
    -- ============================================
    -- CREATE TEXT LIST IN TAB
    -- ============================================
    function tabtable:CreateTextList(argstable)
        local name = argstable.Name
        local list = argstable.List or {}
        local placeholder = argstable.PlaceholderText or ""
        local callback = argstable.Callback or function() end
        
        local textlistapi = {
            Name = name,
            List = list,
            Callback = callback,
            Add = function(self, text)
                table.insert(self.List, text)
                callback(self.List)
                self:Update()
            end,
            Remove = function(self, index)
                table.remove(self.List, index)
                callback(self.List)
                self:Update()
            end,
            Update = function(self)
                -- Обновление UI
            end
        }
        
        local frame = Instance.new("Frame")
        frame.Name = name
        frame.Parent = frame
        frame.BackgroundColor3 = color
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(0, 180, 0, 33)
        
        local textbox = Instance.new("TextBox")
        textbox.Name = name .. "TextBox"
        textbox.Parent = frame
        textbox.BackgroundTransparency = 1
        textbox.BorderSizePixel = 0
        textbox.Size = UDim2.new(0, 180, 0, 33)
        textbox.Font = guipallet.Font
        textbox.Text = ""
        textbox.TextColor3 = guipallet.TextColor
        textbox.PlaceholderColor3 = guipallet.PlaceholderColor
        textbox.TextSize = 22
        textbox.PlaceholderText = placeholder
        textbox.ClearTextOnFocus = false
        
        textbox.FocusLost:Connect(function()
            if textbox.Text ~= "" then
                textlistapi:Add(textbox.Text)
                textbox.Text = ""
            end
        end)
        
        textlistapi.MainObject = textbox
        textlistapi.Container = frame
        
        return textlistapi
    end
    
    return tabtable
end

return guilibrary
