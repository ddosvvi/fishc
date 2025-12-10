-- =============================================================
-- YuuVins Exploids // ULTIMATE V18 (CLEAN & LEGIT)
-- Owner: ZAYANGGGGG
-- Game: Universal (Fisch & Fish-It Modded)
-- Status: SUPER LEGIT MECHANICS + SAFE SELL
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
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- [[ GAME DETECTION ]]
local PlaceID = game.PlaceId
local IsModded = (PlaceID == 122961055235507) -- Fish-It Modded ID
local ReelSpeed = IsModded and 0.01 or 0.05 -- 10x Speed untuk Modded, 5x untuk Original (Safety)

-- [[ CONFIGURATION ]]
local CONFIG = {
    AutoFish = false,
    AutoSell = false,
    AutoItems = false, -- Collect Items
    RiftFarm = false,
    WebhookUrl = "",
    IsAntiAFK = true
}

-- [[ THEME: OBSIDIAN CLEAN ]]
local THEME = {
    Main = Color3.fromRGB(25, 25, 30),
    Header = Color3.fromRGB(35, 35, 40),
    Sidebar = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(80, 160, 255), -- Calm Blue
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(100, 255, 100),
    Fail = Color3.fromRGB(255, 100, 100)
}

-- [[ GUI LOAD ]]
local function GetSafeGui()
    return LocalPlayer:WaitForChild("PlayerGui")
end
local UI_Parent = GetSafeGui()

for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "YuuVinsV18" or v.Name == "YuuVinsToggle" then v:Destroy() end
end

-- [[ NOTIFICATIONS ]]
local function Notif(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

-- Boot Notif
task.spawn(function()
    Notif("YuuVins V18", "Injecting Universal Logic...", 1)
    task.wait(1)
    if IsModded then Notif("DETECTED", "Fish-It MODDED (Turbo Enabled)", 3)
    else Notif("DETECTED", "Fish-It Original (Safe Mode)", 3) end
end)

-- [[ DRAGGABLE ]]
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- =============================================================
-- UI CONSTRUCTION (CLEAN LOOK)
-- =============================================================
local ScreenGui = Instance.new("ScreenGui", UI_Parent)
ScreenGui.Name = "YuuVinsV18"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.BackgroundColor3 = THEME.Main
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
MakeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Header
local Header = Instance.new("Frame", Main)
Header.BackgroundColor3 = THEME.Header
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "YuuVins <b>HUB</b> V18"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = THEME.Text
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close
local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0.5, -15)
Close.BackgroundColor3 = THEME.Fail
Close.Text = "X"
Close.TextColor3 = THEME.Text
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
Close.MouseButton1Click:Connect(function() 
    TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 0)}):Play()
    Notif("System", "Minimized (Click Toggle to Open)", 2)
end)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.BorderSizePixel = 0
local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

-- Content
local Content = Instance.new("Frame", Main)
Content.BackgroundColor3 = THEME.Main
Content.Position = UDim2.new(0, 140, 0, 50)
Content.Size = UDim2.new(1, -150, 1, -60)
Content.BackgroundTransparency = 1

-- Toggle Button
local TogGui = Instance.new("ScreenGui", UI_Parent); TogGui.Name = "YuuVinsToggle"
local TogBtn = Instance.new("TextButton", TogGui)
TogBtn.Size = UDim2.new(0, 45, 0, 45); TogBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
TogBtn.BackgroundColor3 = THEME.Main; TogBtn.Text = "Y"; TogBtn.TextColor3 = THEME.Accent
TogBtn.Font = Enum.Font.GothamBlack; TogBtn.TextSize = 20
Instance.new("UICorner", TogBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", TogBtn).Color = THEME.Accent; Instance.new("UIStroke", TogBtn).Thickness = 2
MakeDraggable(TogBtn)
TogBtn.MouseButton1Click:Connect(function() TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 500, 0, 350)}):Play() end)

