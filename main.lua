-- ============================================
-- STEAL ELITE v18 - LOADER COMPLETO
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/lynxblackx/StealElite/refs/heads/main/modules/"

local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService"),
    CoreGui = game:GetService("CoreGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
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

for _, gui in pairs(Services.CoreGui:GetChildren()) do
    if gui.Name == "StealEliteV18" then gui:Destroy() end
end

print("🥷 Steal Elite v18 - Iniciando...")

local ConfigData = loadModule("config")
if not ConfigData then return end
local Utils = loadModule("utils")
if not Utils then return end
local GUI = loadModule("gui")
if not GUI then return end
local Core = loadModule("core")
if not Core then return end
local Settings = loadModule("settings")

local Shared = {
    Services = Services,
    Player = player,
    Config = ConfigData.CONFIG,
    Rarities = ConfigData.RARITIES,
    Utils = Utils,
    State = {
        loopRunning = false, speedEnabled = true, afkEnabled = true,
        espEnabled = true, treadmillEnabled = false, rebirthEnabled = false,
        placeEggEnabled = false, openEggEnabled = false,
        sellEnabled = false, equipBestEnabled = false,
        offlineRewardEnabled = false,
        onTreadmill = false, stolenCount = 0, failedCount = 0,
        afkCount = 0, espCount = 0, treadmillTime = 0,
        sellCount = 0, openCount = 0, placeCount = 0,
        currentSlot = 1, lastInput = tick(), lastAfk = tick(),
        lastSell = tick(), lastOpen = tick(), lastPlace = tick(),
        isAfk = false, isMinimized = false,
        robLog = {}, eggs = {}, eggEntries = {}, espObjects = {},
        stealFilters = {}, espFilters = {}, rarityCache = {},
        currentBoostUUID = nil, pendingEggs = {}
    },
    GUI = {}, Switches = {}, Buttons = {steal = {}, esp = {}}
}

for _, r in ipairs(Shared.Rarities) do
    Shared.State.stealFilters[r.name] = true
    Shared.State.espFilters[r.name] = true
end

if Settings then Shared.Settings = Settings end

Utils:init(Shared)
GUI:Build(Shared)
Core:Init(Shared)
Shared.Core = Core

if Settings then Settings:Init(Shared) end

Core:StartLoops(Shared)
print("🚀 Steal Elite v18 listo - Todas las funciones activas")