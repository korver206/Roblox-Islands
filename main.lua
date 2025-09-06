-- Roblox Islands Script - Minimal Test Version
-- This is a minimal version to test if UI can be created

wait(1) -- Wait a moment for the game to load

local player = game.Players.LocalPlayer or game.Players.LocalPlayerAdded:Wait()
local mouse = player:GetMouse()

-- Simple UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "TestUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(100, 100, 100)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Test UI Loaded"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 40)
status.BackgroundTransparency = 1
status.Text = "If you see this, UI works!"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.TextSize = 14
status.Font = Enum.Font.SourceSans
status.Parent = frame

print("[Test Script] UI should be visible now")