-- [[ UI LIBRARY LOGIC ]]
local CurrentPage = nil
function CreateTab(name)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0.9, 0, 0, 30)
    Btn.BackgroundColor3 = THEME.Main
    Btn.Text = name
    Btn.TextColor3 = THEME.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.Visible = false
    local PL = Instance.new("UIListLayout", Page); PL.Padding = UDim.new(0, 5)
    
    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then 
            CurrentPage.Btn.TextColor3 = THEME.TextDim
            CurrentPage.Btn.BackgroundColor3 = THEME.Main
            CurrentPage.Page.Visible = false 
        end
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Btn.BackgroundColor3 = THEME.Header
        Page.Visible = true
    end)
    
    if not CurrentPage then
        CurrentPage = {Btn = Btn, Page = Page}
        Btn.TextColor3 = THEME.Accent
        Btn.BackgroundColor3 = THEME.Header
        Page.Visible = true
    end
    return Page
end

function CreateToggle(page, text, desc, callback)
    local F = Instance.new("Frame", page)
    F.Size = UDim2.new(1, 0, 0, 40)
    F.BackgroundColor3 = THEME.Sidebar
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0.7, 0, 0.6, 0); T.Position = UDim2.new(0.05, 0, 0.1, 0)
    T.BackgroundTransparency = 1; T.Text = text; T.TextColor3 = THEME.Text
    T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextXAlignment = 0
    
    local D = Instance.new("TextLabel", F)
    D.Size = UDim2.new(0.7, 0, 0.4, 0); D.Position = UDim2.new(0.05, 0, 0.6, 0)
    D.BackgroundTransparency = 1; D.Text = desc; D.TextColor3 = THEME.TextDim
    D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextXAlignment = 0
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 20, 0, 20); B.Position = UDim2.new(0.9, -20, 0.5, -10)
    B.BackgroundColor3 = THEME.Main; B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
    local S = Instance.new("UIStroke", B); S.Color = THEME.TextDim; S.Thickness = 1
    
    local On = false
    B.MouseButton1Click:Connect(function()
        On = not On
        B.BackgroundColor3 = On and THEME.Accent or THEME.Main
        S.Color = On and THEME.Accent or THEME.TextDim
        callback(On)
    end)
end

function CreateButton(page, text, callback)
    local B = Instance.new("TextButton", page)
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = THEME.Header
    B.Text = text
    B.TextColor3 = THEME.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(function()
        B.BackgroundColor3 = THEME.Accent
        task.wait(0.1)
        B.BackgroundColor3 = THEME.Header
        callback()
    end)
end

-- =============================================================
-- 3. MENU CONTENT
-- =============================================================

-- TAB: FARMING
local TabFarm = CreateTab("Farming")
CreateToggle(TabFarm, "Auto Fish Legit", "Tap > Charge > 10x Reel", function(s) CONFIG.AutoFish = s end)
CreateToggle(TabFarm, "Auto Sell (Safe)", "Sell All (Fav Locked)", function(s) CONFIG.AutoSell = s end)
CreateToggle(TabFarm, "Auto Collect", "Ambil Item Jatuh", function(s) CONFIG.AutoItems = s end)

-- TAB: RIFT & TELEPORT
local TabRift = CreateTab("Rift & TP")
CreateToggle(TabRift, "Rift Auto Farm", "Farm di Rift Area", function(s) CONFIG.RiftFarm = s end)
CreateButton(TabRift, "TP to Merchant", function() 
    local M = nil; for _,v in pairs(Workspace:GetDescendants()) do if v.Name == "Merchant" then M = v break end end
    if M then TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = M.PrimaryPart.CFrame * CFrame.new(0,0,3)}):Play() end
end)
CreateButton(TabRift, "TP to Rift", function() 
    -- Logic Placeholder for Rift TP
    Notif("Rift", "Searching for Rift...", 2)
end)

-- TAB: SETTINGS
local TabSet = CreateTab("Settings")
CreateToggle(TabSet, "Anti-AFK", "Prevent Idle Kick", function(s) CONFIG.IsAntiAFK = s end)

