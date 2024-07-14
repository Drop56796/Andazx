local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 创建 UI 库
local UILib = {}

-- 创建窗口函数
function UILib:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 600, 0, 600)
    frame.Position = UDim2.new(0.5, -300, 0.5, -300)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = frame

    local winButton = Instance.new("TextButton")
    winButton.Size = UDim2.new(0, 100, 0, 50)
    winButton.Position = UDim2.new(0, 0, 0, 50)
    winButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    winButton.Text = "打开/关闭"
    winButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    winButton.Parent = frame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -100)
    contentFrame.Position = UDim2.new(0, 0, 0, 100)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = frame

    winButton.MouseButton1Click:Connect(function()
        contentFrame.Visible = not contentFrame.Visible
    end)

    local tabs = {}

    function tabs:Tab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 0, 50)
        tabButton.Position = UDim2.new(#tabs * 0.2, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Parent = contentFrame

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, -50)
        tabContent.Position = UDim2.new(0, 0, 0, 50)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(contentFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            tabContent.Visible = true
        end)

        table.insert(tabs, tabButton)
        return tabContent
    end

    return tabs
end

-- 创建文本框函数
function UILib:CreateTextBox(parent, placeholderText, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 400, 0, 50)
    textBox.Position = UDim2.new(0, 0, 0, 20)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Text = placeholderText
    textBox.Parent = parent
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)
    return textBox
end

-- 创建按钮函数
function UILib:CreateButton(parent, buttonText, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 400, 0, 50)
    button.Position = UDim2.new(0, 0, 0, 80)
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    button.Text = buttonText
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end

-- 创建切换开关函数
function UILib:CreateToggle(parent, toggleText, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 400, 0, 50)
    toggle.Position = UDim2.new(0, 0, 0, 140)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggle.Text = toggleText
    toggle.Parent = parent

    local isToggled = false
    toggle.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggle.Text = isToggled and "开启" or "关闭"
        toggle.BackgroundColor3 = isToggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(isToggled)
    end)
    return toggle
end

-- 创建滑块函数
function UILib:CreateSlider(parent, default, initial, max, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0, 400, 0, 50)
    slider.Position = UDim2.new(0, 0, 0, 200)
    slider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    slider.Parent = parent

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 50)
    sliderButton.Position = UDim2.new(initial / max, 0, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderButton.Text = ""
    sliderButton.Parent = slider

    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    sliderButton.MouseButton1Up:Connect(function()
        dragging = false
    end)

    sliderButton.MouseLeave:Connect(function()
        dragging = false
    end)

    sliderButton.MouseMoved:Connect(function(x, y)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local newPosition = math.clamp(relativeX, 0, slider.AbsoluteSize.X - sliderButton.AbsoluteSize.X)
            sliderButton.Position = UDim2.new(0, newPosition, 0, 0)
            callback(newPosition / (slider.AbsoluteSize.X - sliderButton.AbsoluteSize.X) * max)
        end
    end)

    -- 设置默认值
    sliderButton.Position = UDim2.new(default / max, 0, 0, 0)
    callback(default)

    return slider
end

-- 添加动画函数
function UILib:AddAnimation(frame)
    local tweenInfo = TweenInfo.new(
        2, -- 动画持续时间
        Enum.EasingStyle.Bounce, -- 动画样式
        Enum.EasingDirection.Out, -- 动画方向
        -1, -- 重复次数（-1 表示无限循环）
        true, -- 是否反向播放
        0 -- 延迟时间
    )

    local goal = {}
    goal.Position = UDim2.new(0.5, -300, 0.5, -250)
    goal.Size = UDim2.new(0, 650, 0, 650)
    goal.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

    local tween = TweenService:Create(frame, tweenInfo, goal)
    tween:Play()
end
