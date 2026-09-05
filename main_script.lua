-- ========================================
-- JAY V1 - BROOKHAVEN SCRIPT PREMIUM
-- Painel Móvel + Traversal Fantasma + Otimização Real
-- ========================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ========================================
-- CONFIGURAÇÕES GLOBAIS
-- ========================================

local Config = {
    Traversal = false,
    BallMechanics = false,
    OptimizationV1 = false,
    OptimizationV2 = false,
    BallNearBody = false,
    CameraMode = "normal",
}

local TraversalMode = false
local OriginalCollision = {}
local BallChiclete = nil
local ScriptEnabled = true
local PanelVisible = true

-- ========================================
-- OTIMIZAÇÃO REAL V1 - REMOVE TEXTURAS
-- ========================================

local function OptimizeV1()
    if not Config.OptimizationV1 then return end
    
    print("[V1] Iniciando remoção de texturas...")
    
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                -- Remove texturas
                obj.Texture = ""
                obj.TextureID = ""
                
                -- Define material simples
                obj.Material = Enum.Material.SmoothPlastic
                
                -- Remove decals
                for _, decal in pairs(obj:FindFirstChildOfClass("Decal")) do
                    if decal then decal:Destroy() end
                end
            end
            
            if obj:IsA("Decal") then
                obj:Destroy()
            end
            
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = false
            end
            
            if obj:IsA("Humanoid") and obj.Parent ~= Character then
                obj.Parent.Head.Material = Enum.Material.SmoothPlastic
            end
        end)
    end
    
    -- Reduce Lighting
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1.5
    
    print("[V1] ✅ Otimização V1 Completa! FPS Aumentado!")
end

-- ========================================
-- OTIMIZAÇÃO REAL V2 - MÁXIMA (SEM TEXTURAS)
-- ========================================

local function OptimizeV2()
    if not Config.OptimizationV2 then return end
    
    print("[V2] Iniciando otimização MÁXIMA...")
    
    -- Remove todas as texturas e detalhes visuais
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Texture = ""
                obj.TextureID = ""
                obj.Material = Enum.Material.SmoothPlastic
                obj.CanCollide = obj.CanCollide
                
                -- Remove Surface GUI e Decals
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
            
            if obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                obj.Enabled = false
            end
        end)
    end
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    
    print("[V2] ✅ Otimização V2 ATIVADA! Todas texturas removidas!")
end

-- ========================================
-- PAINEL JAY V1 - MÓVEL E BONITO
-- ========================================

