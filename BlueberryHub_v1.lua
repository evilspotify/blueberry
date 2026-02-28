-- =============================================
-- BLUEBERRY BY EVIL SPOTIFY v1.0
-- =============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local BadgeService = game:GetService("BadgeService")
local SoundService = game:GetService("SoundService")
local LocalPlayer  = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name                = "Blueberry by Evil Spotify",
    LoadingTitle        = "Blueberry by Evil Spotify",
    LoadingSubtitle     = "discord: evilspotify91",
    ConfigurationSaving = { Enabled = false },
    Discord             = { Enabled = false },
    KeySystem           = false,
    Theme               = "AmberGlow",
})

-- =============================================
-- HELPERS
-- =============================================
local function getChar() return LocalPlayer.Character end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function tpTo(part)
    local root = getRoot()
    if root and part then
        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
        task.wait(0.25)
    end
end

local BADGE_IDS = {
    Pi               = 2622044173674686,
    EggDog           = 1951664242801429,
    MeetAlrgie       = 1444255831764446,
    YouGotTrolled    = 2879000331507688,
    TrashGoblin      = 1998689686970017,
    Wallhopper       = 1837244855116021,
    TycoonSpecialist = 2953771109176999,
    Exile            = 2081183638453753,
    Returner         = 2893017065272102,
    Donator          = 2122358865905122,
    Suffering        = 642205659509667,
    SoulSearcher     = 3223335317350415,
    Lost             = 3662530188070855,
    WiseWords        = 703246390439638,
    Connected        = 104220730417062,
    ItsASign         = 548997454283853,
    Imposter         = 3625300173152558,
    BlueberryWatcher = 1364826168152608,
    WhatWasThat      = 44050631340663,
    DayRuined        = 3411949610666527,
    TheBachelor      = 666001482850769,
    Hoarder          = 409778894338841,
    Slayer           = 259350670205217,
    TheTeam          = 692405220887262,
}

local function hasBadge(id)
    local ok, res = pcall(function()
        return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, id)
    end)
    return ok and res
end

-- =============================================
-- STAGE TELEPORT
-- =============================================
local function teleportToStage(n)
    n = math.clamp(math.floor(tonumber(n) or 1), 1, 31)
    pcall(function()
        RS:WaitForChild("ChangeStageByTechy"):FireServer(n)
    end)
    task.wait(0.3)
    local root = getRoot()
    if not root then return end
    local spawns = workspace:FindFirstChild("Spawns")
    if spawns then
        local part = spawns:FindFirstChild(tostring(n))
        if part and part:IsA("BasePart") then
            root.CFrame = part.CFrame + Vector3.new(0, 6, 0)
            return
        end
    end
    local stages = workspace:FindFirstChild("Stages")
    if stages then
        local part = stages:FindFirstChild(tostring(n))
        if part and part:IsA("BasePart") then
            root.CFrame = part.CFrame + Vector3.new(0, 6, 0)
        end
    end
end

-- =============================================
-- BOSS: NO-COLLIDE + FLING PREVENTION
-- =============================================
local touchDefenseConn     = nil
local noCollideConstraints = {}

local function applyNoCollide()
    pcall(function()
        local char      = getChar()
        local bossModel = workspace:FindFirstChild("BlueberryBossfight")
            and workspace.BlueberryBossfight:FindFirstChild("Bossberry")
        if not char or not bossModel then return end
        for _, c in ipairs(noCollideConstraints) do pcall(function() c:Destroy() end) end
        noCollideConstraints = {}
        local charParts = {}
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then table.insert(charParts, p) end
        end
        for _, bossPart in ipairs(bossModel:GetDescendants()) do
            if bossPart:IsA("BasePart") then
                for _, charPart in ipairs(charParts) do
                    local nc = Instance.new("NoCollisionConstraint")
                    nc.Part0 = bossPart
                    nc.Part1 = charPart
                    nc.Parent = charPart
                    table.insert(noCollideConstraints, nc)
                end
            end
        end
    end)
end

local function cleanNoCollide()
    for _, c in ipairs(noCollideConstraints) do pcall(function() c:Destroy() end) end
    noCollideConstraints = {}
end

-- ============================================================
-- TAB 1: MAIN
-- ============================================================
local MainTab = Window:CreateTab("Main", nil)

-- SECTION: Teleport
MainTab:CreateSection("Teleport to Stage")

local selectedStage = 1
MainTab:CreateInput({
    Name                     = "Stage Number (1-31)",
    PlaceholderText          = "Enter a number...",
    RemoveTextAfterFocusLost = false,
    Callback = function(val)
        local n = tonumber(val)
        if n then selectedStage = math.clamp(math.floor(n), 1, 31) end
    end,
})

MainTab:CreateButton({
    Name = "Teleport Now",
    Callback = function()
        teleportToStage(selectedStage)
        Rayfield:Notify({ Title = "Teleport", Content = "Stage " .. selectedStage, Duration = 2 })
    end,
})

MainTab:CreateSection("Autocomplete Stages")

local stageAutoRunning = false
MainTab:CreateButton({
    Name = "Autocomplete Stages (1 to 31)",
    Callback = function()
        if stageAutoRunning then
            Rayfield:Notify({ Title = "Already Running", Content = "Stop it first.", Duration = 2 })
            return
        end
        task.spawn(function()
            stageAutoRunning = true
            Rayfield:Notify({ Title = "Autocomplete", Content = "Running stages 1 to 31...", Duration = 3 })
            for i = 1, 31 do
                if not stageAutoRunning then break end
                teleportToStage(i)
                task.wait(0.5)
            end
            stageAutoRunning = false
            Rayfield:Notify({ Title = "Autocomplete", Content = "Done!", Duration = 3 })
        end)
    end,
})

MainTab:CreateButton({
    Name = "Stop Autocomplete",
    Callback = function()
        stageAutoRunning = false
        Rayfield:Notify({ Title = "Autocomplete", Content = "Stopped.", Duration = 2 })
    end,
})

MainTab:CreateSection("Quick Stages")

local quickStages = {
    { n = 1,  label = "Stage 1  — Start"     },
    { n = 5,  label = "Stage 5"              },
    { n = 10, label = "Stage 10"             },
    { n = 15, label = "Stage 15"             },
    { n = 20, label = "Stage 20"             },
    { n = 25, label = "Stage 25"             },
    { n = 30, label = "Stage 30 — Boss"      },
    { n = 31, label = "Stage 31 — Secret"    },
}
for _, e in ipairs(quickStages) do
    MainTab:CreateButton({
        Name = e.label,
        Callback = function()
            selectedStage = e.n
            teleportToStage(e.n)
            Rayfield:Notify({ Title = "Teleport", Content = e.label, Duration = 2 })
        end,
    })
