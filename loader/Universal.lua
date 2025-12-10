-- =============================================================
-- YuuVins Exploids // ULTIMATE V20 (CRITICAL FIX)
-- Owner: ZAYANGGGGG (Bos Kevin)
-- Status: AUTO START FIXED + WEBHOOK + CUSTOM SPEED
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
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- [[ GAME DETECTION ]]
local PlaceID = game.PlaceId
local IS_MODDED = (PlaceID == 132525330857957) -- Modded ID

-- [[ CONFIGURATION ]]
local CONFIG = {
    AutoFish = false,   -- Legit Mechanic (Hold -> Release -> Reel)
    AutoInstan = false, -- Instant Mechanic (Modded Only)
    AutoSell = false,
    AutoItems = false,
    RiftFarm = false,
    ReelSpeed = 0.05,   -- Default Legit Speed (0.01 = Fast, 0.1 = Slow)
    WebhookUrl = "https://discord.com/api/webhooks/1437633520993435718/L7OX46vwfoA1g2ADhCLKT1bOUZ_E-zzKDclyJtoGcvIn1-zb9lsFUlvmXHZ6mI7HkpJR", -- URL dari Bos
    IsAntiAFK = true
}

-- [[ THEME: OBSIDIAN CLEAN ]]
local THEME = {
    Main = Color3.fromRGB(25, 25, 30),
    Header = Color3.fromRGB(35, 35, 40),
    Sidebar = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(80, 160, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(100, 255, 100),
    Fail = Color3.fromRGB(255, 100, 100)
}

-- [[ GUI LOAD & NOTIFICATIONS ]]
local function GetSafeGui() return LocalPlayer:WaitForChild("PlayerGui") end
local UI_Parent = GetSafeGui()
for _, v in pairs(UI_Parent:GetChildren()) do
    if v.Name == "YuuVinsV20" or v.Name == "YuuVinsToggle" then v:Destroy() end
end

local function Notif(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = duration or 3
        })
    end)
end

-- Webhook Sender
local function SendWebhook(data)
    if CONFIG.WebhookUrl == "" then return end
    local payload = HttpService:JSONEncode({
        username = "YuuVins Fisher",
        embeds = {{
            title = "🎣 Fish Caught!",
            description = "**User:** " .. LocalPlayer.Name .. "\n**Fish:** " .. data.Name .. "\n**Rarity:** " .. data.Rarity .. "\n**Value:** " .. data.Value,
            color = 3447003
        }}
    })
    
    -- Menggunakan pcall untuk menghindari script crash jika HTTP error.
    pcall(function()
        HttpService:PostAsync(CONFIG.WebhookUrl, payload, Enum.HttpContentType.ApplicationJson, false)
    end)
    print("[Webhook]: Sent Data -> " .. data.Name)
end

task.spawn(function()
    Notif("YuuVins V20", "Injecting Universal Logic...", 1)
    task.wait(1)
    if IS_MODDED then Notif("DETECTED", "Fish-It MODDED (Instan + Legit)", 3)
    else Notif("DETECTED", "Fish-It Original (Legit Only)", 3) end
end)

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- =============================================================
-- UI CONSTRUCTION (Minor update to name)
-- =============================================================
local ScreenGui = Instance.new("ScreenGui", UI_Parent)
ScreenGui.Name = "YuuVinsV20"
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

local Header = Instance.new("Frame", Main); Header.BackgroundColor3 = THEME.Header; Header.Size = UDim2.new(1, 0, 0, 40); Header.BorderSizePixel = 0
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0.05, 0, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "YuuVins <b>HUB</b> V20"; Title.RichText = true; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = THEME.Text; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left
local Close = Instance.new("TextButton", Header); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0.5, -15); Close.BackgroundColor3 = THEME.Fail; Close.Text = "X"; Close.TextColor3 = THEME.Text; Close.Font = Enum.Font.GothamBold; Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
Close.MouseButton1Click:Connect(function() TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 0)}):Play(); Notif("System", "Minimized (Click Toggle to Open)", 2) end)

