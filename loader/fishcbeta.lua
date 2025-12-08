-- =============================================================
-- YuuVins Exploids // PREMIUM ULTIMATE V5
-- Owner: ZAYANGGGGG (ID: 1398015808)
-- Website: www.YuuVins.online
-- Theme: Alchemy Style (Blue Glow)
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
local Camera = workspace.CurrentCamera

-- [[ KONFIGURASI GLOBAL ]]
local CONFIG = {
    IsAutoFish = false,
    IsInstantFish = false, -- Fast Reel
    IsInfiniteFish = false, -- Fast Recovery
    IsAutoSell = false,    -- Teleport Toggle
    IsESP = false,
    IsAntiAFK = false,
    IsBypass = true,
    
    SavedPosition = nil,   -- Menyimpan lokasi mancing
    FlySpeed = 250,        -- Kecepatan Teleport
    TargetGroupId = 7381705,
    Blacklist = {"Trial Tester", "Trial Mod", "Moderator", "Senior Mod", "Admin", "Developer", "Creator"}
}

-- [[ THEME PRESETS ]]
local THEME = {
    Bg = Color3.fromRGB(15, 15, 25),
    Sidebar = Color3.fromRGB(20, 20, 35),
    Item = Color3.fromRGB(25, 25, 45),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(0, 210, 255), -- YuuVins Blue Neon
    Glow = Color3.fromRGB(0, 150, 255),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(60, 255, 100)
}

-- [[ SAFETY GUI PARENT ]]
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
-- 1. NOTIFIKASI PREMIUM
-- =============================================================
task.spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "YuuVins Exploids",
        Text = "Authenticating Premium Key...",
        Duration = 2,
        Icon = "rbxassetid://16369066601"
    })
    task.wait(2)
    StarterGui:SetCore("SendNotification", {
        Title = "WELCOME OWNER",
        Text = "Logged in as: ZAYANGGGGG",
        Duration = 5,
    })
end)

-- =============================================================
-- 2. UI CONSTRUCTION (ALCHEMY STYLE)
-- =============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuuVinsExploidsUI"
ScreenGui.Parent = UI_Parent
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Glow Border (Blue)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Color = THEME.Glow
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Sidebar (Left)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Logo / Title
local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.BackgroundTransparency = 1
Logo.Text = "YuuVins\nExploids"
Logo.Font = Enum.Font.GothamBlack
Logo.TextColor3 = THEME.Accent
Logo.TextSize = 18
Logo.TextYAlignment = Enum.TextYAlignment.Center

-- Content Area (Right)
local Content = Instance.new("Frame", MainFrame)
Content.BackgroundColor3 = THEME.Bg
Content.Position = UDim2.new(0, 150, 0, 10)
Content.Size = UDim2.new(1, -160, 1, -20)
Content.BackgroundTransparency = 1

-- [[ TAB SYSTEM ]]
local Tabs = {}
local CurrentPage = nil

function CreateTabBtn(text, iconID)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Position = UDim2.new(0, 10, 0, 0)
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
    
    -- Padding Top for list
    if not Sidebar:FindFirstChild("UIPadding") then
        local p = Instance.new("UIPadding", Sidebar)
        p.PaddingTop = UDim.new(0, 60)
    end

    -- Tab Page
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.Visible = false
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding = UDim.new(0, 8)
    PL.SortOrder = Enum.SortOrder.LayoutOrder

    -- Logic
    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then
            CurrentPage.Btn.TextColor3 = Color3.fromRGB(150,150,150)
            CurrentPage.Page.Visible = false
        end
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Page.Visible = true
    end)
    
    -- Select first tab
    if CurrentPage == nil then
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Page.Visible = true
    end
    
    return Page
end

-- [[ ELEMENT CREATOR ]]
function CreateToggle(parent, title, desc, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = THEME.Item
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local TTitle = Instance.new("TextLabel", Frame)
    TTitle.Size = UDim2.new(1, -60, 0, 25)
    TTitle.Position = UDim2.new(0, 10, 0, 2)
    TTitle.BackgroundTransparency = 1
    TTitle.Text = title
    TTitle.TextColor3 = THEME.Text
    TTitle.Font = Enum.Font.GothamBold
    TTitle.TextSize = 13
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local TDesc = Instance.new("TextLabel", Frame)
    TDesc.Size = UDim2.new(1, -60, 0, 15)
    TDesc.Position = UDim2.new(0, 10, 0, 25)
    TDesc.BackgroundTransparency = 1
    TDesc.Text = desc
    TDesc.TextColor3 = Color3.fromRGB(150,150,150)
    TDesc.Font = Enum.Font.Gotham
    TDesc.TextSize = 10
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton", Frame)
    ToggleBtn.Size = UDim2.new(0, 20, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -30, 0.5, -10)
    ToggleBtn.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(50,50,60)
    ToggleBtn.Text = ""
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        default = not default
        ToggleBtn.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(50,50,60)
        callback(default)
    end)
end

function CreateInfo(parent, txt)
    local L = Instance.new("TextLabel", parent)
    L.Size = UDim2.new(1, -5, 0, 25)
    L.BackgroundColor3 = THEME.Item
    L.Text = "  " .. txt
    L.TextColor3 = THEME.Accent
    L.Font = Enum.Font.Code
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", L).CornerRadius = UDim.new(0, 6)
end

