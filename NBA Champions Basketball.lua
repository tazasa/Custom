-- ╔══════════════════════════════════════════════════════════════╗
-- ║       BASKETBALL CHAMPIONS SCRIPT — CUSTOM v2.0             ║
-- ║    CFrame Speed  •  Auto Green  •  Professional UI          ║
-- ╚══════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer  = Players.LocalPlayer
local Character    = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart     = Character:WaitForChild("HumanoidRootPart")
local Humanoid     = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    RootPart  = char:WaitForChild("HumanoidRootPart")
    Humanoid  = char:WaitForChild("Humanoid")
end)

-- ══════════════════════════════════════════════
--  EXECUTOR CAPABILITY CHECK
-- ══════════════════════════════════════════════
local HookSupported = (
    type(newcclosure)       == "function" and
    type(getrawmetatable)   == "function" and
    type(setreadonly)       == "function" and
    type(getnamecallmethod) == "function"
)

-- ══════════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════════
local WalkEnabled  = false
local GreenEnabled = false
local Dragging     = false
local DragStart, StartPos

local DetectedDefault = (Humanoid and Humanoid.WalkSpeed) or 16
DetectedDefault = math.floor(DetectedDefault + 0.5)
local SpeedMultiplier = 1

-- ══════════════════════════════════════════════
--  CFRAME SPEED
-- ══════════════════════════════════════════════
local SpeedConn

local function StartCFrameSpeed()
    if SpeedConn then SpeedConn:Disconnect() end
    SpeedConn = RunService.Heartbeat:Connect(function(dt)
        if not WalkEnabled then return end
        if not RootPart or not Humanoid then return end
        if Humanoid.MoveDirection.Magnitude == 0 then return end
        local extra = Humanoid.MoveDirection * (SpeedMultiplier * DetectedDefault * 0.1)
        RootPart.CFrame = RootPart.CFrame + extra * dt
    end)
end

local function StopCFrameSpeed()
    if SpeedConn then SpeedConn:Disconnect(); SpeedConn = nil end
end

-- ══════════════════════════════════════════════
--  AUTO GREEN
-- ══════════════════════════════════════════════
local FinishShotRemote = nil

local function FindFinishShot()
    local rs = game:GetService("ReplicatedStorage")
    local ok, remote = pcall(function()
        return rs.Comms.ActionProvider.RE.FinishShot
    end)
    if ok and remote then
        FinishShotRemote = remote
    end
end

local function InstallHook()
    FindFinishShot()
    local ok, mt = pcall(getrawmetatable, game)
    if not ok then return end

    setreadonly(mt, false)
    local orig = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if GreenEnabled
        and getnamecallmethod() == "FireServer"
        and FinishShotRemote
        and rawequal(self, FinishShotRemote) then
            local a1, a2, a3, a4, a5 = ...
            return orig(self, a1, 1, a3, a4, a5)
        end
        return orig(self, ...)
    end)
    setreadonly(mt, true)
end

if HookSupported then
    InstallHook()
end

local function StartAutoGreen() end
local function StopAutoGreen()  end

-- ══════════════════════════════════════════════
--  GUI
-- ══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "Custom_BCS"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder   = 999

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game.CoreGui
end

local Main = Instance.new("Frame")
Main.Name             = "Main"
Main.Size             = UDim2.new(0, 340, 0, 430)
Main.Position         = UDim2.new(0.5, -170, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(14, 13, 10)
Main.BorderSizePixel  = 0
Main.ZIndex           = 1
Main.Parent           = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color        = Color3.fromRGB(255, 165, 28)
mainStroke.Thickness    = 1.5
mainStroke.Transparency = 0.5

local bgGrad = Instance.new("UIGradient", Main)
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 18, 13)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 9, 7)),
})
bgGrad.Rotation = 130

local TopAccent = Instance.new("Frame", Main)
TopAccent.Size            = UDim2.new(1, 0, 0, 3)
TopAccent.Position        = UDim2.new(0, 0, 0, 0)
TopAccent.BorderSizePixel = 0
TopAccent.ZIndex          = 10
TopAccent.BackgroundColor3 = Color3.fromRGB(255, 160, 20)
Instance.new("UICorner", TopAccent).CornerRadius = UDim.new(0, 12)
local taGrad = Instance.new("UIGradient", TopAccent)
taGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 215, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 125, 20)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(215, 45, 75)),
})

