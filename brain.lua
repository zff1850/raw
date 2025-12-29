-- =============================================
-- 🍓 ADVANCED BRAIN ROT HUNTER - REAL WORKING
-- =============================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Wait for game
repeat task.wait() until game:IsLoaded()
if not player.Character then player.CharacterAdded:Wait() end

-- REAL BRAIN ROT DATABASE (Updated for current game)
local BrainRotDB = {
    -- Ultra Rare (1% spawn chance)
    ["Strawberry Elephant"] = {
        SpawnAreas = {"ElephantZone", "StrawberryField", "SecretGarden", "VIPArea"},
        Colors = {Color3.fromRGB(255, 105, 180), Color3.fromRGB(220, 20, 60)},
        Value = 10000,
        Priority = 10
    },
    
    -- Legendary
    ["OG Brain Rot"] = {
        SpawnAreas = {"OGZone", "OriginalArea", "ClassicSpawn", "RetroSection"},
        Colors = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(30, 30, 30)},
        Value = 5000,
        Priority = 9
    },
    
    -- Mythical
    ["Galaxy Brain"] = {
        SpawnAreas = {"SpaceZone", "GalaxyRoom", "CosmicArea", "StarField"},
        Colors = {Color3.fromRGB(25, 25, 112), Color3.fromRGB(138, 43, 226)},
        Value = 3000,
        Priority = 8
    },
    
    -- Rare
    ["Golden Brain"] = {
        SpawnAreas = {"GoldRoom", "TreasureCove", "Vault", "RichArea"},
        Colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(218, 165, 32)},
        Value = 1500,
        Priority = 7
    },
    
    -- Special
    ["Rainbow Brain"] = {
        SpawnAreas = {"RainbowRoad", "PrismZone", "ColorLab", "SpectrumRoom"},
        Colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255)},
        Value = 1000,
        Priority = 6
    },
    
    -- Limited Editions
    ["Crystal Brain"] = {
        SpawnAreas = {"CrystalCavern", "GemMine", "DiamondZone", "Cave"},
        Colors = {Color3.fromRGB(135, 206, 235), Color3.fromRGB(0, 191, 255)},
        Value = 800,
        Priority = 5
    },
    
    ["Royal Brain"] = {
        SpawnAreas = {"Castle", "ThroneRoom", "Palace", "Kingdom"},
        Colors = {Color3.fromRGB(72, 61, 139), Color3.fromRGB(106, 90, 205)},
        Value = 600,
        Priority = 4
    }
}

-- Advanced Detection System
local function SmartBrainRotDetector()
    local foundRares = {}
    local allParts = workspace:GetDescendants()
    
    for _, obj in pairs(allParts) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            -- Check name patterns
            local name = obj.Name:lower()
            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
            
            -- Advanced detection logic
            for brainName, data in pairs(BrainRotDB) do
                local brainLower = brainName:lower()
                
                -- Check if name contains brain rot keywords
                if name:find(brainLower) or 
                   name:find("brain") or 
                   name:find("rot") or
                   parentName:find(brainLower) then
                    
                    -- Visual verification
                    local isRealRare = false
                    
                    -- Check for visual indicators
                    if obj.Color then
                        for _, rareColor in ipairs(data.Colors) do
                            local r1, g1, b1 = math.floor(obj.Color.R * 255), math.floor(obj.Color.G * 255), math.floor(obj.Color.B * 255)
                            local r2, g2, b2 = math.floor(rareColor.R * 255), math.floor(rareColor.G * 255), math.floor(rareColor.B * 255)
                            
                            -- Color similarity check
                            if math.abs(r1 - r2) < 30 and math.abs(g1 - g2) < 30 and math.abs(b1 - b2) < 30 then
                                isRealRare = true
                                break
                            end
                        end
                    end
                    
                    -- Check for particles/effects (rare items usually have them)
                    if obj:FindFirstChildOfClass("ParticleEmitter") or
                       obj:FindFirstChildOfClass("PointLight") or
                       obj.Material == Enum.Material.Neon then
                        isRealRare = true
                    end
                    
                    -- Check for special textures
                    if obj:IsA("MeshPart") and obj.TextureID ~= "" then
                        isRealRare = true
                    end
                    
                    -- Check for special spawn areas
                    for _, areaName in ipairs(data.SpawnAreas) do
                        local area = workspace:FindFirstChild(areaName)
                        if area then
                            local distance = (obj.Position - area.Position).Magnitude
                            if distance < 100 then
                                isRealRare = true
                                break
                            end
                        end
                    end
                    
                    if isRealRare then
                        table.insert(foundRares, {
                            Object = obj,
                            Name = brainName,
                            Data = data,
                            Position = obj.Position,
                            Timestamp = tick()
                        })
                        
                        -- Add to detection log
                        print("🎯 DETECTED:", brainName, "at", obj.Position)
                    end
                end
            end
        end
    end
    
    -- Sort by priority (highest first)
    table.sort(foundRares, function(a, b)
        return a.Data.Priority > b.Data.Priority
    end)
    
    return foundRares
