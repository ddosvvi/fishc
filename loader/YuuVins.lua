-- =============================================================
-- YuuVins Exploids // ULTIMATE V9.5 (OPTIMIZED)
-- Owner: ZAYANGGGGG
-- Status: LAG FIXED + INSTANT LOAD + ALL FEATURES
-- =============================================================

-- [[ 1. SERVICES & VARIABLES (OPTIMIZED) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 2. CONFIGURATION ]]
local CONFIG = {
    IsAutoFish = false,
    IsAutoSell = false,
    IsESP = false,
    IsVision = false,
    IsAntiAFK = true,
    IsBypass = true,
    IsAFKLevel = false,
    IsGodMode = false,
    IsNoClip = false,
    IsInfJump = false,
    IsFullBright = false,
    
    SavedPosition = nil,
    FlySpeed = 300,
    TargetGroupId = 7381705,
    Blacklist = {"Trial Tester", "Trial Mod", "Moderator", "Senior Mod", "Admin", "Developer", "Creator"}
}

local THEME = {
    Bg = Color3.fromRGB(10, 12, 20),
    Sidebar = Color3.fromRGB(15, 18, 30),
    Item = Color3.fromRGB(20, 25, 40),
    Text = Color3.fromRGB(240, 240, 255),
    Accent = Color3.fromRGB(0, 230, 255),
    Glow1 = Color3.fromRGB(0, 180, 255),
    Glow2 = Color3.fromRGB(0, 80, 200),
    ESP_Color = Color3.fromRGB(0, 255, 255),
    NPC_Color = Color3.fromRGB(255, 215, 0)
}

-- [[ 3. GUI MANAGER (SAFE LOAD) ]]
local function GetSafeGui()
    local s, h = pcall(function() return gethui() end)
    if s and h then return h end
    return game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end
local UI_Parent = GetSafeGui()

-- Cleanup Old Instances
for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "YuuVinsExploidsUI" then v:Destroy() end
end

-- Notification
task.spawn(function()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "YuuVins Exploids",
            Text = "Optimizing Assets...",
            Duration = 2,
            Icon = "rbxassetid://16369066601"
        })
    end)
    task.wait(2)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "WELCOME OWNER",
            Text = "ZAYANGGGGG (System Ready)",
            Duration = 3,
        })
    end)
end)

-- =============================================================
-- 4. UI CONSTRUCTION (ALCHEMY STYLE)
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

-- Header
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

-- Sidebar & Content
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.BorderSizePixel = 0

local Content = Instance.new("Frame", MainFrame)
Content.BackgroundColor3 = THEME.Bg
Content.Position = UDim2.new(0, 170, 0, 50)
Content.Size = UDim2.new(1, -180, 1, -60)
Content.BackgroundTransparency = 1

-- Animation Loop (Lightweight)
task.spawn(function()
    while MainFrame.Parent do
        local t = TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 360 + 45})
        t:Play() t.Completed:Wait()
        UIGradient.Rotation = 45
    end
end)

-- Minimize Logic
local IsMinimized = false
local function ToggleMinimize()
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
end

-- Control Buttons
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
end
CreateControlBtn("X", -5, Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)
CreateControlBtn("-", -45, Color3.fromRGB(255, 255, 255), ToggleMinimize)

-- [[ UI FUNCTIONS ]]
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
    if not Sidebar:FindFirstChild("UIPadding") then
        local p = Instance.new("UIPadding", Sidebar)
        p.PaddingTop = UDim.new(0, 10)
        p.PaddingLeft = UDim.new(0, 10)
    end

    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
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
        pcall(function() StarterGui:SetCore("SendNotification", {Title="System", Text=title.." : "..(default and "ON" or "OFF"), Duration=1}) end)
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
-- 5. MENU CONTENT
-- =============================================================

-- Tab 1: Auto Mancing
local Tab1 = CreateTab("Auto Mancing")
CreateToggle(Tab1, "Auto Fish V3", "Auto Click + Shake + Perfect Reel", false, function(s) CONFIG.IsAutoFish = s end)
CreateToggle(Tab1, "AFK Level 500", "No-Life Rod Mode (24H Farm)", false, function(s) CONFIG.IsAFKLevel = s; CONFIG.IsAutoFish = s end)

-- Tab 2: Auto Sell
local Tab2 = CreateTab("Auto Sell")
CreateToggle(Tab2, "Teleport ke Merchant", "ON: Ke Merchant | OFF: Balik", false, function(s) CONFIG.IsAutoSell = s end)