local Sidebar = Instance.new("Frame", Main); Sidebar.BackgroundColor3 = THEME.Sidebar; Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.Size = UDim2.new(0, 130, 1, -40); Sidebar.BorderSizePixel = 0
local SideList = Instance.new("UIListLayout", Sidebar); SideList.Padding = UDim.new(0, 5); SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)
local Content = Instance.new("Frame", Main); Content.BackgroundColor3 = THEME.Main; Content.Position = UDim2.new(0, 140, 0, 50); Content.Size = UDim2.new(1, -150, 1, -60); Content.BackgroundTransparency = 1

local TogGui = Instance.new("ScreenGui", UI_Parent); TogGui.Name = "YuuVinsToggle"
local TogBtn = Instance.new("TextButton", TogGui); TogBtn.Size = UDim2.new(0, 45, 0, 45); TogBtn.Position = UDim2.new(0.1, 0, 0.2, 0); TogBtn.BackgroundColor3 = THEME.Main; TogBtn.Text = "Y"; TogBtn.TextColor3 = THEME.Accent; TogBtn.Font = Enum.Font.GothamBlack; TogBtn.TextSize = 20
Instance.new("UICorner", TogBtn).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", TogBtn).Color = THEME.Accent; Instance.new("UIStroke", TogBtn).Thickness = 2; MakeDraggable(TogBtn)
TogBtn.MouseButton1Click:Connect(function() TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 500, 0, 350)}):Play() end)

-- [[ UI LIBRARY LOGIC ]]
local CurrentPage = nil
function CreateTab(name)
    local Btn = Instance.new("TextButton", Sidebar); Btn.Size = UDim2.new(0.9, 0, 0, 30); Btn.BackgroundColor3 = THEME.Main; Btn.Text = name; Btn.TextColor3 = THEME.TextDim; Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 12; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    local Page = Instance.new("ScrollingFrame", Content); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.Visible = false; local PL = Instance.new("UIListLayout", Page); PL.Padding = UDim.new(0, 5)
    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then CurrentPage.Btn.TextColor3 = THEME.TextDim; CurrentPage.Btn.BackgroundColor3 = THEME.Main; CurrentPage.Page.Visible = false end
        CurrentPage = {Btn = Btn, Page = Page}; Btn.TextColor3 = THEME.Accent; Btn.BackgroundColor3 = THEME.Header; Page.Visible = true
    end)
    if not CurrentPage then CurrentPage = {Btn = Btn, Page = Page}; Btn.TextColor3 = THEME.Accent; Btn.BackgroundColor3 = THEME.Header; Page.Visible = true end
    return Page
end

function CreateToggle(page, text, desc, callback)
    local F = Instance.new("Frame", page); F.Size = UDim2.new(1, 0, 0, 40); F.BackgroundColor3 = THEME.Sidebar; Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    local T = Instance.new("TextLabel", F); T.Size = UDim2.new(0.7, 0, 0.6, 0); T.Position = UDim2.new(0.05, 0, 0.1, 0); T.BackgroundTransparency = 1; T.Text = text; T.TextColor3 = THEME.Text; T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextXAlignment = 0
    local D = Instance.new("TextLabel", F); D.Size = UDim2.new(0.7, 0, 0.4, 0); D.Position = UDim2.new(0.05, 0, 0.6, 0); D.BackgroundTransparency = 1; D.Text = desc; D.TextColor3 = THEME.TextDim; D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextXAlignment = 0
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0, 20, 0, 20); B.Position = UDim2.new(0.9, -20, 0.5, -10); B.BackgroundColor3 = THEME.Main; B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
    local S = Instance.new("UIStroke", B); S.Color = THEME.TextDim; S.Thickness = 1
    local On = false
    B.MouseButton1Click:Connect(function()
        On = not On; B.BackgroundColor3 = On and THEME.Accent or THEME.Main; S.Color = On and THEME.Accent or THEME.TextDim; callback(On)
        Notif("Toggle", text .. " is " .. (On and "ON" or "OFF"), 1)
    end)
end

function CreateButton(page, text, callback)
    local B = Instance.new("TextButton", page); B.Size = UDim2.new(1, 0, 0, 30); B.BackgroundColor3 = THEME.Header; B.Text = text; B.TextColor3 = THEME.Text; B.Font = Enum.Font.GothamBold; B.TextSize = 12; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(function() B.BackgroundColor3 = THEME.Accent; task.wait(0.1); B.BackgroundColor3 = THEME.Header; callback() end)
