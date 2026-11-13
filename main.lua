local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("DandyDeltaHub") then
    PlayerGui.DandyDeltaHub:Destroy()
end

local Config = {
    AutoFarm = false,
    SmartAvoid = false,
    AvoidDistance = 32,
    AutoCollect = false,
    AutoElevator = false,
    AutoSkillcheck = true,
    EspMonsters = false,
    EspMachines = false,
    EspItems = false,
    EspPlayers = false,
    SpeedEnabled = false,
    WalkSpeed = 26,
    Noclip = false,
    Fullbright = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DandyDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 120, 0, 38)
ToggleBtn.Position = UDim2.new(0.03, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Text = "Dandy Hub [-]"
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local TStroke = Instance.new("UIStroke", ToggleBtn)
TStroke.Color = Color3.fromRGB(255, 215, 0)
TStroke.Thickness = 1.2

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 380)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MStroke = Instance.new("UIStroke", MainFrame)
MStroke.Color = Color3.fromRGB(65, 65, 85)
MStroke.Thickness = 1.5

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -20, 1, 0)
HeaderTitle.Position = UDim2.new(0, 12, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Text = "Dandy's World | Delta Edition"
HeaderTitle.Parent = Header

local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 24)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
StatusLabel.TextColor3 = Color3.fromRGB(130, 220, 255)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 12
StatusLabel.Text = "Status: Delta Ready"
StatusLabel.Parent = MainFrame
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 6)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -80)
Scroll.Position = UDim2.new(0, 8, 0, 74)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 8
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
Scroll.ScrollingEnabled = true
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 7)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.Parent = Scroll

local function AddSection(titleText)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 200, 70)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "  " .. titleText
    lbl.Parent = Scroll
end

local function AddToggle(name, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(40, 120, 75) or Color3.fromRGB(34, 34, 46)
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Text = name .. (defaultState and "  [ON]" or "  [OFF]")
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and "  [ON]" or "  [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 120, 75) or Color3.fromRGB(34, 34, 46)
        callback(state)
    end)
end

local function AddActionBtn(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(65, 50, 115)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = name
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleBtn.Text = MainFrame.Visible and "Dandy Hub [-]" or "Dandy Hub [+]"
end)

AddSection("AUTOMATION (AUTO FARM)")
AddToggle("Auto Repair Generators", false, function(v)
    Config.AutoFarm = v
    if not v then StatusLabel.Text = "Status: Auto Repair Stopped" end
end)

AddToggle("Smart Monster Avoid", false, function(v)
    Config.SmartAvoid = v
end)

AddToggle("Auto Collect Ichor & Items", false, function(v)
    Config.AutoCollect = v
end)

AddToggle("Auto Skillcheck (No Miss)", true, function(v)
    Config.AutoSkillcheck = v
end)

AddToggle("Auto Elevator (When Done)", false, function(v)
    Config.AutoElevator = v
end)

AddSection("VISUALS (ESP)")
AddToggle("ESP Twisteds (Red)", false, function(v)
    Config.EspMonsters = v
    if not v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "DeltaESP_Monster" then obj:Destroy() end
        end
    end
end)

AddToggle("ESP Generators (Blue)", false, function(v)
    Config.EspMachines = v
    if not v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "DeltaESP_Machine" then obj:Destroy() end
        end
    end
end)

AddToggle("ESP Items & Capsules (Yellow)", false, function(v)
    Config.EspItems = v
    if not v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "DeltaESP_Item" then obj:Destroy() end
        end
    end
end)

AddToggle("ESP Players (Green)", false, function(v)
    Config.EspPlayers = v
    if not v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "DeltaESP_Player" then obj:Destroy() end
        end
    end
end)

AddSection("PLAYER & TELEPORTS")
AddToggle("Fast WalkSpeed (26)", false, function(v)
    Config.SpeedEnabled = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

AddToggle("Noclip (Walk Through Walls)", false, function(v)
    Config.Noclip = v
end)

AddToggle("Fullbright (No Darkness)", false, function(v)
    Config.Fullbright = v
    if not v then
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
    end
end)

AddActionBtn("Teleport to Elevator", function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (string.find(string.lower(v.Name), "elevator") or string.find(string.lower(v.Name), "lift")) then
            char.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 4, 0)
            StatusLabel.Text = "Status: Teleported to Elevator!"
            break
        end
    end
end)

local function GetMonsters()
    local monsters = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                table.insert(monsters, v)
            end
        end
    end
    return monsters
end

local function GetUnfinishedMachines()
    local machines = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local n = string.lower(v.Name)
            if string.find(n, "generator") or string.find(n, "machine") or string.find(n, "extractor") then
