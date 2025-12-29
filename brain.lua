-- // =============================================
-- // 🍓 STRAWBERRY ELEPHANT HUNTER 🐘
-- // Optimized for Delta Executor
-- // =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Configuration
local Settings = {
    AutoCollect = true,
    TeleportToRare = true,
    HighlightRare = true,
    CollectionRange = 35,
    CheckInterval = 0.2,
    DebugMode = true
}

-- Target Brain Rots
local TargetRares = {
    "Strawberry Elephant",
    "Strawberry",
    "Elephant",
    "OG",
    "Golden",
    "Rainbow",
    "Galaxy",
    "Crystal",
    "Diamond",
    "Royal",
    "Ancient",
    "Mythic",
    "Legendary",
    "Exclusive",
    "Limited"
}

-- UI Colors
local Colors = {
    Strawberry = Color3.fromRGB(255, 105, 180),
    Elephant = Color3.fromRGB(128, 0, 128),
    Gold = Color3.fromRGB(255, 215, 0),
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 50, 50)
}

-- Cache
local CollectedRares = {}
local HighlightCache = {}
local Connection
local UI

-- Notify Function
function Notify(title, message, duration)
    duration = duration or 3
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration,
        Icon = "rbxassetid://4483345998"
    })
    
    if Settings.DebugMode then
        print("[" .. title .. "] " .. message)
    end
end

