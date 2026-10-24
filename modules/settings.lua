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
        rebirthEnabled = self.Shared.State.rebirthEnabled,
        boostEnabled = self.Shared.State.boostEnabled,
        placeEggEnabled = self.Shared.State.placeEggEnabled,
        openEggEnabled = self.Shared.State.openEggEnabled,
        sellEnabled = self.Shared.State.sellEnabled,
        equipEnabled = self.Shared.State.equipEnabled,
        offlineRewardEnabled = self.Shared.State.offlineRewardEnabled,
        stealFilters = self.Shared.State.stealFilters,
        espFilters = self.Shared.State.espFilters,
        currentDelay = tonumber(self.Shared.GUI.delayInput.Text) or 0.5
    }
    pcall(function()
        if writefile and isfile then
            writefile(FILE_NAME, self.Shared.Services.HttpService:JSONEncode(data))
        end
    end)
end

function Settings:load()
    pcall(function()
        if readfile and isfile and isfile(FILE_NAME) then
            local data = self.Shared.Services.HttpService:JSONDecode(readfile(FILE_NAME))
            if data.speedEnabled ~= nil then self.Shared.State.speedEnabled = data.speedEnabled end
            if data.treadmillEnabled ~= nil then self.Shared.State.treadmillEnabled = data.treadmillEnabled end
            if data.afkEnabled ~= nil then self.Shared.State.afkEnabled = data.afkEnabled end
            if data.espEnabled ~= nil then self.Shared.State.espEnabled = data.espEnabled end
            if data.rebirthEnabled ~= nil then self.Shared.State.rebirthEnabled = data.rebirthEnabled end
            if data.boostEnabled ~= nil then self.Shared.State.boostEnabled = data.boostEnabled end
            if data.placeEggEnabled ~= nil then self.Shared.State.placeEggEnabled = data.placeEggEnabled end
            if data.openEggEnabled ~= nil then self.Shared.State.openEggEnabled = data.openEggEnabled end
            if data.sellEnabled ~= nil then self.Shared.State.sellEnabled = data.sellEnabled end
            if data.equipEnabled ~= nil then self.Shared.State.equipEnabled = data.equipEnabled end
            if data.offlineRewardEnabled ~= nil then self.Shared.State.offlineRewardEnabled = data.offlineRewardEnabled end
            if data.stealFilters then
                for k, v in pairs(data.stealFilters) do
                    self.Shared.State.stealFilters[k] = v
                end
            end
            if data.espFilters then
                for k, v in pairs(data.espFilters) do
                    self.Shared.State.espFilters[k] = v
                end
            end
            if data.currentDelay then
                self.Shared.GUI.delayInput.Text = tostring(data.currentDelay)
            end
        end
    end)
end

return Settings