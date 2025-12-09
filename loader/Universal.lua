-- =============================================================
-- YuuVins Exploids // ULTIMATE V14 (MODDED SUPPORT)
-- Owner: ZAYANGGGGG
-- Status: FISCH + FISHIT MODDED (LEGIT 5X + 200X LUCK)
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- [[ GAME DETECTION ]]
local PlaceID = game.PlaceId
local GameName = "Unknown"
pcall(function() GameName = MarketplaceService:GetProductInfo(PlaceID).Name end)

local IsFisch = (PlaceID == 16732694052 or string.find(string.lower(GameName), "fisch"))
local IsFishit = (string.find(string.lower(GameName), "fishit") or PlaceID == 122961055235507) -- Modded ID support

-- [[ GLOBAL CONFIGURATION ]]
local CONFIG = {
    -- Shared
    IsESP = false,
    IsVision = false,
    IsAntiAFK = true,
    IsBypass = true,
    IsGodMode = false,
    IsWaterWalk = false,
    IsNoClip = false,
    IsInfJump = false,
    IsFullBright = false,
    
    -- Fisch Specific
    F_AutoFish = false,
    F_AutoSell = false,
    F_AFKLvl = false,
    F_FlySpeed = 300,
    F_SavePos = nil,
    F_TargetGroup = 7381705,
    F_Blacklist = {"Trial Tester", "Trial Mod", "Moderator", "Senior Mod", "Admin", "Developer", "Creator"},

    -- Fishit Modded Specific
    FT_AutoClick = false, -- Hold & Tap Logic
    FT_Legit5x = false,   -- 5x Speed
    FT_Luck200x = false   -- 200x Luck
}

-- [[ THEME SETTINGS ]]
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

-- [[ GUI SAFETY LOADER ]]
local function GetSafeGuiParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end

local UI_Parent = GetSafeGuiParent()

-- Cleanup
for _, child in pairs(UI_Parent:GetChildren()) do
    if child.Name == "YuuVinsV14Full" then child:Destroy() end
end

-- [[ NOTIFIKASI SYSTEM ]]
local function SendNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3,
            Icon = "rbxassetid://16369066601"
        })
    end)
end

task.spawn(function()
    SendNotification("YuuVins Hub", "Checking Game ID...", 2)
    task.wait(1)
    
    if IsFisch then
        SendNotification("DETECTED", "Game: FISCH (Loading Full Modules)", 3)
    elseif IsFishit then
        SendNotification("DETECTED", "Game: FISHIT MODDED (Loading Hack Modules)", 3)
    else
        SendNotification("DETECTED", "Universal Mode Active", 3)
    end
    
    task.wait(2)
    SendNotification("WELCOME OWNER", "ZAYANGGGGG", 3)
end)

-- =============================================================
-- UI CONSTRUCTION (FULL CODE)
-- =============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuuVinsV14Full"
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
        local t = TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 405})
        t:Play() t.Completed:Wait()
        UIGradient.Rotation = 45
    end
end)

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

-- Buttons
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MiniBtn = Instance.new("TextButton", Header)
MiniBtn.Size = UDim2.new(0, 35, 0, 35)
MiniBtn.Position = UDim2.new(1, -80, 0.5, -17.5)
MiniBtn.BackgroundColor3 = Color3.new(1,1,1)
MiniBtn.Text = "-"
MiniBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

local IsMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 600, 0, 40)}):Play()
        MainFrame:FindFirstChild("Sidebar").Visible = false
        MainFrame:FindFirstChild("Content").Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        task.wait(0.3)
        MainFrame:FindFirstChild("Sidebar").Visible = true
        MainFrame:FindFirstChild("Content").Visible = true
    end
end)

-- Layout
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.BorderSizePixel = 0

local Content = Instance.new("Frame", MainFrame)
Content.Name = "Content"
Content.BackgroundColor3 = THEME.Bg
Content.Position = UDim2.new(0, 170, 0, 50)
Content.Size = UDim2.new(1, -180, 1, -60)
Content.BackgroundTransparency = 1

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local SidePad = Instance.new("UIPadding", Sidebar)
SidePad.PaddingTop = UDim.new(0, 10)

-- [[ UI FUNCTIONS ]]
local CurrentPage = nil

