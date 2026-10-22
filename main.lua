-- ============================================
-- STEAL ELITE v15 - LOADER PRINCIPAL
-- Usuario: lynxblackx
-- ============================================

local BASE_URL = "https://raw.githubusercontent.com/lynxblackx/StealElite/refs/heads/main/modules/"

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

-- Función para cargar módulos con manejo de errores
local function loadModule(name)
    local url = BASE_URL .. name .. ".lua"
    
    local success, result = pcall(function()
        local code = game:HttpGet(url)
        local func, err = loadstring(code)
        if not func then
            error("Error compilando " .. name .. ": " .. tostring(err))
        end
        return func()
    end)
    
    if success and result then
        print("✅ " .. name .. " cargado correctamente")
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

print(" Steal Elite - Iniciando carga de módulos...")

-- Cargar módulos en orden
local ConfigData = loadModule("config")
if not ConfigData then
    warn("❌ No se pudo cargar config.lua - Abortando")
    return
end

local Utils = loadModule("utils")
if not Utils then
    warn("❌ No se pudo cargar utils.lua - Abortando")
    return
end

local GUI = loadModule("gui")
if not GUI then
    warn("❌ No se pudo cargar gui.lua - Abortando")
    return
end

local Core = loadModule("core")
if not Core then
    warn("❌ No se pudo cargar core.lua - Abortando")
    return
end

local Settings = loadModule("settings")
if not Settings then
    warn("⚠️ settings.lua no encontrado - Continuando sin guardado persistente")
    Settings = nil
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
        isMinimized = false,
        robLog = {},
        eggs = {},
        eggEntries = {},
        espObjects = {},
        stealFilters = {},
        espFilters = {},
        rarityCache = {},
        myTreadmill = nil,
        myTreadmillPos = nil,
        selectedPlotIndex = 0,
        plots = {}
    },
    GUI = {},
    Switches = {},
    Buttons = {
        steal = {},
        esp = {}
    }
}

-- Inicializar filtros
for _, r in ipairs(Shared.Rarities) do
    Shared.State.stealFilters[r.name] = true
    Shared.State.espFilters[r.name] = true
end

-- Agregar Settings al Shared si existe
if Settings then
    Shared.Settings = Settings
end

-- Inicializar módulos en orden
print("🔧 Inicializando módulos...")

Utils:init(Shared)
print("✅ Utils inicializado")

GUI:Build(Shared)
print("✅ GUI construida")

Core:Init(Shared)
print("✅ Core inicializado")

if Settings then
    Settings:Init(Shared)
    print("✅ Settings inicializado")
else
    print("⚠️ Settings no disponible - sin guardado persistente")
end

Core:StartLoops(Shared)
print("✅ Loops iniciados")

print("🚀 Steal Elite v15 Modular cargado exitosamente")
Shared.Utils:log("✅ Listo - Presiona INICIAR LOOP")