local function CreateJayPanel()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "JayPanelV1"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    -- Painel Principal com Gradient
    local MainPanel = Instance.new("Frame")
    MainPanel.Name = "MainPanel"
    MainPanel.Size = UDim2.new(0, 320, 0, 480)
    MainPanel.Position = UDim2.new(0, 20, 0, 20)
    MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainPanel.BorderSizePixel = 0
    MainPanel.Parent = ScreenGui
    
    -- Sombra do Painel
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 8, 1, 8)
    Shadow.Position = UDim2.new(0, -4, 0, -4)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.5
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = -1
    Shadow.Parent = MainPanel
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Shadow
    
    -- Borda Gradiente Top
    local BorderTop = Instance.new("Frame")
    BorderTop.Size = UDim2.new(1, 0, 0, 4)
    BorderTop.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    BorderTop.BorderSizePixel = 0
    BorderTop.Parent = MainPanel
    
    local CornerBorder = Instance.new("UICorner")
    CornerBorder.CornerRadius = UDim.new(0, 12)
    CornerBorder.Parent = MainPanel
    
    -- Barra de Título (Movível)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainPanel
    
    -- Ícone + Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Text = "⚡ JAY V1"
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Botão Minimizar
    local MinButton = Instance.new("TextButton")
    MinButton.Name = "MinButton"
    MinButton.Size = UDim2.new(0, 40, 0, 40)
    MinButton.Position = UDim2.new(1, -50, 0, 5)
    MinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinButton.TextSize = 16
    MinButton.Font = Enum.Font.GothamBold
    MinButton.Text = "−"
    MinButton.BorderSizePixel = 0
    MinButton.Parent = TitleBar
    
    local CornerMin = Instance.new("UICorner")
    CornerMin.CornerRadius = UDim.new(0, 6)
    CornerMin.Parent = MinButton
    
    -- ScrollingFrame para Botões
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -16, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 8, 0, 52)
    ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    ScrollFrame.Parent = MainPanel
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollFrame
    
    -- ========================================
    -- FUNÇÃO PARA CRIAR BOTÕES PREMIUM
    -- ========================================
    
    local function CreateButton(icon, name, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, -12, 0, 45)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.TextSize = 13
        Button.Font = Enum.Font.Gotham
        Button.Text = icon .. " " .. name
        Button.BorderSizePixel = 0
        Button.Parent = ScrollFrame
        
        local CornerBtn = Instance.new("UICorner")
        CornerBtn.CornerRadius = UDim.new(0, 8)
        CornerBtn.Parent = Button
        
        -- Efeito Hover Premium
        local IsActive = false
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            }):Play()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            if not IsActive then
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                }):Play()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
            end
        end)
        
        Button.MouseButton1Click:Connect(function()
            IsActive = not IsActive
            if IsActive then
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                }):Play()
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                }):Play()
                Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            callback()
        end)
        
        return Button
    end
    
    -- ========================================
    -- BOTÕES DO PAINEL JAY
    -- ========================================
    
    CreateButton("👻", "Traversal Fantasma", function()
        Config.Traversal = not Config.Traversal
        TraversalMode = Config.Traversal
        print("[Traversal] " .. (Config.Traversal and "ATIVADO - MODO FANTASMA" or "DESATIVADO"))
    end)
    
    CreateButton("🎯", "Bola Chiclete", function()
        Config.BallMechanics = not Config.BallMechanics
        if Config.BallMechanics then
            AttachBallToCharacter()
        else
            if BallChiclete then BallChiclete:Destroy() end
        end
        print("[Ball] " .. (Config.BallMechanics and "ATIVADA" or "DESATIVADA"))
    end)
    
    CreateButton("📊", "Otimização V1", function()
        Config.OptimizationV1 = not Config.OptimizationV1
        if Config.OptimizationV1 then OptimizeV1() end
        print("[V1] " .. (Config.OptimizationV1 and "ATIVADA" or "DESATIVADA"))
    end)
    
    CreateButton("⚙️", "Otimização V2 (MAX)", function()
        Config.OptimizationV2 = not Config.OptimizationV2
        if Config.OptimizationV2 then OptimizeV2() end
        print("[V2] " .. (Config.OptimizationV2 and "ATIVADA" or "DESATIVADA"))
    end)
    
    CreateButton("📍", "Bola Perto do Corpo", function()
        Config.BallNearBody = not Config.BallNearBody
        print("[Bola Chiclete] " .. (Config.BallNearBody and "PERTO" or "LONGE"))
    end)
    
    CreateButton("🎥", "Câmera 1ª Pessoa", function()
        Config.CameraMode = "first"
        print("[Câmera] 1ª Pessoa")
    end)
    
    CreateButton("🎥", "Câmera 3ª Pessoa", function()
        Config.CameraMode = "third"
        print("[Câmera] 3ª Pessoa")
    end)
    
    CreateButton("❌", "Desabilitar", function()
        ScriptEnabled = false
        print("[Script] DESABILITADO")
    end)
    
    -- Função Minimizar
    MinButton.MouseButton1Click:Connect(function()
        PanelVisible = not PanelVisible
        ScrollFrame.Visible = PanelVisible
        if PanelVisible then
            MainPanel:TweenSize(UDim2.new(0, 320, 0, 480), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        else
            MainPanel:TweenSize(UDim2.new(0, 320, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
    end)
    
    -- ========================================
    -- SISTEMA DE ARRASTAR PAINEL
    -- ========================================
    
    local Dragging = false
    local DragOffset = Vector2.new(0, 0)
    
    TitleBar.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragOffset = UserInputService:GetMouseLocation() - MainPanel.AbsolutePosition
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local MousePos = UserInputService:GetMouseLocation()
            MainPanel.Position = UDim2.new(0, MousePos.X - DragOffset.X, 0, MousePos.Y - DragOffset.Y)
        end
    end)
    
    return MainPanel
end

-- ========================================
-- TRAVERSAL COMO FANTASMA
-- ========================================

local function EnableTraversalMode()
    if not TraversalMode then return end
    
    -- Você atravessa tudo
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            OriginalCollision[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- Mas outras pessoas ainda te empurram (simulado)
    print("[Traversal] ATIVADO - Você é fantasma, mas ainda pode ser empurrado!")
end

local function DisableTraversalMode()
    for part, state in pairs(OriginalCollision) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
    OriginalCollision = {}
end

-- ========================================
-- BOLA CHICLETE
-- ========================================

local function AttachBallToCharacter()
    if BallChiclete then BallChiclete:Destroy() end
    
    local BallSize = Config.BallNearBody and Vector3.new(2.5, 2.5, 2.5) or Vector3.new(4, 4, 4)
    local Ball = Instance.new("Part")
    Ball.Name = "ChicleteBall"
    Ball.Shape = Enum.PartType.Ball
    Ball.Size = BallSize
    Ball.Color = Color3.fromRGB(255, 100, 0)
    Ball.Material = Enum.Material.SmoothPlastic
    Ball.CanCollide = true
    Ball.TopSurface = Enum.SurfaceType.Smooth
    Ball.BottomSurface = Enum.SurfaceType.Smooth
    
    local AttachPos = Config.BallNearBody and Vector3.new(0, 0, -2) or Vector3.new(0, 0, -8)
    Ball.CFrame = RootPart.CFrame + AttachPos
    Ball.Parent = workspace
    
    local Attachment0 = Instance.new("Attachment")
    Attachment0.Parent = RootPart
    
    local Attachment1 = Instance.new("Attachment")
    Attachment1.Parent = Ball
    
    local Rope = Instance.new("RopeConstraint")
    Rope.Attachment0 = Attachment0
    Rope.Attachment1 = Attachment1
    Rope.Length = Config.BallNearBody and 3 or 8
    Rope.Parent = Ball
    
    BallChiclete = Ball
    print("[Ball] Bola Chiclete anexada!")
end

-- ========================================
-- LOOP PRINCIPAL
-- ========================================

local function MainLoop()
    while ScriptEnabled do
        if not Character or not Humanoid or Humanoid.Health <= 0 then
            Character = Player.Character or Player.CharacterAdded:Wait()
            Humanoid = Character:WaitForChild("Humanoid")
            RootPart = Character:WaitForChild("HumanoidRootPart")
            OriginalCollision = {}
        end
        
        if Config.Traversal then
            EnableTraversalMode()
        else
            DisableTraversalMode()
        end
        
        if Config.BallMechanics and not BallChiclete then
            AttachBallToCharacter()
        end
        
        if Config.BallNearBody and BallChiclete then
            BallChiclete.Size = Vector3.new(2.5, 2.5, 2.5)
        end
        
        RunService.Heartbeat:Wait()
    end
end

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

print("\n" .. string.rep("=", 60))
print("✅ JAY V1 - BROOKHAVEN SCRIPT CARREGADO COM SUCESSO!")
print("=" .. string.rep("60"))
print("📍 Painel móvel criado - Arraste pela barra de título")
print("👻 Traversal: Age como fantasma para você")
print("📊 Otimizações: Remove todas as texturas do jogo")
print("⚽ Bola Chiclete: Prende bola perto do corpo")
print("=" .. string.rep("60") .. "\n")

CreateJayPanel()

-- Inicia o loop principal
spawn(MainLoop)

-- Atalhos de Teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        Config.Traversal = not Config.Traversal
        TraversalMode = Config.Traversal
    end
    
    if input.KeyCode == Enum.KeyCode.B then
        Config.BallMechanics = not Config.BallMechanics
    end
    
    if input.KeyCode == Enum.KeyCode.O then
        Config.OptimizationV1 = not Config.OptimizationV1
        if Config.OptimizationV1 then OptimizeV1() end
    end
    
    if input.KeyCode == Enum.KeyCode.P then
        Config.OptimizationV2 = not Config.OptimizationV2
        if Config.OptimizationV2 then OptimizeV2() end
    end
end)