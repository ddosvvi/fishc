-- =============================================================
-- YuuVins Exploids // ULTIMATE V7.9 (EVENT + VISION)
-- Owner: ZAYANGGGGG
-- Status: ALL FEATURES UNLOCKED + PREMIUM NOTIFS
-- =============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- [[ KONFIGURASI GLOBAL ]]
local CONFIG = {
    IsAutoFish = false,
    IsAutoSell = false,
    IsESP = false,
    IsNPC_ESP = false, -- Night Vision NPC Rod
    IsAntiAFK = false,
    IsBypass = true,
    IsAFKLevel = false,
    IsGodMode = false,
    IsNoClip = false,  -- Smart NoClip
    IsWaterWalk = false, -- Walk on Water
    
    SavedPosition = nil,
    FlySpeed = 300,
    TargetGroupId = 7381705,
    Blacklist = {"Trial Tester", "Trial Mod", "Moderator", "Senior Mod", "Admin", "Developer", "Creator"}
}

-- [[ THEME PRESETS ]]
local THEME = {
    Bg = Color3.fromRGB(10, 12, 20),
    Sidebar = Color3.fromRGB(15, 18, 30),
    Item = Color3.fromRGB(20, 25, 40),
    Text = Color3.fromRGB(240, 240, 255),
    Accent = Color3.fromRGB(0, 230, 255),
    Glow1 = Color3.fromRGB(0, 180, 255),
    Glow2 = Color3.fromRGB(0, 80, 200),
    ESP_Color = Color3.fromRGB(0, 255, 255),
    NPC_Color = Color3.fromRGB(255, 215, 0) -- Gold for NPC
}

-- [[ GET SAFE GUI ]]
local function GetSafeGui()
    local s, h = pcall(function() return gethui() end)
    if s and h then return h end
    return game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end
local UI_Parent = GetSafeGui()

-- Cleanup
for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "YuuVinsExploidsUI" then v:Destroy() end
end

-- =============================================================
-- 1. NOTIFIKASI SYSTEM (PREMIUM)
-- =============================================================
local function SendNotif(title, text, dur)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = dur or 3,
        Icon = "rbxassetid://16369066601"
    })
end

task.spawn(function()
    SendNotif("YuuVins Exploids", "Injecting Event Module...", 2)
    task.wait(2)
    SendNotif("WELCOME USER", "Owner: ZAYANGGGGG", 3)
end)

-- =============================================================
-- 2. UI CONSTRUCTION
-- =============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuuVinsExploidsUI"
ScreenGui.Parent = UI_Parent
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false 

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Glow Border
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Transparency = 0
local UIGradient = Instance.new("UIGradient", Stroke)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, THEME.Glow1),
    ColorSequenceKeypoint.new(1.00, THEME.Glow2)
}
UIGradient.Rotation = 45
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

task.spawn(function()
    while MainFrame.Parent do
        local t = TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 360 + 45})
        t:Play() t.Completed:Wait()
        UIGradient.Rotation = 45
    end
end)

-- Header Area
local Header = Instance.new("Frame", MainFrame)
Header.Name = "Header"
Header.BackgroundColor3 = Color3.fromRGB(0,0,0)
Header.BackgroundTransparency = 0.8
Header.Size = UDim2.new(1, 0, 0, 40)

local Logo = Instance.new("TextLabel", Header)
Logo.Size = UDim2.new(0, 200, 1, 0)
Logo.Position = UDim2.new(0, 15, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "YuuVins Exploids"
Logo.Font = Enum.Font.GothamBlack
Logo.TextColor3 = THEME.Accent
Logo.TextSize = 18
Logo.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons (Minimize & Close)
local function CreateControlBtn(text, xOffset, color, callback)
    local Btn = Instance.new("TextButton", Header)
    Btn.Size = UDim2.new(0, 35, 0, 35)
    Btn.AnchorPoint = Vector2.new(1, 0.5)
    Btn.Position = UDim2.new(1, xOffset, 0.5, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Btn.BackgroundTransparency = 0.95
    Btn.Text = text
    Btn.TextColor3 = color
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 18
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local IsMinimized = false
local Sidebar, Content 

CreateControlBtn("X", -5, Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)
local MiniBtn = CreateControlBtn("-", -45, Color3.fromRGB(255, 255, 255), function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 40)}):Play()
        Sidebar.Visible = false
        Content.Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        task.wait(0.3)
        Sidebar.Visible = true
        Content.Visible = true
    end