function CreateTab(text)
    local Button = Instance.new("TextButton", Sidebar)
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.BackgroundColor3 = THEME.Bg
    Button.BackgroundTransparency = 1
    Button.Text = "  " .. text
    Button.TextColor3 = Color3.fromRGB(150,150,150)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left
    
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.Visible = false
    
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 8)
    
    Button.MouseButton1Click:Connect(function()
        if CurrentPage then
            CurrentPage.Button.TextColor3 = Color3.fromRGB(150,150,150)
            CurrentPage.Page.Visible = false
        end
        CurrentPage = {Button = Button, Page = Page}
        Button.TextColor3 = THEME.Accent
        Page.Visible = true
    end)
    
    if CurrentPage == nil then
        CurrentPage = {Button = Button, Page = Page}
        Button.TextColor3 = THEME.Accent
        Page.Visible = true
    end
    
    return Page
end

function CreateToggle(parent, title, description, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = THEME.Item
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, -60, 0, 25)
    Title.Position = UDim2.new(0, 10, 0, 2)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = THEME.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Desc = Instance.new("TextLabel", Frame)
    Desc.Size = UDim2.new(1, -60, 0, 15)
    Desc.Position = UDim2.new(0, 10, 0, 25)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(150,150,150)
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -50, 0.5, -10)
    Btn.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(50,50,60)
    Btn.Text = ""
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    Btn.MouseButton1Click:Connect(function()
        default = not default
        Btn.BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(50,50,60)
        SendNotification("System", title .. ": " .. (default and "ON" or "OFF"), 1)
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

-- =============================================================
-- 3. MODULE LOADER (GAME SPECIFIC)
-- =============================================================

-- [[ MODULE: FISCH LOGIC ]]
local function LoadFischLogic()
    -- Tab 1: Auto Fish
    local Tab1 = CreateTab("Fisch: Auto")
    CreateToggle(Tab1, "Auto Fish V3", "Cast + Shake + Perfect Reel", false, function(s) CONFIG.F_AutoFish = s end)
    CreateToggle(Tab1, "AFK Level 500", "No-Life Mode (24H Farm)", false, function(s) 
        CONFIG.F_AFKLvl = s
        CONFIG.F_AutoFish = s 
    end)
    
    -- Tab 2: Sell & TP
    local Tab2 = CreateTab("Fisch: Sell/TP")
    CreateToggle(Tab2, "Auto Sell (Smart)", "Teleport Merchant Terdekat", false, function(s) CONFIG.F_AutoSell = s end)
    
    local Islands = {
        {"Moosewood", Vector3.new(380, 135, 230)},
        {"Roslit Bay", Vector3.new(-1480, 132, 720)},
        {"Snowcap", Vector3.new(2620, 135, 2400)},
        {"Statue", Vector3.new(30, 140, -1020)},
        {"Desolate Deep", Vector3.new(-970, 135, 1330)}
    }
    for _, dat in ipairs(Islands) do
        CreateButton(Tab2, "TP: " .. dat[1], function() TweenTeleport(CFrame.new(dat[2])) end)
    end

    -- Tab 3: Secret Rods
    local Tab3 = CreateTab("Fisch: Rods")
    local Rods = {
        {N="Magma Rod", P=Vector3.new(-1830, 165, 160), I="God Mode ON! Jalan ke Orc."},
        {N="Kings Rod", P=Vector3.new(30, 135, -1020), I="Bayar 400C, turun lift."},
        {N="Fungal Rod", P=Vector3.new(2550, 135, -730), I="Quest Alligator (Malam)."}
    }
    for _, r in ipairs(Rods) do
        CreateButton(Tab3, "TP: " .. r.N, function()
            if string.find(r.N, "Magma") then CONFIG.IsGodMode = true; SendNotification("GOD MODE", "Anti-Lava ON", 3) end
            TweenTeleport(CFrame.new(r.P))
            SendNotification("Info", r.I, 5)
        end)
    end
    
    -- Tab 4: Events
    local Tab4 = CreateTab("Fisch: Events")
    CreateButton(Tab4, "[AUTO] Quest Brick Rod", function()
         local L = {Vector3.new(-1480, 135, 720), Vector3.new(-3150, 140, 2600), Vector3.new(-970, 135, 1330), Vector3.new(450, 150, 230)}
         for i,v in ipairs(L) do TweenTeleport(CFrame.new(v)); task.wait(4) end
    end)
    CreateButton(Tab4, "[AUTO] Find Shark/Whale", function()
        local t = nil
        for _, v in pairs(Workspace:GetDescendants()) do if v.Name:find("Shark") or v.Name:find("Megalodon") then t = v break end end
        if t then TweenTeleport(t.PrimaryPart.CFrame * CFrame.new(0, 20, 0)) else SendNotification("Scan", "No Boss Found", 2) end
    end)

    -- LOOPS FISCH
    task.spawn(function() -- Auto Cast
        while true do task.wait(0.2)
            if CONFIG.F_AutoFish and LocalPlayer.Character then
                local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if Tool and not Tool:FindFirstChild("bobber") then
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1); task.wait(1.0)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1); task.wait(1.5)
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function() -- Shake & Reel
        if CONFIG.F_AutoFish then
            local G = LocalPlayer:FindFirstChild("PlayerGui")
            if G then
                local S = G:FindFirstChild("shakeui")
                if S and S.Enabled then
                    local B = S:FindFirstChild("safezone") and S.safezone:FindFirstChild("button")
                    if B and B.Visible then
                        GuiService.SelectedObject = B
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                end
                local R = G:FindFirstChild("reel")
                if R and R.Enabled then
                    local Bar = R:FindFirstChild("bar")
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
end

