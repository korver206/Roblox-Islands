-- Roblox Islands Comprehensive Script v2.0
-- Enhanced solution for finding remote events in any location
-- Compatible with Vega X
-- Toggle UI with 'G' key

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local replicatedStorage = game:GetService("ReplicatedStorage")
local backpack = player:WaitForChild("Backpack")
local enabled = true
local debugMode = false

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "IslandsUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 340)
frame.Position = UDim2.new(0.5, -160, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(70, 70, 70)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
frame.Visible = enabled

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Islands Comprehensive Script v2.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0.5
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local dupBtn = Instance.new("TextButton")
dupBtn.Size = UDim2.new(0, 300, 0, 35)
dupBtn.Position = UDim2.new(0, 10, 0, 40)
dupBtn.Text = "Duplicate Item"
dupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dupBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
dupBtn.BorderSizePixel = 1
dupBtn.BorderColor3 = Color3.fromRGB(100, 100, 220)
dupBtn.Parent = frame

local coinBtn = Instance.new("TextButton")
coinBtn.Size = UDim2.new(0, 300, 0, 35)
coinBtn.Position = UDim2.new(0, 10, 0, 85)
coinBtn.Text = "Add Coins"
coinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
coinBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
coinBtn.BorderSizePixel = 1
coinBtn.BorderColor3 = Color3.fromRGB(100, 220, 100)
coinBtn.Parent = frame

local debugBtn = Instance.new("TextButton")
debugBtn.Size = UDim2.new(0, 300, 0, 35)
debugBtn.Position = UDim2.new(0, 10, 0, 130)
debugBtn.Text = "Toggle Debug Mode"
debugBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
debugBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
debugBtn.BorderSizePixel = 1
debugBtn.BorderColor3 = Color3.fromRGB(220, 100, 100)
debugBtn.Parent = frame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0, 300, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 0, 175)
scanBtn.Text = "Scan All for Remotes"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 60)
scanBtn.BorderSizePixel = 1
scanBtn.BorderColor3 = Color3.fromRGB(220, 220, 100)
scanBtn.Parent = frame

local scanCoinsBtn = Instance.new("TextButton")
scanCoinsBtn.Size = UDim2.new(0, 300, 0, 35)
scanCoinsBtn.Position = UDim2.new(0, 10, 0, 220)
scanCoinsBtn.Text = "Scan for Coins"
scanCoinsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanCoinsBtn.BackgroundColor3 = Color3.fromRGB(180, 90, 180)
scanCoinsBtn.BorderSizePixel = 1
scanCoinsBtn.BorderColor3 = Color3.fromRGB(220, 150, 220)
scanCoinsBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 60)
status.Position = UDim2.new(0, 0, 0, 270)
status.BackgroundTransparency = 1
status.Text = "Status: Ready\nHold an item to duplicate"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.TextStrokeTransparency = 0.7
status.TextScaled = false
status.TextSize = 14
status.TextWrapped = true
status.Font = Enum.Font.SourceSans
status.Parent = frame

-- Helper Functions
local function updateStatus(text)
    status.Text = "Status: "..text
    if debugMode then
        print("[Islands Script] "..text)
    end
end

local function findRemoteEventInContainer(container, names)
    if not container or not container:IsA("Instance") then return nil end
    
    for _, name in ipairs(names) do
        local event = container:FindFirstChild(name)
        if event and (event:IsA("RemoteEvent") or event:IsA("RemoteFunction")) then
            return event, name, container.Name
        end
    end
    return nil
end