end

-- SECTION: Stage Tricks
MainTab:CreateSection("Stage Tricks")

MainTab:CreateButton({
    Name = "Autocomplete Pi (Stage 11)",
    Callback = function()
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local piTimer = pg and pg:FindFirstChild("PiTimer")
            if not piTimer then
                Rayfield:Notify({ Title = "Pi", Content = "Go to stage 11 and wait for the challenge.", Duration = 4 })
                return
            end
            local bg = piTimer:FindFirstChild("Background")
            if not bg or not bg.Visible then
                Rayfield:Notify({ Title = "Pi", Content = "Challenge not active yet.", Duration = 3 })
                return
            end
            local tb = bg:FindFirstChildOfClass("TextBox") or bg:FindFirstChild("TextBox")
            if not tb then Rayfield:Notify({ Title = "Pi", Content = "TextBox not found.", Duration = 3 }) return end
            tb.Text = "3.141592653"
            Rayfield:Notify({ Title = "Pi", Content = "Done!", Duration = 2 })
        end)
    end,
})

MainTab:CreateButton({
    Name = "Delete Pi Trigger (Stage 11)",
    Callback = function()
        pcall(function()
            local pt = workspace:FindFirstChild("PiTrigger")
            if pt then
                pt:Destroy()
                Rayfield:Notify({ Title = "Pi Trigger", Content = "Deleted — no more forced Pi challenge.", Duration = 3 })
            else
                Rayfield:Notify({ Title = "Pi Trigger", Content = "Not found — wrong stage or already deleted.", Duration = 3 })
            end
        end)
    end,
})

local doorLoopConn = nil
MainTab:CreateToggle({
    Name = "Keep Secret Doors Open (Stage 10)",
    CurrentValue = false,
    Flag = "DoorLoop",
    Callback = function(val)
        if val then
            local folder = workspace:FindFirstChild("OpenDoorsYes")
            if not folder then
                Rayfield:Notify({ Title = "Error", Content = "Not on stage 10.", Duration = 3 })
                return
            end
            local function openAll()
                for _, door in ipairs(folder:GetChildren()) do
                    if door:IsA("BasePart") then
                        door.CanCollide    = false
                        door.Transparency  = 1
                        local d = door:FindFirstChildOfClass("Decal")
                        if d then d.Transparency = 1 end
                    end
                end
            end
            openAll()
            doorLoopConn = RunService.Heartbeat:Connect(function() pcall(openAll) end)
            Rayfield:Notify({ Title = "Secret Doors", Content = "Staying open.", Duration = 2 })
        else
            if doorLoopConn then doorLoopConn:Disconnect() doorLoopConn = nil end
            Rayfield:Notify({ Title = "Secret Doors", Content = "Off.", Duration = 2 })
        end
    end,
})

MainTab:CreateButton({
    Name = "Flash All Stages White",
    Callback = function()
        pcall(function()
            local stages = workspace:FindFirstChild("Stages")
            if not stages then
                Rayfield:Notify({ Title = "Error", Content = "Stages folder not found.", Duration = 3 })
                return
            end
            local count = 0
            for _, stage in ipairs(stages:GetChildren()) do
                if stage:IsA("BasePart") then
                    local orig = stage.Color
                    stage.Color = Color3.fromRGB(255, 255, 255)
                    count += 1
                    task.delay(2, function()
                        pcall(function()
                            TweenService:Create(stage, TweenInfo.new(1), { Color = orig }):Play()
                        end)
                    end)
                end
            end
            Rayfield:Notify({ Title = "Stages", Content = "Flashed " .. count .. " stages.", Duration = 3 })
        end)
    end,
})

-- Glass Bridge (Stage 21 area) — Parts with a Decal child = fake/deadly, without = safe
-- Highlights safe tiles green so you know which to step on
local glassBridgeESPActive = false
local glassBridgeHighlights = {}
MainTab:CreateToggle({
    Name         = "Glass Bridge ESP (Stage 2)",
    CurrentValue = false,
    Flag         = "GlassBridgeESP",
    Callback = function(val)
        glassBridgeESPActive = val
        if val then
            -- Find the glass bridge model: unnamed Model whose parts have Decal children
            -- Confirmed at workspace:GetChildren()[185] but search dynamically to be safe
            local bridgeModel = nil
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Model" then
                    local partCount  = 0
                    local decalCount = 0
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("BasePart") then
                            partCount += 1
                            if child:FindFirstChildOfClass("Decal") then
                                decalCount += 1
                            end
                        end
                    end
                    -- Glass bridge has ~18 parts and several have Decals
                    if partCount >= 10 and decalCount >= 4 then
                        bridgeModel = obj
                        break
                    end
                end
            end
            if not bridgeModel then
                Rayfield:Notify({ Title = "Glass Bridge", Content = "Not found — go to stage 2 first.", Duration = 3 })
                return
            end
            local safe, fake = 0, 0
            for _, part in ipairs(bridgeModel:GetChildren()) do
                if part:IsA("BasePart") and part.Name == "Part" then
                    local hasDecal = part:FindFirstChildOfClass("Decal") ~= nil
                    local h = Instance.new("Highlight")
                    h.Name             = "_GlassESP"
                    h.DepthMode        = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency = 0.3
                    if hasDecal then
                        -- Fake glass — red
                        h.FillColor    = Color3.fromRGB(255, 50, 50)
                        h.OutlineColor = Color3.fromRGB(255, 0, 0)
                        fake += 1
                    else
                        -- Safe glass — green
                        h.FillColor    = Color3.fromRGB(50, 255, 50)
                        h.OutlineColor = Color3.fromRGB(0, 200, 0)
                        safe += 1
                    end
                    h.Parent = part
                    table.insert(glassBridgeHighlights, h)
                end
            end
            Rayfield:Notify({ Title = "Glass Bridge", Content = safe .. " safe (green), " .. fake .. " fake (red).", Duration = 4 })
        else
            for _, h in ipairs(glassBridgeHighlights) do
                pcall(function() h:Destroy() end)
            end
            glassBridgeHighlights = {}
            Rayfield:Notify({ Title = "Glass Bridge", Content = "ESP off.", Duration = 2 })
        end
    end,
})

-- SECTION: Tycoon (Stage 12)
MainTab:CreateSection("Tycoon (Stage 12)")

