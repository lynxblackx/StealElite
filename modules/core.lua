-- ============================================
-- 📍 AUTO PLACE EGG (CORREGIDO - Coordenadas válidas)
-- ============================================
function Core:placeEgg(eggUUID, x, y)
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then 
        self.Utils:log("❌ No Remotes folder")
        return false 
    end
    
    local placeEggRemote = remotes:FindFirstChild("PlaceEggRequest")
    if not placeEggRemote then 
        self.Utils:log("❌ No PlaceEggRequest remote")
        return false 
    end
    
    self.Utils:log("📍 Placing egg: " .. eggUUID .. " at (" .. x .. ", " .. y .. ")")
    
    -- ✅ Usar InvokeServer con UUID, X, Y
    local ok, result = pcall(function()
        return placeEggRemote:InvokeServer(eggUUID, x, y)
    end)
    
    if ok then
        if result == true then
            self.Utils:log("✅ Egg placed successfully")
            self.State.placeCount = (self.State.placeCount or 0) + 1
            return true
        else
            self.Utils:log("⚠️ PlaceEgg returned: " .. tostring(result))
            return false
        end
    else
        self.Utils:log("❌ PlaceEgg failed: " .. tostring(result))
        return false
    end
end

function Core:checkAndPlaceEggs()
    local player = self.Shared.Player
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then 
        self.Utils:log("⚠️ No backpack found")
        return 
    end
    
    -- ✅ Obtener posición del plot
    local plotPos = self:getPlotPosition()
    if not plotPos then
        self.Utils:log("❌ No plot position")
        return
    end
    
    -- ✅ Coordenadas relativas al centro del plot (como en el log de Cobalt)
    -- X: pequeño offset aleatorio (-5 a 5)
    -- Y: altura del suelo del plot (aproximadamente -55 a -60)
    local baseX = 0  -- Centro del plot en X
    local baseY = -55  -- Altura del suelo
    
    local placed = 0
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and placed < 2 then  -- Máximo 2 por ciclo
            local uuid = tool:GetAttribute("UUID") or tool:GetAttribute("Id")
            
            if uuid then
                -- ✅ Coordenadas con pequeño offset aleatorio
                local relX = baseX + math.random(-30, 30) / 10  -- -3 a 3
                local relY = baseY + math.random(-10, 10) / 10  -- -56 a -54
                
                self.Utils:log("🥚 Placing " .. tool.Name .. " at (" .. relX .. ", " .. relY .. ")")
                local success = self:placeEgg(uuid, relX, relY)
                
                if success then
                    placed = placed + 1
                    task.wait(2)  -- Esperar entre colocaciones
                else
                    self.Utils:log("️ Failed to place " .. tool.Name)
                    break  -- Si falla uno, detener
                end
            end
        end
    end
end

-- ============================================
-- 🔓 AUTO OPEN EGG (CORREGIDO - Detectar notificación)
-- ============================================
function Core:openEgg(eggUUID)
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local eggGuiAction = remotes:FindFirstChild("EggGuiAction")
    if not eggGuiAction then return false end
    
    self.Utils:log("🔓 Opening egg: " .. eggUUID)
    
    -- ✅ Invocar con "Open" y UUID
    local ok, result = pcall(function()
        return eggGuiAction:InvokeServer("Open", eggUUID)
    end)
    
    if ok and result then
        if result[1] == true then
            self.Utils:log("✅ Egg opened: " .. (result[2] or "success"))
            self.State.openCount = (self.State.openCount or 0) + 1
            return true
        else
            self.Utils:log("⚠️ Open failed: " .. tostring(result[2]))
            return false
        end
    else
        self.Utils:log("❌ Open error: " .. tostring(result))
        return false
    end
end

