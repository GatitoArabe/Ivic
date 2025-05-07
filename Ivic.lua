local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Ivic  " .. Fluent.Version,
    SubTitle = "Feito com  por arabicsc",
    TabWidth = 160,
    Size = UDim2.new(0, 580, 0, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local function AddTab(window, title, icon)
    return window:AddTab({
        Title = title,
        Icon = icon or ""
    })
end

local Tabs = {
    Main = AddTab(Window, "Main"),
}

-- Tabela de ilhas e coordenadas
local ilhas = {
    ["🏴‍☠️ Pirates Starter Island"] = Vector3.new(1114.1, 16.3, 1429.9),
    ["⚓ Marine Starter Island"] = Vector3.new(-2748.2, 24.5, 2194.8),
    ["🐒 Jungle"] = Vector3.new(-1429.1, 61.8, -21.2),
    ["🏘️ Pirate Village"] = Vector3.new(-1178.6, 44.7, 3845.0),
    ["🏜️ Desert"] = Vector3.new(959.1, 6.4, 4215.5),
    ["🏝️ Middle Island"] = Vector3.new(-653.7, 7.8, 1570.8),
    ["❄️ Frozen Village"] = Vector3.new(1406.1, 87.3, -1347.3),
    ["🏰 Marine Fortress"] = Vector3.new(-4871.3, 20.6, 4331.3),
    ["☁️ Lower Skylands"] = Vector3.new(-5250.1, 388.6, -2255.4),
    ["🧱 Prison"] = Vector3.new(5097.2, 3.5, 791.8),
    ["🏟️ Colosseum"] = Vector3.new(-1498.8, 7.4, -2957.8),
    ["🌋 Magma Village"] = Vector3.new(-5331.5, 9.0, 8534.3),
    ["🌊 Underwater City"] = Vector3.new(4030.9, 2.0, -1815.8),
    ["☁️ Middle Skylands"] = Vector3.new(-4791.7, 717.7, -2620.2),
    ["☁️ Upper Skylands"] = Vector3.new(-7885.9, 5636.0, -1398.6),
    ["⛲ Fountain City"] = Vector3.new(5233.0, 38.5, 4066.6)
}

-- Junta a lista para o dropdown (com Null)
local islandNames = { "🛑 Null" }
for name, _ in pairs(ilhas) do
    table.insert(islandNames, name)
end

-- Variável para armazenar a ilha selecionada
local ilhaSelecionada = "🛑 Null"

-- Dropdown único
local Dropdown = Tabs.Main:AddDropdown("DropdownIlhaTP", {
    Title = "Selecionar Ilha",
    Values = islandNames,
    Multi = false,
    Default = 1,
    Callback = function(value)
        ilhaSelecionada = value
    end
})

-- Função de teleporte
local function TeleportToSelectedIsland()
    if ilhaSelecionada == "🛑 Null" then
        warn("Nenhuma ilha selecionada.")
        return
    end

    local destino = ilhas[ilhaSelecionada]
    if not destino then
        warn("Coordenada não encontrada.")
        return
    end

    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    -- Função para remover colisões
    local function noclipAtivo()
        for _, parte in pairs(char:GetDescendants()) do
            if parte:IsA("BasePart") then
                parte.CanCollide = false
            end
        end
    end

    -- Função para criar BodyVelocity
    local function criarBodyVelocity()
        local bv = Instance.new("BodyVelocity")
        bv.Name = "AutoFly"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        return bv
    end

    _G.pararTP = false
    noclipAtivo()
    local bv = criarBodyVelocity()

    spawn(function()
        while true do
            if _G.pararTP then
                if bv then bv:Destroy() end
                print("Voo cancelado.")
                break
            end

            if not root:FindFirstChild("AutoFly") then
                bv = criarBodyVelocity()
            end

            noclipAtivo()

            if bv then
                local dir = (destino - root.Position).Unit
                bv.Velocity = dir * 200
            end

            if (root.Position - destino).Magnitude < 5 then
                if bv then bv:Destroy() end
                print("Chegou ao destino.")
                -- Fazendo o personagem olhar para o destino
                local lookDirection = (destino - root.Position).Unit
                root.CFrame = CFrame.new(root.Position, root.Position + lookDirection)

                -- Opcional: Alinhar o humanoide para atacar na direção certa
                humanoid:MoveTo(destino)
                humanoid.WalkSpeed = 0  -- Pode ser ajustado, se necessário

                break
            end
            wait(0.1)
        end
    end)
end

-- Botão de start
Tabs.Main:AddButton({
    Title = "Start TP",
    Callback = function()
        TeleportToSelectedIsland()
    end
})

-- Botão de cancelamento
Tabs.Main:AddButton({
    Title = "Cancelar TP",
    Callback = function()
        _G.pararTP = true
    end
})