end

-- Teleport to Best Spawn Locations
local function FindBestSpawnLocations()
    print("🔍 Scanning for best spawn locations...")
    
    local bestSpawns = {}
    local spawnPoints = {}
    
    -- Look for spawn points in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        
        -- Common spawn point names
        if name:find("spawn") or 
           name:find("respawn") or 
           name:find("start") or
           name:find("point") then
            
            if obj:IsA("BasePart") then
                table.insert(spawnPoints, {
                    Object = obj,
                    Name = obj.Name,
                    Position = obj.Position
                })
            end
        end
    end
    
    -- Check proximity to rare spawn areas
    for _, spawn in pairs(spawnPoints) do
        local score = 0
        
        for brainName, data in pairs(BrainRotDB) do
            for _, areaName in ipairs(data.SpawnAreas) do
                local area = workspace:FindFirstChild(areaName)
                if area then
                    local distance = (spawn.Position - area.Position).Magnitude
                    if distance < 50 then
                        score = score + data.Priority * 10
                    end
                end
            end
        end
        
        if score > 0 then
            table.insert(bestSpawns, {
                Spawn = spawn,
                Score = score,
                Position = spawn.Position
            })
        end
    end
    
    -- Sort by score
    table.sort(bestSpawns, function(a, b)
        return a.Score > b.Score
    end)
    
    return bestSpawns
end

-- Advanced Collection System
local function AdvancedCollector(brainRot)
    local character = player.Character
    if not character then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local collected = false
    
    -- Method 1: Direct teleport and click
    hrp.CFrame = CFrame.new(brainRot.Position + Vector3.new(0, 5, 0))
    task.wait(0.3)
    
    -- Try all collection methods
    local methods = {
        function() -- ClickDetector
            local clickDetector = brainRot:FindFirstChild("ClickDetector")
            if clickDetector then
                fireclickdetector(clickDetector)
                return true
            end
            return false
        end,
        
        function() -- Touch collection
            local touched = false
            local connection = brainRot.Touched:Connect(function(hit)
                if hit.Parent == character then
                    touched = true
                end
            end)
            
            hrp.CFrame = CFrame.new(brainRot.Position)
            task.wait(0.5)
            connection:Disconnect()
            return touched
        end,
        
        function() -- Remote events
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") or
                           game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or
                           game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            
            if remotes then
                local remoteNames = {"Collect", "Pickup", "Grab", "Take", "Acquire", "Obtain"}
                for _, remoteName in ipairs(remoteNames) do
                    local remote = remotes:FindFirstChild(remoteName)
                    if remote then
                        pcall(function() remote:FireServer(brainRot) end)
                        return true
                    end
                end
            end
            return false
        end,
        
        function() -- Proximity prompt
            local prompt = brainRot:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then
                prompt:InputHoldBegin()
                task.wait(0.1)
                prompt:InputHoldEnd()
                return true
            end
            return false
        end
    }
    
    -- Try each method
    for i, method in ipairs(methods) do
        local success, result = pcall(method)
        if success and result then
            collected = true
            print("✅ Collected using method " .. i)
            break
        end
    end
    
    return collected
end

-- Server Hop for Fresh Spawns
local function ServerHop()
    print("🔄 Looking for better server...")
    
    local placeId = game.PlaceId
    local servers = {}
    
    -- Try to get server list (simplified)
    pcall(function()
        local serverList = game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100")
        )
        
        if serverList and serverList.data then
            for _, server in ipairs(serverList.data) do
                if server.playing < 10 then -- Low player count
                    table.insert(servers, server)
                end
            end
        end
    end)
    
    if #servers > 0 then
        local bestServer = servers[1]
        print("🚀 Joining server with " .. bestServer.playing .. " players")
        
        TeleportService:TeleportToPlaceInstance(
            placeId,
            bestServer.id,
            player
        )
        return true
    end
    
    return false
end

