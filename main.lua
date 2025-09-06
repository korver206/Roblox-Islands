-- Roblox Islands Comprehensive Script v3.0
-- Enhanced version with item scanning and categorized UI
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
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
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
title.Text = "Islands Script v3.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0.5
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local dupBtn = Instance.new("TextButton")
dupBtn.Size = UDim2.new(0, 190, 0, 35)
dupBtn.Position = UDim2.new(0, 5, 0, 40)
dupBtn.Text = "Duplicate Held Item"
dupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dupBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
dupBtn.BorderSizePixel = 1
dupBtn.BorderColor3 = Color3.fromRGB(100, 100, 220)
dupBtn.Parent = frame

local coinBtn = Instance.new("TextButton")
coinBtn.Size = UDim2.new(0, 190, 0, 35)
coinBtn.Position = UDim2.new(0, 205, 0, 40)
coinBtn.Text = "Add Coins"
coinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
coinBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
coinBtn.BorderSizePixel = 1
coinBtn.BorderColor3 = Color3.fromRGB(100, 220, 100)
coinBtn.Parent = frame

local debugBtn = Instance.new("TextButton")
debugBtn.Size = UDim2.new(0, 190, 0, 35)
debugBtn.Position = UDim2.new(0, 5, 0, 80)
debugBtn.Text = "Toggle Debug Mode"
debugBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
debugBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
debugBtn.BorderSizePixel = 1
debugBtn.BorderColor3 = Color3.fromRGB(220, 100, 100)
debugBtn.Parent = frame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0, 190, 0, 35)
scanBtn.Position = UDim2.new(0, 205, 0, 80)
scanBtn.Text = "Scan All Remotes"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 60)
scanBtn.BorderSizePixel = 1
scanBtn.BorderColor3 = Color3.fromRGB(220, 220, 100)
scanBtn.Parent = frame

local scanItemsBtn = Instance.new("TextButton")
scanItemsBtn.Size = UDim2.new(0, 190, 0, 35)
scanItemsBtn.Position = UDim2.new(0, 5, 0, 120)
scanItemsBtn.Text = "Scan Game Items"
scanItemsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanItemsBtn.BackgroundColor3 = Color3.fromRGB(180, 90, 180)
scanItemsBtn.BorderSizePixel = 1
scanItemsBtn.BorderColor3 = Color3.fromRGB(220, 150, 220)
scanItemsBtn.Parent = frame

local clearCacheBtn = Instance.new("TextButton")
clearCacheBtn.Size = UDim2.new(0, 190, 0, 35)
clearCacheBtn.Position = UDim2.new(0, 205, 0, 120)
clearCacheBtn.Text = "Clear Event Cache"
clearCacheBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearCacheBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
clearCacheBtn.BorderSizePixel = 1
clearCacheBtn.BorderColor3 = Color3.fromRGB(130, 130, 130)
clearCacheBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 100)
status.Position = UDim2.new(0, 0, 0, 160)
status.BackgroundTransparency = 1
status.Text = "Status: Ready\nHold an item and click Duplicate\nUse Scan buttons for troubleshooting"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.TextStrokeTransparency = 0.7
status.TextScaled = false
status.TextSize = 14
status.TextWrapped = true
status.Font = Enum.Font.SourceSans
status.Parent = frame