function Core:checkAndOpenEggs()
    -- ✅ Buscar huevos colocados en el plot que estén listos
    local workspace = self.Shared.Services.Workspace
    local essentials = workspace:FindFirstChild("Essentials")
    if not essentials then return end
    
    local tycoons = essentials:FindFirstChild("Tycoons")
    if not tycoons then return end
    
    -- Buscar en el plot del jugador
    if _G.MyPlot then
        local plotArea = _G.MyPlot:FindFirstChild("PlotArea")
        if plotArea then
            for _, child in ipairs(plotArea:GetChildren()) do
                -- Buscar huevos colocados (tienen UUID en atributos)
                local uuid = child:GetAttribute("UUID") or child:GetAttribute("Id")
                if uuid and child.Name:lower():find("egg") then
                    self.Utils:log("🥚 Found placed egg: " .. child.Name)
                    self:openEgg(uuid)
                    task.wait(1)
                end
            end
        end
    end
end

-- ============================================
-- 💰 AUTO SELL ALL (CORREGIDO)
-- ============================================
function Core:sellAll()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local sellRemote = remotes:FindFirstChild("Sell")
    if not sellRemote then return false end
    
    self.Utils:log("💰 Selling all animals...")
    
    -- ✅ Usar FireServer(true) para vender todo
    local ok = pcall(function()
        sellRemote:FireServer(true)
    end)
    
    if ok then
        self.Utils:log("✅ Sale completed")
        self.State.sellCount = (self.State.sellCount or 0) + 1
        return true
    else
        self.Utils:log("❌ Sale failed")
        return false
    end
end

-- ============================================
-- ⭐ AUTO EQUIP BEST (CORREGIDO)
-- ============================================
function Core:equipBest()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local animalGuiAction = remotes:FindFirstChild("AnimalGuiAction")
    if not animalGuiAction then return false end
    
    self.Utils:log("⭐ Equipping best animals...")
    
    -- ✅ Usar InvokeServer("EquipBest")
    local ok, result = pcall(function()
        return animalGuiAction:InvokeServer("EquipBest")
    end)
    
    if ok and result then
        if result[1] == true then
            self.Utils:log("✅ Best equipped: " .. (result[2] or "success"))
            return true
        else
            self.Utils:log("⚠️ Equip failed: " .. tostring(result[2]))
            return false
        end
    else
        self.Utils:log(" Equip error: " .. tostring(result))
        return false
    end
end

-- ============================================
-- 🎁 AUTO OFFLINE REWARD (CORREGIDO)
-- ============================================
function Core:claimOfflineReward()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local offlineReward = remotes:FindFirstChild("OfflineReward")
    if not offlineReward then return false end
    
    self.Utils:log("🎁 Claiming offline reward...")
    
    -- ✅ Invocar con "Get"
    local ok, result = pcall(function()
        return offlineReward:InvokeServer("Get")
    end)
    
    if ok and result then
        local data = result[1]
        if data and type(data) == "table" then
            local amount = data.Amount or 0
            local seconds = data.Seconds or 0
            
            if amount > 0 then
                self.Utils:log("✅ Reward claimed: $" .. amount .. " (" .. seconds .. "s offline)")
                return true
            else
                self.Utils:log("⚠️ No reward available (Amount: " .. amount .. ", Seconds: " .. seconds .. ")")
                return false
            end
        end
    else
        self.Utils:log(" Offline reward error: " .. tostring(result))
    end
    
    return false
end

-- ============================================
-- 🔔 LISTENER DE NOTIFICACIONES (NUEVO)
-- ============================================
function Core:listenForNotifications()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    
    local notificationRemote = remotes:FindFirstChild("Notification")
    if not notificationRemote then return end
    
    -- ✅ Escuchar notificaciones del servidor
    notificationRemote.OnClientEvent:Connect(function(message, ...)
        if message then
            -- Detectar huevo listo para abrir
            if message:find("ready to hatch") then
                self.Utils:log("🎯 Egg ready to hatch detected!")
                self.State.eggReadyToOpen = true
            end
            
            -- Detectar huevo colocado
            if message:find("placed!") then
                self.Utils:log("✅ " .. message)
            end
            
            -- Detectar venta
            if message:find("Sold") then
                self.Utils:log("💰 " .. message)
            end
        end
    end)
end