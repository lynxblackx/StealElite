-- modules/settings.lua
local Settings = {}

local FILE_NAME = "StealElite_Settings.json"
local HttpService = game:GetService("HttpService")

function Settings:Init(Shared)
    self.Shared = Shared
    self:load() -- Cargar al iniciar
end

function Settings:save()
    local data = {
        speedEnabled = self.Shared.State.speedEnabled,
        treadmillEnabled = self.Shared.State.treadmillEnabled,
        stealFilters = self.Shared.State.stealFilters
    }
    
    -- Usamos pcall por si el executor no soporta writefile
    pcall(function()
        if writefile and isfile then
            writefile(FILE_NAME, HttpService:JSONEncode(data))
        end
    end)
end

function Settings:load()
    pcall(function()
        if readfile and isfile and isfile(FILE_NAME) then
            local data = HttpService:JSONDecode(readfile(FILE_NAME))
            
            -- Aplicar configuraciones guardadas al estado
            if data.speedEnabled ~= nil then 
                self.Shared.State.speedEnabled = data.speedEnabled 
            end
            if data.treadmillEnabled ~= nil then 
                self.Shared.State.treadmillEnabled = data.treadmillEnabled 
            end
            if data.stealFilters then
                for rarity, enabled in pairs(data.stealFilters) do
                    self.Shared.State.stealFilters[rarity] = enabled
                end
            end
            
            self.Shared.Utils:log("⚙️ Configuración guardada cargada exitosamente")
        end
    end)
end

return Settings