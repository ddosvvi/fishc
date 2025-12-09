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
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

-- [[ KONFIGURASI GLOBAL ]]
local CONFIG = {
    FT_AutoFish = false,
    FT_Legit10x = false,
    FT_Luck200x = false,
    IsAntiAFK = true,
    IsInfJump = false,
    IsFullBright = false
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
}

-- [[ GUI SAFE LOADER ]]
local function GetSafeGui()
    local s, h = pcall(function() return gethui() end)
    if s and h then return h end
    return game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end
local UI_Parent = GetSafeGui()

for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "YuuVinsExploidsUI" or v.Name == "YuuVinsLoading" then v:Destroy() end
end

-- =============================================================
-- 1. LOADING SCREEN (ANIMATED 0-100%)
-- =============================================================
local LoadScreen = Instance.new("ScreenGui", UI_Parent)
LoadScreen.Name = "YuuVinsLoading"
LoadScreen.IgnoreGuiInset = true

local LoadFrame = Instance.new("Frame", LoadScreen)
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = THEME.Bg
LoadFrame.ZIndex = 999

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0.2, 0)
LoadTitle.Position = UDim2.new(0, 0, 0.3, 0)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "YuuVins Exploids"
LoadTitle.Font = Enum.Font.GothamBlack
LoadTitle.TextColor3 = THEME.Accent
LoadTitle.TextSize = 40

local LoadBarBg = Instance.new("Frame", LoadFrame)
LoadBarBg.Size = UDim2.new(0.6, 0, 0.02, 0)
LoadBarBg.Position = UDim2.new(0.2, 0, 0.5, 0)
LoadBarBg.BackgroundColor3 = THEME.Item
Instance.new("UICorner", LoadBarBg).CornerRadius = UDim.new(1, 0)

local LoadBarFill = Instance.new("Frame", LoadBarBg)
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = THEME.Accent
Instance.new("UICorner", LoadBarFill).CornerRadius = UDim.new(1, 0)

local LoadPercent = Instance.new("TextLabel", LoadFrame)
LoadPercent.Size = UDim2.new(1, 0, 0.1, 0)
LoadPercent.Position = UDim2.new(0, 0, 0.55, 0)
LoadPercent.BackgroundTransparency = 1
LoadPercent.Text = "0%"
LoadPercent.TextColor3 = Color3.fromRGB(200,200,200)
LoadPercent.Font = Enum.Font.GothamBold
LoadPercent.TextSize = 20

-- Animasi Loading
spawn(function()
    for i = 1, 100 do
        LoadBarFill:TweenSize(UDim2.new(i/100, 0, 1, 0), "Out", "Quad", 0.02, true)
        LoadPercent.Text = "Loading Assets... " .. i .. "%"
        task.wait(0.015) -- Kecepatan loading
    end
    LoadPercent.Text = "Injecting Modules..."
    task.wait(0.5)
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(LoadBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadBarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadPercent, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6)
    LoadScreen:Destroy()
end)

-- =============================================================
-- 2. UI MAIN SYSTEM
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
-- 3. MENU CONTENT
-- =============================================================
local TabMain = CreateTab("Fish-It Main")
CreateToggle(TabMain, "Auto Fish V3", "Tap -> Charge -> Turbo Reel", false, function(s) CONFIG.FT_AutoFish = s end)
CreateToggle(TabMain, "Legit 10x Speed", "Animation Booster", false, function(s) CONFIG.FT_Legit10x = s end)
CreateToggle(TabMain, "200x Luck", "Spam RNG Event", false, function(s) CONFIG.FT_Luck200x = s end)

local TabVis = CreateTab("Visuals")
CreateToggle(TabVis, "Infinite Jump", "Lompat di udara", false, function(s) CONFIG.IsInfJump = s end)
CreateToggle(TabVis, "Always Day", "Terang Terus", false, function(s) CONFIG.IsFullBright = s; if not s then Lighting.ClockTime = 12 end end)

local TabSys = CreateTab("System")
CreateToggle(TabSys, "Anti-AFK", "No Disconnect 24H", true, function(s) CONFIG.IsAntiAFK = s end)

local TabInfo = CreateTab("Info")
local execName = "Unknown" if identifyexecutor then execName = identifyexecutor() end
local gameName = "Fish It Modded"
CreateInfo(TabInfo, "Best Xploid YuuVins")
CreateInfo(TabInfo, "Username:", LocalPlayer.DisplayName)
CreateInfo(TabInfo, "Game:", gameName)
CreateInfo(TabInfo, "Status:", "SPECIAL EDITION")
CreateInfo(TabInfo, "Executor:", execName)

-- =============================================================
-- 4. LOGIC ENGINE (FISH IT PRO MAX)
-- =============================================================

-- [[ FISH IT: AUTO FISH LOGIC (TAP > CHARGE > REEL) ]]
task.spawn(function()
    while true do task.wait(0.1)
        if CONFIG.FT_AutoFish and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool then
                if not Tool:FindFirstChild("bobber") then
                    -- FASE 1: CAST (LEMPAR)
                    -- Klik 1x untuk mulai charge
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    
                    task.wait(0.8) -- Tunggu bar charge naik ke zona perfect
                    
                    -- Klik lagi untuk lempar perfect
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    
                    task.wait(2.5) -- Tunggu umpan masuk air
                else
                    -- FASE 2: REEL (TARIK)
                    -- Spam klik super cepat (Turbo Reel) saat sudah hook
                    for i = 1, 10 do -- Klik 10x cepat
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                        task.wait(0.01)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    end
                    task.wait(0.1) -- Jeda dikit
                end
            end
        end
    end
end)

-- [[ FISH IT: 10x SPEED ]]
task.spawn(function()
    while true do task.wait(0.5)
        if CONFIG.FT_Legit10x then pcall(function() Workspace.Gravity = 50 end) 
        else Workspace.Gravity = 196.2 end
    end
end)

-- [[ FISH IT: 200X LUCK ]]
task.spawn(function()
    while true do task.wait(2)
        if CONFIG.FT_Luck200x then
            local RS = game:GetService("ReplicatedStorage")
            local Evt = RS:FindFirstChild("LuckEvent") or RS:FindFirstChild("Events") and RS.Events:FindFirstChild("Luck")
            if Evt then pcall(function() Evt:FireServer(200) end) end
        end
    end
end)

-- [[ SYSTEM: INFINITE JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if CONFIG.IsInfJump and LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ SYSTEM: FULLBRIGHT ]]
task.spawn(function()
    while true do task.wait(1)
        if CONFIG.IsFullBright then Lighting.ClockTime = 12; Lighting.Brightness = 2; Lighting.GlobalShadows = false end
    end
end)

-- [[ SYSTEM: ANTI AFK ]]
LocalPlayer.Idled:Connect(function()
    if CONFIG.IsAntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end
end)

-- [[ BOOT SEQUENCE ]]
task.spawn(function()
    task.wait(1.5) -- Tunggu loading bar selesai
    ScreenGui.Enabled = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 600, 0, 400)}):Play()
end)
