-- Roblox Islands Script v3.1
-- Simplified version to fix UI opening issue

-- Wait for the game to load properly
repeat wait() until game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "IslandsUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(70, 70, 70)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Islands Script v3.1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local dupBtn = Instance.new("TextButton")
dupBtn.Size = UDim2.new(0, 140, 0, 30)
dupBtn.Position = UDim2.new(0, 5, 0, 40)
dupBtn.Text = "Duplicate Item"
dupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dupBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
dupBtn.BorderSizePixel = 1
dupBtn.BorderColor3 = Color3.fromRGB(100, 100, 220)
dupBtn.Parent = frame

local coinBtn = Instance.new("TextButton")
coinBtn.Size = UDim2.new(0, 140, 0, 30)
coinBtn.Position = UDim2.new(0, 155, 0, 40)
coinBtn.Text = "Add Coins"
coinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
coinBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
coinBtn.BorderSizePixel = 1
coinBtn.BorderColor3 = Color3.fromRGB(100, 220, 100)
coinBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 60)
status.Position = UDim2.new(0, 0, 0, 80)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.TextSize = 14
status.TextWrapped = true
status.Font = Enum.Font.SourceSans
status.Parent = frame

-- Functions
local function updateStatus(text)
    status.Text = "Status: "..text
end

local function duplicateItem()
    local character = player.Character or player.CharacterAdded:Wait()
    local backpack = player:WaitForChild("Backpack")
    
    local tool = character:FindFirstChildWhichIsA("Tool") or backpack:FindFirstChildWhichIsA("Tool")
    
    if tool then
        local clone = tool:Clone()
        clone.Parent = backpack
        updateStatus("Duplicated "..tool.Name.." (client-side)")
    else
        updateStatus("No item found")
    end
end

local function addCoins()
    local leaderstats = player:FindFirstChild("leaderstats") or player:FindFirstChild("Leaderstats")
    local coinsValue = nil
    
    if leaderstats then
        coinsValue = leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("coins") or leaderstats:FindFirstChild("Coin") or leaderstats:FindFirstChild("coin")
    end
    
    if not coinsValue then
        coinsValue = player:FindFirstChild("Coins") or player:FindFirstChild("coins") or player:FindFirstChild("Coin") or player:FindFirstChild("coin")
    end
    
    if coinsValue and typeof(coinsValue) == "Instance" and (coinsValue:IsA("IntValue") or coinsValue:IsA("NumberValue")) then
        coinsValue.Value = coinsValue.Value + 10000
        updateStatus("Added 10k coins (direct)")
    else
        updateStatus("Coins not found")
    end
end

-- Connections
dupBtn.MouseButton1Click:Connect(duplicateItem)
coinBtn.MouseButton1Click:Connect(addCoins)

mouse.KeyDown:Connect(function(key)
    if key:lower() == "g" then
        frame.Visible = not frame.Visible
        updateStatus(frame.Visible and "UI Enabled" or "UI Disabled")
    end
end)

updateStatus("Script Loaded Successfully")
print("[Islands Script] Script v3.1 initialized. Toggle UI with 'G' key.")