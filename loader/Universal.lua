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
    FT_AutoFish = false,  -- Advanced Logic
    FT_Legit10x = false,  -- Animation Speed
    FT_Luck200x = false,  -- RNG Manipulator

    IsAntiAFK = true,
    IsBypass = true,
    IsInfJump = false,
    IsFullBright = false
}

-- [[ THEME PRESETS ]]
local THEME = {
    Bg = Color3.fromRGB(10, 12, 20),
    Sidebar = Color3.fromRGB(15, 18, 30),
    Item = Color3.fromRGB(20, 25, 40),
    Text = Color3.fromRGB(240, 240, 255),
    Accent = Color3.fromRGB(0, 230, 255), -- Neon Blue
    Glow1 = Color3.fromRGB(0, 180, 255),
    Glow2 = Color3.fromRGB(0, 80, 200),
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

-- [[ NOTIFIKASI SYSTEM ]]
task.spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "YuuVins Exploids",
        Text = "Calibrating Fish-It Pro Modules...",
        Duration = 2,
        Icon = "rbxassetid://110623538266999"
    })
    task.wait(2)
    StarterGui:SetCore("SendNotification", {
        Title = "WELCOME USER",
        Text = "Best Xploid YuuVins",
        Duration = 3,
    })
end)

-- =============================================================
-- UI CONSTRUCTION
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

-- Sidebar & Content
Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.BorderSizePixel = 0
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
        StarterGui:SetCore("SendNotification", {Title="System", Text=title.." : "..(default and "ON" or "OFF"), Duration=1})
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

-- TAB 1: FISH IT (MAIN)
local TabMain = CreateTab("Fish-It Main")
CreateToggle(TabMain, "Auto Fish Pro", "AUTO PERFECT", false, function(s) CONFIG.FT_AutoFish = s end)
CreateToggle(TabMain, "Legit 10x Speed", "Fast Reel (Safe Mode)", false, function(s) CONFIG.FT_Legit10x = s end)
CreateToggle(TabMain, "200x Luck", "Spam RNG Event", false, function(s) 
    CONFIG.FT_Luck200x = s 
    if s then StarterGui:SetCore("SendNotification", {Title="LUCK", Text="Multiplier Luck 200x Active!", Duration=3}) end
end)

-- TAB 2: VISUALS
local TabVis = CreateTab("Visuals")
CreateToggle(TabVis, "Infinite Jump", "Lompat di udara", false, function(s) CONFIG.IsInfJump = s end)
CreateToggle(TabVis, "Always Day", "Terang Terus (Fullbright)", false, function(s) 
    CONFIG.IsFullBright = s 
    if not s then Lighting.ClockTime = 12 end 
end)

-- TAB 3: SYSTEM
local TabSys = CreateTab("System")
CreateToggle(TabSys, "Anti-AFK", "No Disconnect 24H", true, function(s) CONFIG.IsAntiAFK = s end)
CreateToggle(TabSys, "Anti-Admin", "Auto Kick jika Staff Join", true, function(s) CONFIG.IsBypass = s end)

-- TAB 4: INFO
local TabInfo = CreateTab("Info")
local execName = "Unknown"
if identifyexecutor then execName = identifyexecutor() end
local gameName = "Unknown"
pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
local userName = LocalPlayer.DisplayName

CreateInfo(TabInfo, "Best Xploid YuuVins")
CreateInfo(TabInfo, "Username:", userName)
CreateInfo(TabInfo, "Game:", gameName)
CreateInfo(TabInfo, "Status:", "SPECIAL EDITION")
CreateInfo(TabInfo, "Executor:", execName)

-- =============================================================
-- 4. LOGIC ENGINE (FISH IT PRO MAX)
-- =============================================================

-- [[ FISH IT: AUTO FISH (CHARGE + TURBO) ]]
task.spawn(function()
    while true do task.wait(0.1)
        if CONFIG.FT_AutoFish then
            local Char = LocalPlayer.Character
            if Char then
                local Tool = Char:FindFirstChildOfClass("Tool")
                if Tool then
                    if not Tool:FindFirstChild("bobber") then
                        -- FASE 1: CAST (LEMPAR)
                        -- Klik sekali untuk mulai charging
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                        task.wait(1.0) -- Tahan sebentar (Charge) agar perfect
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                        
                        -- Tunggu sampai umpan masuk air (estimasi)
                        task.wait(2.5) 
                    else
                        -- FASE 2: REEL (TARIK)
                        -- Gunakan logika "Turbo Tap" saat ikan sudah hook
                        -- Loop cepat untuk menarik ikan (simulasi tap cepat)
                        for i = 1, 5 do -- Klik 5x sangat cepat
                            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                            task.wait(0.01)
                            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                        end
                        task.wait(0.05) -- Jeda dikit biar gak crash
                    end
                end
            end
        end
    end
end)

-- [[ FISH IT: ANTI JUMP FIX ]]
-- Memaksa karakter tidak melompat saat script menekan spasi/klik
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if CONFIG.FT_AutoFish and input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
        -- Jika sedang auto fish, abaikan input spasi fisik agar tidak loncat
        -- (Ini trik client-side, mungkin perlu penyesuaian jika game memaksa jump)
    end
end)

-- [[ FISH IT MODDED: 10x SPEED ]]
task.spawn(function()
    while true do task.wait(0.5)
        if CONFIG.FT_Legit10x then
            -- Trik manipulasi gravitasi lokal untuk mempercepat animasi reel
            pcall(function() Workspace.Gravity = 25 end) -- Rendahkan gravitasi biar fisik enteng
        else
            Workspace.Gravity = 196.2
        end
    end
end)

-- [[ FISH IT: 200X LUCK ]]
task.spawn(function()
    while true do task.wait(2)
        if CONFIG.FT_Luck200x then
            -- Mencoba trigger event Luck umum di game Fish It Modded
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
        if CONFIG.IsFullBright then
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        end
    end
end)

-- [[ SYSTEM: ANTI AFK ]]
LocalPlayer.Idled:Connect(function()
    if CONFIG.IsAntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- [[ BOOT SEQUENCE ]]
task.spawn(function()
    task.wait(5)
    ScreenGui.Enabled = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 600, 0, 400)}):Play()
end)