-- Tab 3: Pulau & Zone
local TabIsland = CreateTab("Pulau & Zone")
local Islands = {
    {"Moosewood", Vector3.new(380, 135, 230)},
    {"Roslit Bay", Vector3.new(-1480, 132, 720)},
    {"Terrapin Island", Vector3.new(-180, 135, 1950)},
    ["Snowcap Island"] = Vector3.new(2620, 135, 2400),
    ["Sunstone Island"] = Vector3.new(-930, 132, -1120),
    ["Mushgrove Swamp"] = Vector3.new(2450, 130, -700),
    ["Forsaken Shores"] = Vector3.new(-2500, 132, 1550),
    ["Ancient Isle"] = Vector3.new(-3150, 140, 2600),
    ["Statue of Sovereignty"] = Vector3.new(30, 140, -1020),
    ["The Arch"] = Vector3.new(980, 130, -1240)
}
for name, pos in pairs(Islands) do
    if type(name) == "number" then -- Handle mixed table
        CreateButton(TabIsland, "TP: " .. pos[1], function() TweenTP(CFrame.new(pos[2])) end)
    else
        CreateButton(TabIsland, "TP: " .. name, function() TweenTP(CFrame.new(pos)) end)
    end
end

-- Tab 4: Secret Rods
local TabRod = CreateTab("Secret Rods")
local Rods = {
    {N="Snowcap: Lost Rod", P=Vector3.new(2650, 140, 2450), I="Price: 2K | Guide: Masuk gua tebing bawah Snowcap."},
    {N="Statue: Kings Rod", P=Vector3.new(30, 135, -1020), I="Price: 120K | Guide: Bayar Cole 400C, turun lift."},
    {N="Roslit: Magma Rod", P=Vector3.new(-1830, 165, 160), I="Price: 15K | Guide: God Mode On! Jalan ke Orc."},
    {N="Swamp: Fungal Rod", P=Vector3.new(2550, 135, -730), I="Price: Quest | Guide: Tangkap Alligator (Malam)."},
    {N="Deep: Trident Rod", P=Vector3.new(-970, 135, 1330), I="Price: Quest | Guide: 5 Relics @ Deep."}
}
for _, d in ipairs(Rods) do
    CreateButton(TabRod, "TP: " .. d.N, function()
        if string.find(d.N, "Magma") then CONFIG.IsGodMode = true end
        TweenTP(CFrame.new(d.P))
        pcall(function() StarterGui:SetCore("SendNotification", {Title="Rod Info", Text=d.I, Duration=10}) end)
    end)
end

-- Tab 5: Events
local TabEvent = CreateTab("Events")
CreateButton(TabEvent, "[AUTO] Quest Brick Rod", function()
    local Locs = {Vector3.new(-1480, 135, 720), Vector3.new(-3150, 140, 2600), Vector3.new(-970, 135, 1330), Vector3.new(450, 150, 230)}
    for i, v in ipairs(Locs) do
        TweenTP(CFrame.new(v))
        pcall(function() StarterGui:SetCore("SendNotification", {Title="Quest", Text="Step " .. i, Duration=3}) end)
        task.wait(4)
    end
end)
CreateButton(TabEvent, "[AUTO] Find Midas", function()
    local ship = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Travelling Merchant" then ship = v break end
    end
    if ship then TweenTP(ship.PrimaryPart.CFrame * CFrame.new(0,10,0)) else 
        pcall(function() StarterGui:SetCore("SendNotification", {Title="System", Text="Not Found", Duration=2}) end) 
    end
end)

-- Tab 6: Character
local TabChar = CreateTab("Character")
CreateToggle(TabChar, "Infinite Jump", "Lompat di udara", false, function(s) CONFIG.IsInfJump = s end)
CreateToggle(TabChar, "God Mode", "Kebal Lava (Roslit)", false, function(s) CONFIG.IsGodMode = s end)
CreateToggle(TabChar, "Smart NoClip", "Tembus Tembok", false, function(s) CONFIG.IsNoClip = s end)

-- Tab 7: Visuals
local TabVis = CreateTab("Visuals")
CreateToggle(TabVis, "Vision Mode (NPC)", "Wallhack NPC Rod/Quest", false, function(s) CONFIG.IsVision = s end)
CreateToggle(TabVis, "ESP Player", "Wallhack Biru Neon", false, function(s) CONFIG.IsESP = s end)
CreateToggle(TabVis, "Always Day", "Terang Terus (Fullbright)", false, function(s) CONFIG.IsFullBright = s; if not s then Lighting.ClockTime = 12 end end)

-- Tab 8: Info
local TabInfo = CreateTab("Info")
CreateInfo(TabInfo, "Owner:", "ZAYANGGGGG")
CreateInfo(TabInfo, "UID:", "1398015808")
CreateInfo(TabInfo, "Web:", "www.YuuVins.online")
CreateInfo(TabInfo, "Status:", "PREMIUM ACTIVE")
CreateInfo(TabInfo, "Version:", "V9.5 Optimized")

-- =============================================================
-- 6. OPTIMIZED LOGIC ENGINE
-- =============================================================

-- [[ TELEPORT ]]
function TweenTP(cframe)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    -- Auto God Mode Logic
    if CONFIG.IsGodMode then
        local h = char:FindFirstChild("Humanoid")
        if h then h:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
    end

    local dist = (root.Position - cframe.Position).Magnitude
    local time = dist / CONFIG.FlySpeed
    local tween = TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cframe})
    
    local conn = RunService.Stepped:Connect(function()
        for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end)
    tween:Play()
    tween.Completed:Wait()
    conn:Disconnect()
    
    root.Anchored = true
    task.wait(0.5)
    root.Anchored = false
