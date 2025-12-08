-- =============================================================
-- CYBER-FISCH ULTIMATE V3.5 // BOS KEVIN EDITION
-- Theme: Cyberpunk Animated
-- Security: Role-Based Anti-Admin (Group ID: 7381705)
-- Features: Auto Fish, Auto Sell (NoClip Fly), Anti-AFK, ESP
-- =============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- [[ KONFIGURASI UTAMA ]]
local CONFIG = {
    MaxWeight = 5000,       -- Batas berat tas
    IsAutoShake = false,
    IsAutoSell = false,
    IsESPActive = false,
    IsAntiAdmin = true,     -- Default ON
    IsAntiAFK = true,       -- Default ON
    
    -- Konfigurasi Sell (Terbang)
    FlySpeed = 80,          -- Kecepatan terbang
    
    -- [[ SECURITY UPDATE: ROLE DETECTION ]]
    TargetGroupId = 7381705, -- ID Group Fisch Resmi
    BlacklistedRoles = {
        "Trial Tester",
        "Trial Mod",
        "Moderator",
        "Senior Mod",
        "Admin",
        "Developer",
        "Lead",
        "Creator"
    }
}

-- [[ UI VARIABLES ]]
local UI = {}
local GradientColor = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 255)), -- Cyan
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 0, 255)), -- Purple
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 80))   -- Red
}

-- Cleanup Old UI
if CoreGui:FindFirstChild("BosKevinUltimateV35") then
    CoreGui.BosKevinUltimateV35:Destroy()
end

-- =============================================================
-- 1. BUILD UI SYSTEM (CYBERPUNK THEME)
-- =============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BosKevinUltimateV35"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -200) 
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Animasi Start
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Border Gradient
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Transparency = 0

local UIGradient = Instance.new("UIGradient")
UIGradient.Parent = UIStroke
UIGradient.Color = GradientColor
UIGradient.Rotation = 45

task.spawn(function()
    while MainFrame.Parent do
        local tween = TweenService:Create(UIGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 225})
        tween:Play()
        tween.Completed:Wait()
        UIGradient.Rotation = 45
    end
end)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 10)
Title.Size = UDim2.new(0.6, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "CYBER-FISCH // V3.5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize & Close
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = MainFrame
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(0.75, 0, 0, 5)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 20

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.88, 0, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 18

-- Decoration Line
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BorderSizePixel = 0
Line.Position = UDim2.new(0, 0, 0.12, 0)
Line.Size = UDim2.new(1, 0, 0, 1)
local LineGrad = Instance.new("UIGradient")
LineGrad.Color = GradientColor
LineGrad.Parent = Line

-- Minimized Widget
local MiniFrame = Instance.new("TextButton") 
MiniFrame.Name = "MiniFrame"
MiniFrame.Parent = ScreenGui
MiniFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MiniFrame.Position = UDim2.new(1, -260, 0.9, 0) 
MiniFrame.Size = UDim2.new(0, 250, 0, 40)
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Visible = false 
MiniFrame.AutoButtonColor = false
MiniFrame.Active = true
MiniFrame.Draggable = true

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Parent = MiniFrame
MiniStroke.Thickness = 2
MiniStroke.Color = Color3.fromRGB(0, 255, 255)
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 6)
MiniCorner.Parent = MiniFrame
local MiniText = Instance.new("TextLabel")
MiniText.Parent = MiniFrame
MiniText.BackgroundTransparency = 1
MiniText.Size = UDim2.new(1, 0, 1, 0)
MiniText.Font = Enum.Font.GothamBold
MiniText.Text = "ULTIMATE V3.5 - BOS KEVIN"
MiniText.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniText.TextSize = 11

-- [[ HELPER: CREATE BUTTON ]]
function CreateCyberButton(parent, text, yPos, defaultState, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Position = UDim2.new(0.1, 0, yPos, 0)
    Btn.Size = UDim2.new(0.8, 0, 0.11, 0)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    Btn.TextSize = 11
    Btn.AutoButtonColor = false

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Parent = Btn
    BtnStroke.Thickness = 1
    BtnStroke.Color = defaultState and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 80)
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Status = Instance.new("Frame")
    Status.Parent = Btn
    Status.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 50)
    Status.Position = UDim2.new(0, 0, 0.9, 0)
    Status.Size = UDim2.new(1, 0, 0.1, 0)
    Status.BorderSizePixel = 0
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = Status

    local toggled = defaultState
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 255)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 255)}):Play()
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(60, 60, 80)}):Play()
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(toggled)
    end)
    return Btn
end

-- ANIMATION FUNCTIONS
function PlayIntro()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    UIStroke.Transparency = 1
    task.wait(0.2)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 400)}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
end
function MinimizeUI()
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.4) MainFrame.Visible = false
    MiniFrame.Size = UDim2.new(0, 0, 0, 40) MiniFrame.Visible = true
    TweenService:Create(MiniFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 40)}):Play()
end
function MaximizeUI()
    TweenService:Create(MiniFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 40)}):Play()
    task.wait(0.3) MiniFrame.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 400)}):Play()
