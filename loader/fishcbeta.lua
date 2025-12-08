-- =============================================================
-- CYBER-FISCH ULTIMATE V4 // UNIVERSAL EDITION
-- Author: Bos Kevin
-- Support: ALL EXECUTORS (PC & MOBILE)
-- Features: Auto Click/Cast, Sell Logic, ESP, Anti-Ban
-- =============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ProximityPromptService = game:GetService("ProximityPromptService")
local GuiService = game:GetService("GuiService")
local Camera = workspace.CurrentCamera

-- [[ UNIVERSAL GUI LOADER ]]
-- Mencari tempat aman untuk GUI di berbagai executor
local function GetSafeGuiRoot()
    local success, hui = pcall(function() return gethui() end)
    if success and hui then return hui end
    if getgenv and getgenv().protectgui then 
        local g = Instance.new("ScreenGui")
        getgenv().protectgui(g)
        return g.Parent
    end
    if game:GetService("CoreGui") then return game:GetService("CoreGui") end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UI_Parent = GetSafeGuiRoot()

-- [[ KONFIGURASI ]]
local CONFIG = {
    MaxWeight = 5000,
    IsAutoShake = false,
    IsAutoSell = false,
    IsESPActive = false,
    IsAntiAdmin = true,
    IsAntiAFK = true,
    FlySpeed = 80,
    TargetGroupId = 7381705,
    BlacklistedRoles = {"Trial Tester", "Trial Mod", "Moderator", "Senior Mod", "Admin", "Developer", "Lead", "Creator"}
}

-- Cleanup Old UI
for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "BosKevinUniversalV4" then v:Destroy() end
end

-- =============================================================
-- 1. NOTIFICATION SYSTEM
-- =============================================================
local function SendNotif(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = dur})
    end)
end

-- =============================================================
-- 2. UI CONSTRUCTION
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BosKevinUniversalV4"
ScreenGui.Parent = UI_Parent
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false -- Hidden saat boot

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Styling
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
local UIGradient = Instance.new("UIGradient", UIStroke)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(85, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 80))
}
UIGradient.Rotation = 45
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Header
local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 10)
Title.Size = UDim2.new(0.6, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "UNIVERSAL // V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.88, 0, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Gradient Anim
task.spawn(function()
    while MainFrame.Parent do
        local t = TweenService:Create(UIGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 225})
        t:Play() t.Completed:Wait()
        UIGradient.Rotation = 45
    end
end)

-- Button Creator
function CreateBtn(text, yPos, callback)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Position = UDim2.new(0.1, 0, yPos, 0)
    Btn.Size = UDim2.new(0.8, 0, 0.1, 0)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.TextSize = 11
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = Color3.fromRGB(60, 60, 80)
    Stroke.Thickness = 1
    
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        local col = toggled and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 80)
        local txtCol = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = col}):Play()
        Btn.TextColor3 = txtCol
        callback(toggled)
    end)
end

-- [[ BUTTON SETUP ]]
CreateBtn("AUTO FISH (CLICK + SHAKE)", 0.15, function(s) CONFIG.IsAutoShake = s end)
CreateBtn("AUTO SELL (FLY + PRESS E)", 0.28, function(s) CONFIG.IsAutoSell = s end)
CreateBtn("PLAYER ESP [WALLHACK]", 0.41, function(s) CONFIG.IsESPActive = s end)
CreateBtn("ANTI-ADMIN [SAFE MODE]", 0.54, function(s) CONFIG.IsAntiAdmin = s end)

-- Input
local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Position = UDim2.new(0.1, 0, 0.68, 0)
InputBox.Size = UDim2.new(0.8, 0, 0.08, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.Gotham
InputBox.Text = "5000"
InputBox.PlaceholderText = "Max Weight"
InputBox.TextSize = 14
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)
InputBox.FocusLost:Connect(function() CONFIG.MaxWeight = tonumber(InputBox.Text) or 5000 end)

-- Footer
local Credit = Instance.new("TextLabel", MainFrame)
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 0, 0.92, 0)
Credit.Size = UDim2.new(1, 0, 0, 10)
Credit.Font = Enum.Font.Code
Credit.Text = "UNIVERSAL BUILD // BOS KEVIN"
Credit.TextColor3 = Color3.fromRGB(100, 100, 100)
Credit.TextSize = 9

-- =============================================================
-- 3. CORE LOGIC
-- =============================================================

-- [[ AUTO CLICK (CAST) ]]
task.spawn(function()
    while true do
        task.wait(0.2)
        if CONFIG.IsAutoShake then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                -- Jika pegang pancing tapi belum lempar (gak ada bobber)
                if tool and tool:FindFirstChild("values") and not tool:FindFirstChild("bobber") then
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1)
                    task.wait(1.5)
                end
            end
        end
    end
end)

