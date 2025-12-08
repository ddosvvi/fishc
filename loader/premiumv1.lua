-- =============================================================
-- YuuVins Exploids // ULTIMATE V10 (HYPER OPTIMIZED)
-- Owner: ZAYANGGGGG
-- Status: COMPRESSED & FAST LOAD
-- =============================================================

-- [[ 1. SHORTENED SERVICES & VARS ]]
local S = setmetatable({}, {__index = function(_,k) return game:GetService(k) end})
local Plrs, RS, VIM, VU, TS, SG, GS, CG, MPS, Lig, UIS, WS = S.Players, S.RunService, S.VirtualInputManager, S.VirtualUser, S.TweenService, S.StarterGui, S.GuiService, S.CoreGui, S.MarketplaceService, S.Lighting, S.UserInputService, S.Workspace
local LP, Cam = Plrs.LocalPlayer, WS.CurrentCamera
local CF, Vec3, RGB, UD2 = CFrame.new, Vector3.new, Color3.fromRGB, UDim2.new
local spawn, wait, delay = task.spawn, task.wait, task.delay
local Enum = Enum

-- [[ 2. CONFIGURATION ]]
local C = {
    Fish=false, Sell=false, ESP=false, Vis=false, AFK=true,
    Bypass=true, AFKLvl=false, God=false, Walk=false, Clip=false,
    InfJump=false, Bright=false,
    SavePos=nil, Speed=300, GrpID=7381705,
    Bad={"Trial Tester","Trial Mod","Moderator","Senior Mod","Admin","Developer","Creator"}
}

local T = {
    Bg=RGB(10,12,20), Side=RGB(15,18,30), Item=RGB(20,25,40),
    Txt=RGB(240,240,255), Acc=RGB(0,230,255),
    G1=RGB(0,180,255), G2=RGB(0,80,200),
    ESP=RGB(0,255,255), NPC=RGB(255,215,0)
}

-- [[ 3. GUI MANAGER ]]
local function GetUI()
    local s,r = pcall(function() return gethui() end)
    if s and r then return r end
    return CG or LP:WaitForChild("PlayerGui")
end
local Parent = GetUI()
for _,v in pairs(Parent:GetChildren()) do if v.Name=="YuuVinsV10" then v:Destroy() end end