MainTab:CreateButton({
    Name = "Get All Tycoon Items",
    Callback = function()
        pcall(function()
            local got = {}
            for _, name in ipairs({ "Blueberry", "Bread", "BlueberryPie" }) do
                local tool = RS:FindFirstChild(name)
                if tool then
                    local ex = LocalPlayer.Backpack:FindFirstChild(name)
                        or (getChar() and getChar():FindFirstChild(name))
                    if ex then ex:Destroy() end
                    tool:Clone().Parent = LocalPlayer.Backpack
                    table.insert(got, name)
                end
            end
            Rayfield:Notify({ Title = "Tycoon Items", Content = table.concat(got, ", ") .. " added.", Duration = 3 })
        end)
    end,
})

MainTab:CreateButton({
    Name = "Unlock Tycoon Door",
    Callback = function()
        pcall(function()
            local door = workspace:FindFirstChild("TycoonDoor")
            if door then
                door.CanCollide   = false
                door.Transparency = 1
                local d = door:FindFirstChildOfClass("Decal")
                if d then d.Transparency = 1 end
                local t = door:FindFirstChildOfClass("Texture")
                if t then t.Transparency = 1 end
            end
            local hidden = workspace:FindFirstChild("Invisibletycoondoorpartfrfr")
            if hidden then hidden.CanCollide = false hidden.Transparency = 1 end
            Rayfield:Notify({ Title = "Tycoon Door", Content = "Door removed.", Duration = 2 })
        end)
    end,
})

-- SECTION: Player
MainTab:CreateSection("Player")

MainTab:CreateSlider({
    Name         = "Walk Speed",
    Range        = { 16, 150 },
    Increment    = 1,
    Suffix       = " studs/s",
    CurrentValue = 16,
    Flag         = "WalkSpeed",
    Callback = function(val)
        _G.CustomWalkSpeed = val
        local h = getHum()
        if h then h.WalkSpeed = val end
    end,
})

LocalPlayer.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid")
    task.wait(0.1)
    if _G.CustomWalkSpeed then h.WalkSpeed = _G.CustomWalkSpeed end
end)

-- Fly
local FLYING    = false
local flyKeyDown, flyKeyUp
local UserInputService = game:GetService("UserInputService")
local flySpeed  = 1

local function sFLY()
    local char     = getChar()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local T        = getRoot()
    if not T or not humanoid then return end

    local CONTROL  = {F=0, B=0, L=0, R=0, Q=0, E=0}
    local lCONTROL = {F=0, B=0, L=0, R=0, Q=0, E=0}
    local SPEED    = 0

    FLYING = true
    local BG = Instance.new("BodyGyro")
    local BV = Instance.new("BodyVelocity")
    BG.P          = 9e4
    BG.MaxTorque  = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame     = T.CFrame
    BG.Parent     = T
    BV.Velocity   = Vector3.new(0,0,0)
    BV.MaxForce   = Vector3.new(9e9, 9e9, 9e9)
    BV.Parent     = T

    task.spawn(function()
        repeat task.wait()
            local cam = workspace.CurrentCamera
            humanoid.PlatformStand = true
            local moving = CONTROL.L+CONTROL.R ~= 0 or CONTROL.F+CONTROL.B ~= 0 or CONTROL.Q+CONTROL.E ~= 0
            if moving then
                SPEED = 50 * flySpeed
                BV.Velocity = ((cam.CFrame.LookVector*(CONTROL.F+CONTROL.B))
                    + ((cam.CFrame*CFrame.new(CONTROL.L+CONTROL.R,(CONTROL.F+CONTROL.B+CONTROL.Q+CONTROL.E)*0.2,0).p)-cam.CFrame.p)) * SPEED
                lCONTROL = {F=CONTROL.F,B=CONTROL.B,L=CONTROL.L,R=CONTROL.R}
            else
                BV.Velocity = Vector3.new(0,0,0)
            end
            BG.CFrame = cam.CFrame
        until not FLYING
        BG:Destroy() BV:Destroy()
        if humanoid then humanoid.PlatformStand = false end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
    end)

    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp   then flyKeyUp:Disconnect()   end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if     input.KeyCode == Enum.KeyCode.W then CONTROL.F =  flySpeed
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -flySpeed
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -flySpeed
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R =  flySpeed
        end
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if     input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 lCONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 lCONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 lCONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 lCONTROL.R = 0
        end
    end)
end

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp   then flyKeyUp:Disconnect()   flyKeyUp   = nil end
    pcall(function()
        local char = getChar()
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end)
end

MainTab:CreateToggle({
    Name         = "Fly",
    CurrentValue = false,
    Flag         = "FlyToggle",
    Callback = function(val)
        if val then sFLY()
        else        NOFLY() end
    end,
})

MainTab:CreateSlider({
    Name         = "Fly Speed",
    Range        = { 1, 5 },
    Increment    = 1,
    CurrentValue = 1,
    Flag         = "FlySpeed",
    Callback = function(val)
        flySpeed = val
    end,
})

MainTab:CreateToggle({
    Name         = "Noclip",
    CurrentValue = false,
    Flag         = "Noclip",
    Callback = function(val)
        _G.NoclipOn = val
        if val then
            _G.NoclipConn = RunService.Stepped:Connect(function()
                if not _G.NoclipOn then return end
                local char = getChar()
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        else
            if _G.NoclipConn then _G.NoclipConn:Disconnect() _G.NoclipConn = nil end
            local char = getChar()
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local h = getHum()
        if h then h.Health = 0 end
    end,
})

-- SECTION: Death Popup
MainTab:CreateSection("Death Popup")

-- Keep BlueberryPopUpp.Enabled=false and destroy all Frame children every frame.
-- Also suppresses TroubleScreen, BlueberryNicheGUI, JumpScare (angry bird gamepass), KillbrickScare.
local autoDismiss  = false
local dismissConn2 = nil
local SUPPRESS_GUIS   = { "JumpScare", "KillbrickScare", "TroubleScreen" }
local SUPPRESS_ALWAYS = { "BlueberryNicheGUI" } -- never restore, off by default

-- Permanently suppress BlueberryNicheGUI — it should never show client-side
RunService.Heartbeat:Connect(function()
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, name in ipairs(SUPPRESS_ALWAYS) do
            local g = pg:FindFirstChild(name)
            if g and g.Enabled then g.Enabled = false end
        end
    end)
end)
MainTab:CreateToggle({
    Name         = "Block Death Popups",
    CurrentValue = false,
    Flag         = "AutoDismiss",
    Callback = function(val)
        autoDismiss = val
        if val then
            if dismissConn2 then dismissConn2:Disconnect() end
            dismissConn2 = RunService.Heartbeat:Connect(function()
                if not autoDismiss then return end
                pcall(function()
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    if not pg then return end
                    -- Main death popup
                    local pu = pg:FindFirstChild("BlueberryPopUpp")
                    if pu then
                        if pu.Enabled then pu.Enabled = false end
                        for _, child in ipairs(pu:GetChildren()) do
                            if child:IsA("Frame") then
                                pcall(function() child:Destroy() end)
                            end
                        end
                    end
                    -- Other nuisance GUIs — just keep disabled
                    for _, name in ipairs(SUPPRESS_GUIS) do
                        local g = pg:FindFirstChild(name)
                        if g and g.Enabled then g.Enabled = false end
                    end
                end)
            end)
            Rayfield:Notify({ Title = "Popups", Content = "Blocked.", Duration = 2 })
        else
            if dismissConn2 then dismissConn2:Disconnect() dismissConn2 = nil end
            -- Restore all suppressed GUIs
            pcall(function()
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if not pg then return end
                local pu = pg:FindFirstChild("BlueberryPopUpp")
                if pu then pu.Enabled = true end
                for _, name in ipairs(SUPPRESS_GUIS) do
                    local g = pg:FindFirstChild(name)
                    if g then g.Enabled = true end
                end
            end)
            Rayfield:Notify({ Title = "Popups", Content = "Restored.", Duration = 2 })
        end
    end,
})