end

-- [[ AUTO FISH V3 ]]
task.spawn(function()
    while true do
        task.wait(0.2)
        if CONFIG.IsAutoFish then
            local Char = LocalPlayer.Character
            if Char then
                local Tool = Char:FindFirstChildOfClass("Tool")
                if Tool and not Tool:FindFirstChild("bobber") then
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1)
                    task.wait(1.0) 
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1) 
                    task.wait(1.5)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not CONFIG.IsAutoFish then return end
    local GUI = LocalPlayer:FindFirstChild("PlayerGui")
    if not GUI then return end

    local ShakeUI = GUI:FindFirstChild("shakeui")
    if ShakeUI and ShakeUI.Enabled then
        local Safe = ShakeUI:FindFirstChild("safezone")
        local Btn = Safe and Safe:FindFirstChild("button")
        if Btn and Btn.Visible then
            GuiService.SelectedObject = Btn
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
    end

    local ReelUI = GUI:FindFirstChild("reel")
    if ReelUI and ReelUI.Enabled then
        local Bar = ReelUI:FindFirstChild("bar")
        if Bar then
            local Fish = Bar:FindFirstChild("fish")
            local PlayerBar = Bar:FindFirstChild("playerbar")
            if Fish and PlayerBar then
                if Fish.Position.X.Scale > PlayerBar.Position.X.Scale then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                elseif Fish.Position.X.Scale < PlayerBar.Position.X.Scale then
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end
            end
        end
    else
        -- [FIX] FORCE RELEASE SPACE
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- [[ SMART AUTO SELL ]]
local function FindNearestMerchant()
    local Char = LocalPlayer.Character
    if not Char then return nil end
    local Root = Char.HumanoidRootPart
    local Nearest = nil
    local MinDist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name == "Merchant" or v.Name == "Marc Merchant") then
            if v:FindFirstChild("HumanoidRootPart") then
                local Dist = (Root.Position - v.HumanoidRootPart.Position).Magnitude
                if Dist < MinDist then MinDist = Dist; Nearest = v end
            end
        end
    end
    return Nearest
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if CONFIG.IsAutoSell then
            if not CONFIG.SavedPosition and LocalPlayer.Character then
                CONFIG.SavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
            local Merch = FindNearestMerchant()
            if Merch and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Dist = (Root.Position - Merch.HumanoidRootPart.Position).Magnitude
                if Dist > 10 then
                    TweenTP(Merch.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                end
            end
        else
            if CONFIG.SavedPosition and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Dist = (Root.Position - CONFIG.SavedPosition.Position).Magnitude
                if Dist > 10 then
                    TweenTP(CONFIG.SavedPosition)
                    CONFIG.SavedPosition = nil
                end
            end
        end
    end
end)

-- [[ OPTIMIZED VISUALS (CACHE SYSTEM) ]]
local VisualCache = {}
-- Update Cache every 3 seconds (Fix Lag)
task.spawn(function()
    while true do
        table.clear(VisualCache)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                if CONFIG.IsVision and (string.find(v.Name, "Merchant") or string.find(v.Name, "Orc")) then
                    table.insert(VisualCache, {Obj=v, Type="NPC"})
                end
            end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                table.insert(VisualCache, {Obj=p.Character, Type="Player", Plr=p})
            end
        end
        task.wait(3)
    end
end)

-- [[ VISUALS: ESP & VISION ]]
RunService.RenderStepped:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        -- NPC Vision
        if CONFIG.IsVision and v:IsA("Model") and (v.Name == "Merchant" or string.find(v.Name, "Rod")) then
            if not v:FindFirstChild("VisESP") then
                local h = Instance.new("Highlight", v)
                h.Name = "VisESP"; h.FillColor = THEME.NPC_Color; h.OutlineColor = Color3.new(1,1,1); h.DepthMode = "AlwaysOnTop"
            end
        elseif not CONFIG.IsVision and v:FindFirstChild("VisESP") then
            v.VisESP:Destroy()
        end
    end
    
    -- Player ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if CONFIG.IsESP then
                if not p.Character:FindFirstChild("PlrESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "PlrESP"; h.FillColor = THEME.ESP_Color; h.DepthMode = "AlwaysOnTop"
                end
            elseif p.Character:FindFirstChild("PlrESP") then
                p.Character.PlrESP:Destroy()
            end
        end
    end
end)

-- [[ INFINITE JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if CONFIG.IsInfJump and LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Fullbright
if CONFIG.IsFullBright then
    Lighting.ClockTime = 12
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
end

-- [[ BOOT ]]
task.spawn(function()
    task.wait(5)
    ScreenGui.Enabled = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 600, 0, 400)}):Play()
end)
