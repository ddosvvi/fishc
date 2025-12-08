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
local Camera = workspace.CurrentCamera

-- [[ KONFIGURASI GLOBAL ]]
local CONFIG = {
    IsAutoFish = false,
    IsAutoSell = false,    -- Teleport Toggle
    IsESP = false,
    IsAntiAFK = true,
    IsBypass = true,
    
    SavedPosition = nil,   -- Menyimpan lokasi mancing
    FlySpeed = 300,        -- Kecepatan Teleport (Sangat Cepat)
    TargetGroupId = 7381705,
    Blacklist = {"Trial Tester", "Trial Mod", "Moderator", "Senior Mod", "Admin", "Developer", "Creator"}
}

-- [[ THEME PRESETS ]]
local THEME = {
    Bg = Color3.fromRGB(10, 12, 20),
    Sidebar = Color3.fromRGB(15, 18, 30),
    Item = Color3.fromRGB(20, 25, 40),
    Text = Color3.fromRGB(240, 240, 255),
    Accent = Color3.fromRGB(0, 230, 255), -- YuuVins Neon Blue
    Glow1 = Color3.fromRGB(0, 180, 255),
    Glow2 = Color3.fromRGB(0, 80, 200),
    ESP_Color = Color3.fromRGB(0, 255, 255)
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
-- 1. NOTIFIKASI SYSTEM (BOOT SEQUENCE)
-- =============================================================
task.spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "YuuVins Exploids",
        Text = "Authenticating Premium Key...",
        Duration = 2.5,
        Icon = "rbxassetid://16369066601"
    })
    task.wait(2.5)
    StarterGui:SetCore("SendNotification", {
        Title = "WELCOME USER",
        Text = "Logged in as: ZAYANGGGGG",
        Duration = 2.5,
    })
end)

-- =============================================================
-- 2. UI CONSTRUCTION (ALCHEMY STYLE + MINIMIZE)
-- =============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuuVinsExploidsUI"
ScreenGui.Parent = UI_Parent
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false -- Hidden during boot

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Glow Border (Animated)
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
local Sidebar, Content -- Declared early

CreateControlBtn("X", -5, Color3.fromRGB(255, 80, 80), function() ScreenGui:Destroy() end)
local MiniBtn = CreateControlBtn("-", -45, Color3.fromRGB(255, 255, 255), function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        -- Animasi Minimize
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 40)}):Play()
        Sidebar.Visible = false
        Content.Visible = false
    else
        -- Animasi Maximize
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
        task.wait(0.3)
        Sidebar.Visible = true
        Content.Visible = true
    end
end)

-- Sidebar (Left)
Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.BorderSizePixel = 0

-- Content Area (Right)
Content = Instance.new("Frame", MainFrame)
Content.BackgroundColor3 = THEME.Bg
Content.Position = UDim2.new(0, 160, 0, 50)
Content.Size = UDim2.new(1, -170, 1, -60)
Content.BackgroundTransparency = 1

-- [[ TAB LOGIC ]]
local CurrentPage = nil
function CreateTab(text)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.BackgroundColor3 = THEME.Bg
    Btn.BackgroundTransparency = 1
    Btn.Text = "  " .. text
    Btn.TextColor3 = Color3.fromRGB(150,150,150)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
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
        callback(default)
    end)
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
-- 3. MENU CONTENT
-- =============================================================

-- TAB 1: AUTO MANCING
local Tab1 = CreateTab("Auto Mancing")
CreateToggle(Tab1, "Auto Fish V3", "Auto Click + Shake + Perfect Reel", false, function(s) CONFIG.IsAutoFish = s end)

-- TAB 2: AUTO SELL
local Tab2 = CreateTab("Auto Sell")
CreateToggle(Tab2, "Teleport ke Merchant", "ON: Pindah ke Merchant | OFF: Balik ke Awal", false, function(s) CONFIG.IsAutoSell = s end)