end)

-- Sidebar (Left)
Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.BorderSizePixel = 0

-- Content Area (Right)
Content = Instance.new("Frame", MainFrame)
Content.BackgroundColor3 = THEME.Bg
Content.Position = UDim2.new(0, 170, 0, 50)
Content.Size = UDim2.new(1, -180, 1, -60)
Content.BackgroundTransparency = 1

-- [[ TAB LOGIC ]]
local CurrentPage = nil
function CreateTab(text)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = THEME.Bg
    Btn.BackgroundTransparency = 1
    Btn.Text = "  " .. text
    Btn.TextColor3 = Color3.fromRGB(150,150,150)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local List = Sidebar:FindFirstChild("UIListLayout") or Instance.new("UIListLayout", Sidebar)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 5)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    if not Sidebar:FindFirstChild("UIPadding") then
        local p = Instance.new("UIPadding", Sidebar)
        p.PaddingTop = UDim.new(0, 10)
    end

    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.Visible = false
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding = UDim.new(0, 8)
    PL.SortOrder = Enum.SortOrder.LayoutOrder

    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then
            CurrentPage.Btn.TextColor3 = Color3.fromRGB(150,150,150)
            CurrentPage.Page.Visible = false
        end
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Page.Visible = true
    end)
    
    if CurrentPage == nil then
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Page.Visible = true
    end
    return Page
end

-- [[ COMPONENT CREATOR ]]
function CreateToggle(parent, title, desc, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = THEME.Item
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local LTitle = Instance.new("TextLabel", Frame)
    LTitle.Size = UDim2.new(1, -60, 0, 25)
    LTitle.Position = UDim2.new(0, 10, 0, 2)
    LTitle.BackgroundTransparency = 1
    LTitle.Text = title
    LTitle.TextColor3 = THEME.Text
    LTitle.Font = Enum.Font.GothamBold
    LTitle.TextSize = 13
    LTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local LDesc = Instance.new("TextLabel", Frame)
    LDesc.Size = UDim2.new(1, -60, 0, 15)
    LDesc.Position = UDim2.new(0, 10, 0, 25)
    LDesc.BackgroundTransparency = 1
    LDesc.Text = desc
    LDesc.TextColor3 = Color3.fromRGB(150,150,150)
    LDesc.Font = Enum.Font.Gotham
    LDesc.TextSize = 10
    LDesc.TextXAlignment = Enum.TextXAlignment.Left
    
    local TBtn = Instance.new("TextButton", Frame)
    TBtn.Size = UDim2.new(0, 40, 0, 20)
    TBtn.Position = UDim2.new(1, -50, 0.5, -10)
    TBtn.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(50,50,60)
    TBtn.Text = ""
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 4)
    
    TBtn.MouseButton1Click:Connect(function()
        default = not default
        TBtn.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(50,50,60)
        
        -- PREMIUM NOTIF
        local status = default and "ON" or "OFF"
        SendNotif("System Update", title .. ": " .. status, 1)
        
        callback(default)
    end)
end

function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.BackgroundColor3 = THEME.Item
    Btn.Text = text
    Btn.TextColor3 = THEME.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