local Header = Instance.new("Frame", Main)
Header.Size                  = UDim2.new(1, 0, 0, 60)
Header.Position              = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.ZIndex                = 5

local Badge = Instance.new("Frame", Header)
Badge.Size             = UDim2.new(0, 36, 0, 36)
Badge.Position         = UDim2.new(0, 14, 0, 12)
Badge.BorderSizePixel  = 0
Badge.BackgroundColor3 = Color3.fromRGB(200, 120, 15)
Badge.ZIndex           = 6
Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 8)
local bdGrad = Instance.new("UIGradient", Badge)
bdGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 210, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 75, 15)),
})
bdGrad.Rotation = 135

local BadgeIcon = Instance.new("TextLabel", Badge)
BadgeIcon.Size                = UDim2.new(1,0,1,0)
BadgeIcon.BackgroundTransparency = 1
BadgeIcon.Text                = "🏀"
BadgeIcon.TextSize            = 18
BadgeIcon.Font                = Enum.Font.GothamBold
BadgeIcon.TextColor3          = Color3.fromRGB(255,255,255)
BadgeIcon.ZIndex              = 7

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size               = UDim2.new(0, 210, 0, 20)
TitleLabel.Position           = UDim2.new(0, 58, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text               = "BASKETBALL CHAMPIONS SCRIPT"
TitleLabel.Font               = Enum.Font.GothamBold
TitleLabel.TextSize           = 11
TitleLabel.TextColor3         = Color3.fromRGB(245, 232, 210)
TitleLabel.TextXAlignment     = Enum.TextXAlignment.Left
TitleLabel.ZIndex             = 6

local SubLabel = Instance.new("TextLabel", Header)
SubLabel.Size                 = UDim2.new(0, 210, 0, 14)
SubLabel.Position             = UDim2.new(0, 58, 0, 32)
SubLabel.BackgroundTransparency = 1
SubLabel.Text                 = "Custom  •  v2.0"
SubLabel.Font                 = Enum.Font.Gotham
SubLabel.TextSize             = 10
SubLabel.TextColor3           = Color3.fromRGB(100, 88, 68)
SubLabel.TextXAlignment       = Enum.TextXAlignment.Left
SubLabel.ZIndex               = 6

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size               = UDim2.new(0, 26, 0, 26)
MinBtn.Position           = UDim2.new(1, -68, 0, 17)
MinBtn.BackgroundColor3   = Color3.fromRGB(18, 38, 18)
MinBtn.BorderSizePixel    = 0
MinBtn.Text               = "—"
MinBtn.Font               = Enum.Font.GothamBold
MinBtn.TextSize           = 11
MinBtn.TextColor3         = Color3.fromRGB(55, 195, 55)
MinBtn.ZIndex             = 10
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size             = UDim2.new(0, 26, 0, 26)
CloseBtn.Position         = UDim2.new(1, -38, 0, 17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(48, 18, 18)
CloseBtn.BorderSizePixel  = 0
CloseBtn.Text             = "✕"
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.TextSize         = 11
CloseBtn.TextColor3       = Color3.fromRGB(215, 65, 65)
CloseBtn.ZIndex           = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local Divider = Instance.new("Frame", Main)
Divider.Size             = UDim2.new(1, -24, 0, 1)
Divider.Position         = UDim2.new(0, 12, 0, 61)
Divider.BackgroundColor3 = Color3.fromRGB(34, 30, 22)
Divider.BorderSizePixel  = 0
Divider.ZIndex           = 5

-- ══════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════
local function SectionLabel(yPos, text)
    local f = Instance.new("Frame", Main)
    f.Size                  = UDim2.new(1, -24, 0, 16)
    f.Position              = UDim2.new(0, 12, 0, yPos)
    f.BackgroundTransparency = 1
    f.ZIndex                = 5

    local bar = Instance.new("Frame", f)
    bar.Size             = UDim2.new(0, 3, 0, 12)
    bar.Position         = UDim2.new(0, 0, 0.5, -6)
    bar.BackgroundColor3 = Color3.fromRGB(255, 155, 18)
    bar.BorderSizePixel  = 0
    bar.ZIndex           = 6
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size             = UDim2.new(1, -8, 1, 0)
    lbl.Position         = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text             = text:upper()
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextSize         = 9
    lbl.TextColor3       = Color3.fromRGB(135, 120, 92)
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    lbl.ZIndex           = 6
end

local function MakeToggle(yPos, titleText, descText, callback)
    local card = Instance.new("Frame", Main)
    card.Size             = UDim2.new(1, -24, 0, 62)
    card.Position         = UDim2.new(0, 12, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(20, 18, 14)
    card.BorderSizePixel  = 0
    card.ZIndex           = 5
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(36, 32, 24); cs.Thickness = 1

    local dot = Instance.new("Frame", card)
    dot.Size             = UDim2.new(0, 7, 0, 7)
    dot.Position         = UDim2.new(0, 12, 0.5, -3.5)
    dot.BackgroundColor3 = Color3.fromRGB(52, 48, 38)
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 6
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size             = UDim2.new(0, 200, 0, 20)
    tLbl.Position         = UDim2.new(0, 28, 0, 10)
    tLbl.BackgroundTransparency = 1
    tLbl.Text             = titleText
    tLbl.Font             = Enum.Font.GothamBold
    tLbl.TextSize         = 13
    tLbl.TextColor3       = Color3.fromRGB(235, 222, 200)
    tLbl.TextXAlignment   = Enum.TextXAlignment.Left
    tLbl.ZIndex           = 6

    local dLbl = Instance.new("TextLabel", card)
    dLbl.Size             = UDim2.new(0, 200, 0, 14)
    dLbl.Position         = UDim2.new(0, 28, 0, 33)
    dLbl.BackgroundTransparency = 1
    dLbl.Text             = descText
    dLbl.Font             = Enum.Font.Gotham
    dLbl.TextSize         = 10
    dLbl.TextColor3       = Color3.fromRGB(88, 80, 64)
    dLbl.TextXAlignment   = Enum.TextXAlignment.Left
    dLbl.ZIndex           = 6

    local pill = Instance.new("Frame", card)
    pill.Size             = UDim2.new(0, 44, 0, 22)
    pill.Position         = UDim2.new(1, -54, 0.5, -11)
    pill.BackgroundColor3 = Color3.fromRGB(26, 24, 18)
    pill.BorderSizePixel  = 0
    pill.ZIndex           = 7
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local ps = Instance.new("UIStroke", pill)
    ps.Color = Color3.fromRGB(46, 42, 32); ps.Thickness = 1

    local knob = Instance.new("Frame", pill)
    knob.Size             = UDim2.new(0, 16, 0, 16)
    knob.Position         = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(86, 78, 62)
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 8
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = false
    local function Toggle(state)
        enabled = state
        TweenService:Create(knob, TweenInfo.new(0.18), {
            Position         = state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3 = state and Color3.fromRGB(255,192,32) or Color3.fromRGB(86,78,62),
        }):Play()
        TweenService:Create(pill, TweenInfo.new(0.18), {
            BackgroundColor3 = state and Color3.fromRGB(52,38,6) or Color3.fromRGB(26,24,18),
        }):Play()
        TweenService:Create(dot, TweenInfo.new(0.18), {
            BackgroundColor3 = state and Color3.fromRGB(255,165,22) or Color3.fromRGB(52,48,38),
        }):Play()
        callback(state)
    end

    local btn = Instance.new("TextButton", card)
    btn.Size                 = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 9
    btn.MouseButton1Click:Connect(function() Toggle(not enabled) end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(24,22,16)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(20,18,14)}):Play()
    end)

    return card
end

-- ── SPEED SLIDER ─────────────────────────────
local function MakeSlider(yPos)
    local card = Instance.new("Frame", Main)
    card.Size             = UDim2.new(1, -24, 0, 80)
    card.Position         = UDim2.new(0, 12, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(20, 18, 14)
    card.BorderSizePixel  = 0
    card.ZIndex           = 5
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(36, 32, 24); cs.Thickness = 1

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Size             = UDim2.new(0.55, 0, 0, 18)
    nameLbl.Position         = UDim2.new(0, 12, 0, 10)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text             = "Speed Boost"
    nameLbl.Font             = Enum.Font.GothamBold
    nameLbl.TextSize         = 12
    nameLbl.TextColor3       = Color3.fromRGB(228, 215, 195)
    nameLbl.TextXAlignment   = Enum.TextXAlignment.Left
    nameLbl.ZIndex           = 6

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Size              = UDim2.new(0, 32, 0, 18)
    valLbl.Position          = UDim2.new(1, -100, 0, 10)
    valLbl.BackgroundTransparency = 1
    valLbl.Text              = "x" .. tostring(SpeedMultiplier)
    valLbl.Font              = Enum.Font.GothamBold
    valLbl.TextSize          = 14
    valLbl.TextColor3        = Color3.fromRGB(255, 172, 28)
    valLbl.TextXAlignment    = Enum.TextXAlignment.Right
    valLbl.ZIndex            = 6

    local addLbl = Instance.new("TextLabel", card)
    addLbl.Size              = UDim2.new(0, 60, 0, 18)
    addLbl.Position          = UDim2.new(1, -62, 0, 10)
    addLbl.BackgroundTransparency = 1
    addLbl.Text              = "(+" .. string.format("%.1f", SpeedMultiplier * DetectedDefault * 0.1) .. " s/s)"
    addLbl.Font              = Enum.Font.Gotham
    addLbl.TextSize          = 10
    addLbl.TextColor3        = Color3.fromRGB(100, 90, 72)
    addLbl.TextXAlignment    = Enum.TextXAlignment.Right
    addLbl.ZIndex            = 6

    local track = Instance.new("Frame", card)
    track.Size            = UDim2.new(1, -24, 0, 6)
    track.Position        = UDim2.new(0, 12, 0, 42)
    track.BackgroundColor3 = Color3.fromRGB(30, 27, 20)
    track.BorderSizePixel = 0
    track.ZIndex          = 6
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    for i = 1, 10 do
        local tick = Instance.new("Frame", track)
        tick.Size             = UDim2.new(0, 1, 1, 4)
        tick.AnchorPoint      = Vector2.new(0.5, 0.5)
        tick.Position         = UDim2.new((i - 1) / 9, 0, 0.5, 0)
        tick.BackgroundColor3 = Color3.fromRGB(50, 46, 36)
        tick.BorderSizePixel  = 0
        tick.ZIndex           = 6
    end

    local initPct = (SpeedMultiplier - 1) / 9

    local fill = Instance.new("Frame", track)
    fill.Size             = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 155, 18)
    fill.BorderSizePixel  = 0
    fill.ZIndex           = 7
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fg = Instance.new("UIGradient", fill)
    fg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 212, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(228, 82, 18)),
    })

    local handle = Instance.new("Frame", track)
    handle.Size           = UDim2.new(0, 15, 0, 15)
    handle.AnchorPoint    = Vector2.new(0.5, 0.5)
    handle.Position       = UDim2.new(initPct, 0, 0.5, 0)
    handle.BackgroundColor3 = Color3.fromRGB(255, 178, 28)
    handle.BorderSizePixel = 0
    handle.ZIndex         = 8
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

    local hCenter = Instance.new("Frame", handle)
    hCenter.Size          = UDim2.new(0, 5, 0, 5)
    hCenter.AnchorPoint   = Vector2.new(0.5, 0.5)
    hCenter.Position      = UDim2.new(0.5, 0, 0.5, 0)
    hCenter.BackgroundColor3 = Color3.fromRGB(255, 250, 195)
    hCenter.BorderSizePixel = 0
    hCenter.ZIndex        = 9
    Instance.new("UICorner", hCenter).CornerRadius = UDim.new(1, 0)

    local minLbl = Instance.new("TextLabel", card)
    minLbl.Size           = UDim2.new(0, 8, 0, 12)
    minLbl.Position       = UDim2.new(0, 12, 0, 58)
    minLbl.BackgroundTransparency = 1
    minLbl.Text           = "1"
    minLbl.Font           = Enum.Font.Gotham
    minLbl.TextSize       = 9
    minLbl.TextColor3     = Color3.fromRGB(72, 65, 52)
    minLbl.TextXAlignment = Enum.TextXAlignment.Left
    minLbl.ZIndex         = 6

    local maxLbl = Instance.new("TextLabel", card)
    maxLbl.Size           = UDim2.new(0, 12, 0, 12)
    maxLbl.Position       = UDim2.new(1, -24, 0, 58)
    maxLbl.BackgroundTransparency = 1
    maxLbl.Text           = "10"
    maxLbl.Font           = Enum.Font.Gotham
    maxLbl.TextSize       = 9
    maxLbl.TextColor3     = Color3.fromRGB(72, 65, 52)
    maxLbl.TextXAlignment = Enum.TextXAlignment.Right
    maxLbl.ZIndex         = 6

    local sensor = Instance.new("TextButton", card)
    sensor.Size            = UDim2.new(1, 0, 0, 30)
    sensor.Position        = UDim2.new(0, 0, 0, 34)
    sensor.BackgroundTransparency = 1
    sensor.Text            = ""
    sensor.ZIndex          = 10

    local slDrag = false

    local function UpdateSlider(x)
        local ax  = track.AbsolutePosition.X
        local aw  = track.AbsoluteSize.X
        local pct = math.clamp((x - ax) / aw, 0, 1)
        local step = math.floor(pct * 9 + 0.5)
        local snapPct = step / 9
        SpeedMultiplier = step + 1
        valLbl.Text = "x" .. tostring(SpeedMultiplier)
        addLbl.Text = "(+" .. string.format("%.1f", SpeedMultiplier * DetectedDefault * 0.1) .. " s/s)"
        fill.Size        = UDim2.new(snapPct, 0, 1, 0)
        handle.Position  = UDim2.new(snapPct, 0, 0.5, 0)
    end

    sensor.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            slDrag = true; UpdateSlider(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if slDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            slDrag = false
        end
    end)
