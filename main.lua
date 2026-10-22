-- ============================================
-- STEAL ELITE v15 - LOADER PRINCIPAL
-- Usuario: lynxblackx
-- ============================================

local BASE_URL = "https://raw.githubusercontent.com/lynxblackx/StealElite/main/modules/"

-- Servicios
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService"),
    VirtualUser = game:GetService("VirtualUser"),
    RunService = game:GetService("RunService"),
    CoreGui = game:GetService("CoreGui")
}

local player = Services.Players.LocalPlayer

-- Función para cargar módulos desde GitHub
local function loadModule(name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. name .. ".lua"))()
    end)
    
    if success and result then
        print("✅ " .. name .. " cargado")
        return result
    else
        warn("❌ Error cargando " .. name .. ": " .. tostring(result))
        return nil
    end
end

-- Limpiar GUIs anteriores
for _, gui in pairs(Services.CoreGui:GetChildren()) do
    if gui.Name == "StealEliteV15" then gui:Destroy() end
end

-- Cargar módulos
print("🥷 Steal Elite - Cargando módulos...")
local ConfigData = loadModule("config")
local Utils = loadModule("utils")
local GUI = loadModule("gui")
local Core = loadModule("core")
local Settings = loadModule("settings")

if not ConfigData or not Utils or not GUI or not Core then
    warn("❌ No se pudieron cargar todos los módulos")
    return
end

-- Crear estado compartido
local Shared = {
    Services = Services,
    Player = player,
    Config = ConfigData.CONFIG,
    Rarities = ConfigData.RARITIES,
    Utils = Utils,
    State = {
        loopRunning = false,
        speedEnabled = true,
        afkEnabled = true,
        espEnabled = true,
        treadmillEnabled = false,
        onTreadmill = false,
        stolenCount = 0,
        failedCount = 0,
        afkCount = 0,
        espCount = 0,
        treadmillTime = 0,
        currentSlot = 1,
        lastInput = tick(),
        lastAfk = tick(),
        isAfk = false,
        robLog = {},
        eggs = {},
        eggEntries = {},
        espObjects = {},
        stealFilters = {},
        espFilters = {},
        myTreadmill = nil,
        myTreadmillPos = nil,
        selectedPlotIndex = 0,
        plots = {}
    },
    GUI = {},
    Switches = {},
    Buttons = {}
}

-- Inicializar filtros
for _, r in ipairs(Shared.Rarities) do
    Shared.State.stealFilters[r.name] = true
    Shared.State.espFilters[r.name] = true
end

-- Inicializar módulos en orden
Utils:init(Shared)
GUI:Build(Shared)
Core:Init(Shared)
Settings:Init(Shared)
Core:StartLoops(Shared)

print("🚀 Steal Elite v15 Modular cargado exitosamente")
Shared.Utils:log("✅ Listo - Presiona INICIAR LOOP")