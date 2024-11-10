local NatsLib = {}

function NatsLib:MakeWindow(config)
    -- Main window setup
    local window = Instance.new("ScreenGui")
    window.Name = config.Name or "NatsLibWindow"
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    window.Enabled = false  -- Start with window disabled

    -- Window frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)  -- Adjust size if needed
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Center the frame
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)  -- Dark gray background
    frame.BorderSizePixel = 0
    frame.Visible = false  -- Start hidden, will enable after intro
    frame.Parent = window

    -- Sidebar for tabs
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 100, 1, 0)  -- Width of sidebar
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)  -- Darker shade for sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = frame

    -- Draggable top bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)  -- Height of top bar
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)  -- Even darker for top bar
    topBar.BorderSizePixel = 0
    topBar.Parent = frame

    -- Enable dragging for top bar
    local dragging = false
    local dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Minimize and Close Buttons
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 20, 0, 20)
    minimizeButton.Position = UDim2.new(1, -50, 0, 5)
    minimizeButton.Text = "_"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Parent = topBar
    minimizeButton.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Parent = topBar
    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- Intro Text with Fade-In Animation
    if config.IntroEnabled and config.IntroText then
        local introText = Instance.new("TextLabel")
        introText.Size = UDim2.new(1, 0, 1, 0)
        introText.Position = UDim2.new(0, 0, 0, 0)
        introText.Text = config.IntroText
        introText.TextColor3 = Color3.fromRGB(255, 255, 255)
        introText.BackgroundTransparency = 1
        introText.TextTransparency = 1  -- Start fully transparent
        introText.Parent = frame

        -- Fade-in animation
        for i = 1, 10 do
            introText.TextTransparency = introText.TextTransparency - 0.1
            wait(0.1)
        end

        introText:Destroy()  -- Remove intro text after animation
        frame.Visible = true  -- Show the main frame after intro
        window.Enabled = true  -- Enable the main window
    else
        frame.Visible = true  -- Show frame immediately if no intro
        window.Enabled = true  -- Enable window
    end

    -- Return a table for managing the window’s elements
    return {
        AddTab = function(self, tabConfig)
            -- Add Tab Button to Sidebar
            local tabButton = Instance.new("TextButton")
            tabButton.Size = UDim2.new(1, 0, 0, 30)
            tabButton.Text = tabConfig.Name or "Tab"
            tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tabButton.BorderSizePixel = 0
            tabButton.Parent = sidebar

            -- Handle tab functionality (e.g., switching tabs)
            tabButton.MouseButton1Click:Connect(function()
                print("Switched to tab:", tabConfig.Name)
            end)

            return tabButton
        end
        -- Additional functions for other elements could go here
    }
end

return NatsLib
