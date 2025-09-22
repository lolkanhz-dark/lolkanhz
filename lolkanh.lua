-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "lolkanhzMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tạo Frame chính (nền menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Visible = true
frame.Parent = screenGui

-- Tiêu đề menu
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "lolkanhz Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
title.Parent = frame

-- Nút đóng/mở menu
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.2, 0, 0, 30)
toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
toggleButton.Text = "X"
toggleButton.Parent = frame
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Kéo thả menu
local dragging = false
local dragInput, mousePos, framePos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                   framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- ESP
local Players = game:GetService("Players")
local ESPEnabled = false
local ESPBoxes = {}

local function addESP(player)
    if player.Character and not ESPBoxes[player] then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 2)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.Parent = game:GetService("CoreGui")
        ESPBoxes[player] = box
    end
end

local function removeESP(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
end

local function toggleESP()
    ESPEnabled = not ESPEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if ESPEnabled then
                addESP(player)
            else
                removeESP(player)
            end
        end
    end
end

-- Nút bật/tắt ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0, 50)
espButton.Text = "ESP Bật/Tắt"
espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Parent = frame
espButton.MouseButton1Click:Connect(toggleESP)

-- Cập nhật ESP khi có người chơi mới
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        player.CharacterAdded:Connect(function()
            addESP(player)
        end)
    end
end)
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)