-- TAB 3: SYSTEM
local Tab3 = CreateTab("System")
CreateToggle(Tab3, "ESP Player", "Wallhack Biru Neon (Box, Line, HP)", false, function(s) CONFIG.IsESP = s end)
CreateToggle(Tab3, "Anti-AFK 24H", "Bypass Idle Kick (Bisa ditinggal tidur)", false, function(s) CONFIG.IsAntiAFK = s end)
CreateToggle(Tab3, "Bypass Anti-BAN", "Auto kick jika Staff join", true, function(s) CONFIG.IsBypass = s end)

-- TAB 4: INFO
local Tab4 = CreateTab("Info")
-- Get Executor Name
local execName = "Unknown"
if identifyexecutor then execName = identifyexecutor() end
-- Get Game Name
local gameName = "Unknown"
pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)

CreateInfo(Tab4, "Owner:", "ZAYANGGGGG")
CreateInfo(Tab4, "Owner ID:", "1398015808")
CreateInfo(Tab4, "Website:", "www.YuuVins.online")
CreateInfo(Tab4, "Status:", "PREMIUM ACTIVE")
CreateInfo(Tab4, "----------------", "----------------")
CreateInfo(Tab4, "Current Player:", LocalPlayer.DisplayName)
CreateInfo(Tab4, "Your ID:", LocalPlayer.UserId)
CreateInfo(Tab4, "Executor:", execName)
CreateInfo(Tab4, "Game:", gameName)

-- =============================================================
-- 4. LOGIC ENGINE
-- =============================================================

-- [[ AUTO FISH V3 ]]
task.spawn(function()
    while true do
        task.wait(0.1)
        if CONFIG.IsAutoFish then
            local Char = LocalPlayer.Character
            if Char then
                local Tool = Char:FindFirstChildOfClass("Tool")
                -- 1. AUTO CAST (KLIK SAAT ROD DIAM)
                if Tool and not Tool:FindFirstChild("bobber") then
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1)
                    task.wait(1)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not CONFIG.IsAutoFish then return end
    local GUI = LocalPlayer:FindFirstChild("PlayerGui")
    if not GUI then return end

    -- 2. AUTO SHAKE
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

    -- 3. AUTO REEL (PERFECT CATCH)
    local ReelUI = GUI:FindFirstChild("reel")
    if ReelUI and ReelUI.Enabled then
        local Bar = ReelUI:FindFirstChild("bar")
        if Bar then
            local Fish = Bar:FindFirstChild("fish")
            local PlayerBar = Bar:FindFirstChild("playerbar")
            if Fish and PlayerBar then
                if Fish.Position.X.Scale > PlayerBar.Position.X.Scale then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                else
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end
            end
        end
    end
end)

-- [[ SMART TELEPORT MERCHANT ]]
local function TweenMove(targetCFrame)
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart
    
    local Dist = (Root.Position - targetCFrame.Position).Magnitude
    local Time = Dist / CONFIG.FlySpeed
    
    local TI = TweenInfo.new(Time, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, TI, {CFrame = targetCFrame})
    
    local Conn
    Conn = RunService.Stepped:Connect(function()
        for _, v in pairs(Char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    
    Tween:Play()
    Tween.Completed:Wait()
    if Conn then Conn:Disconnect() end
end

local function FindMerchant()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name == "Merchant" or v.Name == "Marc Merchant") then
            if v:FindFirstChild("HumanoidRootPart") then return v end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if CONFIG.IsAutoSell then
            -- Save Posisi Awal
            if not CONFIG.SavedPosition and LocalPlayer.Character then
                CONFIG.SavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
            
            -- Pergi ke Merchant
            local Merch = FindMerchant()
            if Merch and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Dist = (Root.Position - Merch.HumanoidRootPart.Position).Magnitude
                if Dist > 10 then
                    TweenMove(Merch.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                end
            end
        else
            -- Balik ke Posisi Awal
            if CONFIG.SavedPosition and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Dist = (Root.Position - CONFIG.SavedPosition.Position).Magnitude
                if Dist > 10 then
                    TweenMove(CONFIG.SavedPosition)
                    CONFIG.SavedPosition = nil
                end
            end
        end
    end
end)

-- [[ SYSTEM: PREMIUM ESP & AFK & ADMIN ]]
task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        if CONFIG.IsAntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end)