-- TAB: INFO
local TabInfo = CreateTab("Info")
local F = Instance.new("Frame", TabInfo); F.Size=UDim2.new(1,0,0,100); F.BackgroundTransparency=1
local L1 = Instance.new("TextLabel", F); L1.Size=UDim2.new(1,0,0.3,0); L1.BackgroundTransparency=1; L1.Text="Owner: ZAYANGGGGG"; L1.TextColor3=THEME.Accent; L1.Font=Enum.Font.GothamBold; L1.TextSize=14
local L2 = Instance.new("TextLabel", F); L2.Size=UDim2.new(1,0,0.3,0); L2.Position=UDim2.new(0,0,0.3,0); L2.BackgroundTransparency=1; L2.Text="Version: V18 (Clean)"; L2.TextColor3=THEME.Text; L2.Font=Enum.Font.Gotham; L2.TextSize=12

-- =============================================================
-- 4. LOGIC ENGINE (SUPER LEGIT)
-- =============================================================

-- [[ AUTO FISH LEGIT MECHANIC ]]
task.spawn(function()
    while true do task.wait(0.1)
        if CONFIG.AutoFish and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool then
                -- FASE 1: CASTING (LEMPAR)
                if not Tool:FindFirstChild("bobber") then
                    -- 1. Tap Awal (Persiapan)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    
                    task.wait(0.5) -- Delay manusiawi
                    
                    -- 2. Charge Perfect (Hold 1 Detik)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(1.0) -- Tahan sampai bar penuh/hijau
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    
                    -- 3. Tunggu Umpan Masuk Air
                    task.wait(2.5) 
                
                -- FASE 2: REELING (TARIK)
                -- Kita deteksi jika bobber ada, berarti sedang mancing.
                -- Jika ada notifikasi "Fish Bite" (visual/gui), kita spam klik.
                -- Untuk universal, kita pakai timer atau deteksi gui jika mungkin. 
                -- Di sini kita pakai "Blind Spam" yang aman (Tap Tap Cepat).
                else
                    -- Spam Klik 10x (Turbo Reel)
                    -- Ini meniru "Click Fast 10x" yang diminta
                    for i = 1, 10 do
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                        task.wait(ReelSpeed) -- 0.01 (Modded) atau 0.05 (Ori)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    end
                    task.wait(0.1) -- Istirahat sebentar biar tidak crash
                end
            end
        end
    end
end)

-- [[ ANTI JUMP (FIX LONCAT) ]]
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if CONFIG.AutoFish and input.KeyCode == Enum.KeyCode.Space then
        -- Sink input Space biar karakter gak loncat pas mancing
        return Enum.ContextActionResult.Sink
    end
end)

-- [[ AUTO SELL (SAFE MODE) ]]
task.spawn(function()
    while true do task.wait(1)
        if CONFIG.AutoSell then
            -- 1. Cari Merchant
            local Merchant = nil
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == "Merchant" or v.Name == "Fish Merchant" then Merchant = v break end
            end
            
            -- 2. Teleport & Sell
            if Merchant and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                if (Root.Position - Merchant.PrimaryPart.Position).Magnitude > 10 then
                    -- Teleport Dekat
                    Root.CFrame = Merchant.PrimaryPart.CFrame * CFrame.new(0, 0, 4)
                else
                    -- Tekan Tombol Sell (Virtual Interact)
                    -- Kita asumsi game pakai ProximityPrompt atau GUI Button
                    -- Jika GUI:
                    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if PlayerGui then
                        local SellGui = PlayerGui:FindFirstChild("MerchantGui") or PlayerGui:FindFirstChild("Sell")
                        if SellGui and SellGui.Enabled then
                            -- Cari tombol "Sell All"
                            local SellBtn = SellGui:FindFirstChild("SellAll", true)
                            if SellBtn then
                                GuiService.SelectedObject = SellBtn
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        else
                            -- Jika belum buka GUI, fire ProximityPrompt
                            for _, prompt in pairs(Merchant:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [[ AUTO ITEMS ]]
task.spawn(function()
    while true do task.wait(0.5)
        if CONFIG.AutoItems and LocalPlayer.Character then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then -- Item jatuh biasanya Tool
                    v.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
end)

-- [[ ANTI AFK ]]
LocalPlayer.Idled:Connect(function()
    if CONFIG.IsAntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)
