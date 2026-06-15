--[[
    GRIP HUB V4.0 - [99 Noites na Floresta]
    CONTROLE TOTAL: Speed Slider, FOV Slider, Target-Selector.
--]]

local GripHub_Settings = {
    SpeedValue = 16, FOVValue = 70, BringTarget = "Me", -- "Me", "Campfire", "Workbench"
    KillAura = false, GoldMode = false, GodMode = false
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera

-- // LOOP DE ATUALIZAÇÃO (Dinâmico)
task.spawn(function()
    while task.wait(0.1) do
        if Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = GripHub_Settings.SpeedValue
        end
        Camera.FieldOfView = GripHub_Settings.FOVValue
        
        -- Lógica do Bring Items
        if GripHub_Settings.BringTarget ~= "Me" then
            for _, item in pairs(workspace:GetChildren()) do
                if item:FindFirstChild("Handle") then
                    local target = workspace:FindFirstChild(GripHub_Settings.BringTarget)
                    if target then item.Handle.CFrame = target.CFrame end
                end
            end
        end
    end
end)

-- // UI COM SLIDERS E SELETORES
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", Gui)
Frame.Size, Frame.Position = UDim2.new(0, 250, 0, 500), UDim2.new(0.05, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Active, Frame.Draggable = true, true

-- Função auxiliar para Sliders
local function CreateSlider(name, min, max, setting)
    local Label = Instance.new("TextLabel", Frame)
    Label.Text = name .. ": " .. GripHub_Settings[setting]
    Label.Size = UDim2.new(1, 0, 0, 30)
    local Slider = Instance.new("TextButton", Label)
    Slider.Size = UDim2.new(1, 0, 0, 10)
    Slider.Position = UDim2.new(0, 0, 1, 0)
    Slider.MouseButton1Down:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local pos = math.clamp((mouse.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            GripHub_Settings[setting] = math.floor(min + (max - min) * pos)
            Label.Text = name .. ": " .. GripHub_Settings[setting]
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then connection:Disconnect() end
        end)
    end)
end

-- Função para Seletor de Target
local function CreateSelector(name, options)
    local btn = Instance.new("TextButton", Frame)
    btn.Size, btn.Text = UDim2.new(1, 0, 0, 30), name .. ": " .. GripHub_Settings.BringTarget
    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        GripHub_Settings.BringTarget = options[idx]
        btn.Text = name .. ": " .. options[idx]
    end)
end

-- Criando os Controles
CreateSlider("Velocidade (Speed)", 16, 100, "SpeedValue")
CreateSlider("Campo de Visão (FOV)", 70, 120, "FOVValue")
CreateSelector("Trazer Itens Para", {"Me", "Campfire", "Workbench"})

-- (O resto das funções de Kill Aura/God Mode continuam como antes)
