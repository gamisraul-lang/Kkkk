-- Ro-Ghoul Ultimate: No-Key Edition (Delta Optimized)
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LP = game.Players.LocalPlayer

-- State Variables
local Farming = false 
local AutoStat = false
local AutoStage = false
local AutoTrain = false
local AntiAFK = true
local MenuVisible = true

-- UI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGhoul_Toggle_UI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -180)
MainFrame.Size = UDim2.new(0, 220, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true 

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "RO-GHOUL [V3]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- MINI TOGGLE BUTTON (Mobile Friendly)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
OpenBtn.Text = "RG"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Visible = false 
OpenBtn.Draggable = true -- Can move the open button if it's in the way

-- UI Helper
local function createBtn(pos, text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    return btn
end

local FarmBtn = createBtn(UDim2.new(0.07, 0, 0.15, 0), "Auto Boss: OFF")
local StatBtn = createBtn(UDim2.new(0.07, 0, 0.28, 0), "Auto Stat: OFF")
local TrainBtn = createBtn(UDim2.new(0.07, 0, 0.41, 0), "Auto Trainer: OFF")
local StageBtn = createBtn(UDim2.new(0.07, 0, 0.54, 0), "Auto Stage: OFF")
local AfkBtn = createBtn(UDim2.new(0.07, 0, 0.67, 0), "Anti-AFK: ON")
local CloseBtn = createBtn(UDim2.new(0.07, 0, 0.85, 0), "Minimize [RightCtrl]")

--- TOGGLE VISIBILITY ---

local function toggleUI()
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
    OpenBtn.Visible = not MenuVisible
end

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        toggleUI()
    end
end)

CloseBtn.MouseButton1Click:Connect(toggleUI)
OpenBtn.MouseButton1Click:Connect(toggleUI)

--- FEATURES ---

-- Anti-AFK
LP.Idled:Connect(function()
    if AntiAFK then
        VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- Auto Stat Logic
spawn(function()
    while task.wait(5) do
        if AutoStat then
            local stats = LP:FindFirstChild("Stats")
            if stats and stats:FindFirstChild("Points") and stats.Points.Value > 0 then
                game:GetService("ReplicatedStorage").Remotes.Stats:FireServer("Kagune", stats.Points.Value)
            end
        end
    end
end)

-- Auto Stage Logic
spawn(function()
    while task.wait(3) do
        if AutoStage then
            for i = 1, 9 do
                VIM:SendKeyEvent(true, tostring(i), false, game)
                task.wait(0.05)
            end
        end
    end
end)

-- Auto Trainer Logic
local function startTrainer()
    spawn(function()
        while AutoTrain do
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") and (v.Parent.Name:find("Trainer") or v.Parent.Name:find("Yoshimura")) then
                        LP.Character.HumanoidRootPart.CFrame = v.Parent.PrimaryPart.CFrame * CFrame.new(0, 0, 3)
                        fireclickdetector(v)
                        task.wait(1)
                        game:GetService("ReplicatedStorage").Remotes.Chat:FireServer("Yes")
                    end
                end
            end
            task.wait(10)
        end
    end)
end

-- Boss Farm Logic
local function startFarming()
    spawn(function()
        while Farming do
            local npcs = workspace:FindFirstChild("NPCs")
            if npcs then
                for _, boss in pairs(npcs:GetChildren()) do
                    if (boss.Name:find("Nishiki") or boss.Name:find("Amon") or boss.Name:find("Eto")) 
                    and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        LP.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        -- Skill Spammer
                        for _, k in pairs({"E","R","F"}) do 
                            VIM:SendKeyEvent(true, k, false, game) task.wait(0.05) VIM:SendKeyEvent(false, k, false, game)
                        end
                        -- Clicker
                        VIM:SendMouseButtonEvent(0,0,0,true,game,1) task.wait(0.05) VIM:SendMouseButtonEvent(0,0,0,false,game,1)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

--- BUTTON EVENTS ---

FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    FarmBtn.Text = Farming and "Auto Boss: ON" or "Auto Boss: OFF"
    FarmBtn.BackgroundColor3 = Farming and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    if Farming then startFarming() end
end)

StatBtn.MouseButton1Click:Connect(function()
    AutoStat = not AutoStat
    StatBtn.Text = AutoStat and "Auto Stat: ON" or "Auto Stat: OFF"
    StatBtn.BackgroundColor3 = AutoStat and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

TrainBtn.MouseButton1Click:Connect(function()
    AutoTrain = not AutoTrain
    TrainBtn.Text = AutoTrain and "Auto Trainer: ON" or "Auto Trainer: OFF"
    TrainBtn.BackgroundColor3 = AutoTrain and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    if AutoTrain then startTrainer() end
end)

StageBtn.MouseButton1Click:Connect(function()
    AutoStage = not AutoStage
    StageBtn.Text = AutoStage and "Auto Stage: ON" or "Auto Stage: OFF"
    StageBtn.BackgroundColor3 = AutoStage and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

AfkBtn.MouseButton1Click:Connect(function()
    AntiAFK = not AntiAFK
    AfkBtn.Text = AntiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"
    AfkBtn.BackgroundColor3 = AntiAFK and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)