end

-- ── STATUS BAR ───────────────────────────────
local statusBar = Instance.new("Frame", Main)
statusBar.Size             = UDim2.new(1, -24, 0, 30)
statusBar.Position         = UDim2.new(0, 12, 1, -42)
statusBar.BackgroundColor3 = Color3.fromRGB(15, 13, 10)
statusBar.BorderSizePixel  = 0
statusBar.ZIndex           = 5
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 8)
local sbStroke = Instance.new("UIStroke", statusBar)
sbStroke.Color = Color3.fromRGB(32, 28, 20); sbStroke.Thickness = 1

local sbDot = Instance.new("Frame", statusBar)
sbDot.Size             = UDim2.new(0, 7, 0, 7)
sbDot.Position         = UDim2.new(0, 10, 0.5, -3.5)
sbDot.BackgroundColor3 = Color3.fromRGB(65, 185, 65)
sbDot.BorderSizePixel  = 0
sbDot.ZIndex           = 6
Instance.new("UICorner", sbDot).CornerRadius = UDim.new(1, 0)

local sbText = Instance.new("TextLabel", statusBar)
sbText.Size             = UDim2.new(1, -26, 1, 0)
sbText.Position         = UDim2.new(0, 24, 0, 0)
sbText.BackgroundTransparency = 1
sbText.Text             = "Ready — all features standby"
sbText.Font             = Enum.Font.Gotham
sbText.TextSize         = 10
sbText.TextColor3       = Color3.fromRGB(105, 95, 76)
sbText.TextXAlignment   = Enum.TextXAlignment.Left
sbText.ZIndex           = 6