-- [[ SHAKE & REEL ]]
RunService.Heartbeat:Connect(function()
    if not CONFIG.IsAutoShake then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    
    local shake = gui:FindFirstChild("shakeui")
    if shake and shake.Enabled then
        pcall(function()
            local btn = shake.safezone.button
            if btn.Visible then
                GuiService.SelectedObject = btn
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end)
    end
    
    local reel = gui:FindFirstChild("reel")
    if reel and reel.Enabled then
        pcall(function()
            local bar = reel.bar
            if bar.fish.Position.X.Scale > bar.playerbar.Position.X.Scale then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            else
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end
        end)
    else
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- [[ AUTO SELL (FLY + INTERACT) ]]
local function TweenMove(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local dist = (root.Position - targetCFrame.Position).Magnitude
    local time = dist / CONFIG.FlySpeed 

    local tInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tInfo, {CFrame = targetCFrame})
    
    local noclip
    noclip = RunService.Stepped:Connect(function()
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    tween:Play() tween.Completed:Wait()
    if noclip then noclip:Disconnect() end
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
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, gui in pairs(pg:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Visible and (string.find(gui.Text, "kg") or string.find(gui.Text, "/")) then
                 local current = gui.Text:match("^(%d+)")
                 if current then return tonumber(current) end
            end
        end
    end
    return 0
end

task.spawn(function()
    while true do
        task.wait(2)
        if CONFIG.IsAutoSell then
            local cw = GetCurrentWeight()
            if cw >= CONFIG.MaxWeight then
                local Char = LocalPlayer.Character
                local Merchant = FindMerchant()
                
                if Char and Merchant then
                    local saved = Char.HumanoidRootPart.CFrame
                    -- 1. Fly
                    TweenMove(Merchant.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                    task.wait(0.5)
                    
                    -- 2. Interact (E & Click)
                    local prompt = Merchant:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(0.2)
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game) -- Tekan E
                        task.wait(1.5)
                        
                        -- 3. Select Option
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game) -- Tekan 2
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                        
                        -- Backup Click GUI
                        local pg = LocalPlayer:FindFirstChild("PlayerGui")
                        if pg then
                            for _, v in pairs(pg:GetDescendants()) do
                                if v:IsA("TextButton") and v.Visible then
                                    local txt = string.lower(v.Text)
                                    if string.find(txt, "inventory") or string.find(txt, "sell all") then
                                        for _, c in pairs(getconnections(v.MouseButton1Click)) do c:Fire() end
                                    end
                                end
                            end
                        end
                        task.wait(2.5)
                    end
                    
                    -- 4. Return
                    if saved then TweenMove(saved) end
                end
            end
        end
    end
end)

-- [[ ESP & SECURITY ]]
task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        if CONFIG.IsAntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(5)
        if CONFIG.IsAntiAdmin then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local s, r = pcall(function() return p:GetRoleInGroup(CONFIG.TargetGroupId) end)
                    if s and r then
                        for _, bad in ipairs(CONFIG.BlacklistedRoles) do
                            if r == bad then LocalPlayer:Kick("Admin: "..p.Name) end
                        end
                    end
                end
            end
        end
    end
end)

local ESPEngine = {Objs = {}}
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESPEngine.Objs[p] then
                local b = Instance.new("BillboardGui", CoreGui)
                b.Size = UDim2.new(0,200,0,50) b.AlwaysOnTop = true
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1,0,1,0) t.BackgroundTransparency = 1
                t.TextColor3 = Color3.new(1,1,1) t.Font = Enum.Font.Bold t.TextSize = 12
                t.TextStrokeTransparency = 0
                local h = Instance.new("Highlight", CoreGui)
                h.FillTransparency = 0.5
                ESPEngine.Objs[p] = {b=b, t=t, h=h}
            end
            
            local data = ESPEngine.Objs[p]
            if CONFIG.IsESPActive and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                data.b.Enabled = true data.h.Enabled = true
                data.b.Adornee = p.Character.HumanoidRootPart
                data.h.Adornee = p.Character
                local dist = math.floor((p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
                data.t.Text = p.DisplayName.."\n["..dist.."m]"
                
                if p.Team == LocalPlayer.Team then 
                    data.h.FillColor = Color3.fromRGB(0,255,100) 
                    data.t.TextColor3 = Color3.fromRGB(0,255,100)
                else 
                    data.h.FillColor = Color3.fromRGB(255,50,50)
                    data.t.TextColor3 = Color3.fromRGB(255,50,50)
                end
            else
                data.b.Enabled = false data.h.Enabled = false
            end
        end
    end
end)

-- =============================================================
-- 4. BOOT SEQUENCE
-- =============================================================
task.spawn(function()
    SendNotif("UNIVERSAL LOADER", "Injecting Scripts...", 2)
    task.wait(2)
    SendNotif("BOS KEVIN SYSTEM", "Success! Opening Menu...", 2)
    task.wait(2)
    
    ScreenGui.Enabled = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 260, 0, 420)}):Play()
end)