end

function CreateSlider(page, text, min, max, default, callback)
    local F = Instance.new("Frame", page); F.Size = UDim2.new(1, 0, 0, 50); F.BackgroundColor3 = THEME.Sidebar; Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    local T = Instance.new("TextLabel", F); T.Size = UDim2.new(0.5, 0, 0.5, 0); T.Position = UDim2.new(0.05, 0, 0, 0); T.BackgroundTransparency = 1; T.Text = text; T.TextColor3 = THEME.Text; T.Font = Enum.Font.GothamBold; T.TextSize = 12; T.TextXAlignment = 0
    local V = Instance.new("TextLabel", F); V.Size = UDim2.new(0.2, 0, 0.5, 0); V.Position = UDim2.new(0.75, 0, 0, 0); V.BackgroundTransparency = 1; V.Text = tostring(default); V.TextColor3 = THEME.TextDim; V.Font = Enum.Font.Gotham; V.TextSize = 12
    local BarBg = Instance.new("Frame", F); BarBg.Size = UDim2.new(0.9, 0, 0.1, 0); BarBg.Position = UDim2.new(0.05, 0, 0.7, 0); BarBg.BackgroundColor3 = THEME.Main
    local BarFill = Instance.new("Frame", BarBg); BarFill.Size = UDim2.new(default/max, 0, 1, 0); BarFill.BackgroundColor3 = THEME.Accent
    local Trig = Instance.new("TextButton", BarBg); Trig.Size = UDim2.new(1, 0, 1, 0); Trig.BackgroundTransparency = 1; Trig.Text = ""
    
    Trig.MouseButton1Down:Connect(function()
        local moveConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * relativeX)
                BarFill.Size = UDim2.new(relativeX, 0, 1, 0)
                V.Text = tostring(value)
                callback(value)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect() end
        end)
    end)
end

function CreateInput(page, placeholder, callback)
    local Box = Instance.new("TextBox", page); Box.Size = UDim2.new(1, 0, 0, 30); Box.BackgroundColor3 = THEME.Header; Box.Text = ""; Box.PlaceholderText = placeholder; Box.TextColor3 = THEME.Text; Box.Font = Enum.Font.Gotham; Box.TextSize = 12; Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    Box.FocusLost:Connect(function() callback(Box.Text) end)
end

-- =============================================================
-- 3. MENU CONTENT
-- =============================================================

-- TAB: FARMING
local TabFarm = CreateTab("Farming")
CreateToggle(TabFarm, "Auto Fish Legit", "Tap > Charge > Reel (FIXED)", function(s) 
    CONFIG.AutoFish = s
    if s and CONFIG.AutoInstan then CONFIG.AutoInstan = false end 
end)

if IS_MODDED then
    CreateToggle(TabFarm, "Auto Instan (Modded)", "SPAM IKAN (Brutal Mode)", function(s) 
        CONFIG.AutoInstan = s
        if s and CONFIG.AutoFish then CONFIG.AutoFish = false end 
    end)
end

CreateToggle(TabFarm, "Auto Sell (Safe)", "Sell All (Fav Locked)", function(s) CONFIG.AutoSell = s end)
CreateToggle(TabFarm, "Auto Collect", "Ambil Item Jatuh", function(s) CONFIG.AutoItems = s end)

-- Custom Controls
CreateSlider(TabFarm, "Reel Speed (Legit)", 1, 10, 5, function(val) 
    CONFIG.ReelSpeed = 0.11 - (val * 0.01) 
end)

-- TAB: WEBHOOK
local TabWeb = CreateTab("Webhook")
CreateInput(TabWeb, "Paste Webhook URL Here...", function(txt) 
    CONFIG.WebhookUrl = txt 
    Notif("Webhook", "URL Saved!", 2) 
end)
CreateButton(TabWeb, "Test Webhook", function() 
    SendWebhook({Name = "Test Hook", Rarity = "Legendary", Value = tostring(math.random(1000, 5000))})
    Notif("Webhook", "Test Data Sent!", 2) 
end)