-- Create Optimized UI
function CreateUI()
    if player.PlayerGui:FindFirstChild("DeltaBrainRotHunter") then
        player.PlayerGui.DeltaBrainRotHunter:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaBrainRotHunter"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = player.PlayerGui
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 280, 0, 250)
    Main.Position = UDim2.new(0, 15, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Main.BackgroundTransparency = 0.15
    Main.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Main
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "🍓 DELTA BRAIN ROT HUNTER 🐘"
    Title.TextColor3 = Colors.Strawberry
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = Main
    
    -- Status
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(1, 0, 0, 25)
    Status.Position = UDim2.new(0, 0, 0, 45)
    Status.Text = "🟢 Ready - Scanning..."
    Status.TextColor3 = Color3.fromRGB(200, 200, 255)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14
    Status.Parent = Main
    
    -- Toggles
    local yPos = 80
    local Toggles = {
        {Name = "Auto Collect", Setting = "AutoCollect", Color = Colors.Success},
        {Name = "Teleport to Rare", Setting = "TeleportToRare", Color = Color3.fromRGB(33, 150, 243)},
        {Name = "Highlight Rares", Setting = "HighlightRare", Color = Color3.fromRGB(255, 193, 7)},
        {Name = "Debug Mode", Setting = "DebugMode", Color = Color3.fromRGB(150, 150, 150)}
    }
    
    for i, toggle in ipairs(Toggles) do
        local Button = Instance.new("TextButton")
        Button.Name = toggle.Setting
        Button.Size = UDim2.new(0.9, 0, 0, 32)
        Button.Position = UDim2.new(0.05, 0, 0, yPos)
        Button.Text = toggle.Name .. ": " .. (Settings[toggle.Setting] and "ON" or "OFF")
        Button.BackgroundColor3 = toggle.Color
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 13
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button
        
        Button.Parent = Main
        yPos = yPos + 37
    end
    
    -- Counter
    local Counter = Instance.new("TextLabel")
    Counter.Name = "Counter"
    Counter.Size = UDim2.new(1, 0, 0, 30)
    Counter.Position = UDim2.new(0, 0, 0, yPos + 10)
    Counter.Text = "🎯 Rares Collected: 0"
    Counter.TextColor3 = Colors.Gold
    Counter.BackgroundTransparency = 1
    Counter.Font = Enum.Font.GothamBold
    Counter.TextSize = 16
    Counter.Parent = Main
    
    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.Size = UDim2.new(0, 100, 0, 30)
    Close.Position = UDim2.new(0.5, -50, 1, -35)
    Close.Text = "Hide UI"
    Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 14
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    Close.Parent = Main
    Main.Parent = ScreenGui
    
    return ScreenGui
end

-- Smart Object Detection
function IsRareObject(obj)
    if not obj:IsA("BasePart") and not obj:IsA("MeshPart") and not obj:IsA("UnionOperation") then
        return false
    end
    
    local name = obj.Name:lower()
    local parentName = obj.Parent and obj.Parent.Name:lower() or ""
    
    -- Quick name check
    for _, rareName in ipairs(TargetRares) do
        if name:find(rareName:lower()) or parentName:find(rareName:lower()) then
            return true, rareName
        end
    end
    
    -- Visual detection
    if obj.Color then
        -- Strawberry colors (pink/red)
        if obj.Color == Colors.Strawberry or 
           obj.Color == Color3.fromRGB(220, 20, 60) or
           obj.Color == Color3.fromRGB(255, 20, 147) then
            return true, "Strawberry"
        end
        
        -- Gold colors
        if obj.Color == Colors.Gold or 
           obj.Color == Color3.fromRGB(218, 165, 32) then
            return true, "Golden"
        end
    end
    
    -- Check for particles/effects
    if obj:FindFirstChildOfClass("ParticleEmitter") or
       obj:FindFirstChildOfClass("PointLight") then
        return true, "Special"
    end
    
    -- Check material
    if obj.Material == Enum.Material.Neon or
       obj.Material == Enum.Material.Glass or
       obj.Material == Enum.Material.Foil then
        return true, "Shiny"
    end
    
    return false, nil
end

-- Fast Scan Function
function QuickScan()
    local found = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        local isRare, rareName = IsRareObject(obj)
        if isRare and not CollectedRares[obj] then
            table.insert(found, {
                Object = obj,
                Name = rareName,
                Position = obj.Position
            })
            
            -- Highlight if enabled
            if Settings.HighlightRare then
                HighlightObject(obj, rareName)
            end
        end
    end
    
    return found
end

-- Optimized Highlight
function HighlightObject(obj, rareName)
    if HighlightCache[obj] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "DeltaHighlight"
    
    if rareName == "Strawberry Elephant" or rareName == "Strawberry" then
        highlight.FillColor = Colors.Strawberry
    elseif rareName == "Golden" then
        highlight.FillColor = Colors.Gold
    else
        highlight.FillColor = Color3.fromRGB(148, 0, 211)
    end
    
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.Parent = obj
    
    HighlightCache[obj] = highlight
end

-- Fast Collection
function CollectObject(obj)
    local character = player.Character
    if not character then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local distance = (hrp.Position - obj.Position).Magnitude
    
    -- Teleport if too far
    if distance > Settings.CollectionRange and Settings.TeleportToRare then
        hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 5, 0))
        task.wait(0.2)
    end
    
    -- Try all collection methods
    local success = false
    
    -- Method 1: ClickDetector
    local clickDetector = obj:FindFirstChild("ClickDetector") or 
                         obj.Parent:FindFirstChild("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
        success = true
    end
    
    -- Method 2: Touch
    if not success then
        local touched = false
        local connection = obj.Touched:Connect(function(hit)
            if hit.Parent == character then
                touched = true
            end
        end)
        
        hrp.CFrame = CFrame.new(obj.Position)
        task.wait(0.3)
        connection:Disconnect()
        success = touched
    end
    
    -- Method 3: Remote Events
    if not success then
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or
                       game:GetService("ReplicatedStorage"):FindFirstChild("Events") or
                       game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
        
        if remotes then
            local remotesList = {
                "Collect",
                "CollectBrain",
                "Pickup",
                "Grab",
                "Take",
                "Acquire",
                "Obtain"
            }
            
            for _, remoteName in ipairs(remotesList) do
                local remote = remotes:FindFirstChild(remoteName)
                if remote then
                    pcall(function()
                        remote:FireServer(obj)
                        success = true
                    end)
                    break
                end
            end
        end
    end
    
    return success
end

-- Main Loop
function MainLoop()
    while Settings.AutoCollect and task.wait(Settings.CheckInterval) do
        local rares = QuickScan()
        
        if #rares > 0 and UI then
            local status = UI:FindFirstChild("Status")
            if status then
                status.Text = "🎯 Found " .. #rares .. " rare brain rots!"
                status.TextColor3 = Colors.Success
            end
            
            for _, rare in ipairs(rares) do
                local success = CollectObject(rare.Object)
                
                if success then
                    CollectedRares[rare.Object] = true
                    
                    -- Update counter
                    if UI then
                        local counter = UI:FindFirstChild("Counter")
                        if counter then
                            local count = 0
                            for _ in pairs(CollectedRares) do count = count + 1 end
                            counter.Text = "🎯 Rares Collected: " .. count
                        end
                    end
                    
                    Notify("SUCCESS!", "Collected: " .. rare.Name, 2)
                    
                    -- Special notification for Strawberry Elephant
                    if rare.Name == "Strawberry Elephant" then
                        Notify("🎉 CONGRATULATIONS! 🎉", 
                               "YOU GOT STRAWBERRY ELEPHANT!", 5)
                    end
                end
            end
        elseif UI then
            local status = UI:FindFirstChild("Status")
            if status then
                status.Text = "🔍 Scanning for rares..."
                status.TextColor3 = Color3.fromRGB(200, 200, 255)
            end
        end
    end
end

-- Initialize
function Initialize()
    -- Create UI
    UI = CreateUI()
    
    -- Setup button events
    for _, button in ipairs(UI:GetDescendants()) do
        if button:IsA("TextButton") then
            button.MouseButton1Click:Connect(function()
                if button.Name == "Close" then
                    UI.Enabled = not UI.Enabled
                    button.Text = UI.Enabled and "Hide UI" or "Show UI"
                    
                elseif Settings[button.Name] ~= nil then
                    Settings[button.Name] = not Settings[button.Name]
                    button.Text = button.Name:gsub("([A-Z])", " %1"):sub(2) .. 
                                 ": " .. (Settings[button.Name] and "ON" or "OFF")
                    
                    -- Update colors
                    if Settings[button.Name] then
                        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    else
                        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                    end
                    
                    -- Restart loop if AutoCollect was toggled
                    if button.Name == "AutoCollect" then
                        if Settings.AutoCollect then
                            task.spawn(MainLoop)
                        end
                    end
                end
            end)
        end
    end
    
    -- Keybind (F for toggle UI)
    local uis = game:GetService("UserInputService")
    uis.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
            UI.Enabled = not UI.Enabled
            local closeBtn = UI:FindFirstChild("Close")
            if closeBtn then
                closeBtn.Text = UI.Enabled and "Hide UI" or "Show UI"
            end
        end
    end)
    
    -- Start main loop
    if Settings.AutoCollect then
        task.spawn(MainLoop)
    end
    
    Notify("Delta Executor", "🍓 Strawberry Elephant Hunter Loaded!", 3)
    print("====================================")
    print("🍓 STRAWBERRY ELEPHANT HUNTER ACTIVE")
    print("🐘 Target Rares:", #TargetRares)
    print("🔧 Auto Collect:", Settings.AutoCollect)
    print("🚀 Teleport:", Settings.TeleportToRare)
    print("====================================")
end

-- Wait for player
if player.Character then
    Initialize()
else
    player.CharacterAdded:Wait()
    task.wait(2)
    Initialize()
end
