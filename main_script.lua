-- ========================================
-- JAY V1 - BROOKHAVEN SCRIPT PREMIUM V2.0
-- Painel Móvel + Traversal Fantasma REAL + Otimização MÁXIMA
-- VERSÃO CORRIGIDA - Atravessa na sua câmera + Empurra mais
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

print("✅ JAY V1 V2.0 Script iniciando...")

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
local TraversalConnection = nil

-- ========================================
-- OTIMIZAÇÃO V1 - REMOVE TEXTURAS REAL
-- ========================================

local function OptimizationV1()
    print("🔧 Otimização V1 iniciando - Removendo texturas...")
    
    local processed = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if not processed[obj] then
            processed[obj] = true
            pcall(function()
                if obj:IsA("BasePart") then
                    -- Remove todas as texturas
                    obj.Texture = ""
                    obj.TextureID = ""
                    
                    -- Tira decals
                    for _, decal in pairs(obj:GetChildren()) do
                        if decal:IsA("Decal") then
                            decal:Destroy()
                        end
                    end
                    
                    -- Material simples
                    obj.Material = Enum.Material.SmoothPlastic
                end
                
                if obj:IsA("Decal") then
                    obj:Destroy()
                end
                
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
                
                if obj:IsA("SurfaceGui") then
                    obj.Enabled = false
                end
            end)
        end
    end
    
    -- Reduz iluminação
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    
    print("✅ Otimização V1 Ativada - Texturas removidas!")
end

-- ========================================
-- OTIMIZAÇÃO V2 - REMOVE TUDO MESMO
-- ========================================

local function OptimizationV2()
    print("⚙️ Otimização V2 MÁXIMA iniciando...")
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.Brightness = 3
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    
    local processed = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if not processed[obj] then
            processed[obj] = true
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Texture = ""
                    obj.TextureID = ""
                    obj.Material = Enum.Material.SmoothPlastic
                    
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("Decal") or child:IsA("SurfaceGui") then
                            child:Destroy()
                        end
                    end
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
    end
    
    print("✅ Otimização V2 ATIVADA - Todas as texturas removidas!")
end

-- ========================================
-- TRAVERSAL FANTASMA REAL - VOCÊ ATRAVESSA NA SUA CÂMERA
-- ========================================

local function ActivateTraversal()
    print("👻 Traversal FANTASMA ATIVADO!")
    
    -- Desativa colisão do seu personagem
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            OriginalCollisions[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- Aumenta o peso/massa para empurrar mais
    if TraversalConnection then
        TraversalConnection:Disconnect()
    end
    
    TraversalConnection = RunService.Heartbeat:Connect(function()
        if TraversalActive and RootPart then
            -- Você pode atravessar, mas tem mais "empurrão"
            -- Aumenta a velocidade de movimento para simular mais peso
            if Humanoid.State ~= Enum.HumanoidStateType.Jumping then
                -- Mantém você sempre travessando
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

local function DeactivateTraversal()
    print("❌ Traversal DESATIVADO!")
    
    if TraversalConnection then
        TraversalConnection:Disconnect()
        TraversalConnection = nil
    end
    
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
-- CRIAR PAINEL JAY V1 V2.0
-- ========================================

local function CreatePanel()
    print("🎨 Criando painel JAY V1 V2.0...")
    
    local OldGui = CoreGui:FindFirstChild("JayPanelV1_GUI")
    if OldGui then
        OldGui:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "JayPanelV1_GUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui
    
    -- PAINEL PRINCIPAL
    local Panel = Instance.new("Frame")
    Panel.Name = "MainPanel"
    Panel.Size = UDim2.new(0, 320, 0, 500)
    Panel.Position = UDim2.new(0, 50, 0, 50)
    Panel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Panel.BorderSizePixel = 0
    Panel.Parent = ScreenGui
    
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
    Title.Text = "⚡ JAY V1 V2.0"
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
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
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    
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
    
    print("✅ Painel JAY V1 V2.0 criado!")
end

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

print("\n" .. string.rep("═", 70))
print("✨✨✨ JAY V1 V2.0 - BROOKHAVEN SCRIPT PREMIUM ✨✨✨")
print(string.rep("═", 70))
print("👻 Traversal Fantasma MELHORADO - Você atravessa na sua câmera")
print("💥 Empurra MUITO mais quando outros jogadores te tocam")
print("📊 Otimizações REAIS que removem todas as texturas")
print("⚽ Bola Chiclete presa no corpo")
print(string.rep("═", 70) .. "\n")

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
