local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Linux = {}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function Linux:SafeCallback(Function, ...)
    if not Function then
        return
    end
    local Success, Error = pcall(Function, ...)
    if not Success then
        self:Notify({
            Title = "Callback Error",
            Content = tostring(Error),
            Duration = 5
        })
    end
end

function Linux:Notify(config)
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local notificationWidth = isMobile and 200 or 300
    local notificationHeight = config.SubContent and 80 or 60
    local startPosX = isMobile and 10 or 20
    local parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui")
    
    for _, v in pairs(parent:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "NotificationHolder" then
            v:Destroy()
        end
    end
    
    local NotificationHolder = Linux.Instance("ScreenGui", {
        Name = "NotificationHolder",
        Parent = parent,
        ResetOnSpawn = false,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local Notification = Linux.Instance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight),
        Position = UDim2.new(1, 10, 1, -notificationHeight - 10),
        ZIndex = 100
    })
    
    Linux.Instance("UICorner", {
        Parent = Notification,
        CornerRadius = UDim.new(0, 6)
    })
    
    Linux.Instance("UIStroke", {
        Parent = Notification,
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1
    })
    
    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        Font = Enum.Font.GothamSemibold,
        Text = config.Title or "Notification",
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })
    
    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        Font = Enum.Font.GothamSemibold,
        Text = config.Content or "Content",
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })
    
    if config.SubContent then
        Linux.Instance("TextLabel", {
            Parent = Notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 45),
            Font = Enum.Font.GothamSemibold,
            Text = config.SubContent,
            TextColor3 = Color3.fromRGB(180, 180, 190),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 101
        })
    end
    
    local ProgressBar = Linux.Instance("Frame", {
        Parent = Notification,
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(1, -10, 0, 4),
        Position = UDim2.new(0, 5, 1, -9),
        ZIndex = 101,
        BorderSizePixel = 0
    })
    
    Linux.Instance("UICorner", {
        Parent = ProgressBar,
        CornerRadius = UDim.new(1, 0)
    })
    
    local ProgressFill = Linux.Instance("Frame", {
        Parent = ProgressBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 101,
        BorderSizePixel = 0
    })
    
    Linux.Instance("UICorner", {
        Parent = ProgressFill,
        CornerRadius = UDim.new(1, 0)
    })
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0, startPosX, 1, -notificationHeight - 10)}):Play()
    
    if config.Duration then
        local progressTweenInfo = TweenInfo.new(config.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        TweenService:Create(ProgressFill, progressTweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.delay(config.Duration, function()
            TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1, 10, 1, -notificationHeight - 10)}):Play()
            task.wait(0.5)
            NotificationHolder:Destroy()
        end)
    end
end