local function findRemoteEvent(names)
    -- Search in common locations
    local locations = {
        {"ReplicatedStorage", replicatedStorage},
        {"Workspace", workspace},
        {"game", game},
        {"Lighting", game:GetService("Lighting")},
        {"SoundService", game:GetService("SoundService")},
        {"StarterGui", game:GetService("StarterGui")},
        {"StarterPack", game:GetService("StarterPack")},
        {"HttpService", game:GetService("HttpService")},
    }
    
    -- Add player-specific locations
    table.insert(locations, {"Player", player})
    if player:FindFirstChild("PlayerGui") then
        table.insert(locations, {"PlayerGui", player.PlayerGui})
    end
    if player:FindFirstChild("Backpack") then
        table.insert(locations, {"Backpack", player.Backpack})
    end
    
    -- Search in each location
    for _, location in ipairs(locations) do
        local event, name, containerName = findRemoteEventInContainer(location[2], names)
        if event then
            return event, name, location[1]
        end
    end
    
    -- If not found, search recursively in ReplicatedStorage
    local function searchRecursively(instance)
        if not instance then return nil end
        
        for _, child in ipairs(instance:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                for _, name in ipairs(names) do
                    if child.Name == name then
                        return child, name, instance.Name
                    end
                end
            elseif child:IsA("Folder") or child:IsA("Model") then
                local event, name, container = searchRecursively(child)
                if event then
                    return event, name, container
                end
            end
        end
        return nil
    end
    
    local event, name, container = searchRecursively(replicatedStorage)
    if event then
        return event, name, container
    end
    
    return nil
end

local function findCoinsValue()
    -- Comprehensive paths for coins
    local paths = {
        {"player.leaderstats.Coins", function() return player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins") end},
        {"player.leaderstats.coins", function() return player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("coins") end},
        {"player.leaderstats.Coin", function() return player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coin") end},
        {"player.leaderstats.coin", function() return player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("coin") end},
        {"player.Leaderstats.Coins", function() return player:FindFirstChild("Leaderstats") and player.Leaderstats:FindFirstChild("Coins") end},
        {"player.Leaderstats.coins", function() return player:FindFirstChild("Leaderstats") and player.Leaderstats:FindFirstChild("coins") end},
        {"player.Leaderstats.Coin", function() return player:FindFirstChild("Leaderstats") and player.Leaderstats:FindFirstChild("Coin") end},
        {"player.Leaderstats.coin", function() return player:FindFirstChild("Leaderstats") and player.Leaderstats:FindFirstChild("coin") end},
        {"player.data.Coins", function() return player:FindFirstChild("data") and player.data:FindFirstChild("Coins") end},
        {"player.data.coins", function() return player:FindFirstChild("data") and player.data:FindFirstChild("coins") end},
        {"player.Data.Coins", function() return player:FindFirstChild("Data") and player.Data:FindFirstChild("Coins") end},
        {"player.Data.coins", function() return player:FindFirstChild("Data") and player.Data:FindFirstChild("coins") end},
        {"player.Values.Coins", function() return player:FindFirstChild("Values") and player.Values:FindFirstChild("Coins") end},
        {"player.Values.coins", function() return player:FindFirstChild("Values") and player.Values:FindFirstChild("coins") end},
        {"player.Stats.Coins", function() return player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Coins") end},
        {"player.Stats.coins", function() return player:FindFirstChild("Stats") and player.Stats:FindFirstChild("coins") end},
        {"player.Money.Coins", function() return player:FindFirstChild("Money") and player.Money:FindFirstChild("Coins") end},
        {"player.Money.coins", function() return player:FindFirstChild("Money") and player.Money:FindFirstChild("coins") end},
        {"player.Currency.Coins", function() return player:FindFirstChild("Currency") and player.Currency:FindFirstChild("Coins") end},
        {"player.Currency.coins", function() return player:FindFirstChild("Currency") and player.Currency:FindFirstChild("coins") end},
        {"player.Balance.Value", function() return player:FindFirstChild("Balance") and player.Balance:FindFirstChild("Value") end},
        {"player.Coins", function() return player:FindFirstChild("Coins") end},
        {"player.coins", function() return player:FindFirstChild("coins") end},
        {"player.Coin", function() return player:FindFirstChild("Coin") end},
        {"player.coin", function() return player:FindFirstChild("coin") end},
        {"player.Money", function() return player:FindFirstChild("Money") end},
        {"player.money", function() return player:FindFirstChild("money") end},
        {"player.Currency", function() return player:FindFirstChild("Currency") end},
        {"player.currency", function() return player:FindFirstChild("currency") end},
        {"player.Balance", function() return player:FindFirstChild("Balance") end},
        {"player.balance", function() return player:FindFirstChild("balance") end},
    }
    
    for i, path in ipairs(paths) do
        local coinsValue = path[2]()
        if coinsValue and typeof(coinsValue) == "Instance" and (coinsValue:IsA("IntValue") or coinsValue:IsA("NumberValue") or coinsValue:IsA("StringValue")) then
            return coinsValue, path[1]
        end
    end
    
    return nil
end

local function scanForRemotesInContainer(containerName, container)
    if not container or not container:IsA("Instance") then return {} end
    
    local remotes = {}
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(remotes, {name = child.Name, type = child.ClassName, container = containerName})
        end
    end
    return remotes
end

local function scanAllForRemotes()
    updateStatus("Scanning all locations for remotes...")
    local allRemotes = {}
    
    -- Common locations to check
    local locations = {
        {"ReplicatedStorage", replicatedStorage},
        {"Workspace", workspace},
        {"game", game},
        {"Lighting", game:GetService("Lighting")},
        {"SoundService", game:GetService("SoundService")},
        {"StarterGui", game:GetService("StarterGui")},
        {"StarterPack", game:GetService("StarterPack")},
    }
    
    -- Add player-specific locations
    table.insert(locations, {"Player", player})
    if player:FindFirstChild("PlayerGui") then
        table.insert(locations, {"PlayerGui", player.PlayerGui})
    end
    if player:FindFirstChild("Backpack") then
        table.insert(locations, {"Backpack", player.Backpack})
    end
    
    -- Scan each location
    for _, location in ipairs(locations) do
        local remotes = scanForRemotesInContainer(location[1], location[2])
        for _, remote in ipairs(remotes) do
            table.insert(allRemotes, remote)
        end
    end
    
    if #allRemotes > 0 then
        updateStatus("Found "..#allRemotes.." remotes. Check console for details.")
        print("[Islands Script] Remote Events/Functions Found:")
        for i, remote in ipairs(allRemotes) do
            print("  "..i..". "..remote.name.." ("..remote.type..") in "..remote.container)
        end
        print("[Islands Script] Look for names related to 'Duplicate', 'Clone', 'Item', 'Coin', 'Add', 'Give'")
    else
        updateStatus("No remotes found in any location.")
        print("[Islands Script] No Remote Events/Functions found in common locations.")
        print("[Islands Script] The game may use obfuscation or custom structures.")
    end
end

local function scanForCoins()
    updateStatus("Scanning for coin values...")
    print("[Islands Script] Player children:")
    for i, child in ipairs(player:GetChildren()) do
        print("  "..i..". "..child.Name.." ("..child.ClassName..")")
    end
    
    if player:FindFirstChild("leaderstats") then
        print("[Islands Script] Leaderstats children:")
        for i, child in ipairs(player.leaderstats:GetChildren()) do
            print("  "..i..". "..child.Name.." ("..child.ClassName..")")
        end
    end
    
    if player:FindFirstChild("data") then
        print("[Islands Script] Data children:")
        for i, child in ipairs(player.data:GetChildren()) do
            print("  "..i..". "..child.Name.." ("..child.ClassName..")")
        end
    end
    
    updateStatus("Coin scan complete. Check console for details.")
end

-- Main Functions
local function duplicateItem()
    local character = player.Character or player.CharacterAdded:Wait()
    local tool = character:FindFirstChildWhichIsA("Tool") or backpack:FindFirstChildWhichIsA("Tool")
    
    if tool then
        updateStatus("Attempting to duplicate "..tool.Name.."...")
        
        -- Comprehensive list of possible duplication remote event names
        local dupEventNames = {
            -- Common variations
            "DuplicateItem", "DupItem", "duplicateItem", "dupItem",
            "CloneItem", "cloneItem", "Clone", "clone",
            "Duplicate", "duplicate", "CopyItem", "copyItem",
            "ReplicateItem", "replicateItem", "CreateItem", "createItem",
            "GiveItem", "giveItem", "AddItem", "addItem",
            
            -- More specific variations
            "ServerDuplicate", "ServerDup", "ItemDuplicate", "ItemDup",
            "DuplicateTool", "DupTool", "CloneTool", "CopyTool",
            "ReplicateTool", "CreateTool", "GiveTool", "AddTool",
            
            -- Game-specific possibilities
            "Replicate", "Rep", "MakeItem", "NewItem", "SpawnItem",
            "GenerateItem", "ProduceItem", "ForgeItem", "CraftItem",
            
            -- Other common names
            "MakeTool", "SpawnTool", "CreateTool", "GenerateTool",
            "ProduceTool", "ForgeTool", "CraftTool", "BuildItem",
            "BuildTool", "ConstructItem", "ConstructTool"
        }
        
        local dupEvent, eventName, containerName = findRemoteEvent(dupEventNames)
        
        if dupEvent then
            if dupEvent:IsA("RemoteEvent") then
                dupEvent:FireServer(tool)
                updateStatus("SUCCESS! Duplicated "..tool.Name.." using "..eventName.." (RemoteEvent)")
                if debugMode then
                    print("[Islands Script] Used RemoteEvent: "..eventName.." in "..containerName)
                end
            else
                local success, result = pcall(function() return dupEvent:InvokeServer(tool) end)
                if success then
                    updateStatus("SUCCESS! Duplicated "..tool.Name.." using "..eventName.." (RemoteFunction)")
                    if debugMode then
                        print("[Islands Script] Used RemoteFunction: "..eventName.." in "..containerName)
                    end
                else
                    updateStatus("RemoteFunction failed. Error: "..tostring(result))
                end
            end
        else
            updateStatus("No server event found. Try Scan All button to search everywhere.")
            if debugMode then
                print("[Islands Script] Searched for these events without success:")
                for i, name in ipairs(dupEventNames) do
                    print("  "..i..". "..name)
                end
            end
        end
    else
        updateStatus("No item found. Equip or hold an item to duplicate.")
    end
end

local function addCoins()
    updateStatus("Searching for coins...")
    local coinsValue, path = findCoinsValue()
    
    if coinsValue then
        updateStatus("Found coins at: "..path..". Adding 10000...")
        
        -- Comprehensive list of possible coin remote event names
        local coinEventNames = {
            -- Common variations
            "CoinEvent", "AddCoins", "GiveCoins", "coinEvent", 
            "addCoins", "giveCoins", "AddCoin", "GiveCoin",
            "addCoin", "giveCoin", "UpdateCoins", "updateCoins",
            "ChangeCoins", "changeCoins", "SetCoins", "setCoins",
            
            -- More specific variations
            "ServerCoins", "ServerAddCoins", "ServerGiveCoins",
            "AddMoney", "GiveMoney", "addMoney", "giveMoney",
            "UpdateMoney", "updateMoney", "SetMoney", "setMoney",
            "AddCurrency", "GiveCurrency", "addCurrency", "giveCurrency",
            "UpdateCurrency", "updateCurrency", "SetCurrency", "setCurrency",
            
            -- Game-specific possibilities
            "ChangeBalance", "changeBalance", "UpdateBalance", "updateBalance",
            "SetBalance", "setBalance", "ModifyCoins", "modifyCoins",
            "ModifyMoney", "modifyMoney", "ModifyCurrency", "modifyCurrency",
            "ChangeCurrency", "changeCurrency", "ChangeMoney", "changeMoney"
        }
        
        local coinEvent, eventName, containerName = findRemoteEvent(coinEventNames)
        
        if coinEvent then
            if coinEvent:IsA("RemoteEvent") then
                coinEvent:FireServer(10000)
                updateStatus("SUCCESS! Added 10k coins using "..eventName.." (RemoteEvent)")
                if debugMode then
                    print("[Islands Script] Used RemoteEvent: "..eventName.." in "..containerName)
                end
            else
                local success, result = pcall(function() return coinEvent:InvokeServer(10000) end)
                if success then
                    updateStatus("SUCCESS! Added 10k coins using "..eventName.." (RemoteFunction)")
                    if debugMode then
                        print("[Islands Script] Used RemoteFunction: "..eventName.." in "..containerName)
                    end
                else
                    updateStatus("RemoteFunction failed. Error: "..tostring(result))
                end
            end
        else
            -- Direct modification if no remote found
            local oldValue = coinsValue.Value
            coinsValue.Value = oldValue + 10000
            updateStatus("Added 10k coins directly. Found at: "..path)
            if debugMode then
                print("[Islands Script] Direct modification. Path: "..path)
            end
        end
    else
        updateStatus("Coins not found. Try Scan Coins button to identify coin location.")
        if debugMode then
            print("[Islands Script] Searched these paths without success:")
            local paths = {
                "player.leaderstats.Coins", "player.leaderstats.coins",
                "player.Leaderstats.Coins", "player.Leaderstats.coins",
                "player.Coins", "player.coins", "player.Coin", "player.coin"
            }
            for i, path in ipairs(paths) do
                print("  "..i..". "..path)
            end
        end
    end
end

local function toggleDebugMode()
    debugMode = not debugMode
    updateStatus("Debug Mode "..(debugMode and "Enabled" or "Disabled"))
    debugBtn.BackgroundColor3 = debugMode and Color3.fromRGB(220, 100, 100) or Color3.fromRGB(180, 60, 60)
    
    if debugMode then
        print("[Islands Script] Debug Mode Enabled")
        print("[Islands Script] Player Name: "..player.Name)
        print("[Islands Script] Game: "..game.Name)
    else
        print("[Islands Script] Debug Mode Disabled")
    end
end

-- Connections
dupBtn.MouseButton1Click:Connect(duplicateItem)
coinBtn.MouseButton1Click:Connect(addCoins)
debugBtn.MouseButton1Click:Connect(toggleDebugMode)
scanBtn.MouseButton1Click:Connect(scanAllForRemotes)
scanCoinsBtn.MouseButton1Click:Connect(scanForCoins)

mouse.KeyDown:Connect(function(key)
    if key:lower() == "g" then
        enabled = not enabled
        frame.Visible = enabled
        updateStatus(enabled and "UI Enabled" or "UI Disabled")
    end
end)

-- Initialize
updateStatus("Script Loaded Successfully\nHold an item and click Duplicate\nUse Scan buttons for troubleshooting")
print("[Islands Script] Script initialized. Toggle UI with 'G' key.")