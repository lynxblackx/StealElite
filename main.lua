-- ============================================
-- STEAL ELITE v16 - LOADER
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/lynxblackx/StealElite/refs/heads/main/modules/"

local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService"),
    CoreGui = game:GetService("CoreGui"),
    HttpService = game:GetService("HttpService")
}

local player = Services.Players.LocalPlayer

local function loadModule(name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. name .. ".lua"))()
    end)
    if success and result then
        print("✅ " .. name .. " cargado")
        return result
    else
        warn("❌ Error en " .. name .. ": " .. tostring(result))
        return nil
    end
end

-- Limpiar GUIs anteriores
for _, gui in pairs(Services.CoreGui:GetChildren()) do
    if gui.Name == "StealEliteV16" then gui:Destroy() end
end

print("🥷 Steal Elite v16 - Iniciando...")

-- Cargar módulos en orden estricto
local ConfigData = loadModule("config")
if not ConfigData then return end

local Utils = loadModule("utils")
if not Utils then return end

local GUI = loadModule("gui")
if not GUI then return end

local Core = loadModule("core")
if not Core then return end

local Settings = loadModule("settings") -- opcional

-- Tabla compartida (el "cerebro" que conecta todo)
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
        rarityCache = {}
    },
    GUI = {},
    Switches = {},
    Buttons = {steal = {}, esp = {}}
}

-- Inicializar filtros
for _, r in ipairs(Shared.Rarities) do
    Shared.State.stealFilters[r.name] = true
    Shared.State.espFilters[r.name] = true
end

if Settings then Shared.Settings = Settings end

-- Inicializar en orden
Utils:init(Shared)
GUI:Build(Shared)
Core:Init(Shared)
Shared.Core = Core -- importante para que GUI pueda llamar a Core

if Settings then
    Settings:Init(Shared)
end

Core:StartLoops(Shared)

print(" Steal Elite v16 listo")