function Linux.Create(config)
    local randomName = "UI_" .. tostring(math.random(100000, 999999))
    
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
            v:Destroy()
        end
    end
    
    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
    
    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = randomName,
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true
    })
    
    ProtectGui(LinuxUI)
    
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local uiSize = isMobile and (config.SizeMobile or UDim2.fromOffset(300, 500)) or (config.SizePC or UDim2.fromOffset(550, 355))
    
    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Color3.fromRGB(14, 14, 19),
        BorderColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        Active = true,
        Draggable = true,
        ZIndex = 1
    })
    
    Linux.Instance("UICorner", {
        Parent = Main,
        CornerRadius = UDim.new(0, 8)
    })
    
    Linux.Instance("UIStroke", {
        Parent = Main,
        Color = Color3.fromRGB(40, 40, 50),
        Thickness = 1
    })
    
    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BorderColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 2
    })
    
    Linux.Instance("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    Linux.Instance("Frame", {
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        ZIndex = 3
    })
    
    local TitleLabel = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 2
    })
    
    local MinimizeButton = Linux.Instance("ImageButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -46, 0.5, -8),
        Image = "rbxassetid://10734895698",
        ImageColor3 = Color3.fromRGB(180, 180, 190),
        ZIndex = 3
    })
    
    local CloseButton = Linux.Instance("ImageButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -26, 0.5, -8),
        Image = "rbxassetid://10747384394",
        ImageColor3 = Color3.fromRGB(180, 180, 190),
        ZIndex = 3
    })
    
    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, config.TabWidth or 130, 1, -30),
        ZIndex = 2,
        BorderSizePixel = 0
    })
    
    Linux.Instance("UICorner", {
        Parent = TabsBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    Linux.Instance("Frame", {
        Parent = TabsBar,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 8, 1, 0),
        Position = UDim2.new(1, -8, 0, 0),
        ZIndex = 3
    })
    
    local TabHolder = Linux.Instance("ScrollingFrame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ZIndex = 2,
        BorderSizePixel = 0,
        ScrollingEnabled = true
    })
    
    Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    })
    
    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(14, 14, 19),
        BackgroundTransparency = 0,
        Position = UDim2.new(0, config.TabWidth or 130, 0, 30),
        Size = UDim2.new(1, -(config.TabWidth or 130), 1, -30),
        ZIndex = 1,
        BorderSizePixel = 0
    })
    
    local isHidden = false
    local isMinimized = false
    local originalSize = uiSize
    local minimizedSize = UDim2.new(0, uiSize.X.Offset, 0, 30)
    
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(220, 220, 230)}):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 190)}):Play()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = minimizedSize}):Play()
            Content.Visible = false
            TabsBar.Visible = false
            MinimizeButton.Image = "rbxassetid://10734886496"
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = originalSize}):Play()
            Content.Visible = true
            TabsBar.Visible = true
            MinimizeButton.Image = "rbxassetid://10734895698"
        end
    end)
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(220, 220, 230)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 190)}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        
        task.delay(0.3, function()
            LinuxUI:Destroy()
        end)
    end)
    
    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            isHidden = not isHidden
            Main.Visible = not isHidden
        end
    end)
    
    local LinuxLib = {}
    local Tabs = {}
    local CurrentTab = nil
    local tabOrder = 0
    
    function LinuxLib.Tab(config)
        tabOrder = tabOrder + 1
        local tabIndex = tabOrder
        
        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(40, 40, 50),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.GothamSemibold,
            Text = "",
            TextColor3 = Color3.fromRGB(200, 200, 210),
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            LayoutOrder = tabIndex
        })
        
        Linux.Instance("UICorner", {
            Parent = TabBtn,
            CornerRadius = UDim.new(0, 6)
        })
        
        local TabSelectionIndicator = Linux.Instance("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0
        })
        
        Linux.Instance("UICorner", {
            Parent = TabSelectionIndicator,
            CornerRadius = UDim.new(0, 2)
        })
        
        local TabIcon
        if config.Icon and config.Enabled then
            TabIcon = Linux.Instance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 10, 0.5, -9),
                Image = config.Icon,
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                ZIndex = 2
            })
        end
        
        local textOffset = config.Icon and config.Enabled and 33 or 16
        local TabText = Linux.Instance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -(textOffset + 20), 1, 0),
            Position = UDim2.new(0, textOffset, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(200, 200, 210),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })
        
        local TabContent = Linux.Instance("Frame", {
            Parent = Content,
            BackgroundColor3 = Color3.fromRGB(18, 18, 23),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 1,
            BorderSizePixel = 0
        })
        
        local TitleFrame = Linux.Instance("Frame", {
            Parent = Content,
            BackgroundColor3 = Color3.fromRGB(18, 18, 23),
            BackgroundTransparency = 0,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 5),
            Visible = false,
            ZIndex = 3,
            BorderSizePixel = 0
        })
        
        local TitleLabel = Linux.Instance("TextLabel", {
            Parent = TitleFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.GothamBold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 24,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 4
        })
        
        local Container = Linux.Instance("ScrollingFrame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -60),
            Position = UDim2.new(0, 10, 0, 50),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            ZIndex = 1,
            BorderSizePixel = 0,
            ScrollingEnabled = true,
            CanvasPosition = Vector2.new(0, 0)
        })
        
        local ContainerListLayout = Linux.Instance("UIListLayout", {
            Parent = Container,
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Linux.Instance("UIPadding", {
            Parent = Container,
            PaddingLeft = UDim.new(0, 0),
            PaddingTop = UDim.new(0, 0)
        })
        
        local function SelectTab()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.TitleFrame.Visible = false
                tab.Text.TextColor3 = Color3.fromRGB(200, 200, 210)
                tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                tab.Button.BackgroundTransparency = 1
                tab.Indicator.BackgroundTransparency = 1
                
                if tab.Icon then
                    tab.Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            TabContent.Visible = true
            TitleFrame.Visible = true
            TabText.TextColor3 = Color3.fromRGB(230, 230, 240)
            TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            TabBtn.BackgroundTransparency = 0.5
            TabSelectionIndicator.BackgroundTransparency = 0
            
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            CurrentTab = tabIndex
            Container.CanvasPosition = Vector2.new(0, 0)
        end
        
        local hoverTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= tabIndex then
                TweenService:Create(TabBtn, hoverTween, {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(TabSelectionIndicator, hoverTween, {BackgroundTransparency = 0.7}):Play()
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= tabIndex then
                TweenService:Create(TabBtn, hoverTween, {BackgroundTransparency = 1}):Play()
                TweenService:Create(TabSelectionIndicator, hoverTween, {BackgroundTransparency = 1}):Play()
            end
        end)
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        
        Tabs[tabIndex] = {
            Name = config.Name,
            Button = TabBtn,
            Text = TabText,
            Icon = TabIcon,
            Content = TabContent,
            TitleFrame = TitleFrame,
            Indicator = TabSelectionIndicator
        }
        
        if tabOrder == 1 then
            SelectTab()
        end
        
        local TabElements = {}
        local elementOrder = 0
        local lastWasDropdown = false
        
        function TabElements.Button(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local BtnFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = BtnFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = BtnFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local Btn = Linux.Instance("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
                AutoButtonColor = false
            })
            
            Linux.Instance("UIPadding", {
                Parent = Btn,
                PaddingLeft = UDim.new(0, 10)
            })
            
            local BtnIcon = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -26, 0.5, -8),
                Image = "https://www.roblox.com/asset/?id=10709791437",
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                ZIndex = 2
            })
            
            local purpleColor = Color3.fromRGB(125, 65, 255)
            local darkPurpleColor = Color3.fromRGB(75, 35, 180)
            local hoverColor = Color3.fromRGB(35, 35, 40)
            local originalColor = Color3.fromRGB(25, 25, 30)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            Btn.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = hoverColor}):Play()
                TweenService:Create(BtnFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 38)}):Play()
            end)
            
            Btn.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = originalColor}):Play()
                TweenService:Create(BtnFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 36)}):Play()
            end)
            
            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = purpleColor}):Play()
                end
            end)
            
            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = originalColor}):Play()
                    TweenService:Create(BtnFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 36)}):Play()
                end
            end)
            
            Btn.MouseButton1Click:Connect(function()
                spawn(function() Linux:SafeCallback(config.Callback) end)
            end)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            return Btn
        end
        
        function TabElements.Toggle(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Toggle = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Toggle,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local ToggleText = Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
                Name = "ToggleText"
            })
            
            local ToggleTrack = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -46, 0.5, -9),
                ZIndex = 2,
                BorderSizePixel = 0,
                Name = "Track"
            })
            
            Linux.Instance("UICorner", {
                Parent = ToggleTrack,
                CornerRadius = UDim.new(1, 0)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ToggleTrack,
                Color = Color3.fromRGB(60, 60, 70),
                Thickness = 1
            })
            
            local purpleColor = Color3.fromRGB(125, 65, 255)
            local darkPurpleColor = Color3.fromRGB(75, 35, 180)
            
            local ToggleKnob = Linux.Instance("Frame", {
                Parent = ToggleTrack,
                BackgroundColor3 = Color3.fromRGB(200, 200, 210),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 2, 0.5, -7),
                ZIndex = 3,
                BorderSizePixel = 0,
                Name = "Knob"
            })
            
            Linux.Instance("UICorner", {
                Parent = ToggleKnob,
                CornerRadius = UDim.new(1, 0)
            })
            
            local State = config.Default or false
            Toggle:SetAttribute("State", State)
            
            local isToggling = false
            local function UpdateToggle(thisToggle)
                if isToggling then return end
                isToggling = true
                
                local currentState = thisToggle:GetAttribute("State")
                local thisTrack = thisToggle:FindFirstChild("Track")
                local thisKnob = thisTrack and thisTrack:FindFirstChild("Knob")
                local thisText = thisToggle:FindFirstChild("ToggleText")
                
                if thisTrack and thisKnob and thisText then
                    local tween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    if currentState then
                        TweenService:Create(thisTrack, tween, {BackgroundColor3 = purpleColor}):Play()
                        TweenService:Create(thisKnob, tween, {Position = UDim2.new(0, 20, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        TweenService:Create(thisText, tween, {TextColor3 = purpleColor}):Play()
                    else
                        TweenService:Create(thisTrack, tween, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                        TweenService:Create(thisKnob, tween, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 210)}):Play()
                        TweenService:Create(thisText, tween, {TextColor3 = Color3.fromRGB(200, 200, 210)}):Play()
                    end
                end
                
                task.wait(0.25)
                isToggling = false
            end
            
            UpdateToggle(Toggle)
            spawn(function() Linux:SafeCallback(config.Callback, State) end)
            
            local function toggleSwitch()
                if not isToggling then
                    local newState = not Toggle:GetAttribute("State")
                    Toggle:SetAttribute("State", newState)
                    
                    UpdateToggle(Toggle)
                    spawn(function() Linux:SafeCallback(config.Callback, newState) end)
                end
            end
            
            ToggleTrack.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
                    toggleSwitch()
                end
            end)
            
            ToggleKnob.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
                    toggleSwitch()
                end
            end)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            return Toggle
        end
        
        function TabElements.Dropdown(config)
            elementOrder = elementOrder + 1
            lastWasDropdown = true
            
            local Dropdown = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Dropdown,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local DropdownButton = Linux.Instance("TextButton", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = "",
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                ZIndex = 2,
                AutoButtonColor = false
            })
            
            Linux.Instance("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local Options = config.Options or {}
            local SelectedValue = config.Default or (Options[1] or "None")
            
            local purpleColor = Color3.fromRGB(125, 65, 255)
            local darkPurpleColor = Color3.fromRGB(75, 35, 180)
            
            local Selected = Linux.Instance("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.3, -21, 1, 0),
                Position = UDim2.new(0.65, 5, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(SelectedValue),
                TextColor3 = purpleColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })
            
            local Arrow = Linux.Instance("ImageLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -26, 0.5, -8),
                Image = "https://www.roblox.com/asset/?id=10709791437",
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                Rotation = 0,
                ZIndex = 2
            })
            
            local DropFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                ZIndex = 3,
                LayoutOrder = elementOrder + 1,
                ClipsDescendants = true,
                Visible = true
            })
            
            Linux.Instance("UICorner", {
                Parent = DropFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = DropFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local OptionsHolder = Linux.Instance("ScrollingFrame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ZIndex = 3,
                BorderSizePixel = 0,
                ScrollingEnabled = true
            })
            
            Linux.Instance("UIListLayout", {
                Parent = OptionsHolder,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Linux.Instance("UIPadding", {
                Parent = OptionsHolder,
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5)
            })
            
            local IsOpen = false
            
            local function UpdateDropSize()
                local optionHeight = 28
                local paddingBetween = 2
                local paddingTopBottom = 10
                local maxHeight = 150
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions > 0 and (numOptions - 1) * paddingBetween + paddingTopBottom or 0)
                local finalHeight = math.min(calculatedHeight, maxHeight)
                
                local tween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                
                if IsOpen then
                    DropFrame.Visible = true
                    DropFrame.Size = UDim2.new(1, 0, 0, 0)
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, 0, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 85}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                    task.delay(0.25, function()
                        if not IsOpen then
                            DropFrame.Visible = false
                        end
                    end)
                end
            end
            
            local function PopulateOptions()
                for _, child in pairs(OptionsHolder:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                if IsOpen then
                    for i, opt in pairs(Options) do
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = OptionsHolder,
                            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                            BorderColor3 = Color3.fromRGB(40, 40, 50),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, -4, 0, 28),
                            Font = Enum.Font.GothamSemibold,
                            Text = tostring(opt),
                            TextColor3 = opt == SelectedValue and purpleColor or Color3.fromRGB(200, 200, 210),
                            TextSize = 14,
                            ZIndex = 3,
                            AutoButtonColor = false,
                            LayoutOrder = i
                        })
                        
                        Linux.Instance("UICorner", {
                            Parent = OptBtn,
                            CornerRadius = UDim.new(0, 4)
                        })
                        
                        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        
                        OptBtn.MouseEnter:Connect(function()
                            if opt ~= SelectedValue then
                                TweenService:Create(OptBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                            end
                        end)
                        
                        OptBtn.MouseLeave:Connect(function()
                            if opt ~= SelectedValue then
                                TweenService:Create(OptBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                            end
                        end)
                        
                        OptBtn.MouseButton1Click:Connect(function()
                            if opt ~= SelectedValue then
                                SelectedValue = opt
                                Selected.Text = tostring(opt)
                                Selected.TextColor3 = purpleColor
                                
                                for _, btn in pairs(OptionsHolder:GetChildren()) do
                                    if btn:IsA("TextButton") then
                                        if btn.Text == tostring(opt) then
                                            btn.TextColor3 = purpleColor
                                            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                                        else
                                            btn.TextColor3 = Color3.fromRGB(200, 200, 210)
                                            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                                        end
                                    end
                                end
                                
                                spawn(function() Linux:SafeCallback(config.Callback, opt) end)
                            end
                        end)
                    end
                end
                
                UpdateDropSize()
            end
            
            if #Options > 0 then
                PopulateOptions()
                spawn(function() Linux:SafeCallback(config.Callback, SelectedValue) end)
            end
            
            Arrow.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    PopulateOptions()
                end
            end)
            
            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValue = Options[1] or "None"
                Selected.Text = tostring(SelectedValue)
                Selected.TextColor3 = purpleColor
                
                IsOpen = false
                UpdateDropSize()
                PopulateOptions()
                
                spawn(function() Linux:SafeCallback(config.Callback, SelectedValue) end)
            end
            
            local function SetValue(value)
                if table.find(Options, value) then
                    SelectedValue = value
                    Selected.Text = tostring(value)
                    Selected.TextColor3 = purpleColor
                    
                    IsOpen = false
                    UpdateDropSize()
                    PopulateOptions()
                    
                    spawn(function() Linux:SafeCallback(config.Callback, value) end)
                end
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return SelectedValue end
            }
        end
        
        function TabElements.Slider(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Slider = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 42),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Slider,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local TitleLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 16),
                Position = UDim2.new(0, 10, 0, 4),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local SliderBar = Linux.Instance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 26),
                ZIndex = 2,
                BorderSizePixel = 0,
                Name = "Bar"
            })
            
            Linux.Instance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            local ValueLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 50, 0, 16),
                Position = UDim2.new(1, -60, 0, 4),
                Font = Enum.Font.GothamSemibold,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2,
                Name = "Value"
            })
            
            local purpleColor = Color3.fromRGB(125, 65, 255)
            
            local FillBar = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = purpleColor,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                Name = "Fill"
            })
            
            Linux.Instance("UICorner", {
                Parent = FillBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SliderButton = Linux.Instance("TextButton", {
                Parent = SliderBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 3
            })
            
            local Min = config.Min or 0
            local Max = config.Max or 100
            
            Slider:SetAttribute("Min", Min)
            Slider:SetAttribute("Max", Max)
            
            local Value = config.Default or Min
            
            Slider:SetAttribute("Value", Value)
            
            local function AnimateValueLabel()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(ValueLabel, tweenInfo, {TextSize = 16}):Play()
                task.wait(0.2)
                TweenService:Create(ValueLabel, tweenInfo, {TextSize = 14}):Play()
            end
            
            local function UpdateSlider(pos)
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((pos - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
                
                local min = Slider:GetAttribute("Min")
                local max = Slider:GetAttribute("Max")
                
                local value = min + (max - min) * relativePos
                value = math.floor(value + 0.5)
                
                Slider:SetAttribute("Value", value)
                
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                
                ValueLabel.Text = tostring(value)
                
                AnimateValueLabel()
                spawn(function() Linux:SafeCallback(config.Callback, value) end)
            end
            
            local draggingSlider = false
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)
            
            SliderButton.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSlider then
                    UpdateSlider(input.Position.X)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            
            local function SetValue(newValue)
                local min = Slider:GetAttribute("Min")
                local max = Slider:GetAttribute("Max")
                
                newValue = math.clamp(newValue, min, max)
                
                Slider:SetAttribute("Value", newValue)
                
                local relativePos = (newValue - min) / (max - min)
                
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                
                ValueLabel.Text = tostring(newValue)
                
                AnimateValueLabel()
                spawn(function() Linux:SafeCallback(config.Callback, newValue) end)
            end
            
            SetValue(Value)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = Slider,
                SetValue = SetValue,
                GetValue = function() return Slider:GetAttribute("Value") end,
                SetMin = function(min)
                    Slider:SetAttribute("Min", min)
                    SetValue(Slider:GetAttribute("Value"))
                end,
                SetMax = function(max)
                    Slider:SetAttribute("Max", max)
                    SetValue(Slider:GetAttribute("Value"))
                end
            }
        end
        
        function TabElements.Input(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Input = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Input,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Input,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local TextBox = Linux.Instance("TextBox", {
                Parent = Input,
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                BorderSizePixel = 0,
                Size = UDim2.new(0.3, -16, 0, 24),
                Position = UDim2.new(0.7, 0, 0.5, -12),
                Font = Enum.Font.GothamSemibold,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Text here",
                PlaceholderColor3 = Color3.fromRGB(120, 120, 130),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextScaled = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                ZIndex = 3
            })
            
            Linux.Instance("UICorner", {
                Parent = TextBox,
                CornerRadius = UDim.new(0, 4)
            })
            
            Linux.Instance("UIPadding", {
                Parent = TextBox,
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6)
            })
            
            local MaxLength = 100
            
            local function CheckTextBounds()
                if #TextBox.Text > MaxLength then
                    TextBox.Text = string.sub(TextBox.Text, 1, MaxLength)
                end
            end
            
            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                CheckTextBounds()
            end)
            
            local function UpdateInput()
                CheckTextBounds()
                spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            end
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    UpdateInput()
                end
            end)
            
            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                end
            end)
            
            spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            
            local function SetValue(newValue)
                local text = tostring(newValue)
                if #text > MaxLength then
                    text = string.sub(text, 1, MaxLength)
                end
                TextBox.Text = text
                UpdateInput()
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = Input,
                SetValue = SetValue,
                GetValue = function() return TextBox.Text end
            }
        end
        
        function TabElements.Label(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local LabelFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = LabelFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = LabelFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local LabelText = Linux.Instance("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Text or "Label",
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 2
            })
            
            local UpdateConnection = nil
            local lastUpdate = 0
            local updateInterval = 0.1
            
            local function StartUpdateLoop()
                if UpdateConnection then
                    UpdateConnection:Disconnect()
                end
                if config.UpdateCallback then
                    UpdateConnection = RunService.Heartbeat:Connect(function()
                        if not LabelFrame:IsDescendantOf(game) then
                            UpdateConnection:Disconnect()
                            return
                        end
                        local currentTime = tick()
                        if currentTime - lastUpdate >= updateInterval then
                            local success, newText = pcall(config.UpdateCallback)
                            if success and newText ~= nil then
                                LabelText.Text = tostring(newText)
                            end
                            lastUpdate = currentTime
                        end
                    end)
                end
            end
            
            local function SetText(newText)
                if config.UpdateCallback then
                    config.Text = tostring(newText)
                else
                    LabelText.Text = tostring(newText)
                end
            end
            
            if config.UpdateCallback then
                StartUpdateLoop()
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = LabelFrame,
                SetText = SetText,
                GetText = function() return LabelText.Text end
            }
        end
        
        function TabElements.Section(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Section = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })
            
            local SectionLabel = Linux.Instance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamBold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return Section
        end
        
        function TabElements.Paragraph(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local ParagraphFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = ParagraphFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ParagraphFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 26),
                Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamBold,
                Text = config.Title or "Paragraph",
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local Content = Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = config.Content or "Content",
                TextColor3 = Color3.fromRGB(150, 150, 155),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2
            })
            
            Linux.Instance("UIPadding", {
                Parent = ParagraphFrame,
                PaddingBottom = UDim.new(0, 10)
            })
            
            local function SetTitle(newTitle)
                ParagraphFrame:GetChildren()[3].Text = tostring(newTitle)
            end
            
            local function SetContent(newContent)
                Content.Text = tostring(newContent)
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = ParagraphFrame,
                SetTitle = SetTitle,
                SetContent = SetContent
            }
        end
        
        function TabElements.Notification(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local NotificationFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = NotificationFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = NotificationFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local purpleColor = Color3.fromRGB(125, 65, 255)
            
            local NotificationText = Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -20, 1, 0),
                Position = UDim2.new(0.5, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Default or "Notification",
                TextColor3 = purpleColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 2
            })
            
            local function SetText(newText)
                NotificationText.Text = tostring(newText)
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = NotificationFrame,
                SetText = SetText,
                GetText = function() return NotificationText.Text end
            }
        end
        
        function TabElements.Keybind(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local KeybindFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = KeybindFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = KeybindFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = KeybindFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local currentKey = config.Default or Enum.KeyCode.None
            local isCapturing = false
            
            local KeybindButton = Linux.Instance("TextButton", {
                Parent = KeybindFrame,
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                BorderSizePixel = 0,
                Size = UDim2.new(0.3, -16, 0, 24),
                Position = UDim2.new(0.7, 0, 0.5, -12),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(currentKey.Name),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                ZIndex = 3,
                AutoButtonColor = false
            })
            
            Linux.Instance("UICorner", {
                Parent = KeybindButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            local inputConnection = nil
            
            local function StopCapture()
                if inputConnection then
                    inputConnection:Disconnect()
                    inputConnection = nil
                end
                isCapturing = false
                KeybindButton.Text = tostring(currentKey.Name)
                KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                if isCapturing then
                    StopCapture()
                    return
                end
                isCapturing = true
                KeybindButton.Text = "..."
                KeybindButton.TextColor3 = Color3.fromRGB(200, 200, 210)
                
                inputConnection = InputService.InputBegan:Connect(function(input, gameProcessedEvent)
                    if gameProcessedEvent then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            StopCapture()
                        else
                            currentKey = input.KeyCode
                            StopCapture()
                            spawn(function() Linux:SafeCallback(config.Callback, currentKey) end)
                        end
                    end
                end)
            end)
            
            spawn(function() Linux:SafeCallback(config.Callback, currentKey) end)
            
            local function SetValue(newKey)
                if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
                    currentKey = newKey
                    KeybindButton.Text = tostring(currentKey.Name)
                    spawn(function() Linux:SafeCallback(config.Callback, currentKey) end)
                end
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = KeybindFrame,
                SetValue = SetValue,
                GetValue = function() return currentKey end
            }
        end
        
        function TabElements.Colorpicker(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local ColorpickerFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = ColorpickerFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ColorpickerFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = ColorpickerFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local currentColor = config.Default or Color3.fromRGB(255, 255, 255)
            local isPicking = false
            
            local ColorPreview = Linux.Instance("Frame", {
                Parent = ColorpickerFrame,
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(1, -34, 0.5, -12),
                ZIndex = 3
            })
            
            Linux.Instance("UICorner", {
                Parent = ColorPreview,
                CornerRadius = UDim.new(0, 4)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ColorPreview,
                Color = Color3.fromRGB(60, 60, 70),
                Thickness = 1
            })
            
            local ColorpickerPopup = nil
            local paletteMarker = nil
            local hueMarker = nil
            local currentHue = 0
            local currentSaturation = 0
            local currentValue = 1
            
            local function UpdateColorFromHSV()
                currentColor = Color3.fromHSV(currentHue, currentSaturation, currentValue)
                ColorPreview.BackgroundColor3 = currentColor
                
                if ColorpickerPopup then
                    local palette = ColorpickerPopup:FindFirstChild("Palette")
                    if palette then
                        palette.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                    end
                    
                    local preview = ColorpickerPopup:FindFirstChild("ColorPreview")
                    if preview then
                        preview.BackgroundColor3 = currentColor
                    end
                end
                spawn(function() Linux:SafeCallback(config.Callback, currentColor) end)
            end
            
            local function CreateColorpickerPopup()
                if ColorpickerPopup then
                    ColorpickerPopup:Destroy()
                end
                
                ColorpickerPopup = Linux.Instance("Frame", {
                    Parent = Main,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    BorderColor3 = Color3.fromRGB(40, 40, 50),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 200, 0, 180),
                    Position = UDim2.new(0.5, -100, 0.5, -90),
                    ZIndex = 10,
                    Visible = false
                })
                
                Linux.Instance("UICorner", {
                    Parent = ColorpickerPopup,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Linux.Instance("UIStroke", {
                    Parent = ColorpickerPopup,
                    Color = Color3.fromRGB(40, 40, 50),
                    Thickness = 1
                })
                
                local Palette = Linux.Instance("Frame", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1),
                    Size = UDim2.new(0, 140, 0, 100),
                    Position = UDim2.new(0, 10, 0, 10),
                    ZIndex = 11
                })
                
                Linux.Instance("UICorner", {
                    Parent = Palette,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local SaturationGradient = Linux.Instance("UIGradient", {
                    Parent = Palette,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, 1, 1))
                    }),
                    Transparency = NumberSequence.new(0),
                    Rotation = 0
                })
                
                local ValueOverlay = Linux.Instance("Frame", {
                    Parent = Palette,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 11
                })
                
                Linux.Instance("UICorner", {
                    Parent = ValueOverlay,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local ValueGradient = Linux.Instance("UIGradient", {
                    Parent = ValueOverlay,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                    }),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }),
                    Rotation = 90
                })
                
                paletteMarker = Linux.Instance("Frame", {
                    Parent = Palette,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 6, 0, 6),
                    ZIndex = 12,
                    BorderSizePixel = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Linux.Instance("UICorner", {
                    Parent = paletteMarker,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local HueBar = Linux.Instance("Frame", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 20, 0, 100),
                    Position = UDim2.new(0, 160, 0, 10),
                    ZIndex = 11
                })
                
                Linux.Instance("UICorner", {
                    Parent = HueBar,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local HueGradient = Linux.Instance("UIGradient", {
                    Parent = HueBar,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90
                })
                
                hueMarker = Linux.Instance("Frame", {
                    Parent = HueBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 24, 0, 4),
                    ZIndex = 12,
                    BorderSizePixel = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                local ColorPreview = Linux.Instance("Frame", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = currentColor,
                    Size = UDim2.new(0, 180, 0, 30),
                    Position = UDim2.new(0, 10, 0, 120),
                    ZIndex = 11,
                    Name = "ColorPreview"
                })
                
                Linux.Instance("UICorner", {
                    Parent = ColorPreview,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Linux.Instance("UIStroke", {
                    Parent = ColorPreview,
                    Color = Color3.fromRGB(60, 60, 70),
                    Thickness = 1
                })
                
                local CloseButton = Linux.Instance("TextButton", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                    Size = UDim2.new(0, 180, 0, 20),
                    Position = UDim2.new(0, 10, 0, 150),
                    Font = Enum.Font.GothamSemibold,
                    Text = "Close",
                    TextColor3 = Color3.fromRGB(200, 200, 210),
                    TextSize = 12,
                    ZIndex = 11,
                    AutoButtonColor = false
                })
                
                Linux.Instance("UICorner", {
                    Parent = CloseButton,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local paletteDragging = false
                local hueDragging = false
                
                Palette.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        paletteDragging = true
                        local pos = input.Position
                        local palettePos = Palette.AbsolutePosition
                        local paletteSize = Palette.AbsoluteSize
                        local x = math.clamp((pos.X - palettePos.X) / paletteSize.X, 0, 1)
                        local y = math.clamp((pos.Y - palettePos.Y) / paletteSize.Y, 0, 1)
                        currentSaturation = x
                        currentValue = 1 - y
                        paletteMarker.Position = UDim2.new(0, x * paletteSize.X - 3, 0, y * paletteSize.Y - 3)
                        UpdateColorFromHSV()
                    end
                end)
                
                Palette.InputChanged:Connect(function(input)
                    if paletteDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position
                        local palettePos = Palette.AbsolutePosition
                        local paletteSize = Palette.AbsoluteSize
                        local x = math.clamp((pos.X - palettePos.X) / paletteSize.X, 0, 1)
                        local y = math.clamp((pos.Y - palettePos.Y) / paletteSize.Y, 0, 1)
                        currentSaturation = x
                        currentValue = 1 - y
                        paletteMarker.Position = UDim2.new(0, x * paletteSize.X - 3, 0, y * paletteSize.Y - 3)
                        UpdateColorFromHSV()
                    end
                end)
                
                Palette.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        paletteDragging = false
                    end
                end)
                
                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true
                        local pos = input.Position
                        local huePos = HueBar.AbsolutePosition
                        local hueSize = HueBar.AbsoluteSize
                        local y = math.clamp((pos.Y - huePos.Y) / hueSize.Y, 0, 1)
                        currentHue = 1 - y
                        hueMarker.Position = UDim2.new(0, -2, 0, y * hueSize.Y - 2)
                        UpdateColorFromHSV()
                    end
                end)
                
                HueBar.InputChanged:Connect(function(input)
                    if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position
                        local huePos = HueBar.AbsolutePosition
                        local hueSize = HueBar.AbsoluteSize
                        local y = math.clamp((pos.Y - huePos.Y) / hueSize.Y, 0, 1)
                        currentHue = 1 - y
                        hueMarker.Position = UDim2.new(0, -2, 0, y * hueSize.Y - 2)
                        UpdateColorFromHSV()
                    end
                end)
                
                HueBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = false
                    end
                end)
                
                CloseButton.MouseButton1Click:Connect(function()
                    isPicking = false
                    ColorpickerPopup.Visible = false
                end)
                
                local h, s, v = currentColor:ToHSV()
                currentHue = h
                currentSaturation = s
                currentValue = v
                paletteMarker.Position = UDim2.new(0, s * Palette.AbsoluteSize.X - 3, 0, (1 - v) * Palette.AbsoluteSize.Y - 3)
                hueMarker.Position = UDim2.new(0, -2, 0, (1 - h) * HueBar.AbsoluteSize.Y - 2)
                Palette.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            end
            
            ColorPreview.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isPicking = not isPicking
                    if isPicking then
                        CreateColorpickerPopup()
                        ColorpickerPopup.Visible = true
                    else
                        if ColorpickerPopup then
                            ColorpickerPopup.Visible = false
                        end
                    end
                end
            end)
            
            local function SetValue(newColor)
                if typeof(newColor) == "Color3" then
                    currentColor = newColor
                    ColorPreview.BackgroundColor3 = currentColor
                    local h, s, v = newColor:ToHSV()
                    currentHue = h
                    currentSaturation = s
                    currentValue = v
                    if ColorpickerPopup then
                        paletteMarker.Position = UDim2.new(0, s * 140 - 3, 0, (1 - v) * 100 - 3)
                        hueMarker.Position = UDim2.new(0, -2, 0, (1 - h) * 100 - 2)
                        local palette = ColorpickerPopup:FindFirstChild("Palette")
                        if palette then
                            palette.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        end
                        local preview = ColorpickerPopup:FindFirstChild("ColorPreview")
                        if preview then
                            preview.BackgroundColor3 = currentColor
                        end
                    end
                    spawn(function() Linux:SafeCallback(config.Callback, currentColor) end)
                end
            end
            
            spawn(function() Linux:SafeCallback(config.Callback, currentColor) end)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            return {
                Instance = ColorpickerFrame,
                SetValue = SetValue,
                GetValue = function() return currentColor end
            }
        end
        
        return TabElements
    end
    
    function LinuxLib.Destroy()
        for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
            if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
                v:Destroy()
            end
        end
    end
    
    return LinuxLib
end

return Linux