-- SECTION: Boss Fight
MainTab:CreateSection("Boss Fight")

MainTab:CreateButton({
    Name = "Teleport to Boss Arena",
    Callback = function()
        pcall(function()
            local bossfight = workspace:FindFirstChild("BlueberryBossfight")
            if bossfight then
                local arena = bossfight:FindFirstChild("BossArena")
                local root  = getRoot()
                if root and arena and arena:IsA("BasePart") then
                    root.CFrame = arena.CFrame + Vector3.new(0, 5, 0)
                    Rayfield:Notify({ Title = "Boss", Content = "Teleported to arena.", Duration = 2 })
                    return
                end
            end
            teleportToStage(30)
            Rayfield:Notify({ Title = "Boss", Content = "Teleported to stage 30.", Duration = 2 })
        end)
    end,
})

local bossDefenseActive = false
local bossDefenseConn   = nil
local ATTACK_PARTS      = { Shockwave = true, AttackWarning = true, Hitbox = true }

MainTab:CreateToggle({
    Name         = "Stop All Boss Attacks",
    CurrentValue = false,
    Flag         = "BossDefenseAll",
    Callback = function(val)
        bossDefenseActive = val
        if val then
            if bossDefenseConn then bossDefenseConn:Disconnect() end
            bossDefenseConn = workspace.DescendantAdded:Connect(function(obj)
                if bossDefenseActive and obj:IsA("BasePart") and ATTACK_PARTS[obj.Name] then
                    task.defer(function()
                        pcall(function() if obj and obj.Parent then obj:Destroy() end end)
                    end)
                end
            end)
            Rayfield:Notify({ Title = "Boss Defense", Content = "All 3 attacks blocked.", Duration = 3 })
        else
            if bossDefenseConn then bossDefenseConn:Disconnect() bossDefenseConn = nil end
            Rayfield:Notify({ Title = "Boss Defense", Content = "Off.", Duration = 2 })
        end
    end,
})

MainTab:CreateToggle({
    Name         = "Prevent Fling + Touch Damage",
    CurrentValue = false,
    Flag         = "BossTouchDefense",
    Callback = function(val)
        if val then
            applyNoCollide()
            if touchDefenseConn then touchDefenseConn:Disconnect() end
            touchDefenseConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = getChar()
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not hum or not root then return end
                    -- Only lock health when it's actually dropping, avoids jump interference
                    if hum.Health > 0 and hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                    if hum.Sit then hum.Sit = false end
                    local vel = root.AssemblyLinearVelocity
                    if vel.Y > 20 then
                        root.AssemblyLinearVelocity = Vector3.new(vel.X * 0.2, 0, vel.Z * 0.2)
                    end
                end)
            end)
            LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if touchDefenseConn then applyNoCollide() end
            end)
            Rayfield:Notify({ Title = "Anti-Fling", Content = "No-collide applied to all Bossberry parts.", Duration = 3 })
        else
            if touchDefenseConn then touchDefenseConn:Disconnect() touchDefenseConn = nil end
            cleanNoCollide()
            Rayfield:Notify({ Title = "Anti-Fling", Content = "Off.", Duration = 2 })
        end
    end,
})

-- Mute all Bossberry audio — voice lines + attack sounds + death sound
-- Voice lines: Head.Voice folder ("Prepare thyself!", "Useless...", etc.)
-- Attack sounds: Kame, Magic on Torso; Stomp, LegRaise on legs
-- Death sound: rbxassetid://7468131335 (in BossArena)
local bossAudioMuted = false
local bossAudioVolumes = {}
MainTab:CreateToggle({
    Name         = "Mute All Boss Audio",
    CurrentValue = false,
    Flag         = "BossAudioMute",
    Callback = function(val)
        bossAudioMuted = val
        pcall(function()
            local bossfight = workspace:FindFirstChild("BlueberryBossfight")
            if not bossfight then
                Rayfield:Notify({ Title = "Boss Audio", Content = "BlueberryBossfight not loaded yet.", Duration = 3 })
                return
            end
            -- Mute everything inside the entire bossfight model (Bossberry + BossArena death sound)
            for _, obj in ipairs(bossfight:GetDescendants()) do
                if obj:IsA("Sound") then
                    if val then
                        bossAudioVolumes[obj] = obj.Volume
                        obj.Volume = 0
                    else
                        if bossAudioVolumes[obj] then
                            obj.Volume = bossAudioVolumes[obj]
                            bossAudioVolumes[obj] = nil
                        end
                    end
                end
            end
        end)
        Rayfield:Notify({ Title = "Boss Audio", Content = val and "All boss sounds muted." or "Restored.", Duration = 2 })
    end,
})

MainTab:CreateButton({
    Name = "Clone Rocket Launcher",
    Callback = function()
        pcall(function()
            local bossStuff = RS:FindFirstChild("BossStuff")
            local rl = bossStuff and bossStuff:FindFirstChild("RocketLauncher")
            if rl then
                rl:Clone().Parent = LocalPlayer.Backpack
                Rayfield:Notify({ Title = "Rocket Launcher", Content = "Added to backpack.", Duration = 2 })
            else
                Rayfield:Notify({ Title = "Error", Content = "RocketLauncher not found in RS.BossStuff.", Duration = 3 })
            end
        end)
    end,
})