local function Notif(t,x,d) pcall(function() SG:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
Notif("YuuVins V10", "Loading Optimized Script...", 2)

-- [[ 4. UI FACTORY (COMPRESSED) ]]
local function Make(Cls, Prp)
    local x = Instance.new(Cls)
    for k,v in pairs(Prp) do if k~="Parent" then x[k]=v end end
    if Prp.Parent then x.Parent = Prp.Parent end
    return x
end

local Screen = Make("ScreenGui", {Name="YuuVinsV10", Parent=Parent, ResetOnSpawn=false, Enabled=false})
local Main = Make("Frame", {Name="Main", Parent=Screen, BackgroundColor3=T.Bg, Position=UD2(0.5,-300,0.5,-200), Size=UD2(0,600,0,400), ClipsDescendants=true, Active=true, Draggable=true})
local Stroke = Make("UIStroke", {Parent=Main, Thickness=2, Transparency=0})
local Grad = Make("UIGradient", {Parent=Stroke, Color=ColorSequence.new{ColorSequenceKeypoint.new(0,T.G1), ColorSequenceKeypoint.new(1,T.G2)}, Rotation=45})
Make("UICorner", {Parent=Main, CornerRadius=UDim.new(0,10)})

-- Animation
spawn(function() while Main.Parent do local t=TS:Create(Grad,TweenInfo.new(3,Enum.EasingStyle.Linear),{Rotation=405}); t:Play(); t.Completed:Wait(); Grad.Rotation=45 end end)

-- Layout
local Head = Make("Frame", {Parent=Main, BackgroundColor3=RGB(0,0,0), BackgroundTransparency=0.8, Size=UD2(1,0,0,40)})
Make("TextLabel", {Parent=Head, Size=UD2(0,200,1,0), Position=UD2(0,15,0,0), BackgroundTransparency=1, Text="YuuVins Exploids", Font=Enum.Font.GothamBlack, TextColor3=T.Acc, TextSize=18, TextXAlignment=0})

local Side = Make("Frame", {Parent=Main, BackgroundColor3=T.Side, Position=UD2(0,0,0,40), Size=UD2(0,160,1,-40), BorderSizePixel=0})
local Cont = Make("Frame", {Parent=Main, BackgroundColor3=T.Bg, Position=UD2(0,170,0,50), Size=UD2(1,-180,1,-60), BackgroundTransparency=1})
local SideList = Make("UIListLayout", {Parent=Side, SortOrder="LayoutOrder", Padding=UDim.new(0,5), HorizontalAlignment=1})
Make("UIPadding", {Parent=Side, PaddingTop=UDim.new(0,10)})

local Tabs, CurPage = {}, nil

local function AddTab(txt)
    local B = Make("TextButton", {Parent=Side, Size=UD2(1,-10,0,35), BackgroundColor3=T.Bg, BackgroundTransparency=1, Text="  "..txt, TextColor3=RGB(150,150,150), Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=0, AutoButtonColor=false})
    local P = Make("ScrollingFrame", {Parent=Cont, Size=UD2(1,0,1,0), BackgroundTransparency=1, ScrollBarThickness=3, Visible=false})
    Make("UIListLayout", {Parent=P, Padding=UDim.new(0,8), SortOrder="LayoutOrder"})
    
    B.MouseButton1Click:Connect(function()
        if CurPage then CurPage.B.TextColor3=RGB(150,150,150); CurPage.P.Visible=false end
        CurPage = {B=B, P=P}; B.TextColor3=T.Acc; P.Visible=true
    end)
    if not CurPage then CurPage={B=B,P=P}; B.TextColor3=T.Acc; P.Visible=true end
    return P
end

local function AddTog(Pg, txt, desc, def, func)
    local F = Make("Frame", {Parent=Pg, Size=UD2(1,-5,0,50), BackgroundColor3=T.Item})
    Make("UICorner", {Parent=F, CornerRadius=UDim.new(0,6)})
    Make("TextLabel", {Parent=F, Size=UD2(1,-60,0,25), Position=UD2(0,10,0,2), BackgroundTransparency=1, Text=txt, TextColor3=T.Txt, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=0})
    Make("TextLabel", {Parent=F, Size=UD2(1,-60,0,15), Position=UD2(0,10,0,25), BackgroundTransparency=1, Text=desc, TextColor3=RGB(150,150,150), Font=Enum.Font.Gotham, TextSize=10, TextXAlignment=0})
    local B = Make("TextButton", {Parent=F, Size=UD2(0,40,0,20), Position=UD2(1,-50,0.5,-10), BackgroundColor3=def and T.Acc or RGB(50,50,60), Text=""})
    Make("UICorner", {Parent=B, CornerRadius=UDim.new(0,4)})
    B.MouseButton1Click:Connect(function() def=not def; B.BackgroundColor3=def and T.Acc or RGB(50,50,60); Notif("System", txt..": "..(def and "ON" or "OFF"), 1); func(def) end)
end

local function AddBtn(Pg, txt, func)
    local B = Make("TextButton", {Parent=Pg, Size=UD2(1,-5,0,35), BackgroundColor3=T.Item, Text=txt, TextColor3=T.Txt, Font=Enum.Font.GothamBold, TextSize=12})
    Make("UICorner", {Parent=B, CornerRadius=UDim.new(0,6)})
    B.MouseButton1Click:Connect(func)
end

local function AddInfo(Pg, l, v)
    local F = Make("Frame", {Parent=Pg, Size=UD2(1,-5,0,30), BackgroundColor3=T.Item})
    Make("UICorner", {Parent=F, CornerRadius=UDim.new(0,6)})
    Make("TextLabel", {Parent=F, Size=UD2(0.4,0,1,0), Position=UD2(0,10,0,0), BackgroundTransparency=1, Text=l, TextColor3=RGB(180,180,180), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=0})
    Make("TextLabel", {Parent=F, Size=UD2(0.6,-20,1,0), Position=UD2(0.4,0,0,0), BackgroundTransparency=1, Text=v, TextColor3=T.Acc, Font=Enum.Font.GothamBold, TextSize=12, TextXAlignment=1})
end

-- Header Controls
local function HeadBtn(t,x,c,f)
    local b = Make("TextButton", {Parent=Header, Size=UD2(0,35,0,35), AnchorPoint=Vec3(1,0.5,0), Position=UD2(1,x,0.5,0), BackgroundColor3=RGB(255,255,255), BackgroundTransparency=0.95, Text=t, TextColor3=c, Font=Enum.Font.GothamBold, TextSize=18})
    Make("UICorner", {Parent=b, CornerRadius=UDim.new(0,6)})
    b.MouseButton1Click:Connect(f)
end
HeadBtn("X", -5, RGB(255,80,80), function() Screen:Destroy() end)
local Mini=false
HeadBtn("-", -45, RGB(255,255,255), function() Mini=not Mini; TS:Create(Main,TweenInfo.new(0.5,Enum.EasingStyle.Quart),{Size=Mini and UD2(0,600,0,40) or UD2(0,600,0,400)}):Play(); Side.Visible=not Mini; Cont.Visible=not Mini end)

-- =============================================================
-- 5. LOGIC CORE (OPTIMIZED)
-- =============================================================

-- [[ TELEPORT & GODMODE ]]
local function TP(pos)
    local C = LP.Character
    if not C or not C:FindFirstChild("HumanoidRootPart") then return end
    local Root = C.HumanoidRootPart
    
    -- God Mode Inject
    if C.IsGodMode then
        if C:FindFirstChild("Humanoid") then C.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
        for _,v in pairs(WS:GetDescendants()) do if v.Name=="Lava" then v.CanTouch=false; v.CanCollide=true end end
    end

    local Time = (Root.Position - pos.Position).Magnitude / C.FlySpeed
    local Tw = TS:Create(Root, TweenInfo.new(Time, Enum.EasingStyle.Linear), {CFrame=pos})
    local Conn = RS.Stepped:Connect(function() for _,v in pairs(C:GetChildren()) do if v:IsA("BasePart") then v.CanCollide=false end end end)
    Tw:Play(); Tw.Completed:Wait(); Conn:Disconnect()
    Root.Anchored=true; wait(0.5); Root.Anchored=false
end

-- [[ TABS & CONTENT ]]
local T1 = AddTab("Auto Mancing")
AddTog(T1, "Auto Fish V3", "Cast + Shake + Reel", false, function(s) C.IsAutoFish=s end)
AddTog(T1, "AFK Level 500", "No-Life Mode (24H)", false, function(s) C.IsAFKLevel=s; C.IsAutoFish=s end)

local T2 = AddTab("Auto Sell")
AddTog(T2, "Auto Sell (Smart)", "Teleport Merchant Terdekat", false, function(s) C.IsAutoSell=s end)

local T3 = AddTab("Pulau & Zone")
local Islands = {
    {"Moosewood", Vec3(380,135,230)}, {"Roslit Bay", Vec3(-1480,132,720)}, {"Terrapin", Vec3(-180,135,1950)},
    {"Snowcap", Vec3(2620,135,2400)}, {"Sunstone", Vec3(-930,132,-1120)}, {"Swamp", Vec3(2450,130,-700)},
    {"Forsaken", Vec3(-2500,132,1550)}, {"Ancient", Vec3(-3150,140,2600)}, {"Statue", Vec3(30,140,-1020)}, {"Arch", Vec3(980,130,-1240)}
}
for _,v in ipairs(Islands) do AddBtn(T3, "TP: "..v[1], function() TP(CF(v[2])) end) end

local T4 = AddTab("Secret Rods")
local Rods = {
    {"Snowcap: Lost Rod", Vec3(2650,140,2450), "2K | Gua Bawah"},
    {"Statue: Kings Rod", Vec3(30,135,-1020), "120K | Bayar Cole"},
    {"Roslit: Magma Rod", Vec3(-1830,165,160), "15K | Auto God Mode!"},
    {"Swamp: Fungal Rod", Vec3(2550,135,-730), "Quest | Alligator"},
    {"Deep: Trident", Vec3(-970,135,1330), "Quest | 5 Relics"},
    {"Forsaken: Scurvy", Vec3(-2550,135,1630), "50K | Pirate Cave"}
}
for _,v in ipairs(Rods) do
    AddBtn(T4, v[1], function()
        if v[1]:find("Magma") then C.IsGodMode=true; Notif("GOD MODE", "Anti-Lava Active!", 3) else C.IsGodMode=false end
        TP(CF(v[2])); Notif("Info", v[3], 5)
    end)
end

local T5 = AddTab("Events & Quests")
AddBtn(T5, "[AUTO] Quest Brick Rod", function()
    local L = {Vec3(-1480,135,720), Vec3(-3150,140,2600), Vec3(-970,135,1330), Vec3(450,150,230)}
    for i,p in ipairs(L) do Notif("Quest", "Step "..i, 3); TP(CF(p)); wait(1) if i==4 then Notif("Done","Talk to NPC!",5) else wait(5) end end
end)
AddBtn(T5, "[AUTO] Find Midas", function()
    local s; for _,v in pairs(WS:GetDescendants()) do if v.Name=="Travelling Merchant" then s=v break end end
    if s then TP(s.PrimaryPart.CFrame*CF(0,10,0)); Notif("Success","Midas Found!",3) else Notif("Fail","Not Spawned",2) end
end)
AddBtn(T5, "[AUTO] Find Sharks", function()
    local t; for _,v in pairs(WS:GetDescendants()) do if v.Name:find("Shark") or v.Name:find("Megalodon") then t=v break end end
    if t then TP(t.PrimaryPart.CFrame*CF(0,20,0)); Notif("Danger","Boss Found!",3) else Notif("Fail","No Boss",2) end
end)

local T6 = AddTab("Visuals")
AddTog(T6, "ESP Player", "Box & Name", false, function(s) C.IsESP=s end)
AddTog(T6, "Vision (NPC)", "Wallhack Rod NPC", false, function(s) C.IsVision=s end)
AddTog(T6, "Infinite Jump", "Spasi di udara", false, function(s) C.IsInfJump=s end)
AddTog(T6, "Fullbright", "Selalu Terang", false, function(s) C.IsFullBright=s; if not s then Lig.ClockTime=12 end end)

local T7 = AddTab("System")
AddTog(T7, "God Mode", "Anti-Lava Roslit", false, function(s) C.IsGodMode=s end)
AddTog(T7, "Walk on Water", "Jalan di Air", false, function(s) C.IsWaterWalk=s end)
AddTog(T7, "NoClip", "Tembus Tembok", false, function(s) C.IsNoClip=s end)
AddTog(T7, "Anti-AFK", "No Disconnect", true, function(s) C.IsAntiAFK=s end)
AddTog(T7, "Anti-Admin", "Auto Kick Staff", true, function(s) C.IsBypass=s end)

local T8 = AddTab("Info")
AddInfo(T8, "Owner", "ZAYANGGGGG"); AddInfo(T8, "UID", "1398015808"); AddInfo(T8, "Ver", "V10 Optimized")

-- =============================================================
-- 6. LOOPS & LOGIC (HIGH SPEED)
-- =============================================================

-- Auto Fish
spawn(function()
    while true do
        wait(0.1)
        if C.IsAutoFish and LP.Character then
            local T = LP.Character:FindFirstChildOfClass("Tool")
            if T and not T:FindFirstChild("bobber") then
                VIM:SendMouseButtonEvent(0,0,0,true,game,1); wait(1)
                VIM:SendMouseButtonEvent(0,0,0,false,game,1); wait(1.5)
            end
        end
    end
end)

RS.Heartbeat:Connect(function()
    if C.IsAutoFish then
        local G = LP:FindFirstChild("PlayerGui")
        if G then
            local S = G:FindFirstChild("shakeui")
            if S and S.Enabled then
                local B = S:FindFirstChild("safezone") and S.safezone:FindFirstChild("button")
                if B and B.Visible then GS.SelectedObject=B; VIM:SendKeyEvent(true,Enum.KeyCode.Return,false,game); VIM:SendKeyEvent(false,Enum.KeyCode.Return,false,game) end
            end
            local R = G:FindFirstChild("reel")
            if R and R.Enabled then
                local Bar = R:FindFirstChild("bar")
                if Bar and Bar:FindFirstChild("fish") and Bar:FindFirstChild("playerbar") then
                    if Bar.fish.Position.X.Scale > Bar.playerbar.Position.X.Scale then VIM:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
                    else VIM:SendKeyEvent(false,Enum.KeyCode.Space,false,game) end
                end
            else VIM:SendKeyEvent(false,Enum.KeyCode.Space,false,game) end
        end
    end
    
    -- Water Walk
    if C.IsWaterWalk and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local H = LP.Character.HumanoidRootPart
        local R = WS:Raycast(H.Position, Vec3(0,-15,0))
        if R and R.Material == Enum.Material.Water then
            if not WS:FindFirstChild("WPlat") then 
                local P = Instance.new("Part", WS); P.Name="WPlat"; P.Anchored=true; P.Transparency=1; P.Size=Vec3(10,1,10)
            end
            WS.WPlat.Position = Vec3(H.Position.X, R.Position.Y-0.5, H.Position.Z)
        elseif WS:FindFirstChild("WPlat") then WS.WPlat:Destroy() end
    end
    
    -- God Mode
    if C.IsGodMode and LP.Character then
        local H = LP.Character:FindFirstChild("Humanoid")
        if H then H:SetStateEnabled(15, false); if H.Health<100 then H.Health=100 end end
        for _,v in pairs(WS:GetDescendants()) do if v.Name=="Lava" then v.CanTouch=false; v.CanCollide=true end end
    end
    
    -- Fullbright
    if C.IsFullBright then Lig.ClockTime=12; Lig.Brightness=2 end
end)

-- Auto Sell
spawn(function()
    while true do
        wait(1)
        if C.IsAutoSell and LP.Character then
            if not C.SavedPosition then C.SavedPosition = LP.Character.HumanoidRootPart.CFrame end
            local M, D = nil, 9e9
            for _,v in pairs(WS:GetDescendants()) do 
                if v.Name=="Merchant" and v:FindFirstChild("HumanoidRootPart") then
                    local d = (LP.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if d < D then D=d; M=v end
                end
            end
            if M and D > 15 then TP(M.HumanoidRootPart.CFrame*CF(0,0,3)) end
        elseif not C.IsAutoSell and C.SavedPosition and LP.Character then
            if (LP.Character.HumanoidRootPart.Position - C.SavedPosition.Position).Magnitude > 15 then
                TP(C.SavedPosition); C.SavedPosition=nil
            end
        end
    end
end)

-- Visuals
spawn(function()
    while true do
        wait(1)
        for _,v in pairs(WS:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                if C.IsVision and (v.Name:find("Merchant") or v.Name:find("Orc")) then
                    if not v:FindFirstChild("Vis") then 
                        local h=Make("Highlight",{Parent=v,Name="Vis",FillColor=T.NPC,OutlineColor=RGB(255,255,255),DepthMode=0})
                        Make("BillboardGui",{Parent=v.Head,Name="Info",Size=UD2(0,100,0,50),AlwaysOnTop=true,Children={
                            Make("TextLabel",{Size=UD2(1,0,1,0),BackgroundTransparency=1,Text=v.Name,TextColor3=T.NPC,Font=2,TextSize=10})
                        }})
                    end
                elseif not C.IsVision and v:FindFirstChild("Vis") then v.Vis:Destroy(); if v.Head:FindFirstChild("Info") then v.Head.Info:Destroy() end end
            end
        end
        for _,p in pairs(Plrs:GetPlayers()) do
            if p~=LP and p.Character then
                if C.IsESP then
                    if not p.Character:FindFirstChild("ESP") then Make("Highlight",{Parent=p.Character,Name="ESP",FillColor=T.ESP,DepthMode=0}) end
                elseif p.Character:FindFirstChild("ESP") then p.Character.ESP:Destroy() end
            end
        end
    end
end)

-- Security
spawn(function()
    LP.Idled:Connect(function() if C.IsAntiAFK then VU:CaptureController(); VU:ClickButton2(Vector2.new()) end end)
    while wait(5) do
        if C.IsBypass then
            for _,p in pairs(Plrs:GetPlayers()) do
                if p~=LP then
                    local s,r = pcall(function() return p:GetRoleInGroup(C.GrpID) end)
                    if s and r then for _,b in ipairs(C.Bad) do if r==b then LP:Kick("Staff: "..p.Name) end end end
                end
            end
        end
    end
end)

-- Noclip & InfJump
RS.Stepped:Connect(function() if C.IsNoClip and LP.Character then for _,v in pairs(LP.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide=false end end end end)
UIS.JumpRequest:Connect(function() if C.IsInfJump and LP.Character then LP.Character.Humanoid:ChangeState(3) end end)

-- Finish Boot
Screen.Enabled = true
spawn(function()
    Notif("WELCOME USER", "ZAYANGGGGG", 3)
    Main.Size = UD2(0,0,0,0); TS:Create(Main,TweenInfo.new(0.5,Enum.EasingStyle.Back),{Size=UD2(0,600,0,400)}):Play()
end)