end
MinBtn.MouseButton1Click:Connect(MinimizeUI)
MiniFrame.MouseButton1Click:Connect(MaximizeUI)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- =============================================================
-- 2. BUTTONS SETUP
-- =============================================================

CreateCyberButton(MainFrame, "ACTIVATE AUTO FISH", 0.18, CONFIG.IsAutoShake, function(state) CONFIG.IsAutoShake = state end)
CreateCyberButton(MainFrame, "AUTO SELL (NOCLIP FLY)", 0.32, CONFIG.IsAutoSell, function(state) CONFIG.IsAutoSell = state end)
CreateCyberButton(MainFrame, "PLAYER ESP [WALLHACK]", 0.46, CONFIG.IsESPActive, function(state) CONFIG.IsESPActive = state end)
CreateCyberButton(MainFrame, "ANTI-ADMIN [ROLE CHECK]", 0.60, CONFIG.IsAntiAdmin, function(state) CONFIG.IsAntiAdmin = state end)

-- WEIGHT INPUT
local InputBg = Instance.new("Frame")
InputBg.Parent = MainFrame
InputBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
InputBg.Position = UDim2.new(0.1, 0, 0.75, 0)
InputBg.Size = UDim2.new(0.8, 0, 0.08, 0)
local InputCorner = Instance.new("UICorner") InputCorner.CornerRadius = UDim.new(0, 6) InputCorner.Parent = InputBg
local InputBox = Instance.new("TextBox")
InputBox.Parent = InputBg
InputBox.Size = UDim2.new(1, 0, 1, 0)
InputBox.BackgroundTransparency = 1
InputBox.Font = Enum.Font.Gotham
InputBox.Text = tostring(CONFIG.MaxWeight)
InputBox.PlaceholderText = "MAX WEIGHT (KG)"
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextSize = 14
InputBox.FocusLost:Connect(function() local n = tonumber(InputBox.Text) if n then CONFIG.MaxWeight = n end end)

-- AFK STATUS INDICATOR
local AfkStatus = Instance.new("TextLabel")
AfkStatus.Parent = MainFrame
AfkStatus.BackgroundTransparency = 1
AfkStatus.Position = UDim2.new(0, 0, 0.86, 0)
AfkStatus.Size = UDim2.new(1, 0, 0, 20)
AfkStatus.Font = Enum.Font.GothamBold
AfkStatus.Text = "ANTI-AFK: ACTIVE (24H)"
AfkStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
AfkStatus.TextSize = 10

-- CREDIT
local Credit = Instance.new("TextLabel")
Credit.Parent = MainFrame
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 0, 0.94, 0)
Credit.Size = UDim2.new(1, 0, 0, 10)
Credit.Font = Enum.Font.Code
Credit.Text = "BOS KEVIN // ULTIMATE EDITION"
Credit.TextColor3 = Color3.fromRGB(100, 100, 100)
Credit.TextSize = 9

-- =============================================================
-- 3. SAFETY FEATURES (ANTI-ADMIN & ANTI-AFK)
-- =============================================================

-- [[ ANTI-AFK 24H ]]
task.spawn(function()
    local vu = VirtualUser
    LocalPlayer.Idled:Connect(function()
        if CONFIG.IsAntiAFK then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
            AfkStatus.Text = "ANTI-AFK: PREVENTED KICK!"
            task.wait(2)
            AfkStatus.Text = "ANTI-AFK: ACTIVE (24H)"
        end
    end)
end)

-- [[ ANTI-ADMIN DETECTOR (ROLE CHECK) ]]
local function CheckForAdmin(player)
    if not CONFIG.IsAntiAdmin then return end
    if player == LocalPlayer then return end

    -- Ambil Nama Role dari Group ID Fisch
    local success, roleName = pcall(function()
        return player:GetRoleInGroup(CONFIG.TargetGroupId)
    end)

    if success and roleName then
        -- Cek apakah role player ada di daftar Blacklist
        for _, blockedRole in ipairs(CONFIG.BlacklistedRoles) do
            if roleName == blockedRole then
                -- ALARM! ADMIN DETECTED
                LocalPlayer:Kick("\n[SECURITY SYSTEM]\nAdmin/Staff Detected!\nName: " .. player.Name .. "\nRole: " .. roleName .. "\nAction: Safety Kick Triggered.")
                return
            end
        end
    end
end

-- Scan Pemain Baru & Pemain Lama
Players.PlayerAdded:Connect(CheckForAdmin)
for _, p in pairs(Players:GetPlayers()) do CheckForAdmin(p) end

-- =============================================================
-- 4. SMART NOCLIP FLY (AUTO SELL)
-- =============================================================

local function TweenMove(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = character.HumanoidRootPart
    local dist = (root.Position - targetCFrame.Position).Magnitude
    local time = dist / CONFIG.FlySpeed -- Hitung waktu berdasarkan jarak & speed

    local tInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tInfo, {CFrame = targetCFrame})
    
    -- Aktifkan NoClip (Tembus Tembok) selama terbang
    local noclipConnection
    noclipConnection = RunService.Stepped:Connect(function()
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)

    tween:Play()
    tween.Completed:Wait()
    
    if noclipConnection then noclipConnection:Disconnect() end