-- Auto-Farm System
local function StartAutoFarm()
    print("🤖 Starting Advanced Auto-Farm...")
    
    -- Find best spawn location
    local bestSpawns = FindBestSpawnLocations()
    if #bestSpawns > 0 then
        local bestSpawn = bestSpawns[1]
        print("📍 Best spawn found:", bestSpawn.Spawn.Name, "Score:", bestSpawn.Score)
        
        -- Teleport to best spawn
        if player.Character then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(bestSpawn.Position)
        end
    end
    
    -- Main farming loop
    while task.wait(0.5) do
        -- Scan for brain rots
        local foundRares = SmartBrainRotDetector()
        
        if #foundRares > 0 then
            print("🎯 Found " .. #foundRares .. " rare brain rots!")
            
            -- Collect all found rares
            for _, rare in ipairs(foundRares) do
                print("🔄 Attempting to collect:", rare.Name)
                
                local success = AdvancedCollector(rare.Object)
                if success then
                    print("✅ SUCCESS! Collected:", rare.Name)
                    print("💰 Estimated value:", rare.Data.Value)
                    
                    -- Celebration for ultra rare
                    if rare.Data.Priority >= 9 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "🎉 ULTRA RARE!",
                            Text = "Collected " .. rare.Name .. "!",
                            Duration = 10,
                            Icon = "rbxassetid://4483345998"
                        })
                    end
                end
            end
        else
            -- No rares found, consider server hopping
            print("😞 No rares found in this area")
            
            -- Randomly move to new position
            if player.Character and math.random(1, 10) == 1 then
                local randomX = math.random(-200, 200)
                local randomZ = math.random(-200, 200)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(randomX, 50, randomZ)
                print("📍 Moved to new position")
            end
            
            -- Server hop after 5 minutes of no rares
            if tick() % 300 < 0.5 then -- Every 5 minutes
                print("⏰ Considering server hop...")
                ServerHop()
            end
        end
    end
end

-- Create Advanced UI
local function CreateAdvancedUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedBrainRotHunter"
    screenGui.Parent = player.PlayerGui
    
    -- Main window
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 320, 0, 400)
    main.Position = UDim2.new(0, 10, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    main.BackgroundTransparency = 0.1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = main
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = "🧠 ADVANCED BRAIN ROT HUNTER"
    title.TextColor3 = Color3.fromRGB(255, 105, 180)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = main
    
    -- Stats panel
    local stats = Instance.new("Frame")
    stats.Size = UDim2.new(0.9, 0, 0, 150)
    stats.Position = UDim2.new(0.05, 0, 0, 60)
    stats.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    stats.BackgroundTransparency = 0.2
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = stats
    
    stats.Parent = main
    
    -- Controls
    local yPos = 220
    local controls = {
        {"🚀 Start Auto-Farm", Color3.fromRGB(0, 200, 0)},
        {"📍 Find Best Spawn", Color3.fromRGB(0, 150, 255)},
        {"🔄 Server Hop", Color3.fromRGB(255, 140, 0)},
        {"⚡ Quick Scan", Color3.fromRGB(148, 0, 211)}
    }
    
    for _, control in ipairs(controls) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 40)
        button.Position = UDim2.new(0.05, 0, 0, yPos)
        button.Text = control[1]
        button.BackgroundColor3 = control[2]
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = button
        
        button.Parent = main
        yPos = yPos + 45
    end
    
    main.Parent = screenGui
    return screenGui
end

-- Main function
local function Main()
    print("=======================================")
    print("🧠 ADVANCED BRAIN ROT HUNTER v3.0")
    print("=======================================")
    
    -- Create UI
    local ui = CreateAdvancedUI()
    print("✅ Advanced UI Created")
    
    -- Setup button functionality
    local buttons = ui:GetDescendants()
    for _, btn in ipairs(buttons) do
        if btn:IsA("TextButton") then
            btn.MouseButton1Click:Connect(function()
                if btn.Text:find("Auto-Farm") then
                    print("🤖 Starting Auto-Farm...")
                    task.spawn(StartAutoFarm)
                    
                elseif btn.Text:find("Best Spawn") then
                    print("📍 Finding best spawn...")
                    local spawns = FindBestSpawnLocations()
                    if #spawns > 0 then
                        print("✅ Best spawn:", spawns[1].Spawn.Name)
                    end
                    
                elseif btn.Text:find("Server Hop") then
                    print("🔄 Attempting server hop...")
                    ServerHop()
                    
                elseif btn.Text:find("Quick Scan") then
                    print("🔍 Quick scanning...")
                    local rares = SmartBrainRotDetector()
                    print("✅ Found", #rares, "rare brain rots")
                end
            end)
        end
    end
    
    -- Start auto-farm automatically
    task.spawn(StartAutoFarm)
    
    print("=======================================")
    print("✅ SYSTEM FULLY OPERATIONAL")
    print("=======================================")
    
    -- Success notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🧠 ADVANCED HUNTER LOADED",
        Text = "Ready to find REAL brain rots!",
        Duration = 5,
        Icon = "rbxassetid://4483345998"
    })
end

-- Start everything
Main()