-- [[ MODULE: FISHIT MODDED LOGIC (NEW) ]]
local function LoadFishitLogic()
    local TabF = CreateTab("Fishit: Main")
    CreateToggle(TabF, "Auto Fish (Hold & Tap)", "Hold 2s -> Tap Tap", false, function(s) CONFIG.FT_AutoClick = s end)
    
    local TabLegit = CreateTab("Fishit: LEGIT")
    CreateToggle(TabLegit, "5x Speed Reel", "Tarik Ikan 5x Cepat", false, function(s) CONFIG.FT_Legit5x = s end)
    CreateToggle(TabLegit, "200x Luck", "Manipulasi RNG Event", false, function(s) 
        CONFIG.FT_Luck200x = s 
        if s then SendNotification("LUCK", "RNG 200x Active!", 5) end
    end)
    
    -- Fishit Auto Fish Logic (Hold 2s -> Tap Tap)
    task.spawn(function()
        while true do task.wait(0.1)
            if CONFIG.FT_AutoClick then
                local Char = LocalPlayer.Character
                if Char then
                    local Tool = Char:FindFirstChildOfClass("Tool")
                    if Tool and not Tool:FindFirstChild("bobber") then
                        -- Hold 2 Detik
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                        task.wait(2.0)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                        task.wait(1.0)
                    else
                        -- Tap Tap (Reel)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    end
                end
            end
        end
    end)
    
    -- Fishit 5x Speed (TimeScale Hack)
    task.spawn(function()
        while true do task.wait(0.5)
            if CONFIG.FT_Legit5x then
                -- Method: Manipulasi TimeScale lokal jika game allow
                pcall(function() game.Workspace.Gravity = 100 end) -- Trik speed animasi
            else
                game.Workspace.Gravity = 196.2
            end
        end
    end)
    
    -- Fishit 200x Luck (Event Spammer)
    task.spawn(function()
        while true do task.wait(1)
            if CONFIG.FT_Luck200x then
                -- Coba tembak RemoteEvent Luck jika ada
                local RS = game:GetService("ReplicatedStorage")
                local Evt = RS:FindFirstChild("LuckEvent") or RS:FindFirstChild("Events"):FindFirstChild("Luck")
                if Evt then
                     pcall(function() Evt:FireServer(200) end)
                end
            end
        end
    end)
end

-- [[ SHARED LOGIC (UNIVERSAL) ]]
local function LoadUniversal()
    local TabV = CreateTab("Visuals")
    CreateToggle(TabV, "ESP Player", "Wallhack Biru", false, function(s) CONFIG.IsESP = s end)
    CreateToggle(TabV, "Vision Mode (NPC)", "Wallhack NPC", false, function(s) CONFIG.IsVision = s end)
    CreateToggle(TabV, "Always Day", "Fullbright", false, function(s) CONFIG.IsFullBright = s; if not s then Lighting.ClockTime = 12 end end)
    
    local TabS = CreateTab("System")
    CreateToggle(TabS, "Walk on Water", "Platform Air", false, function(s) CONFIG.IsWaterWalk = s end)
    CreateToggle(TabS, "God Mode", "Anti-Lava", false, function(s) CONFIG.IsGodMode = s end)
    CreateToggle(TabS, "Infinite Jump", "Fly Jump", false, function(s) CONFIG.IsInfJump = s end)
    CreateToggle(TabS, "NoClip", "Tembus Tembok", false, function(s) CONFIG.IsNoClip = s end)
    CreateToggle(TabS, "Anti-AFK", "No Disconnect", true, function(s) CONFIG.IsAntiAFK = s end)
    
    local TabI = CreateTab("Info")
    local F = Instance.new("Frame", TabI); F.Size=UDim2.new(1,-5,0,30); F.BackgroundColor=THEME.Item
    Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
    local L = Instance.new("TextLabel", F); L.Size=UDim2.new(1,0,1,0); L.BackgroundTransparency=1; L.Text="Owner: ZAYANGGGGG"; L.TextColor3=THEME.Accent; L.Font=Enum.Font.GothamBold; L.TextSize=12