local function SetStatus(msg, good)
    sbText.Text = msg
    TweenService:Create(sbDot, TweenInfo.new(0.18), {
        BackgroundColor3 = good
            and Color3.fromRGB(65,185,65)
            or  Color3.fromRGB(195,65,65)
    }):Play()
end

-- ══════════════════════════════════════════════
--  BUILD LAYOUT
-- ══════════════════════════════════════════════
SectionLabel(68,  "CFrame Speed")
MakeSlider(88)

SectionLabel(176, "Movement")
MakeToggle(196, "CFrame Speed", "Bypass anti-cheat with CFrame movement", function(on)
    WalkEnabled = on
    if on then
        StartCFrameSpeed()
        SetStatus("Speed ON — x" .. tostring(SpeedMultiplier) .. " (+" .. string.format("%.1f", SpeedMultiplier * DetectedDefault * 0.1) .. " studs/s)", true)
    else
        StopCFrameSpeed()
        SetStatus("CFrame Speed OFF", false)
    end
end)

SectionLabel(268, "Shooting")
local autoGreenCard = MakeToggle(288, "Auto Green", "Auto-release shot at perfect green zone", function(on)
    if not HookSupported then return end
    GreenEnabled = on
    if on then
        StartAutoGreen()
        SetStatus("Auto Green ON — every shot will be green", true)
    else
        StopAutoGreen()
        SetStatus("Auto Green OFF", false)
    end
end)