-- Custom ESP Loop (Wallhack, Box, Tracer, Health)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if CONFIG.IsESP then
                if not p.Character:FindFirstChild("YuuVinsESP") then
                    local H = Instance.new("Highlight", p.Character)
                    H.Name = "YuuVinsESP"
                    H.FillColor = THEME.ESP_Color
                    H.OutlineColor = Color3.new(1,1,1)
                    H.FillTransparency = 0.6
                    H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Wallhack
                    
                    local B = Instance.new("BillboardGui", p.Character.HumanoidRootPart)
                    B.Name = "InfoESP"
                    B.Size = UDim2.new(0, 200, 0, 50)
                    B.StudsOffset = Vector3.new(0, 3.5, 0)
                    B.AlwaysOnTop = true
                    
                    local T = Instance.new("TextLabel", B)
                    T.Size = UDim2.new(1,0,0.7,0)
                    T.BackgroundTransparency = 1
                    T.TextColor3 = THEME.ESP_Color
                    T.Font = Enum.Font.GothamBold
                    T.TextStrokeTransparency = 0
                    T.TextSize = 11
                    
                    -- Health Bar
                    local HPBg = Instance.new("Frame", B)
                    HPBg.BackgroundColor3 = Color3.new(0,0,0)
                    HPBg.Size = UDim2.new(0.6, 0, 0.1, 0)
                    HPBg.Position = UDim2.new(0.2, 0, 0.7, 0)
                    local HPFill = Instance.new("Frame", HPBg)
                    HPFill.Name = "Fill"
                    HPFill.BackgroundColor3 = Color3.new(0,1,0)
                    HPFill.Size = UDim2.new(1,0,1,0)
                end
                
                -- Update ESP Info
                local B = p.Character.HumanoidRootPart:FindFirstChild("InfoESP")
                local H = p.Character:FindFirstChild("YuuVinsESP")
                if B and H then
                    local Dist = math.floor((p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
                    local Hum = p.Character:FindFirstChild("Humanoid")
                    local HP = Hum and Hum.Health or 0
                    local MaxHP = Hum and Hum.MaxHealth or 100
                    
                    B.TextLabel.Text = string.format("%s\n[%d m]", p.DisplayName, Dist)
                    B.Frame.Fill.Size = UDim2.new(HP/MaxHP, 0, 1, 0)
                    B.Frame.Fill.BackgroundColor3 = Color3.fromHSV((HP/MaxHP)*0.3, 1, 1)
                end
            else
                -- Remove ESP if toggled off
                if p.Character:FindFirstChild("YuuVinsESP") then p.Character.YuuVinsESP:Destroy() end
                if p.Character.HumanoidRootPart:FindFirstChild("InfoESP") then p.Character.HumanoidRootPart.InfoESP:Destroy() end
            end
        end
    end
end)

-- Anti Admin
task.spawn(function()
    while true do
        task.wait(5)
        if CONFIG.IsBypass then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local s, r = pcall(function() return p:GetRoleInGroup(CONFIG.TargetGroupId) end)
                    if s and r then
                        for _, bad in ipairs(CONFIG.Blacklist) do
                            if r == bad then LocalPlayer:Kick("YuuVins Security: Staff Detected.") end
                        end
                    end
                end
            end
        end
    end
end)

-- Load GUI After 5 Seconds
task.spawn(function()
    task.wait(5) -- 2.5 + 2.5 from Notifs
    ScreenGui.Enabled = true
    -- Intro Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
end)


