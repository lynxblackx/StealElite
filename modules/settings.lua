-- ============================================
-- GUARDADO PERSISTENTE
-- ============================================
local Settings = {}

local FILE_NAME = "StealElite_Settings.json"

function Settings:Init(Shared)
    self.Shared = Shared
    self:load()
end

function Settings:save()
    local data = {
        speedEnabled = self.Shared.State.speedEnabled,
        treadmillEnabled = self.Shared.State.treadmillEnabled,
        afkEnabled = self.Shared.State.afkEnabled,
        espEnabled = self.Shared.State.espEnabled,
        stealFilters = self.Shared.State.stealFilters,
        espFilters = self.Shared.State.espFilters
    }
    
    pcall(function()
        if writefile and isfile then
            writefile(FILE_NAME, game:GetService("HttpService"):JSONEncode(data))
            self.Shared.Utils:log("💾 Configuración guardada")
        end
    end)
end

function Settings:load()
    pcall(function()
        if readfile and isfile and isfile(FILE_NAME) then
            local data = game:GetService("HttpService"):JSONDecode(readfile(FILE_NAME))
            
            if data.speedEnabled ~= nil then 
                self.Shared.State.speedEnabled = data.speedEnabled 
            end
            if data.treadmillEnabled ~= nil then 
                self.Shared.State.treadmillEnabled = data.treadmillEnabled 
            end
            if data.afkEnabled ~= nil then 
                self.Shared.State.afkEnabled = data.afkEnabled 
            end
            if data.espEnabled ~= nil then 
                self.Shared.State.espEnabled = data.espEnabled 
            end
            if data.stealFilters then
                for rarity, enabled in pairs(data.stealFilters) do
                    self.Shared.State.stealFilters[rarity] = enabled
                end
            end
            if data.espFilters then
                for rarity, enabled in pairs(data.espFilters) do
                    self.Shared.State.espFilters[rarity] = enabled
                end
            end
            
            self.Shared.Utils:log("⚙️ Configuración cargada")
        end
    end)
end

return Settings