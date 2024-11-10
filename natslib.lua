local NatsLib = {}

function NatsLib:MakeWindow(config)
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main window setup
    local window = Instance.new("ScreenGui")
    window.Name = config.Name or "NatsLibWindow"
    window.Parent = playerGui
    window.Enabled = true

    -- Window frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.6, 0)  -- Scaled down for mobile screens
    frame.Position = UDim2.new(0.1, 0, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Visible = false  -- Hide until intro completes
    frame.Parent = window

    -- Sidebar for tabs
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 80, 1, 0)  -- Scaled down width for mobile
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = frame

    -- Draggable top bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame

    -- Minimize and Close buttons
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
        introText.Parent = window

        -- Fade-in animation
        for i = 1, 10 do
            introText.TextTransparency = introText.TextTransparency - 0.1
            wait(0.1)
        end

        -- Remove intro text and show main frame
        introText:Destroy()
        frame.Visible = true  -- Show the main frame after intro
    else
        frame.Visible = true  -- Show frame immediately if no intro
    end

    -- Function to create and position tabs in sidebar
    local tabCount = 0

    return {
        AddTab = function(self, tabConfig)
            tabCount = tabCount + 1

            -- Create the tab button in the sidebar
            local tabButton = Instance.new("TextButton")
            tabButton.Size = UDim2.new(1, 0, 0, 40)  -- Larger buttons for mobile
            tabButton.Position = UDim2.new(0, 0, 0, (tabCount - 1) * 40)
            tabButton.Text = tabConfig.Name or "Tab"
            tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  -- Darker background for visibility
            tabButton.BorderSizePixel = 0
            tabButton.Parent = sidebar  -- Ensure it's added to sidebar

            -- Debug message
            print("Tab created:", tabConfig.Name)

            -- Handle tab functionality
            tabButton.MouseButton1Click:Connect(function()
                print("Switched to tab:", tabConfig.Name)
            end)
        end
    }
end

return NatsLib
