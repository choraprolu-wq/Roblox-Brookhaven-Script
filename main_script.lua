-- ========================================
-- JAY V1 - BROOKHAVEN SCRIPT PREMIUM
-- Painel Móvel + Traversal Fantasma + Otimização Real
-- VERSÃO CORRIGIDA - PAINEL APARECENDO 100%
-- ========================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

print("✅ JAY V1 Script iniciando...")

-- ========================================
-- VARIÁVEIS GLOBAIS
-- ========================================

local TraversalActive = false
local BallActive = false
local OptV1Active = false
local OptV2Active = false
local BallNearBody = false
local ScriptRunning = true
local BallChiclete = nil
local OriginalCollisions = {}

-- ========================================
-- OTIMIZAÇÃO V1
-- ========================================

local function OptimizationV1()
    print("🔧 Otimização V1 iniciando...")
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Texture = ""
                obj.TextureID = ""
                obj.Material = Enum.Material.SmoothPlastic
            end)
        elseif obj:IsA("Decal") then
            pcall(function()
                obj:Destroy()
            end)
        end
    end
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1.5
    
    print("✅ Otimização V1 Ativada!")
end

-- ========================================
-- OTIMIZAÇÃO V2
-- ========================================

local function OptimizationV2()
    print("⚙️ Otimização V2 iniciando...")
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.Brightness = 3
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Texture = ""
                obj.TextureID = ""
                obj.Material = Enum.Material.SmoothPlastic
            end
            if obj:IsA("Decal") then
                obj:Destroy()
            end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
            if obj:IsA("Light") then
                obj.Enabled = false
            end
        end)
    end
    
    print("✅ Otimização V2 Ativada!")
end

-- ========================================
-- TRAVERSAL
-- ========================================

local function ActivateTraversal()
    print("👻 Traversal ATIVADO!")
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            OriginalCollisions[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end

local function DeactivateTraversal()
    print("❌ Traversal DESATIVADO!")
    for part, state in pairs(OriginalCollisions) do
        if part and part.Parent then
            pcall(function()
                part.CanCollide = state
            end)
        end
    end
    OriginalCollisions = {}
end

-- ========================================
-- BOLA CHICLETE
-- ========================================

local function CreateBall()
    if BallChiclete then
        BallChiclete:Destroy()
    end
    
    print("⚽ Bola Chiclete criada!")
    
    local Ball = Instance.new("Part")
    Ball.Name = "ChicleteBall"
    Ball.Shape = Enum.PartType.Ball
    Ball.Size = BallNearBody and Vector3.new(2.5, 2.5, 2.5) or Vector3.new(4, 4, 4)
    Ball.Color = Color3.fromRGB(255, 130, 0)
    Ball.Material = Enum.Material.SmoothPlastic
    Ball.CanCollide = true
    Ball.CFrame = RootPart.CFrame + RootPart.CFrame.LookVector * 10
    Ball.Parent = workspace
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = RootPart
    weld.Part1 = Ball
    weld.Parent = Ball
    
    BallChiclete = Ball
end

-- ========================================
-- CRIAR PAINEL - VERSÃO CORRIGIDA
-- ========================================

local function CreatePanel()
    print("🎨 Criando painel JAY V1...")
    
    -- Remove painel anterior se existir
    local OldGui = CoreGui:FindFirstChild("JayPanelV1_GUI")
    if OldGui then
        OldGui:Destroy()
    end
    
    -- Criar ScreenGui com as configurações corretas
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "JayPanelV1_GUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui
    
    print("✅ ScreenGui criada")
    
    -- PAINEL PRINCIPAL
    local Panel = Instance.new("Frame")
    Panel.Name = "MainPanel"
    Panel.Size = UDim2.new(0, 320, 0, 500)
    Panel.Position = UDim2.new(0, 50, 0, 50)
    Panel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Panel.BorderSizePixel = 0
    Panel.Parent = ScreenGui
    
    print("✅ Painel criado")
    
    -- Canto arredondado
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Panel
    
    -- BARRA DE TÍTULO
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 60)
    TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Panel
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar
    
    -- Linha azul no topo
    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 4)
    TopLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    TopLine.BorderSizePixel = 0
    TopLine.Parent = TitleBar
    
    -- TÍTULO
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Text = "⚡ JAY V1"
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    print("✅ Título criado")
    
    -- SCROLL FRAME COM BOTÕES
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -16, 1, -70)
    ScrollFrame.Position = UDim2.new(0, 8, 0, 65)
    ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = Panel
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = ScrollFrame
    
    -- Callback para atualizar tamanho do canvas
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    
    print("✅ ScrollFrame criado")
    
    -- FUNÇÃO PARA CRIAR BOTÕES
    local function MakeButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -12, 0, 45)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.BorderSizePixel = 0
        Button.Parent = ScrollFrame
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            }):Play()
        end)
        
        Button.MouseButton1Click:Connect(callback)
    end
    
    -- CRIAR BOTÕES
    MakeButton("👻 Traversal Fantasma", function()
        TraversalActive = not TraversalActive
        if TraversalActive then
            ActivateTraversal()
        else
            DeactivateTraversal()
        end
    end)
    
    MakeButton("⚽ Bola Chiclete", function()
        BallActive = not BallActive
        if BallActive then
            CreateBall()
        elseif BallChiclete then
            BallChiclete:Destroy()
            BallChiclete = nil
        end
    end)
    
    MakeButton("📍 Bola Perto do Corpo", function()
        BallNearBody = not BallNearBody
        if BallActive and BallChiclete then
            BallChiclete:Destroy()
            CreateBall()
        end
    end)
    
    MakeButton("📊 Otimização V1", function()
        OptV1Active = not OptV1Active
        if OptV1Active then
            OptimizationV1()
        end
    end)
    
    MakeButton("⚙️ Otimização V2 (MAX)", function()
        OptV2Active = not OptV2Active
        if OptV2Active then
            OptimizationV2()
        end
    end)
    
    MakeButton("❌ Fechar Script", function()
        ScriptRunning = false
        ScreenGui:Destroy()
    end)
    
    print("✅ Botões criados")
    
    -- SISTEMA DE ARRASTAR PAINEL
    local Dragging = false
    local DragOffset = Vector2.new(0, 0)
    
    TitleBar.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragOffset = UserInputService:GetMouseLocation() - Panel.AbsolutePosition
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local MousePos = UserInputService:GetMouseLocation()
            Panel.Position = UDim2.new(0, MousePos.X - DragOffset.X, 0, MousePos.Y - DragOffset.Y)
        end
    end)
    
    print("✅ Sistema de arrastar configurado")
    print("✅ PAINEL JAY V1 CRIADO COM SUCESSO!")
end

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

print("\n" .. string.rep("═", 70))
print("✨✨✨ JAY V1 - BROOKHAVEN SCRIPT PREMIUM ✨✨✨")
print(string.rep("═", 70))
print("📍 Painel deve aparecer no canto superior esquerdo")
print("👻 Traversal: Ativa modo fantasma")
print("⚽ Bola Chiclete: Prende bola no seu corpo")
print("📊 Otimizações: Remove todas as texturas do jogo")
print(string.rep("═", 70) .. "\n")

-- Criar o painel
CreatePanel()

-- ========================================
-- LOOP PRINCIPAL
-- ========================================

while ScriptRunning do
    if not Character or Humanoid.Health <= 0 then
        Character = Player.Character or Player.CharacterAdded:Wait()
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        OriginalCollisions = {}
    end
    
    RunService.Heartbeat:Wait()
end

print("❌ Script finalizado")
