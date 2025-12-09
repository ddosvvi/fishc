-- =============================================================
-- YuuVins Exploids // ULTIMATE V16 (CYBERPUNK MOBILE)
-- Owner: ZAYANGGGGG
-- Status: MOBILE FIXED + CYBER THEME + FISHIT PRO
-- =============================================================

-- [[ SERVICES ]]
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
    IsBypass = true,
    IsInfJump = false,
    IsFullBright = false,
    IsGodMode = false,
    IsWaterWalk = false,
    IsNoClip = false,
    IsESP = false,
    IsVision = false
}

-- [[ CYBERPUNK THEME ]]
local THEME = {
    Bg = Color3.fromRGB(5, 5, 10), -- Deep Dark
    Sidebar = Color3.fromRGB(10, 10, 15),
    Item = Color3.fromRGB(20, 20, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(0, 255, 255), -- Neon Cyan
    SecAccent = Color3.fromRGB(255, 0, 120), -- Neon Pink
    Glow = Color3.fromRGB(0, 255, 255),
    Success = Color3.fromRGB(0, 255, 100),
    Fail = Color3.fromRGB(255, 50, 50)
}

-- [[ GUI SAFETY LOADER (MOBILE FIX) ]]
local function GetSafeGui()
    -- Prioritas PlayerGui untuk Mobile (Lebih Stabil)
    return LocalPlayer:WaitForChild("PlayerGui")
end
local UI_Parent = GetSafeGui()

-- Cleanup Old UI
for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "YuuVinsCyber" or v.Name == "YuuVinsToggle" then v:Destroy() end
end

-- [[ DRAGGABLE FUNCTION (MOBILE SUPPORT) ]]
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

-- =============================================================
-- 1. LOADING SCREEN (CYBER STYLE)
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuuVinsCyber"
ScreenGui.Parent = UI_Parent
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = THEME.Bg
LoadFrame.ZIndex = 100

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0.2, 0)
LoadTitle.Position = UDim2.new(0, 0, 0.4, 0)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "YuuVins // SYSTEM_BOOT"
LoadTitle.Font = Enum.Font.Code
LoadTitle.TextColor3 = THEME.Accent
LoadTitle.TextSize = 35

local LoadBar = Instance.new("Frame", LoadFrame)
LoadBar.Size = UDim2.new(0, 0, 0.01, 0)
LoadBar.Position = UDim2.new(0.2, 0, 0.6, 0)
LoadBar.BackgroundColor3 = THEME.SecAccent
LoadBar.BorderSizePixel = 0

-- Animasi Loading
task.spawn(function()
    LoadBar:TweenSize(UDim2.new(0.6, 0, 0.01, 0), "Out", "Quint", 2, true)
    task.wait(2.2)
    LoadFrame:TweenPosition(UDim2.new(0, 0, -1.5, 0), "Out", "Quart", 0.5, true)
    task.wait(0.5)
    LoadFrame.Visible = false
end)

-- =============================================================
-- 2. MAIN UI (CYBERPUNK)
-- =============================================================

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Start Kecil (Animasi)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MakeDraggable(MainFrame)

-- Border Gradient
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 3
local UIGradient = Instance.new("UIGradient", UIStroke)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, THEME.Accent),
    ColorSequenceKeypoint.new(0.50, THEME.SecAccent),
    ColorSequenceKeypoint.new(1.00, THEME.Accent)
}
UIGradient.Rotation = 45
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Rotate Gradient Loop
task.spawn(function()
    while MainFrame.Parent do
        local t = TweenService:Create(UIGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 405})
        t:Play(); t.Completed:Wait()
        UIGradient.Rotation = 45
    end
end)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.BackgroundColor3 = Color3.fromRGB(0,0,0); Header.BackgroundTransparency = 0.5; Header.Size = UDim2.new(1, 0, 0, 45)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.8, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "YuuVins <font color='#00FFFF'>Exploids</font> <font color='#FF0078'>V16</font>"; Title.RichText = true
Title.Font = Enum.Font.Code; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 20; Title.TextXAlignment = 0