-- Storage for found remotes and items
local foundDupEvent = nil
local foundCoinEvent = nil
local foundCoinsValue = nil
local gameItems = {}

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
    
    -- Also do recursive search in ReplicatedStorage
    local function searchRecursively(instance)
        if not instance then return {} end
        
        local remotes = {}
        for _, child in ipairs(instance:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(remotes, {name = child.Name, type = child.ClassName, container = instance.Name})
            elseif child:IsA("Folder") or child:IsA("Model") then
                local childRemotes = searchRecursively(child)
                for _, remote in ipairs(childRemotes) do
                    table.insert(remotes, remote)
                end
            end
        end
        return remotes
    end
    
    local recursiveRemotes = searchRecursively(replicatedStorage)
    for _, remote in ipairs(recursiveRemotes) do
        table.insert(allRemotes, remote)
    end
    
    if #allRemotes > 0 then
        updateStatus("Found "..#allRemotes.." remotes. Displaying potential dup/coin events below.")
        
        -- Try to identify the most likely duplication and coin events
        local dupEvents = {}
        local coinEvents = {}
        
        for _, remote in ipairs(allRemotes) do
            local name = remote.name:lower()
            if name:find("dup") or name:find("clone") or name:find("item") or name:find("tool") or name:find("create") or name:find("make") or name:find("spawn") then
                table.insert(dupEvents, remote)
            end
            if name:find("coin") or name:find("money") or name:find("currency") or name:find("balance") or name:find("add") or name:find("give") then
                table.insert(coinEvents, remote)
            end
        end
        
        local displayText = "Found "..#allRemotes.." remotes total.\n"
        
        if #dupEvents > 0 then
            displayText = displayText.."Dup events ("..#dupEvents.."): "
            for i, event in ipairs(dupEvents) do
                if i <= 3 then
                    displayText = displayText..event.name.." "
                end
            end
            if #dupEvents > 3 then
                displayText = displayText.."and "..(#dupEvents-3).." more..."
            end
            displayText = displayText.."\n"
        end
        
        if #coinEvents > 0 then
            displayText = displayText.."Coin events ("..#coinEvents.."): "
            for i, event in ipairs(coinEvents) do
                if i <= 3 then
                    displayText = displayText..event.name.." "
                end
            end
            if #coinEvents > 3 then
                displayText = displayText.."and "..(#coinEvents-3).." more..."
            end
        end
        
        if #dupEvents == 0 and #coinEvents == 0 then
            displayText = displayText.."No obvious dup/coin events found. Check all remotes manually."
        end
        
        updateStatus(displayText)
    else
        updateStatus("No remotes found in any location.")
    end
end

local function scanForCoins()
    updateStatus("Scanning for coin values...")
    
    local displayText = "Player children:\n"
    local count = 0
    for i, child in ipairs(player:GetChildren()) do
        if count < 5 then
            displayText = displayText..i..". "..child.Name.." ("..child.ClassName..")\n"
            count = count + 1
        end
    end
    
    if player:FindFirstChild("leaderstats") then
        displayText = displayText.."Leaderstats children:\n"
        count = 0
        for i, child in ipairs(player.leaderstats:GetChildren()) do
            if count < 5 then
                displayText = displayText..i..". "..child.Name.." ("..child.ClassName..")\n"
                count = count + 1
            end
        end
    end
    
    if player:FindFirstChild("data") then
        displayText = displayText.."Data children:\n"
        count = 0
        for i, child in ipairs(player.data:GetChildren()) do
            if count < 5 then
                displayText = displayText..i..". "..child.Name.." ("..child.ClassName..")\n"
                count = count + 1
            end
        end
    end
    
    updateStatus(displayText)
end

local function scanGameItems()
    updateStatus("Scanning game for items...")
    gameItems = {}
    
    -- Search in ReplicatedStorage for items
    local function searchForItems(instance, depth)
        if depth > 3 then return end -- Limit recursion depth
        
        for _, child in ipairs(instance:GetChildren()) do
            if child:IsA("Tool") or child:IsA("Model") then
                table.insert(gameItems, child)
            end
            
            if child:IsA("Folder") or child:IsA("Model") then
                searchForItems(child, depth + 1)
            end
        end
    end
    
    searchForItems(replicatedStorage, 0)
    
    updateStatus("Found "..#gameItems.." items in game. Use item browser for selection.")
    print("[Islands Script] Found "..#gameItems.." items in game")
    
    -- Create item browser UI
    createItemBrowser()
end

local function createItemBrowser()
    -- Clear existing browser if it exists
    if frame:FindFirstChild("ItemBrowser") then
        frame.ItemBrowser:Destroy()
    end
    
    local browserFrame = Instance.new("Frame")
    browserFrame.Name = "ItemBrowser"
    browserFrame.Size = UDim2.new(0, 380, 0, 200)
    browserFrame.Position = UDim2.new(0, 10, 0, 160)
    browserFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    browserFrame.BorderSizePixel = 1
    browserFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    browserFrame.Parent = frame
    
    local browserTitle = Instance.new("TextLabel")
    browserTitle.Size = UDim2.new(1, 0, 0, 20)
    browserTitle.Position = UDim2.new(0, 0, 0, 0)
    browserTitle.BackgroundTransparency = 1
    browserTitle.Text = "Game Items Browser ("..#gameItems.." found)"
    browserTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    browserTitle.Font = Enum.Font.SourceSansBold
    browserTitle.TextSize = 14
    browserTitle.Parent = browserFrame
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -10, 1, -60)
    listFrame.Position = UDim2.new(0, 5, 0, 25)
    listFrame.BackgroundTransparency = 0.8
    listFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    listFrame.BorderSizePixel = 1
    listFrame.BorderColor3 = Color3.fromRGB(120, 120, 120)
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #gameItems * 25)
    listFrame.ScrollBarThickness = 8
    listFrame.Parent = browserFrame
    
    local amountBox = Instance.new("TextBox")
    amountBox.Size = UDim2.new(0, 100, 0, 30)
    amountBox.Position = UDim2.new(0, 5, 1, -30)
    amountBox.BackgroundTransparency = 0
    amountBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    amountBox.BorderSizePixel = 1
    amountBox.BorderColor3 = Color3.fromRGB(120, 120, 120)
    amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    amountBox.Text = "1"
    amountBox.PlaceholderText = "Amount"
    amountBox.Parent = browserFrame
    
    -- Create item buttons
    for i, item in ipairs(gameItems) do
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, -10, 0, 20)
        itemBtn.Position = UDim2.new(0, 5, 0, (i-1) * 25)
        itemBtn.Text = item.Name
        itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemBtn.BackgroundTransparency = 0.7
        itemBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        itemBtn.BorderSizePixel = 0
        itemBtn.Parent = listFrame
        
        itemBtn.MouseButton1Click:Connect(function()
            local amount = tonumber(amountBox.Text) or 1
            giveItem(item, amount)
        end)
    end
end

local function giveItem(item, amount)
    if not item then
        updateStatus("No item selected")
        return
    end
    
    -- Try to find duplication remote
    if foundDupEvent then
        if foundDupEvent:IsA("RemoteEvent") then
            foundDupEvent:FireServer(item, amount)
            updateStatus("Gave "..amount.."x "..item.Name.." using cached event")
            return
        else
            local success, result = pcall(function() return foundDupEvent:InvokeServer(item, amount) end)
            if success then
                updateStatus("Gave "..amount.."x "..item.Name.." using cached event")
                return
            else
                updateStatus("Cached RemoteFunction failed. Clearing cache.")
                foundDupEvent = nil
            end
        end
    end
    
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
        "BuildTool", "ConstructItem", "ConstructTool",
        "GiveTool", "GiveItem", "SpawnItem", "CreateItem"
    }
    
    local dupEvent, eventName, containerName = findRemoteEvent(dupEventNames)
    
    if dupEvent then
        foundDupEvent = dupEvent -- Cache the found event
        if dupEvent:IsA("RemoteEvent") then
            dupEvent:FireServer(item, amount)
            updateStatus("Gave "..amount.."x "..item.Name.." using "..eventName.." (RemoteEvent)")
        else
            local success, result = pcall(function() return dupEvent:InvokeServer(item, amount) end)
            if success then
                updateStatus("Gave "..amount.."x "..item.Name.." using "..eventName.." (RemoteFunction)")
            else
                updateStatus("RemoteFunction failed. Error: "..tostring(result))
            end
        end
    else
        updateStatus("No server event found for giving items")
    end
end

-- Main Functions
local function duplicateItem()
    local character = player.Character or player.CharacterAdded:Wait()
    local tool = character:FindFirstChildWhichIsA("Tool") or backpack:FindFirstChildWhichIsA("Tool")
    
    if tool then
        updateStatus("Attempting to duplicate "..tool.Name.."...")
        
        -- If we already found a duplication event, use it
        if foundDupEvent then
            if foundDupEvent:IsA("RemoteEvent") then
                foundDupEvent:FireServer(tool)
                updateStatus("SUCCESS! Duplicated "..tool.Name.." using cached event (RemoteEvent)")
                return
            else
                local success, result = pcall(function() return foundDupEvent:InvokeServer(tool) end)
                if success then
                    updateStatus("SUCCESS! Duplicated "..tool.Name.." using cached event (RemoteFunction)")
                    return
                else
                    updateStatus("Cached RemoteFunction failed. Clearing cache.")
                    foundDupEvent = nil
                end
            end
        end
        
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
            foundDupEvent = dupEvent -- Cache the found event
            if dupEvent:IsA("RemoteEvent") then
                dupEvent:FireServer(tool)
                updateStatus("SUCCESS! Duplicated "..tool.Name.." using "..eventName.." (RemoteEvent)")
            else
                local success, result = pcall(function() return dupEvent:InvokeServer(tool) end)
                if success then
                    updateStatus("SUCCESS! Duplicated "..tool.Name.." using "..eventName.." (RemoteFunction)")
                else
                    updateStatus("RemoteFunction failed. Error: "..tostring(result))
                end
            end
        else
            updateStatus("No server event found. Try Scan All button to search everywhere.")
        end
    else
        updateStatus("No item found. Equip or hold an item to duplicate.")
    end
end

local function addCoins()
    updateStatus("Searching for coins...")
    
    -- If we already found coins value, use it
    if foundCoinsValue then
        local oldValue = foundCoinsValue.Value
        foundCoinsValue.Value = oldValue + 10000
        updateStatus("Added 10k coins directly using cached value.")
        return
    end
    
    local coinsValue, path = findCoinsValue()
    
    if coinsValue then
        foundCoinsValue = coinsValue -- Cache the found value
        updateStatus("Found coins at: "..path..". Adding 10000...")
        
        -- If we already found a coin event, try to use it first
        if foundCoinEvent then
            if foundCoinEvent:IsA("RemoteEvent") then
                foundCoinEvent:FireServer(10000)
                updateStatus("SUCCESS! Added 10k coins using cached event (RemoteEvent)")
                return
            else
                local success, result = pcall(function() return foundCoinEvent:InvokeServer(10000) end)
                if success then
                    updateStatus("SUCCESS! Added 10k coins using cached event (RemoteFunction)")
                    return
                else
                    updateStatus("Cached coin RemoteFunction failed. Clearing cache.")
                    foundCoinEvent = nil
                end
            end
        end
        
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
            foundCoinEvent = coinEvent -- Cache the found event
            if coinEvent:IsA("RemoteEvent") then
                coinEvent:FireServer(10000)
                updateStatus("SUCCESS! Added 10k coins using "..eventName.." (RemoteEvent)")
            else
                local success, result = pcall(function() return coinEvent:InvokeServer(10000) end)
                if success then
                    updateStatus("SUCCESS! Added 10k coins using "..eventName.." (RemoteFunction)")
                else
                    updateStatus("RemoteFunction failed. Error: "..tostring(result))
                end
            end
        else
            -- Direct modification if no remote found
            local oldValue = coinsValue.Value
            coinsValue.Value = oldValue + 10000
            updateStatus("Added 10k coins directly. Found at: "..path)
        end
    else
        updateStatus("Coins not found. Try Scan Coins button to identify coin location.")
    end
end

local function toggleDebugMode()
    debugMode = not debugMode
    updateStatus("Debug Mode "..(debugMode and "Enabled" or "Disabled"))
    debugBtn.BackgroundColor3 = debugMode and Color3.fromRGB(220, 100, 100) or Color3.fromRGB(180, 60, 60)
end

local function clearEventCache()
    foundDupEvent = nil
    foundCoinEvent = nil
    foundCoinsValue = nil
    updateStatus("Event cache cleared. Will rescan on next use.")
end

-- Connections
dupBtn.MouseButton1Click:Connect(duplicateItem)
coinBtn.MouseButton1Click:Connect(addCoins)
debugBtn.MouseButton1Click:Connect(toggleDebugMode)
scanBtn.MouseButton1Click:Connect(scanAllForRemotes)
scanItemsBtn.MouseButton1Click:Connect(scanGameItems)
clearCacheBtn.MouseButton1Click:Connect(clearEventCache)

mouse.KeyDown:Connect(function(key)
    if key:lower() == "g" then
        enabled = not enabled
        frame.Visible = enabled
        updateStatus(enabled and "UI Enabled" or "UI Disabled")
    end
end)

-- Initialize
updateStatus("Script v3.0 Loaded Successfully\nHold an item and click Duplicate\nUse Scan buttons for troubleshooting")
print("[Islands Script] Script v3.0 initialized. Toggle UI with 'G' key.")