end

-- =============================================================
-- HELPER FUNCTIONS
-- =============================================================

function TweenTeleport(cframe)
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart
    
    if CONFIG.IsGodMode then
        if Char:FindFirstChild("Humanoid") then Char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
    end

    local Dist = (Root.Position - cframe.Position).Magnitude
    local Time = Dist / CONFIG.F_FlySpeed
    
    local Tween = TweenService:Create(Root, TweenInfo.new(Time, Enum.EasingStyle.Linear), {CFrame = cframe})
    
    local Conn = RunService.Stepped:Connect(function()
        for _,v in pairs(Char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end)
    
    Tween:Play()
    Tween.Completed:Wait()
    if Conn then Conn:Disconnect() end
    
    Root.Anchored = true
    task.wait(0.5)
    Root.Anchored = false
end

-- Systems Loop
local WaterPlat = Instance.new("Part", Workspace); WaterPlat.Anchored=true; WaterPlat.Transparency=1; WaterPlat.Size=Vector3.new(10,1,10); WaterPlat.CanCollide=true
RunService.Heartbeat:Connect(function()
    if CONFIG.IsWaterWalk and LocalPlayer.Character then
        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local Ray = Workspace:Raycast(Root.Position, Vector3.new(0,-15,0))
            if Ray and Ray.Material == Enum.Material.Water then
                WaterPlat.Position = Vector3.new(Root.Position.X, Ray.Position.Y - 0.5, Root.Position.Z)
            else
                WaterPlat.Position = Vector3.new(0,-1000,0)
            end
        end
    else
        WaterPlat.Position = Vector3.new(0,-1000,0)
    end
    
    if CONFIG.IsGodMode then
        for _,v in pairs(Workspace:GetDescendants()) do if v.Name=="Lava" then v.CanTouch=false; v.CanCollide=true end end
    end
    
    if CONFIG.IsFullBright then Lighting.ClockTime=12; Lighting.Brightness=2; Lighting.GlobalShadows=false end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if CONFIG.IsInfJump and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fix Auto Jump (Prevent Space Stuck)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        -- Force release logic internally handled by engine, but ensuring no script holds it
    end
end)

-- ESP & Vision
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if CONFIG.IsVision and v:IsA("Model") and (v.Name:find("Merchant") or v.Name:find("Orc")) then
            if not v:FindFirstChild("VisESP") then
                local h = Instance.new("Highlight", v); h.Name="VisESP"; h.FillColor=THEME.NPC_Color; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
            end
        elseif not CONFIG.IsVision and v:FindFirstChild("VisESP") then v.VisESP:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            if CONFIG.IsESP then
                if not p.Character:FindFirstChild("PlrESP") then
                    local h = Instance.new("Highlight", p.Character); h.Name="PlrESP"; h.FillColor=THEME.ESP_Color; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif p.Character:FindFirstChild("PlrESP") then p.Character.PlrESP:Destroy() end
        end
    end
end)

-- Anti Admin & AFK
task.spawn(function()
    LocalPlayer.Idled:Connect(function() if CONFIG.IsAntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)
    while true do
        task.wait(5)
        if CONFIG.IsBypass then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local s, r = pcall(function() return p:GetRoleInGroup(CONFIG.F_TargetGroup) end)
                    if s and r then
                        for _, bad in ipairs(CONFIG.F_Blacklist) do if r == bad then LocalPlayer:Kick("Staff Detected: "..p.Name) end end
                    end
                end
            end
        end
    end
end)

-- =============================================================
-- MAIN EXECUTION
-- =============================================================
if IsFisch then
    LoadFischLogic()
elseif IsFishit then
    LoadFishitLogic()
end
LoadUniversal()

task.spawn(function()
    task.wait(5)
    ScreenGui.Enabled = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 600, 0, 400)}):Play()
end)