function CreateInfo(parent, label, value)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 30)
    Frame.BackgroundColor3 = THEME.Item
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local L = Instance.new("TextLabel", Frame)
    L.Size = UDim2.new(0.4, 0, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = label
    L.TextColor3 = Color3.fromRGB(180,180,180)
    L.Font = Enum.Font.Gotham
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    local V = Instance.new("TextLabel", Frame)
    V.Size = UDim2.new(0.6, -20, 1, 0)
    V.Position = UDim2.new(0.4, 0, 0, 0)
    V.BackgroundTransparency = 1
    V.Text = value
    V.TextColor3 = THEME.Accent
    V.Font = Enum.Font.GothamBold
    V.TextSize = 12
    V.TextXAlignment = Enum.TextXAlignment.Right
end

-- =============================================================
-- 3. TELEPORT LOGIC
-- =============================================================
local function TweenTP(cframe)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    -- GOD MODE LOGIC
    if CONFIG.IsGodMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Lava" and v:IsA("BasePart") then
                v.CanTouch = false 
                v.CanCollide = true
            end
        end
    end
    
    local dist = (root.Position - cframe.Position).Magnitude
    local time = dist / CONFIG.FlySpeed
    
    local ti = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, ti, {CFrame = cframe})
    
    local conn
    conn = RunService.Stepped:Connect(function()
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    
    tween:Play()
    tween.Completed:Wait()
    if conn then conn:Disconnect() end
    
    root.Anchored = true
    task.wait(1)
    root.Anchored = false
end

-- =============================================================
-- 4. MENU CONTENT
-- =============================================================

-- TAB 1: AUTO MANCING
local Tab1 = CreateTab("Auto Mancing")
CreateToggle(Tab1, "Auto Fish V3", "Auto Click + Shake + Perfect Reel", false, function(s) CONFIG.IsAutoFish = s end)
CreateToggle(Tab1, "AFK Level 500", "No-Life Rod Mode (Auto Fish 24H)", false, function(s) 
    CONFIG.IsAFKLevel = s 
    CONFIG.IsAutoFish = s 
end)

-- TAB 2: AUTO SELL
local Tab2 = CreateTab("Auto Sell")
CreateToggle(Tab2, "Teleport ke Merchant", "ON: Ke Merchant Terdekat | OFF: Balik", false, function(s) CONFIG.IsAutoSell = s end)

-- TAB 3: PULAU
local TabIsland = CreateTab("Pulau & Zone")
local IslandMap = {
    ["Moosewood Dock"] = Vector3.new(380, 135, 230),
    ["Roslit Bay Dock"] = Vector3.new(-1480, 132, 720),
    ["Terrapin Island Dock"] = Vector3.new(-180, 135, 1950),
    ["Snowcap Island Dock"] = Vector3.new(2620, 135, 2400),
    ["Sunstone Island Beach"] = Vector3.new(-930, 132, -1120),
    ["Mushgrove Swamp Dock"] = Vector3.new(2450, 130, -700),
    ["Forsaken Shores Beach"] = Vector3.new(-2500, 132, 1550),
    ["Ancient Isle Entrance"] = Vector3.new(-3150, 140, 2600),
    ["Statue of Sovereignty"] = Vector3.new(30, 140, -1020),
    ["The Arch Stone"] = Vector3.new(980, 130, -1240)
}
for name, pos in pairs(IslandMap) do
    CreateButton(TabIsland, "TP: " .. name, function() TweenTP(CFrame.new(pos)) end)
end

-- TAB 4: SECRET RODS
local TabRod = CreateTab("Secret Rods")
local RodMap = {
    ["Snowcap: Lost Rod"] = {Pos=Vector3.new(2650, 140, 2450), Price="2,000 C$", Guide="Masuk gua di tebing bawah Snowcap."},
    ["Statue: Kings Rod"] = {Pos=Vector3.new(30, 135, -1020), Price="120,000 C$", Guide="Bayar 400C$ ke Cole, turun lift ke Altar."},
    ["Arch: Destiny Rod"] = {Pos=Vector3.new(980, 150, -1240), Price="190,000 C$", Guide="Lengkapi 70% Bestiary."},
    ["Roslit: Magma Rod"] = {Pos=Vector3.new(-1830, 165, 160), Price="15,000 C$", Guide="God Mode Aktif! Jalan di atas lava ke Orc."},
    ["Swamp: Fungal Rod"] = {Pos=Vector3.new(2550, 135, -730), Price="Quest", Guide="Tangkap Alligator (Malam/Foggy/Hujan)."},
    ["Ancient: Forgotten Fang"] = {Pos=Vector3.new(-3150, 135, 2600), Price="Crafting", Guide="Belakang air terjun Ancient Isle."},
    ["Deep: Trident Rod"] = {Pos=Vector3.new(-970, 135, 1330), Price="Quest", Guide="Buka gerbang Desolate Deep (5 Relics)."},
    ["Vertigo: Aurora Rod"] = {Pos=Vector3.new(-100, 135, 1000), Price="90,000 C$", Guide="Hanya muncul saat Event Aurora."},
    ["Forsaken: Scurvy Rod"] = {Pos=Vector3.new(-2550, 135, 1630), Price="50,000 C$", Guide="Masuk gua Bajak Laut di Forsaken."}
}
for name, data in pairs(RodMap) do
    CreateButton(TabRod, "TP: " .. name, function()
        if string.find(name, "Magma") then CONFIG.IsGodMode = true else CONFIG.IsGodMode = false end
        TweenTP(CFrame.new(data.Pos))
        SendNotif(name, "Price: " .. data.Price .. "\n" .. data.Guide, 10)
    end)
end

-- TAB 5: SPECIAL RODS
local TabSpecial = CreateTab("Special Rods")
CreateButton(TabSpecial, "[AUTO] Quest Brick Rod", function()
    local locs = {
        {Name="Brick 1 (Roslit)", Pos=Vector3.new(-1480, 135, 720)}, 
        {Name="Brick 2 (Ancient)", Pos=Vector3.new(-3150, 140, 2600)},
        {Name="Brick 3 (Deep Entrance)", Pos=Vector3.new(-970, 135, 1330)},
        {Name="Claim NPC (Tree)", Pos=Vector3.new(450, 150, 230)}
    }
    for _, loc in ipairs(locs) do
        SendNotif("Quest Progress", "Going to: " .. loc.Name, 3)
        TweenTP(CFrame.new(loc.Pos))
        task.wait(1) 
        if loc.Name == "Claim NPC (Tree)" then
            SendNotif("FINISH!", "Talk to the NPC to get Brick Rod!", 10)
        else
            SendNotif("Action", "Look for White Lego Brick!", 5)
            task.wait(6) 
        end
    end
end)

-- TAB 6: EVENT (NEW)
local TabEvent = CreateTab("Events")
CreateButton(TabEvent, "[AUTO] Find Megalodon / Shark", function()
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Great White Shark" or v.Name == "Megalodon" then target = v break end
    end
    if target then
        TweenTP(target.PrimaryPart.CFrame * CFrame.new(0,20,0))
        SendNotif("Monster Found!", "Teleported above target.", 5)
    else
        SendNotif("Scanner", "No Boss Spawned.", 3)
    end
end)

-- TAB 7: SYSTEM
local Tab3 = CreateTab("System")
CreateToggle(Tab3, "Smart NoClip", "Tembus Tembok, Lantai Aman", false, function(s) CONFIG.IsNoClip = s end)
CreateToggle(Tab3, "Walk on Water", "Berjalan di atas air", false, function(s) CONFIG.IsWaterWalk = s end)
CreateToggle(Tab3, "Night Vision (Rod NPC)", "ESP Khusus Penjual Rod", false, function(s) CONFIG.IsNPC_ESP = s end)
CreateToggle(Tab3, "ESP Player", "Wallhack Biru Neon", false, function(s) CONFIG.IsESP = s end)
CreateToggle(Tab3, "Anti-AFK 24H", "Bypass Idle Kick", false, function(s) CONFIG.IsAntiAFK = s end)
CreateToggle(Tab3, "God Mode (Anti-Lava)", "Kebal Lava Roslit", false, function(s) CONFIG.IsGodMode = s end)

-- TAB 8: INFO
local Tab4 = CreateTab("Info")
local execName = "Unknown" if identifyexecutor then execName = identifyexecutor() end
local gameName = "Unknown" pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
CreateInfo(Tab4, "Owner:", "ZAYANGGGGG")
CreateInfo(Tab4, "Owner ID:", "1398015808")
CreateInfo(Tab4, "Website:", "www.YuuVins.online")
CreateInfo(Tab4, "Executor:", execName)

-- =============================================================
-- 5. LOGIC ENGINE
-- =============================================================

-- [[ AUTO FISH V3 ]]
task.spawn(function()
    while true do
        task.wait(0.2)
        if CONFIG.IsAutoFish and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool and not Tool:FindFirstChild("bobber") then
                VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1)
                task.wait(1.0) 
                VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1) 
                task.wait(1.5)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if CONFIG.IsAutoFish then
        local GUI = LocalPlayer:FindFirstChild("PlayerGui")
        if GUI then
            -- Shake
            local ShakeUI = GUI:FindFirstChild("shakeui")
            if ShakeUI and ShakeUI.Enabled then
                local Btn = ShakeUI:FindFirstChild("safezone") and ShakeUI.safezone:FindFirstChild("button")
                if Btn and Btn.Visible then
                    GuiService.SelectedObject = Btn
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end
            end
            -- Reel
            local ReelUI = GUI:FindFirstChild("reel")
            if ReelUI and ReelUI.Enabled then
                local Bar = ReelUI:FindFirstChild("bar")
                if Bar and Bar:FindFirstChild("fish") and Bar:FindFirstChild("playerbar") then
                    if Bar.fish.Position.X.Scale > Bar.playerbar.Position.X.Scale then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    else
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end
                end
            else
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end
        end
    end