-- Close & Minimize
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
CloseBtn.BackgroundColor3 = THEME.Fail; CloseBtn.Text = "X"; CloseBtn.Font = Enum.Font.Code; CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
end)

-- Floating Toggle Button (MOBILE FIX)
local ToggleGui = Instance.new("ScreenGui", UI_Parent)
ToggleGui.Name = "YuuVinsToggle"
local ToggleBtn = Instance.new("TextButton", ToggleGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = THEME.Bg
ToggleBtn.Text = "Y"
ToggleBtn.TextColor3 = THEME.Accent
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 25
Instance.new("UIStroke", ToggleBtn).Color = THEME.SecAccent
Instance.new("UIStroke", ToggleBtn).Thickness = 2
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 550, 0, 350)}):Play()
end)

-- Layout Containers
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = THEME.Sidebar; Sidebar.Position = UDim2.new(0, 0, 0, 45); Sidebar.Size = UDim2.new(0, 150, 1, -45); Sidebar.BorderSizePixel = 0
local Content = Instance.new("Frame", MainFrame)
Content.BackgroundColor3 = THEME.Bg; Content.Position = UDim2.new(0, 150, 0, 45); Content.Size = UDim2.new(1, -150, 1, -45); Content.BackgroundTransparency = 1
local SideList = Instance.new("UIListLayout", Sidebar); SideList.Padding = UDim.new(0, 5); SideList.HorizontalAlignment = 1
local SidePad = Instance.new("UIPadding", Sidebar); SidePad.PaddingTop = UDim.new(0, 10)

-- [[ UI FUNCTIONS ]]
local CurrentPage = nil
function CreateTab(text)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = THEME.Bg
    Btn.BackgroundTransparency = 1
    Btn.Text = " // " .. text
    Btn.TextColor3 = Color3.fromRGB(150,150,150)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 14
    Btn.TextXAlignment = 0
    
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = THEME.Accent
    Page.Visible = false
    local PL = Instance.new("UIListLayout", Page); PL.Padding = UDim.new(0, 6)
    local PP = Instance.new("UIPadding", Page); PP.PaddingTop = UDim.new(0,5); PP.PaddingLeft=UDim.new(0,5)

    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then
            CurrentPage.Btn.TextColor3 = Color3.fromRGB(150,150,150)
            CurrentPage.Page.Visible = false
        end
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Page.Visible = true
    end)
    if not CurrentPage then
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Page.Visible = true
    end
    return Page
end

function CreateToggle(parent, title, desc, default, callback)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, -10, 0, 45); F.BackgroundColor3 = THEME.Item
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    local T = Instance.new("TextLabel", F); T.Size=UDim2.new(1,-60,0,20); T.Position=UDim2.new(0,10,0,2); T.BackgroundTransparency=1; T.Text=title; T.TextColor3=THEME.Text; T.Font=Enum.Font.Code; T.TextSize=14; T.TextXAlignment=0
    local D = Instance.new("TextLabel", F); D.Size=UDim2.new(1,-60,0,15); D.Position=UDim2.new(0,10,0,22); D.BackgroundTransparency=1; D.Text=desc; D.TextColor3=Color3.fromRGB(150,150,150); D.Font=Enum.Font.Code; D.TextSize=10; D.TextXAlignment=0
    
    local B = Instance.new("TextButton", F); B.Size=UDim2.new(0,25,0,25); B.Position=UDim2.new(1,-35,0.5,-12.5); B.BackgroundColor3=default and THEME.Success or THEME.Fail; B.Text=""; Instance.new("UICorner", B).CornerRadius=UDim.new(0,4)
    local Glow = Instance.new("UIStroke", B); Glow.Color=default and THEME.Success or THEME.Fail; Glow.Thickness=2
    
    B.MouseButton1Click:Connect(function()
        default = not default
        B.BackgroundColor3 = default and THEME.Success or THEME.Fail
        Glow.Color = default and THEME.Success or THEME.Fail
        callback(default)
    end)