-- ── LOCKED OVERLAY (only if executor can't support it) ───
if not HookSupported then
    -- dark gradient overlay over the card
    local overlay = Instance.new("Frame", autoGreenCard)
    overlay.Size             = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel  = 0
    overlay.ZIndex           = 20
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 10)
    local og = Instance.new("UIGradient", overlay)
    og.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 14, 4)),
    })
    og.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(1, 0.2),
    })
    og.Rotation = 90

    -- lock icon centered on the overlay
    local lockIcon = Instance.new("TextLabel", overlay)
    lockIcon.Size                   = UDim2.new(1, 0, 1, 0)
    lockIcon.BackgroundTransparency = 1
    lockIcon.Text                   = "🔒  Upgrade your executor to unlock"
    lockIcon.Font                   = Enum.Font.GothamBold
    lockIcon.TextSize               = 11
    lockIcon.TextColor3             = Color3.fromRGB(200, 170, 80)
    lockIcon.TextXAlignment         = Enum.TextXAlignment.Center
    lockIcon.TextYAlignment         = Enum.TextYAlignment.Center
    lockIcon.ZIndex                 = 21

    -- block clicks on the card beneath
    local blocker = Instance.new("TextButton", overlay)
    blocker.Size                   = UDim2.new(1, 0, 1, 0)
    blocker.BackgroundTransparency = 1
    blocker.Text                   = ""
    blocker.ZIndex                 = 22
    blocker.MouseButton1Click:Connect(function() end) -- swallow clicks