end)

-- [[ SMART NOCLIP & WATER WALK ]]
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        -- NoClip
        if CONFIG.IsNoClip then
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        -- Water Walk
        if CONFIG.IsWaterWalk then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local ray = Ray.new(root.Position, Vector3.new(0, -5, 0))
                local hit, pos, mat = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if mat == Enum.Material.Water then
                    local bv = root:FindFirstChild("WaterWalk") or Instance.new("BodyVelocity", root)
                    bv.Name = "WaterWalk"
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(0, 10000, 0)
                    root.CFrame = root.CFrame + Vector3.new(0, 0.5, 0)
                else
                    if root:FindFirstChild("WaterWalk") then root.WaterWalk:Destroy() end
                end
            end
        end
    end
end)

-- [[ NIGHT VISION (NPC ESP) ]]
RunService.RenderStepped:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and (v.Name == "Merchant" or string.find(v.Name, "Rod")) then
            if CONFIG.IsNPC_ESP then
                if not v:FindFirstChild("NPC_ESP") then
                    local H = Instance.new("Highlight", v)
                    H.Name = "NPC_ESP"
                    H.FillColor = THEME.NPC_Color
                    H.OutlineColor = Color3.new(1,1,1)
                    H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    local B = Instance.new("BillboardGui", v:FindFirstChild("Head") or v.PrimaryPart)
                    B.Name = "Info"
                    B.Size = UDim2.new(0, 100, 0, 50)
                    B.AlwaysOnTop = true
                    local T = Instance.new("TextLabel", B)
                    T.Size = UDim2.new(1,0,1,0)
                    T.BackgroundTransparency = 1
                    T.TextColor3 = THEME.NPC_Color
                    T.Text = "ROD MERCHANT"
                    T.Font = Enum.Font.Bold
                end
            else
                if v:FindFirstChild("NPC_ESP") then v.NPC_ESP:Destroy() end
                if v:FindFirstChild("Head") and v.Head:FindFirstChild("Info") then v.Head.Info:Destroy() end
            end
        end
    end
end)

-- [[ BOOT SEQUENCE ]]
task.spawn(function()
    task.wait(5)
    ScreenGui.Enabled = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)}):Play()
end)
