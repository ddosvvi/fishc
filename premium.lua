-- =============================================================
-- CYBER-FISCH PREMIUM V1 // BOS KEVIN EDITION
-- Theme: Cyberpunk Animated
-- Features: Intro Animation, Minimize/Maximize, Auto Logic
-- =============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- [[ CONFIGURATION ]]
local CONFIG = {
    MaxWeight = 5000,
    IsAutoShake = false,
    IsAutoSell = false,
    IsHoldingSpace = false,
    SavedPosition = nil,
    UI_Visible = true
}

-- [[ UI VARIABLES ]]
local UI = {}
local GradientColor = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 255)), -- Cyan
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 0, 255)), -- Purple
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 80))   -- Red
}

-- Cleanup Old UI
if CoreGui:FindFirstChild("BosKevinPremiumV1") then
    CoreGui.BosKevinPremiumV1:Destroy()
end

-- =============================================================
-- 1. BUILD UI SYSTEM
-- =============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BosKevinPremiumV1"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ MAIN WINDOW ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -160) -- Center Anchor Logic later
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Start small for animation
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Main Stroke (Border)
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Transparency = 0

local UIGradient = Instance.new("UIGradient")
UIGradient.Parent = UIStroke
UIGradient.Color = GradientColor
UIGradient.Rotation = 45

-- Animated Gradient Loop
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

-- [[ TITLE BAR & CONTROLS ]]
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 10)
Title.Size = UDim2.new(0.6, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "CYBER-FISCH // V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = MainFrame
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(0.75, 0, 0, 5)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 20

-- Close Button (X)
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
Line.Position = UDim2.new(0, 0, 0.15, 0)
Line.Size = UDim2.new(1, 0, 0, 1)

local LineGrad = Instance.new("UIGradient")
LineGrad.Color = GradientColor
LineGrad.Parent = Line

-- [[ MINIMIZED WIDGET ]]
local MiniFrame = Instance.new("TextButton") -- Button agar bisa diklik untuk maximize
MiniFrame.Name = "MiniFrame"
MiniFrame.Parent = ScreenGui
MiniFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MiniFrame.Position = UDim2.new(1, -260, 0.9, 0) -- Pojok kanan bawah default
MiniFrame.Size = UDim2.new(0, 250, 0, 40)
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Visible = false -- Hidden initially
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
MiniText.Text = "EXECUTOR PREMIUM BETA BOS KEVIN V1"
MiniText.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniText.TextSize = 11

local MiniGlow = Instance.new("ImageLabel") -- Fake glow effect
MiniGlow.Parent = MiniFrame
MiniGlow.BackgroundTransparency = 1
MiniGlow.Image = "rbxassetid://5028857472"
MiniGlow.ImageColor3 = Color3.fromRGB(0, 255, 255)
MiniGlow.Size = UDim2.new(1.2, 0, 1.5, 0)
MiniGlow.Position = UDim2.new(-0.1, 0, -0.25, 0)
MiniGlow.ZIndex = 0

-- =============================================================
-- 2. HELPER FUNCTIONS & ANIMATION
-- =============================================================

function CreateCyberButton(parent, text, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Position = UDim2.new(0.1, 0, yPos, 0)
    Btn.Size = UDim2.new(0.8, 0, 0.15, 0)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.TextSize = 13
    Btn.AutoButtonColor = false

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Parent = Btn
    BtnStroke.Thickness = 1
    BtnStroke.Color = Color3.fromRGB(60, 60, 80)
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Status = Instance.new("Frame")
    Status.Parent = Btn
    Status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Status.Position = UDim2.new(0, 0, 0.9, 0)
    Status.Size = UDim2.new(1, 0, 0.1, 0)
    Status.BorderSizePixel = 0
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = Status

    local toggled = false
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

-- ANIMATION: INTRO
function PlayIntro()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    UIStroke.Transparency = 1
    
    task.wait(0.2)
    -- Bounce Effect
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 320)}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
end

-- ANIMATION: MINIMIZE
function MinimizeUI()
    CONFIG.UI_Visible = false
    -- Shrink Main
    local tweenOut = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    MainFrame.Visible = false
    
    -- Show Mini
    MiniFrame.Size = UDim2.new(0, 0, 0, 40)
    MiniFrame.Visible = true
    TweenService:Create(MiniFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 40)}):Play()
end

-- ANIMATION: MAXIMIZE
function MaximizeUI()
    CONFIG.UI_Visible = true
    -- Shrink Mini
    local tweenOut = TweenService:Create(MiniFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 40)})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    MiniFrame.Visible = false
    
    -- Show Main
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 320)}):Play()
end

-- BUTTON EVENTS
MinBtn.MouseButton1Click:Connect(MinimizeUI)
MiniFrame.MouseButton1Click:Connect(MaximizeUI)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    -- Optional: Disable logic
    CONFIG.IsAutoShake = false
    CONFIG.IsAutoSell = false
end)

-- =============================================================
-- 3. CONTENT & LOGIC
-- =============================================================

CreateCyberButton(MainFrame, "ACTIVATE AUTO FISH", 0.25, function(state)
    CONFIG.IsAutoShake = state
end)

CreateCyberButton(MainFrame, "ACTIVATE AUTO SELL", 0.45, function(state)
    CONFIG.IsAutoSell = state
end)

-- WEIGHT INPUT
local InputBg = Instance.new("Frame")
InputBg.Parent = MainFrame
InputBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
InputBg.Position = UDim2.new(0.1, 0, 0.65, 0)
InputBg.Size = UDim2.new(0.8, 0, 0.12, 0)
local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputBg
local InputBox = Instance.new("TextBox")
InputBox.Parent = InputBg
InputBox.Size = UDim2.new(1, 0, 1, 0)
InputBox.BackgroundTransparency = 1
InputBox.Font = Enum.Font.Gotham
InputBox.Text = tostring(CONFIG.MaxWeight)
InputBox.PlaceholderText = "MAX WEIGHT (KG)"
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextSize = 14

InputBox.FocusLost:Connect(function()
    local n = tonumber(InputBox.Text)
    if n then CONFIG.MaxWeight = n end
end)

-- CREDIT
local Credit = Instance.new("TextLabel")
Credit.Parent = MainFrame
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 0, 0.9, 0)
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Font = Enum.Font.Code
Credit.Text = "LOGGED IN: BOS KEVIN"
Credit.TextColor3 = Color3.fromRGB(100, 100, 100)
Credit.TextSize = 10

-- =============================================================
-- 4. BACKEND LOGIC (AUTO FISH/SELL)
-- =============================================================
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
    return #LocalPlayer.Backpack:GetChildren()
end

-- Auto Sell Loop
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
                    Char.HumanoidRootPart.CFrame = Merchant.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                    task.wait(1)
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
                    if CONFIG.SavedPosition then Char.HumanoidRootPart.CFrame = CONFIG.SavedPosition end
                end
            end
        end
    end
end)

-- Auto Shake/Reel Loop
RunService.Heartbeat:Connect(function()
    if not CONFIG.IsAutoShake then return end
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    
    -- Shake
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
    
    -- Reel
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

-- PLAY INTRO
PlayIntro()