-- =============================================================
-- 3. MENU SETUP
-- =============================================================

-- TAB 1: AUTO MANCING
local TabFish = CreateTabBtn("Auto Mancing")
CreateToggle(TabFish, "Auto Fish V3", "Auto Cast + Shake + Perfect Reel", false, function(s) CONFIG.IsAutoFish = s end)
CreateToggle(TabFish, "Instant Fish", "Reel super cepat (Legit Mode)", false, function(s) CONFIG.IsInstantFish = s end)
CreateToggle(TabFish, "Infinite Fish", "Spam cast tanpa delay", false, function(s) CONFIG.IsInfiniteFish = s end)

-- TAB 2: AUTO SELL
local TabSell = CreateTabBtn("Auto Sell")
CreateToggle(TabSell, "Teleport to Merchant", "ON = Pergi ke Merchant | OFF = Balik ke Awal", false, function(s) 
    CONFIG.IsAutoSell = s 
end)
CreateInfo(TabSell, "Note: Fitur ini tidak otomatis jual.")
CreateInfo(TabSell, "Hanya Teleport agar aman dari kick.")

-- TAB 3: SYSTEM
local TabSys = CreateTabBtn("System")
CreateToggle(TabSys, "Player ESP", "Wallhack nama & jarak player", false, function(s) CONFIG.IsESP = s end)
CreateToggle(TabSys, "Anti-AFK 24H", "Mencegah disconnect (Idle)", true, function(s) CONFIG.IsAntiAFK = s end)
CreateToggle(TabSys, "Bypass Anti-Admin", "Auto kick jika ada staff join", true, function(s) CONFIG.IsBypass = s end)

-- TAB 4: INFO
local TabInfo = CreateTabBtn("Info")
CreateInfo(TabInfo, "Owner: ZAYANGGGGG")
CreateInfo(TabInfo, "UID: 1398015808")
CreateInfo(TabInfo, "Web: www.YuuVins.online")
CreateInfo(TabInfo, "Executor: YuuVins Exploids Premium")

-- =============================================================
-- 4. LOGIC ENGINE
-- =============================================================

-- [[ AUTO FISHING ENGINE ]]
task.spawn(function()
    while true do
        task.wait(0.1)
        if CONFIG.IsAutoFish then
            local Char = LocalPlayer.Character
            if Char then
                local Tool = Char:FindFirstChildOfClass("Tool")
                
                -- 1. AUTO CAST (Lempar)
                if Tool and not Tool:FindFirstChild("bobber") then
                    -- Cek cooldown infinite fish
                    if not CONFIG.IsInfiniteFish then task.wait(0.5) end
                    
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1)
                end
            end
        end
    end
end)

-- SHAKE & REEL HANDLER
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
                -- Logic Instant Fish (Speed Hack Reel)
                if CONFIG.IsInstantFish then
                    -- Logika agresif: Selalu tekan spasi
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                else
                    -- Logic Perfect Catch (Normal)
                    if Fish.Position.X.Scale > PlayerBar.Position.X.Scale then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    else
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end
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
    
    -- Noclip selama terbang
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

-- Teleport Manager Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        -- Logic Toggle
        if CONFIG.IsAutoSell then
            -- Jika belum simpan posisi, simpan dulu
            if not CONFIG.SavedPosition and LocalPlayer.Character then
                CONFIG.SavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
            
            -- Cek jarak ke Merchant, kalau jauh, terbang ke sana
            local Merch = FindMerchant()
            if Merch and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Dist = (Root.Position - Merch.HumanoidRootPart.Position).Magnitude
                
                if Dist > 10 then -- Kalau belum sampai
                    TweenMove(Merch.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                end
            end
        else
            -- Jika Toggle OFF dan ada Saved Position, balik ke awal
            if CONFIG.SavedPosition and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Dist = (Root.Position - CONFIG.SavedPosition.Position).Magnitude
                
                if Dist > 10 then
                    TweenMove(CONFIG.SavedPosition)
                    CONFIG.SavedPosition = nil -- Reset setelah sampai
                end
            end
        end
    end
end)

-- [[ SYSTEM: ESP & AFK & ADMIN ]]
task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        if CONFIG.IsAntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end)

local ESPEngine = {Items = {}}
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESPEngine.Items[p] then
                local b = Instance.new("BillboardGui", CoreGui)
                b.Size = UDim2.new(0,200,0,50); b.AlwaysOnTop=true
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency=1
                t.Font=Enum.Font.Bold; t.TextSize=12
                local h = Instance.new("Highlight", CoreGui)
                h.FillTransparency=0.5
                ESPEngine.Items[p] = {b=b, t=t, h=h}
            end
            
            local data = ESPEngine.Items[p]
            if CONFIG.IsESP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                data.b.Enabled=true; data.h.Enabled=true
                data.b.Adornee = p.Character.HumanoidRootPart
                data.h.Adornee = p.Character
                local d = math.floor((p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
                data.t.Text = p.DisplayName.."\n["..d.."m]"
                
                if p.Team == LocalPlayer.Team then
                    data.t.TextColor3 = THEME.Green; data.h.FillColor = THEME.Green
                else
                    data.t.TextColor3 = THEME.Red; data.h.FillColor = THEME.Red
                end
            else
                data.b.Enabled=false; data.h.Enabled=false
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