end

local function FindMerchant()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "Merchant" or obj.Name == "Marc Merchant") then
            if obj:FindFirstChild("HumanoidRootPart") then return obj end
        end
    end
    return nil
end

local function GetCurrentWeight()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Visible and (string.find(gui.Text, "kg") or string.find(gui.Text, "/")) then
                 local current = gui.Text:match("^(%d+)")
                 if current then return tonumber(current) end
            end
        end
    end
    return 0
end

-- AUTO SELL LOOP
task.spawn(function()
    while true do
        task.wait(2)
        if CONFIG.IsAutoSell then
            local w = GetCurrentWeight()
            if w and w >= CONFIG.MaxWeight then
                local Char = LocalPlayer.Character
                local Merchant = FindMerchant()
                
                if Char and Merchant and Char:FindFirstChild("HumanoidRootPart") then
                    CONFIG.SavedPosition = Char.HumanoidRootPart.CFrame
                    
                    -- TERBANG KE MERCHANT (NOCLIP)
                    TweenMove(Merchant.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                    task.wait(0.5)
                    
                    -- JUAL
                    local prompt = Merchant:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(1)
                        local found = false
                        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                            if gui:IsA("TextButton") and gui.Visible and (string.find(string.lower(gui.Text), "sell")) then
                                for _, conn in pairs(getconnections(gui.MouseButton1Click)) do
                                    conn:Fire()
                                    found = true
                                end
                            end
                        end
                        if not found then 
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                        end
                        task.wait(2)
                    end
                    
                    -- TERBANG BALIK (NOCLIP)
                    if CONFIG.SavedPosition then TweenMove(CONFIG.SavedPosition) end
                end
            end
        end
    end
end)

-- =============================================================
-- 5. ESP & AUTO FISH ENGINE
-- =============================================================

RunService.Heartbeat:Connect(function()
    if not CONFIG.IsAutoShake then return end
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    
    local shakeUI = PlayerGui:FindFirstChild("shakeui")
    if shakeUI and shakeUI.Enabled then
        pcall(function()
            local btn = shakeUI.safezone.button
            if btn.Visible then
                GuiService.SelectedObject = btn
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end)
    end
    
    local reelUI = PlayerGui:FindFirstChild("reel")
    if reelUI and reelUI.Enabled then
        pcall(function()
            local bar = reelUI.bar
            if bar.fish.Position.X.Scale > bar.playerbar.Position.X.Scale then
                if not CONFIG.IsHoldingSpace then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    CONFIG.IsHoldingSpace = true
                end
            else
                if CONFIG.IsHoldingSpace then
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    CONFIG.IsHoldingSpace = false
                end
            end
        end)
    else
        if CONFIG.IsHoldingSpace then
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            CONFIG.IsHoldingSpace = false
        end
    end
end)

-- ESP Engine (Simple & Optimized)
local ESPEngine = { Objects = {} }
function ESPEngine:Add(player)
    if player == LocalPlayer then return end
    local Bill = Instance.new("BillboardGui")
    Bill.AlwaysOnTop = true
    Bill.Size = UDim2.new(0, 200, 0, 50)
    Bill.StudsOffset = Vector3.new(0, 3, 0)
    local Txt = Instance.new("TextLabel", Bill)
    Txt.Size = UDim2.new(1,0,1,0)
    Txt.BackgroundTransparency = 1
    Txt.Font = Enum.Font.GothamBold
    Txt.TextColor3 = Color3.new(1,1,1)
    Txt.TextStrokeTransparency = 0
    Txt.TextSize = 12
    local High = Instance.new("Highlight")
    High.FillTransparency = 0.5
    ESPEngine.Objects[player] = {Bill = Bill, High = High, Txt = Txt}
end
function ESPEngine:Remove(player)
    if ESPEngine.Objects[player] then
        ESPEngine.Objects[player].Bill:Destroy()
        ESPEngine.Objects[player].High:Destroy()
        ESPEngine.Objects[player] = nil
    end
end
for _, p in pairs(Players:GetPlayers()) do ESPEngine:Add(p) end
Players.PlayerAdded:Connect(function(p) ESPEngine:Add(p) end)
Players.PlayerRemoving:Connect(function(p) ESPEngine:Remove(p) end)

RunService.RenderStepped:Connect(function()
    for player, data in pairs(ESPEngine.Objects) do
        if not CONFIG.IsESPActive or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            data.Bill.Enabled = false
            data.High.Enabled = false
        else
            data.Bill.Parent = CoreGui
            data.Bill.Adornee = player.Character.HumanoidRootPart
            data.High.Parent = CoreGui
            data.High.Adornee = player.Character
            data.Bill.Enabled = true
            data.High.Enabled = true
            
            local dist = math.floor((player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
            data.Txt.Text = player.DisplayName .. "\n[" .. dist .. "m]"
            if player.Team == LocalPlayer.Team then
                data.High.FillColor = Color3.fromRGB(0, 255, 100)
                data.Txt.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                data.High.FillColor = Color3.fromRGB(255, 50, 50)
                data.Txt.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
    end
end)

PlayIntro()