MainTab:CreateToggle({
    Name         = "Bossberry ESP",
    CurrentValue = false,
    Flag         = "BossESP",
    Callback = function(val)
        pcall(function()
            local boss = workspace:FindFirstChild("BlueberryBossfight")
                and workspace.BlueberryBossfight:FindFirstChild("Bossberry")
            if not boss then
                Rayfield:Notify({ Title = "Error", Content = "Bossberry not loaded yet.", Duration = 2 })
                return
            end
            local existing = boss:FindFirstChild("_BossESP")
            if val and not existing then
                local h = Instance.new("Highlight")
                h.Name             = "_BossESP"
                h.FillColor        = Color3.fromRGB(255, 30, 30)
                h.OutlineColor     = Color3.fromRGB(255, 0, 0)
                h.FillTransparency = 0.35
                h.Parent           = boss
            elseif not val and existing then
                existing:Destroy()
            end
        end)
    end,
})

-- ============================================================
-- TAB 2: BADGES
-- ============================================================
local BadgeTab = Window:CreateTab("Badges", nil)

-- Blueberry Watcher like counter
local likeInfo = "Loading..."
task.spawn(function()
    task.wait(1)
    pcall(function()
        local lb    = workspace:FindFirstChild("LikeBoard")
        local sg    = lb and lb:FindFirstChildOfClass("SurfaceGui")
        local frame = sg and sg:FindFirstChild("Frame")
        local pb    = frame and frame:FindFirstChild("ProgressBackground")
        local pl    = pb and pb:FindFirstChild("ProgressLabel")
        if pl then
            likeInfo = pl.Text
        else
            likeInfo = "Not found"
        end
    end)
end)
task.wait(1.2)
BadgeTab:CreateLabel("Blueberry Watcher likes: " .. likeInfo)

BadgeTab:CreateSection("Badges")

-- Imposter toggle
local imposterActive = false
local imposterConn   = nil
local IMPOSTER_NAMES = { "RaspberryNiche", "StrawberryNiche", "RedNiche", "Imposter", "RaspNiche" }

local function handleImposterFound(obj)
    if not imposterActive then return end
    local pos = nil
    if obj:IsA("BasePart") then
        pos = obj.Position
    elseif obj:IsA("Model") then
        local pp = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
        if pp then pos = pp.Position end
    end
    if not pos then return end
    local root = getRoot()
    if root then root.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0)) end
    Rayfield:Notify({ Title = "Imposter!", Content = obj.Name .. " spawned — teleporting!", Duration = 5 })
    imposterActive = false
    if imposterConn then imposterConn:Disconnect() imposterConn = nil end
end

BadgeTab:CreateToggle({
    Name         = "Imposter (watches for raspberry — Stage 5)",
    CurrentValue = false,
    Flag         = "ImposterWatch",
    Callback = function(val)
        imposterActive = val
        if val then
            -- Check if already spawned in workspace right now
            for _, name in ipairs(IMPOSTER_NAMES) do
                local found = workspace:FindFirstChild(name) -- NOT recursive
                if found then
                    handleImposterFound(found)
                    return
                end
            end
            -- Watch for it spawning
            if imposterConn then imposterConn:Disconnect() end
            imposterConn = workspace.ChildAdded:Connect(function(obj)
                for _, name in ipairs(IMPOSTER_NAMES) do
                    if obj.Name == name then
                        handleImposterFound(obj)
                        return
                    end
                end
            end)
            Rayfield:Notify({ Title = "Imposter", Content = "Watching for raspberry on stage 5...", Duration = 3 })
        else
            if imposterConn then imposterConn:Disconnect() imposterConn = nil end
            Rayfield:Notify({ Title = "Imposter", Content = "Stopped.", Duration = 2 })
        end
    end,
})

-- Trash Goblin
local trashRunning = false
BadgeTab:CreateButton({
    Name = "Trash Goblin (Stage 17)",
    Callback = function()
        if trashRunning then
            Rayfield:Notify({ Title = "Trash Goblin", Content = "Already running!", Duration = 2 })
            return
        end
        task.spawn(function()
            trashRunning = true
            local part = workspace:FindFirstChild("Trash1")
            if not part then
                for i = 2, 9 do
                    part = workspace:FindFirstChild("Trash" .. i)
                    if part then break end
                end
            end
            if not part then
                Rayfield:Notify({ Title = "Error", Content = "No trash cans found. On stage 17?", Duration = 3 })
                trashRunning = false
                return
            end
            local prox = part:FindFirstChild("Prox")
            if not prox then
                Rayfield:Notify({ Title = "Error", Content = "ProximityPrompt not found on trash.", Duration = 3 })
                trashRunning = false
                return
            end
            tpTo(part)
            pcall(function() prox.HoldDuration = 0 end)
            Rayfield:Notify({ Title = "Trash Goblin", Content = "Rapid firing... stay put!", Duration = 4 })
            local attempts = 0
            while trashRunning do
                fireproximityprompt(prox)
                attempts += 1
                task.wait(0.05)
                if attempts % 15 == 0 then
                    local ok, owned = pcall(function()
                        return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, BADGE_IDS.TrashGoblin)
                    end)
                    if ok and owned then
                        trashRunning = false
                        Rayfield:Notify({ Title = "Trash Goblin", Content = "Got it after " .. attempts .. " tries!", Duration = 5 })
                        break
                    end
                end
            end
            trashRunning = false
        end)
    end,
})