end

function CreateButton(parent, text, callback)
    local B = Instance.new("TextButton", parent); B.Size=UDim2.new(1, -10, 0, 35); B.BackgroundColor3 = THEME.Item
    B.Text = "> " .. text; B.TextColor3 = THEME.Text; B.Font = Enum.Font.Code; B.TextSize = 13
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    local S = Instance.new("UIStroke", B); S.Color=THEME.Accent; S.Thickness=1; S.ApplyStrokeMode="Border"
    B.MouseButton1Click:Connect(function()
        S.Thickness = 3; task.wait(0.1); S.Thickness = 1
        callback()
    end)
end

-- =============================================================
-- 3. FEATURES & LOGIC
-- =============================================================

-- TABS
local TabMain = CreateTab("Main")
CreateToggle(TabMain, "Auto Fish V3", "Hold 2s -> Tap Tap Reel", false, function(s) CONFIG.FT_AutoFish = s end)
CreateToggle(TabMain, "Legit 10x Speed", "Animation Booster", false, function(s) CONFIG.FT_Legit10x = s end)
CreateToggle(TabMain, "200x Luck", "Spam RNG Event", false, function(s) CONFIG.FT_Luck200x = s end)

local TabVis = CreateTab("Visuals")
CreateToggle(TabVis, "Infinite Jump", "Spasi di udara", false, function(s) CONFIG.IsInfJump = s end)
CreateToggle(TabVis, "Always Day", "Terang Terus", false, function(s) CONFIG.IsFullBright = s; if not s then Lighting.ClockTime = 12 end end)

local TabSys = CreateTab("System")
CreateToggle(TabSys, "Anti-AFK", "No Disconnect 24H", true, function(s) CONFIG.IsAntiAFK = s end)
CreateToggle(TabSys, "Anti-Admin", "Auto Kick if Staff", true, function(s) CONFIG.IsBypass = s end)

local TabInfo = CreateTab("Info")
CreateButton(TabInfo, "Owner: ZAYANGGGGG", function() end)
CreateButton(TabInfo, "Game: Fish It Modded", function() end)

-- [[ FISH IT: AUTO FISH LOGIC (TAP > CHARGE > REEL) ]]
task.spawn(function()
    while true do task.wait(0.1)
        if CONFIG.FT_AutoFish and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool then
                if not Tool:FindFirstChild("bobber") then
                    -- FASE 1: CAST (LEMPAR)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    task.wait(0.8) -- Charge Perfect
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    task.wait(2.5) -- Wait Bait
                else
                    -- FASE 2: REEL (TARIK CEPAT)
                    for i = 1, 10 do
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                        task.wait(0.01)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    end
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- [[ 10x SPEED ]]
task.spawn(function()
    while true do task.wait(0.5)
        if CONFIG.FT_Legit10x then pcall(function() Workspace.Gravity = 50 end) 
        else Workspace.Gravity = 196.2 end
    end
end)

-- [[ 200X LUCK ]]
task.spawn(function()
    while true do task.wait(2)
        if CONFIG.FT_Luck200x then
            local RS = game:GetService("ReplicatedStorage")
            local Evt = RS:FindFirstChild("LuckEvent") or RS:FindFirstChild("Events") and RS.Events:FindFirstChild("Luck")
            if Evt then pcall(function() Evt:FireServer(200) end) end
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

-- [[ ANTI AFK ]]
LocalPlayer.Idled:Connect(function()
    if CONFIG.IsAntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end
end)

-- [[ FULLBRIGHT ]]
task.spawn(function()
    while true do task.wait(1)
        if CONFIG.IsFullBright then Lighting.ClockTime = 12; Lighting.Brightness = 2; Lighting.GlobalShadows = false end
    end
end)

-- Final Load
task.spawn(function()
    task.wait(2.2) -- Tunggu loading bar
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 550, 0, 350)}):Play()
end)
