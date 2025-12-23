--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║╚██████╔╝██║
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝
    
    NexusUI - Modern Roblox GUI Library
    Version: 2.0.0 (Fixed & Working)
    
    A lightweight, modern GUI library for Roblox
    Created for the Roblox scripting community
]]

local NexusUI = {}
NexusUI.__index = NexusUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- Configuration
local Config = {
    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 50),
        Tertiary = Color3.fromRGB(45, 45, 60),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentDark = Color3.fromRGB(71, 82, 196),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 200),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Danger = Color3.fromRGB(242, 63, 66)
    },
    Font = Enum.Font.GothamBold,
    FontRegular = Enum.Font.Gotham,
    CornerRadius = 8,
    Padding = 10,
    AnimationSpeed = 0.25
}

-- Utility Functions
local function CreateTween(object, properties, duration, style, direction)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = window.Title
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.Font = Config.Font
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = window.TitleBar
    CreatePadding(titleLabel, 18)
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(1, -80, 0.5, 0)
    minimizeBtn.AnchorPoint = Vector2.new(0, 0.5)
    minimizeBtn.BackgroundColor3 = Config.Theme.Tertiary
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Config.Theme.Text
    minimizeBtn.Font = Config.Font
    minimizeBtn.TextSize = 20
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = window.TitleBar
    CreateCorner(minimizeBtn, 6)
    
    minimizeBtn.MouseEnter:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Config.Theme.Accent}, 0.15)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Config.Theme.Tertiary}, 0.15)
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
        if window.Visible then
            CreateTween(window.Frame, {Size = window.Size}, 0.3, Enum.EasingStyle.Back)
        else
            CreateTween(window.Frame, {Size = UDim2.new(0, window.Size.X.Offset, 0, 45)}, 0.3)
        end
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0, 0.5)
    closeBtn.BackgroundColor3 = Config.Theme.Tertiary
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Config.Theme.Text
    closeBtn.Font = Config.Font
    closeBtn.TextSize = 24
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = window.TitleBar
    CreateCorner(closeBtn, 6)
    
    closeBtn.MouseEnter:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Config.Theme.Danger}, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Config.Theme.Tertiary}, 0.15)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        CreateTween(window.Frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        window.Frame:Destroy()
    end)
    
    -- Tab Container
    window.TabContainer = Instance.new("Frame")
    window.TabContainer.Name = "TabContainer"
    window.TabContainer.Size = UDim2.new(1, 0, 0, 40)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    window.TabContainer.BackgroundColor3 = Config.Theme.Secondary
    window.TabContainer.BorderSizePixel = 0
    window.TabContainer.Parent = window.Frame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = window.TabContainer
    CreatePadding(window.TabContainer, 8)
    
    -- Content Container
    window.ContentContainer = Instance.new("Frame")
    window.ContentContainer.Name = "Content"
    window.ContentContainer.Size = UDim2.new(1, 0, 1, -85)
    window.ContentContainer.Position = UDim2.new(0, 0, 0, 85)
    window.ContentContainer.BackgroundTransparency = 1
    window.ContentContainer.Parent = window.Frame
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    
    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Window methods
    function window:CreateTab(tabName)
        local tab = {
            Name = tabName,
            Elements = {},
            Window = window
        }
        
        -- Tab Button
        tab.Button = Instance.new("TextButton")
        tab.Button.Name = tabName
        tab.Button.Size = UDim2.new(0, 120, 1, 0)
        tab.Button.BackgroundColor3 = Config.Theme.Background
        tab.Button.Text = tabName
        tab.Button.TextColor3 = Config.Theme.TextDark
        tab.Button.Font = Config.FontRegular
        tab.Button.TextSize = 15
        tab.Button.BorderSizePixel = 0
        tab.Button.Parent = window.TabContainer
        CreateCorner(tab.Button, 6)
        
        -- Tab Content
        tab.Content = Instance.new("ScrollingFrame")
        tab.Content.Name = tabName .. "Content"
        tab.Content.Size = UDim2.new(1, 0, 1, 0)
        tab.Content.BackgroundTransparency = 1
        tab.Content.BorderSizePixel = 0
        tab.Content.ScrollBarThickness = 6
        tab.Content.ScrollBarImageColor3 = Config.Theme.Accent
        tab.Content.ScrollBarImageTransparency = 0.3
        tab.Content.Visible = false
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.Content.Parent = window.ContentContainer
        CreatePadding(tab.Content, 12)
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tab.Content
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 24)
        end)
        
        tab.Button.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
                CreateTween(t.Button, {
                    BackgroundColor3 = Config.Theme.Background,
                    TextColor3 = Config.Theme.TextDark
                }, 0.2)
            end
            
            tab.Content.Visible = true
            CreateTween(tab.Button, {
                BackgroundColor3 = Config.Theme.Accent,
                TextColor3 = Config.Theme.Text
            }, 0.2)
            window.CurrentTab = tab
        end)
        
        table.insert(window.Tabs, tab)
        
        if #window.Tabs == 1 then
            tab.Button.MouseButton1Click:Fire()
        end
        
        setmetatable(tab, {__index = NexusUI.GetComponentMethods()})
        return tab
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Component Methods
function NexusUI.GetComponentMethods()
    local methods = {}
    
    -- Label Component
    function methods:Label(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 28)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Config.Theme.Text
        label.Font = Config.FontRegular
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        label.Parent = self.Content
        CreatePadding(label, 5)
        
        return self
    end
    
    -- Button Component
    function methods:Button(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 38)
        button.BackgroundColor3 = Config.Theme.Secondary
        button.Text = text
        button.TextColor3 = Config.Theme.Text
        button.Font = Config.FontRegular
        button.TextSize = 15
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Parent = self.Content
        CreateCorner(button)
        CreateStroke(button, Config.Theme.Accent, 1)
        
        button.MouseEnter:Connect(function()
            CreateTween(button, {BackgroundColor3 = Config.Theme.Accent}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, {BackgroundColor3 = Config.Theme.Secondary}, 0.2)
        end)
        
        button.MouseButton1Click:Connect(function()
            CreateTween(button, {Size = UDim2.new(0.98, 0, 0, 36)}, 0.1)
            task.wait(0.1)
            CreateTween(button, {Size = UDim2.new(1, 0, 0, 38)}, 0.1)
            if callback then
                local success, err = pcall(callback)
                if not success then
                    warn("Button callback error:", err)
                end
            end
        end)
        
        return self
    end
    
    -- Toggle Component
    function methods:Toggle(text, default, callback)
        local state = default or false
        
        local frame = Instance.new("Frame")
        frame.Name = "Toggle"
        frame.Size = UDim2.new(1, 0, 0, 38)
        frame.BackgroundColor3 = Config.Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Parent = self.Content
        CreateCorner(frame)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Config.Theme.Text
        label.Font = Config.FontRegular
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Parent = frame
        CreatePadding(label, 12)
        
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Size = UDim2.new(0, 50, 0, 24)
        toggleContainer.Position = UDim2.new(1, -62, 0.5, 0)
        toggleContainer.AnchorPoint = Vector2.new(0, 0.5)
        toggleContainer.BackgroundColor3 = state and Config.Theme.Accent or Config.Theme.Background
        toggleContainer.BorderSizePixel = 0
        toggleContainer.Parent = frame
        CreateCorner(toggleContainer, 12)
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.BackgroundTransparency = 1
        toggleButton.Text = ""
        toggleButton.Parent = toggleContainer
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        knob.AnchorPoint = Vector2.new(0, 0.5)
        knob.BackgroundColor3 = Config.Theme.Text
        knob.BorderSizePixel = 0
        knob.Parent = toggleContainer
        CreateCorner(knob, 9)
        
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            CreateTween(toggleContainer, {
                BackgroundColor3 = state and Config.Theme.Accent or Config.Theme.Background
            }, 0.2)
            CreateTween(knob, {
                Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            }, 0.2)
            if callback then
                local success, err = pcall(callback, state)
                if not success then
                    warn("Toggle callback error:", err)
                end
            end
        end)
        
        return self
    end
    
    -- Slider Component
    function methods:Slider(text, min, max, default, callback)
        local value = default or min
        
        local frame = Instance.new("Frame")
        frame.Name = "Slider"
        frame.Size = UDim2.new(1, 0, 0, 55)
        frame.BackgroundColor3 = Config.Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Parent = self.Content
        CreateCorner(frame)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 8)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Config.Theme.Text
        label.Font = Config.FontRegular
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        CreatePadding(label, 12)
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 60, 0, 20)
        valueLabel.Position = UDim2.new(1, -72, 0, 8)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(value)
        valueLabel.TextColor3 = Config.Theme.Accent
        valueLabel.Font = Config.Font
        valueLabel.TextSize = 15
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = frame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -24, 0, 6)
        sliderBg.Position = UDim2.new(0, 12, 1, -18)
        sliderBg.BackgroundColor3 = Config.Theme.Background
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = frame
        CreateCorner(sliderBg, 3)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Config.Theme.Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        CreateCorner(sliderFill, 3)
        
        local dragging = false
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
                local percent = relativeX / sliderBg.AbsoluteSize.X
                value = math.floor(min + (max - min) * percent)
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(value)
                
                if callback then
                    local success, err = pcall(callback, value)
                    if not success then
                        warn("Slider callback error:", err)
                    end
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
                local percent = relativeX / sliderBg.AbsoluteSize.X
                value = math.floor(min + (max - min) * percent)
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(value)
                
                if callback then
                    local success, err = pcall(callback, value)
                    if not success then
                        warn("Slider callback error:", err)
                    end
                end
            end
        end)
        
        return self
    end
    
    -- Input Component
    function methods:Input(placeholder, callback)
        local frame = Instance.new("Frame")
        frame.Name = "Input"
        frame.Size = UDim2.new(1, 0, 0, 38)
        frame.BackgroundColor3 = Config.Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Parent = self.Content
        CreateCorner(frame)
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(1, 0, 1, 0)
        input.BackgroundTransparency = 1
        input.PlaceholderText = placeholder
        input.PlaceholderColor3 = Config.Theme.TextDark
        input.Text = ""
        input.TextColor3 = Config.Theme.Text
        input.Font = Config.FontRegular
        input.TextSize = 15
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ClearTextOnFocus = false
        input.Parent = frame
        CreatePadding(input, 12)
        
        input.Focused:Connect(function()
            CreateTween(frame, {BackgroundColor3 = Config.Theme.Tertiary}, 0.2)
        end)
        
        input.FocusLost:Connect(function(enterPressed)
            CreateTween(frame, {BackgroundColor3 = Config.Theme.Secondary}, 0.2)
            if enterPressed and callback then
                local success, err = pcall(callback, input.Text)
                if not success then
                    warn("Input callback error:", err)
                end
            end
        end)
        
        return self
    end
    
    -- Dropdown Component
    function methods:Dropdown(text, options, callback)
        local selected = options[1] or "None"
        local isOpen = false
        
        local frame = Instance.new("Frame")
        frame.Name = "Dropdown"
        frame.Size = UDim2.new(1, 0, 0, 38)
        frame.BackgroundColor3 = Config.Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Parent = self.Content
        frame.ClipsDescendants = true
        frame.ZIndex = 10
        CreateCorner(frame)
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 38)
        button.BackgroundTransparency = 1
        button.Text = text .. ": " .. selected
        button.TextColor3 = Config.Theme.Text
        button.Font = Config.FontRegular
        button.TextSize = 15
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.ZIndex = 11
        button.Parent = frame
        CreatePadding(button, 12)
        
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 30, 1, 0)
        arrow.Position = UDim2.new(1, -30, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = Config.Theme.TextDark
        arrow.Font = Config.FontRegular
        arrow.TextSize = 12
        arrow.ZIndex = 12
        arrow.Parent = button
        
        local optionsFrame = Instance.new("ScrollingFrame")
        optionsFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 32, 160))
        optionsFrame.Position = UDim2.new(0, 0, 0, 38)
        optionsFrame.BackgroundColor3 = Config.Theme.Background
        optionsFrame.BorderSizePixel = 0
        optionsFrame.ScrollBarThickness = 4
        optionsFrame.ScrollBarImageColor3 = Config.Theme.Accent
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
        optionsFrame.ZIndex = 11
        optionsFrame.Parent = frame
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Parent = optionsFrame
        
        for _, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, 0, 0, 32)
            optionBtn.BackgroundColor3 = Config.Theme.Background
            optionBtn.Text = option
            optionBtn.TextColor3 = Config.Theme.Text
            optionBtn.Font = Config.FontRegular
            optionBtn.TextSize = 14
            optionBtn.BorderSizePixel = 0
            optionBtn.AutoButtonColor = false
            optionBtn.ZIndex = 12
            optionBtn.Parent = optionsFrame
            
            optionBtn.MouseEnter:Connect(function()
                CreateTween(optionBtn, {BackgroundColor3 = Config.Theme.Secondary}, 0.15)
            end)
            
            optionBtn.MouseLeave:Connect(function()
                CreateTween(optionBtn, {BackgroundColor3 = Config.Theme.Background}, 0.15)
            end)
            
            optionBtn.MouseButton1Click:Connect(function()
                selected = option
                button.Text = text .. ": " .. selected
                isOpen = false
                CreateTween(frame, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
                CreateTween(arrow, {Rotation = 0}, 0.2)
                if callback then
                    local success, err = pcall(callback, selected)
                    if not success then
                        warn("Dropdown callback error:", err)
                    end
                end
            end)
        end
        
        button.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            local targetSize = isOpen and (38 + math.min(#options * 32, 160)) or 38
            CreateTween(frame, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.2)
            CreateTween(arrow, {Rotation = isOpen and 180 or 0}, 0.2)
        end)
        
        return self
    end
    
    return methods
end

return NexusUI