BadgeTab:CreateButton({
    Name = "Lost (Stage 7)",
    Callback = function()
        pcall(function()
            local part = workspace:FindFirstChild("Lost Badge")
            if not part then Rayfield:Notify({ Title = "Error", Content = "Part not found.", Duration = 3 }) return end
            tpTo(part)
            Rayfield:Notify({ Title = "Lost", Content = "Teleporting...", Duration = 2 })
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Wise Words (Stage 13)",
    Callback = function()
        pcall(function()
            local luis
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChild("dialogScript") and obj:FindFirstChild("VarietyShades02") then
                    luis = obj
                    break
                end
            end
            if not luis then
                Rayfield:Notify({ Title = "Error", Content = "Luis NPC not found.", Duration = 3 })
                return
            end
            local torso = luis:FindFirstChild("Torso")
            if torso then tpTo(torso) end
            local prompt = torso and torso:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                Rayfield:Notify({ Title = "Wise Words", Content = "Talking to Luis...", Duration = 2 })
            else
                Rayfield:Notify({ Title = "Wise Words", Content = "Teleported — no prompt found.", Duration = 3 })
            end
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "You Got Trolled (Stage 18)",
    Callback = function()
        pcall(function()
            local part = workspace:FindFirstChild("Trolled Badge")
            if not part then Rayfield:Notify({ Title = "Error", Content = "Part not found.", Duration = 3 }) return end
            tpTo(part)
            Rayfield:Notify({ Title = "You Got Trolled", Content = "Teleporting...", Duration = 2 })
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Wallhopper (Stage 18)",
    Callback = function()
        pcall(function()
            local part = workspace:FindFirstChild("Wallhopper Badge")
            if not part then Rayfield:Notify({ Title = "Error", Content = "Part not found.", Duration = 3 }) return end
            tpTo(part)
            Rayfield:Notify({ Title = "Wallhopper", Content = "Teleporting...", Duration = 2 })
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Egg Dog (Stage 2)",
    Callback = function()
        pcall(function()
            local eggdog = workspace:FindFirstChild("Meshes/eggdog")
            if not eggdog then Rayfield:Notify({ Title = "Error", Content = "Eggdog not found.", Duration = 3 }) return end
            local prompt = eggdog:FindFirstChildOfClass("ProximityPrompt")
            if not prompt then Rayfield:Notify({ Title = "Error", Content = "Prompt missing.", Duration = 3 }) return end
            tpTo(eggdog)
            fireproximityprompt(prompt)
            Rayfield:Notify({ Title = "Egg Dog", Content = "Getting badge...", Duration = 2 })
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Soul Searcher",
    Callback = function()
        task.spawn(function()
            pcall(function()
                local folder = workspace:FindFirstChild("FairySouls")
                if not folder then
                    Rayfield:Notify({ Title = "Error", Content = "FairySouls folder not found.", Duration = 3 })
                    return
                end
                local FairySoulMessage = RS:WaitForChild("FairySoulMessage", 5)
                if not FairySoulMessage then
                    Rayfield:Notify({ Title = "Error", Content = "FairySoulMessage remote not found.", Duration = 3 })
                    return
                end
                local count   = 0
                local total   = 0
                local parts   = {}
                for _, soul in ipairs(folder:GetChildren()) do
                    if soul:IsA("BasePart") and soul:FindFirstChildOfClass("ClickDetector") then
                        table.insert(parts, soul)
                    end
                end
                total = #parts
                Rayfield:Notify({ Title = "Soul Searcher", Content = "Found " .. total .. " souls. Collecting...", Duration = 3 })

                for _, soul in ipairs(parts) do
                    local cd   = soul:FindFirstChildOfClass("ClickDetector")
                    local root = getRoot()
                    if not cd or not root then continue end

                    -- TP directly onto soul
                    root.CFrame = soul.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.15)

                    -- Listen for server confirmation
                    local got = false
                    local conn = FairySoulMessage.OnClientEvent:Connect(function(msg)
                        if msg == "found" or msg == "already" then
                            got = true
                        end
                    end)

                    -- Fire and wait up to 1s for response
                    fireclickdetector(cd)
                    local waited = 0
                    repeat task.wait(0.05) waited += 0.05 until got or waited >= 1

                    conn:Disconnect()

                    if got then
                        count += 1
                    else
                        -- Server didn't respond — try once more with a fresh TP
                        root.CFrame = soul.CFrame + Vector3.new(0, 1, 0)
                        task.wait(0.2)
                        fireclickdetector(cd)
                        task.wait(0.3)
                    end

                    task.wait(0.3)
                end
                Rayfield:Notify({ Title = "Soul Searcher", Content = count .. "/" .. total .. " souls confirmed.", Duration = 5 })
            end)
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "The Team",
    Callback = function()
        pcall(function()
            local part = workspace:FindFirstChild("Room Badge")
            if not part then Rayfield:Notify({ Title = "Error", Content = "Room Badge not found.", Duration = 3 }) return end
            tpTo(part)
            Rayfield:Notify({ Title = "The Team", Content = "Teleporting...", Duration = 2 })
        end)
    end,
})


BadgeTab:CreateButton({
    Name = "Its a Sign",
    Callback = function()
        pcall(function()
            local auth = RS:FindFirstChild("BadgeSignAuth")
            if not auth then Rayfield:Notify({ Title = "Error", Content = "Remote not found.", Duration = 3 }) return end
            local success, alreadyHad = auth:InvokeServer("badgepls")
            if success then
                Rayfield:Notify({ Title = "Its a Sign", Content = alreadyHad and "Already owned." or "Got it!", Duration = 3 })
            else
                Rayfield:Notify({ Title = "Its a Sign", Content = "Server rejected.", Duration = 3 })
            end
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Hoarder",
    Callback = function()
        pcall(function()
            local remote = RS:FindFirstChild("Hoarder")
            if not remote then Rayfield:Notify({ Title = "Error", Content = "Remote not found.", Duration = 3 }) return end
            remote:FireServer()
            Rayfield:Notify({ Title = "Hoarder", Content = "Getting badge...", Duration = 2 })
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Day Ruined (Plinko)",
    Callback = function()
        pcall(function()
            local remote = RS:FindFirstChild("PlinkoGamblingFailBadge")
            if not remote then Rayfield:Notify({ Title = "Error", Content = "Remote not found.", Duration = 3 }) return end
            remote:FireServer()
            Rayfield:Notify({ Title = "Day Ruined", Content = "Getting badge...", Duration = 2 })
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Tycoon Specialist",
    Callback = function()
        pcall(function()
            local remote = RS:FindFirstChild("TrophyGivy")
            if not remote then Rayfield:Notify({ Title = "Error", Content = "Remote not found.", Duration = 3 }) return end
            remote:FireServer()
            Rayfield:Notify({ Title = "Tycoon Specialist", Content = "Getting badge...", Duration = 2 })
        end)
    end,
})


BadgeTab:CreateButton({
    Name = "Pi — Part 1 (main game, WARNING: teleports to another game)",
    Callback = function()
        task.spawn(function()
            pcall(function()
                -- Press all 4 path buttons
                local paths = {
                    { "ButtonButton", "Path2", "Part" },
                    { "ButtonButton", "Path1", "Part" },
                    { "ButtonButton", "Path",  "Part" },
                    { "ButtonButton", "Path3", "Part" },
                }
                for _, p in ipairs(paths) do
                    local folder = workspace:FindFirstChild(p[1])
                    local model  = folder and folder:FindFirstChild(p[2])
                    local part   = model  and model:FindFirstChild(p[3])
                    if part then tpTo(part) task.wait(0.2) end
                end

                -- Find part with "Teleport" script + "TouchInterest" as children
                local teleportPart
                for _, child in ipairs(workspace:GetChildren()) do
                    if child:IsA("BasePart") and child:FindFirstChild("Teleport") and child:FindFirstChild("TouchInterest") then
                        teleportPart = child
                        break
                    end
                    if not teleportPart and child:IsA("Model") then
                        for _, part in ipairs(child:GetChildren()) do
                            if part:IsA("BasePart") and part:FindFirstChild("Teleport") and part:FindFirstChild("TouchInterest") then
                                teleportPart = part
                                break
                            end
                        end
                    end
                    if teleportPart then break end
                end

                if teleportPart then
                    tpTo(teleportPart)
                    firetouchinterest(teleportPart, LocalPlayer.Character.HumanoidRootPart, 0)
                    Rayfield:Notify({ Title = "Pi Part 1", Content = "Teleport triggered! Leaving...", Duration = 4 })
                else
                    Rayfield:Notify({ Title = "Pi Part 1", Content = "Teleport part not found. Wrong stage?", Duration = 4 })
                end
            end)
        end)
    end,
})

BadgeTab:CreateButton({
    Name = "Pi — Part 2 (press after arriving in the other game)",
    Callback = function()
        task.spawn(function()
            pcall(function()
                local staticNoise = workspace:FindFirstChild("static noise heaven")
                if not staticNoise then
                    Rayfield:Notify({ Title = "Pi Part 2", Content = "Not in the Pi game yet — press Part 1 first.", Duration = 4 })
                    return
                end

                -- TP to Model.Handle
                local model  = workspace:FindFirstChild("Model")
                local handle = model and model:FindFirstChild("Handle")
                if handle then
                    tpTo(handle)
                    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    workspace.CurrentCamera.CFrame = CFrame.new(handle.Position + Vector3.new(0, 5, -10), handle.Position)
                end

                -- Find and fire the only ProximityPrompt in the game — retry until badge sound plays
                local badgeGot = false
                workspace.DescendantAdded:Connect(function(obj)
                    if obj:IsA("Sound") and obj.SoundId:find("12222253") then
                        badgeGot = true
                        Rayfield:Notify({ Title = "Pi Badge!", Content = "Got it!", Duration = 5 })
                        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    end
                end)

                local attempts = 0
                while not badgeGot and attempts < 40 do
                    pcall(function()
                        local prompt = workspace:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                    end)
                    attempts += 1
                    task.wait(0.5)
                end

                if not badgeGot then
                    Rayfield:Notify({ Title = "Pi Part 2", Content = "Fired prompt 40 times — no badge sound. Try manually.", Duration = 5 })
                    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                end
            end)
        end)
    end,
})

-- ============================================================
-- TAB 3: EXTRA
-- ============================================================
local ExtraTab = Window:CreateTab("Extra", nil)

-- SECTION: World
ExtraTab:CreateSection("World")

ExtraTab:CreateButton({
    Name = "Load Infinite Yield",
    Callback = function()
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end)
        end)
        Rayfield:Notify({ Title = "Infinite Yield", Content = "Loading...", Duration = 3 })
    end,
})

-- Delete Kill Bricks
-- Destroys workspace.JumpscareParts, all "Lava Spinner" models,
-- any loose "Fire explode" parts, and the unnamed model's part3.
ExtraTab:CreateButton({
    Name = "Delete All Kill Bricks",
    Callback = function()
        local removed = 0
        pcall(function()
            local jp = workspace:FindFirstChild("JumpscareParts")
            if jp then jp:Destroy() removed += 1 end
        end)
        for _, obj in ipairs(workspace:GetChildren()) do
            pcall(function()
                if obj.Name == "Lava Spinner" then
                    obj:Destroy() removed += 1
                elseif obj.Name == "Fire explode" then
                    obj:Destroy() removed += 1
                else
                    -- Unnamed model containing part3
                    local p3 = obj:FindFirstChild("part3")
                    if p3 and p3:IsA("BasePart") then
                        p3:Destroy() removed += 1
                    end
                end
            end)
        end
        Rayfield:Notify({ Title = "Kill Bricks", Content = "Removed " .. removed .. " objects.", Duration = 3 })
    end,
})

-- Remove Stage 15 Popups
-- workspace.popupthing is a Part with a TouchInterest that triggers the popup spam on stage 15.
-- Deleting it stops it from ever firing.
ExtraTab:CreateButton({
    Name = "Remove Stage 15 Popups",
    Callback = function()
        pcall(function()
            local pt = workspace:FindFirstChild("popupthing")
            if pt then
                pt:Destroy()
                Rayfield:Notify({ Title = "Stage 15", Content = "Popup trigger removed.", Duration = 3 })
            else
                Rayfield:Notify({ Title = "Stage 15", Content = "popupthing not found — already gone or wrong stage.", Duration = 3 })
            end
        end)
    end,
})

-- Hide DCNotification (Alrgie's fake Discord "Like the game!" ping)
ExtraTab:CreateToggle({
    Name         = "Hide Like Notification",
    CurrentValue = false,
    Flag         = "HideLikeNotif",
    Callback = function(val)
        pcall(function()
            local pg    = LocalPlayer:FindFirstChild("PlayerGui")
            local notif = pg and pg:FindFirstChild("DCNotification")
            if notif then
                notif.Enabled = not val
                Rayfield:Notify({ Title = "Like Notification", Content = val and "Hidden." or "Restored.", Duration = 2 })
            else
                Rayfield:Notify({ Title = "Like Notification", Content = "DCNotification not found.", Duration = 3 })
            end
        end)
    end,
})

-- SECTION: Fun
ExtraTab:CreateSection("Fun")

ExtraTab:CreateButton({
    Name = "Foxy Jumpscare",
    Callback = function()
        pcall(function()
            local pg   = LocalPlayer:FindFirstChild("PlayerGui")
            local foxy = pg and pg:FindFirstChild("Foxy")
            if not foxy then Rayfield:Notify({ Title = "Error", Content = "Foxy GUI not found.", Duration = 3 }) return end
            local sound = foxy:FindFirstChild("JumpscareSound")
            foxy.Enabled = true
            if sound then
                sound:Play()
                sound.Ended:Once(function()
                    task.wait(0.2)
                    pcall(function() foxy.Enabled = false end)
                end)
            else
                task.delay(2, function() pcall(function() foxy.Enabled = false end) end)
            end
        end)
    end,
})

local announcementText = ""
ExtraTab:CreateInput({
    Name                     = "Announcement Text",
    PlaceholderText          = "Type your message...",
    RemoveTextAfterFocusLost = false,
    Callback = function(val)
        announcementText = val
    end,
})

ExtraTab:CreateButton({
    Name = "Send Fake Announcement",
    Callback = function()
        pcall(function()
            local pg  = LocalPlayer:FindFirstChild("PlayerGui")
            local ui  = pg and pg:FindFirstChild("AnnouncementUI")
            if not ui then Rayfield:Notify({ Title = "Error", Content = "AnnouncementUI not found.", Duration = 3 }) return end
            local frame = ui:FindFirstChild("Frame")
            if not frame then return end
            local label = frame:FindFirstChild("AnnouncementText")
            if not label then return end

            local msg = announcementText ~= "" and announcementText or "Blueberry Hub"
            label.Text  = msg
            ui.Enabled  = true

            local UIStroke  = frame:FindFirstChild("UIStroke")
            local Pattern   = frame:FindFirstChild("Pattern")
            local UIStroke2 = label:FindFirstChild("UIStroke")
            local notif     = SoundService:FindFirstChild("Notification")

            TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad), { BackgroundTransparency = 0 }):Play()
            if UIStroke  then TweenService:Create(UIStroke,  TweenInfo.new(0.6), { Transparency = 0 }):Play() end
            if Pattern   then TweenService:Create(Pattern,   TweenInfo.new(0.6), { ImageTransparency = 0.81 }):Play() end
            TweenService:Create(label, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()
            if UIStroke2 then TweenService:Create(UIStroke2, TweenInfo.new(0.6), { Transparency = 0 }):Play() end
            if notif then notif:Play() end

            task.delay(5, function()
                pcall(function()
                    TweenService:Create(frame, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
                    if UIStroke  then TweenService:Create(UIStroke,  TweenInfo.new(0.6), { Transparency = 1 }):Play() end
                    if Pattern   then TweenService:Create(Pattern,   TweenInfo.new(0.6), { ImageTransparency = 1 }):Play() end
                    TweenService:Create(label, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
                    if UIStroke2 then TweenService:Create(UIStroke2, TweenInfo.new(0.6), { Transparency = 1 }):Play() end
                    task.wait(0.7)
                    pcall(function() ui.Enabled = false end)
                end)
            end)
        end)
    end,
})

-- SECTION: Audio
ExtraTab:CreateSection("Audio")

-- Comprehensive sound blocker by SoundId
-- NOTE: 102433141520135 is Foxy's jumpscare sound — excluded intentionally
local ANNOYING_IDS = {
    ["107067727784898"] = true, ["8551016315"] = true,   ["73753120048787"] = true,
    ["99936497230394"] = true,  ["106974578385523"] = true,["12517136"] = true,
    ["122141604056833"] = true, ["18755832267"] = true,  ["87658025461348"] = true,
    ["15798534597"] = true,     ["89493770401852"] = true,["136487827237413"] = true,
    ["121250496298953"] = true, ["7468131335"] = true,   ["6767836089"] = true,
    ["4471648128"] = true,      ["119006971982707"] = true,["73752938778334"] = true,
    ["478544929"] = true,       ["1372506201"] = true,   ["18865849300"] = true,
    ["6737582037"] = true,      ["74824560444839"] = true,["73537776473957"] = true,
    ["142082170"] = true,       ["9068077052"] = true,   ["421058925"] = true,
    ["5137964328"] = true,      ["100572998569511"] = true,
    -- New additions
    ["18506765604"] = true,     ["3043029786"] = true,   ["6794882849"] = true,
    ["5801257793"] = true,      ["12544690"] = true,
}

local function getSoundId(s)
    local id = tostring(s.SoundId or "")
    return id:match("%d+") or id
end

local annoyingMuteConn  = nil
local annoyingSaved     = {} -- { [sound_instance] = original_volume }

ExtraTab:CreateToggle({
    Name         = "Disable Annoying Sounds",
    CurrentValue = false,
    Flag         = "AnnoyingSounds",
    Callback = function(val)
        if val then
            annoyingSaved = {}
            -- Scan all existing sounds in workspace and SoundService
            local function muteIfAnnoying(obj)
                if obj:IsA("Sound") and ANNOYING_IDS[getSoundId(obj)] then
                    annoyingSaved[obj] = obj.Volume
                    pcall(function() obj.Volume = 0 end)
                end
            end
            -- Named sounds in SoundService by name
            for _, name in ipairs({ "Alarm", "IncorrectSFX", "CorrectSFX", "BlueBerryNicheSound" }) do
                local s = SoundService:FindFirstChild(name)
                if s then annoyingSaved[s] = s.Volume s.Volume = 0 end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do muteIfAnnoying(obj) end
            for _, obj in ipairs(SoundService:GetDescendants()) do muteIfAnnoying(obj) end
            -- Watch for new sounds
            if annoyingMuteConn then annoyingMuteConn:Disconnect() end
            annoyingMuteConn = game.DescendantAdded:Connect(function(obj)
                if obj:IsA("Sound") and ANNOYING_IDS[getSoundId(obj)] then
                    task.defer(function()
                        pcall(function() obj.Volume = 0 end)
                    end)
                end
            end)
            Rayfield:Notify({ Title = "Annoying Sounds", Content = "Silenced.", Duration = 2 })
        else
            if annoyingMuteConn then annoyingMuteConn:Disconnect() annoyingMuteConn = nil end
            -- Restore all saved volumes
            for sound, vol in pairs(annoyingSaved) do
                pcall(function() sound.Volume = vol end)
            end
            annoyingSaved = {}
            -- Restore named ones too
            for _, name in ipairs({ "Alarm", "IncorrectSFX", "CorrectSFX", "BlueBerryNicheSound" }) do
                local s = SoundService:FindFirstChild(name)
                if s then pcall(function() s.Volume = 1 end) end
            end
            Rayfield:Notify({ Title = "Annoying Sounds", Content = "Restored.", Duration = 2 })
        end
    end,
})

-- ============================================================
-- TAB 4: CREDITS
-- ============================================================
local CreditsTab = Window:CreateTab("Credits", nil)

CreditsTab:CreateSection("Blueberry by Evil Spotify v1.0")
CreditsTab:CreateLabel("Made by Evil Spotify")
CreditsTab:CreateLabel("Created 2/27/26")
CreditsTab:CreateLabel("Game: Blueberry (Part 1 of the Berry Trilogy)")
CreditsTab:CreateSection("Notes")
CreditsTab:CreateLabel("Pi badge requires 2 steps — sends you to a different game.")
CreditsTab:CreateLabel("Foxy badge is pure RNG — 1 in 10,000 chance per second.")
CreditsTab:CreateLabel("Imposter badge is 1% chance per blueberry on stage 5.")

-- =============================================
-- LOADED
-- =============================================
Rayfield:Notify({
    Title    = "Blueberry by Evil Spotify",
    Content  = "Loaded!",
    Duration = 4,
})