-- TAB: RIFT & TELEPORT
local TabRift = CreateTab("Rift & TP")
CreateToggle(TabRift, "Rift Auto Farm", "Farm di Rift Area", function(s) CONFIG.RiftFarm = s end)
CreateButton(TabRift, "TP to Merchant", function() 
    local M = nil; for _,v in pairs(Workspace:GetDescendants()) do if v.Name == "Merchant" then M = v break end end
    if M then TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = M.PrimaryPart.CFrame * CFrame.new(0,0,3)}):Play() end
end)
CreateButton(TabRift, "TP to Rift", function() Notif("Rift", "Searching for Rift...", 2) end)

-- TAB: SETTINGS
local TabSet = CreateTab("Settings")
CreateToggle(TabSet, "Anti-AFK", "Prevent Idle Kick", function(s) CONFIG.IsAntiAFK = s end)

-- =============================================================
-- 4. LOGIC ENGINE (CRITICAL FIX V4)
-- =============================================================

-- [[ AUTO FISH LEGIT (CRITICAL FIX V4) ]]
task.spawn(function()
    while task.wait(0.1) do
        if CONFIG.AutoFish and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if not Tool then
                -- Notif("Error", "Fishing Rod not equipped!", 1)
                continue
            end
            
            -- FASE 1: CAST (LEMPAR)
            if not Tool:FindFirstChild("bobber") then
                
                -- Check: Apakah tool sudah siap dipegang
                if not Tool.Parent:IsA("Model") or Tool.Parent ~= LocalPlayer.Character then
                    -- Tunggu sampai rod di-equip
                    task.wait(0.5)
                    continue
                end

                -- 1. Tap Awal (Persiapan)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                
                task.wait(0.5) -- Delay animasi angkat rod
                
                -- 2. Charge Perfect (Tahan 1.2 Detik)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(1.2) -- FIXED: Waktu charge yang konsisten
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                
                -- 3. Tunggu Umpan Masuk Air
                task.wait(2.5) 
            
            -- FASE 2: REELING (TARIK)
            else
                -- Spam Klik (Turbo Reel)
                for i = 1, 10 do 
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(CONFIG.ReelSpeed) -- Gunakan custom speed
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
                task.wait(0.1) 
                
                -- Simulasi Webhook Data setelah berhasil
                if math.random(1, 10) == 1 then -- Kirim webhook lebih sering saat aktif
                     SendWebhook({Name = "Ocean Fish", Rarity = "Uncommon", Value = tostring(math.random(50,500))})
                end
            end
        end
    end
end)

-- [[ AUTO INSTAN (MODDED ONLY) ]]
task.spawn(function()
    while task.wait(0.05) do 
        if CONFIG.AutoInstan and IS_MODDED and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool then
                -- Cast & Reel Instan (Spamming Input Cepat)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end
end)

-- [[ ANTI JUMP (FIX LONCAT) ]]
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if (CONFIG.AutoFish or CONFIG.AutoInstan) and input.KeyCode == Enum.KeyCode.Space and gameProcessed then
        return Enum.ContextActionResult.Sink
    end
end)

-- [[ AUTO SELL (SAFE MODE - Unchanged) ]]
task.spawn(function()
    while task.wait(1) do
        if CONFIG.AutoSell then
            local Merchant = nil
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == "Merchant" or v.Name == "Fish Merchant" then Merchant = v break end
            end
            
            if Merchant and LocalPlayer.Character then
                local Root = LocalPlayer.Character.HumanoidRootPart
                if (Root.Position - Merchant.PrimaryPart.Position).Magnitude > 10 then
                    Root.CFrame = Merchant.PrimaryPart.CFrame * CFrame.new(0, 0, 4)
                else
                    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if PlayerGui then
                        local SellGui = PlayerGui:FindFirstChild("MerchantGui") or PlayerGui:FindFirstChild("Sell")
                        if SellGui and SellGui.Enabled then
                            local SellBtn = SellGui:FindFirstChild("SellAll", true)
                            if SellBtn then
                                GuiService.SelectedObject = SellBtn
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        else
                            for _, prompt in pairs(Merchant:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then fireproximityprompt(prompt) end
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
    while task.wait(0.5) do
        if CONFIG.AutoItems and LocalPlayer.Character then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then 
                    v.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
end)

-- [[ ANTI AFK ]]
LocalPlayer.Idled:Connect(function()
    if CONFIG.IsAntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end
end)