end

-- ══════════════════════════════════════════════
--  DRAG
-- ══════════════════════════════════════════════
Header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging  = true
        DragStart = inp.Position
        StartPos  = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if Dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - DragStart
        Main.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + d.X,
            StartPos.Y.Scale, StartPos.Y.Offset + d.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

Main.Active               = false
Main.BackgroundTransparency = 0

-- ══════════════════════════════════════════════
--  HIDE / SHOW
-- ══════════════════════════════════════════════
local guiVisible = true
local tweening   = false
local savedPos   = UDim2.new(0.5, -170, 0.5, -215)

local function ShowGui()
    if tweening then return end
    tweening    = true
    guiVisible  = true
    Main.Visible = true
    Main.Size     = UDim2.new(0, 320, 0, 0)
    Main.Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset + 10, savedPos.Y.Scale, savedPos.Y.Offset + 215)
    Main.BackgroundTransparency = 1
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size                   = UDim2.new(0, 340, 0, 430),
        Position               = savedPos,
        BackgroundTransparency = 0,
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.35), {Transparency = 0.5}):Play()
    task.delay(0.35, function() tweening = false end)
end

local function HideGui()
    if tweening then return end
    tweening   = true
    guiVisible = false
    savedPos   = Main.Position
    local cx = Main.Position.X.Offset + 170
    local cy = Main.Position.Y.Offset + 215
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size                   = UDim2.new(0, 0, 0, 0),
        Position               = UDim2.new(Main.Position.X.Scale, cx, Main.Position.Y.Scale, cy),
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
    task.delay(0.28, function()
        Main.Visible = false
        tweening     = false
    end)
end

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.24, Enum.EasingStyle.Quad), {
        Size = minimized and UDim2.new(0, 340, 0, 62) or UDim2.new(0, 340, 0, 430)
    }):Play()
    MinBtn.Text = minimized and "□" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function()
    HideGui()
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.K then
        if guiVisible then HideGui() else ShowGui() end
    end
end)

-- ══════════════════════════════════════════════
--  ENTRANCE ANIMATION
-- ══════════════════════════════════════════════
Main.Size     = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundTransparency = 1
mainStroke.Transparency     = 1

task.delay(0.1, function()
    TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size                   = UDim2.new(0, 340, 0, 430),
        Position               = UDim2.new(0.5, -170, 0.5, -215),
        BackgroundTransparency = 0,
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.45), {Transparency = 0.5}):Play()
    savedPos = UDim2.new(0.5, -170, 0.5, -215)
end)

print("[Custom] Basketball Champions Script v2.0 loaded — Press K to toggle menu")
