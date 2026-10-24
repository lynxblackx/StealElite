local Core = {}

function Core:Init(Shared)
    self.Shared = Shared
    self.Config = Shared.Config
    self.Utils = Shared.Utils
    self.State = Shared.State
    self.GUI = Shared.GUI
    self.Switches = Shared.Switches
    self.Buttons = Shared.Buttons
    
    self.cooldowns = {}
    self.rarityCache = {}
    
    self:connectEvents()
    self:listenForBoostOffers()
    
    task.delay(1.5, function()
        self:autoDetectTreadmill()
    end)
end

-- ============================================
-- 🚀 TREADMILL BOOST (CORREGIDO CON LOG)
-- ============================================
function Core:listenForBoostOffers()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    
    local boostRemote = remotes:FindFirstChild("TreadmillBoost")
    if not boostRemote then return end
    
    -- Escuchar ofertas del servidor
    boostRemote.OnClientEvent:Connect(function(action, uuid)
        if action == "Offer" and uuid then
            self.State.currentBoostUUID = uuid
            self.Utils:log("🎯 Boost disponible: " .. uuid)
        elseif action == "Expired" or action == "Clear" then
            self.State.currentBoostUUID = nil
        end
    end)
end

function Core:claimTreadmillBoost()
    if not self.State.currentBoostUUID then return false end
    
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local boostRemote = remotes:FindFirstChild("TreadmillBoost")
    if not boostRemote then return false end
    
    self.Utils:log("🚀 Reclamando Boost: " .. self.State.currentBoostUUID)
    
    local ok = pcall(function()
        boostRemote:FireServer("Claim", self.State.currentBoostUUID)
    end)
    
    if ok then
        self.Utils:log("✅ Boost reclamado")
        self.State.currentBoostUUID = nil
        return true
    end
    
    return false
end

-- ============================================
-- 🔄 AUTO REBIRTH (CORREGIDO - InvokeServer)
-- ============================================
function Core:doRebirth()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local askRebirth = remotes:FindFirstChild("AskRebirth")
    local doRebirthRemote = remotes:FindFirstChild("DoRebirth")
    
    if askRebirth then
        self.Utils:log("🔄 Consultando AskRebirth...")
        local ok, result = pcall(function() return askRebirth:InvokeServer() end)
        
        if ok and result then
            self.Utils:log("✅ AskRebirth OK")
            if doRebirthRemote then
                task.wait(0.5)
                local ok2 = pcall(function() doRebirthRemote:InvokeServer() end)
                if ok2 then
                    self.Utils:log("✅ Rebirth ejecutado")
                    return true
                end
            end
        else
            self.Utils:log("⚠️ Rebirth no disponible")
        end
    end
    return false
end

-- ============================================
-- 📍 AUTO PLACE EGG
-- ============================================
function Core:placeEgg(eggUUID, x, y)
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local placeEggRemote = remotes:FindFirstChild("PlaceEggRequest")
    if not placeEggRemote then return false end
    
    self.Utils:log(" Colocando huevo en (" .. x .. ", " .. y .. ")")
    
    local ok, result = pcall(function()
        return placeEggRemote:InvokeServer(eggUUID, x, y)
    end)
    
    if ok and result == true then
        self.Utils:log("✅ Huevo colocado")
        self.State.placeCount = self.State.placeCount + 1
        return true
    end
    
    return false
end

-- ============================================
-- 🔓 AUTO OPEN EGG
-- ============================================
function Core:openEgg(eggUUID)
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local eggGuiAction = remotes:FindFirstChild("EggGuiAction")
    if not eggGuiAction then return false end
    
    self.Utils:log("🔓 Abriendo huevo: " .. eggUUID)
    
    local ok, result = pcall(function()
        return eggGuiAction:InvokeServer("Open", eggUUID)
    end)
    
    if ok then
        self.Utils:log("✅ Huevo abierto")
        self.State.openCount = self.State.openCount + 1
        return true
    end
    
    return false
end

-- ============================================
-- 💰 AUTO SELL ALL
-- ============================================
function Core:sellAll()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local sellRemote = remotes:FindFirstChild("Sell")
    if not sellRemote then return false end
    
    self.Utils:log("💰 Vendiendo todos los animales...")
    
    local ok = pcall(function()
        sellRemote:FireServer(true)
    end)
    
    if ok then
        self.Utils:log("✅ Venta realizada")
        self.State.sellCount = self.State.sellCount + 1
        return true
    end
    
    return false
end

-- ============================================
-- ⭐ AUTO EQUIP BEST
-- ============================================
function Core:equipBest()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local animalGuiAction = remotes:FindFirstChild("AnimalGuiAction")
    if not animalGuiAction then return false end
    
    self.Utils:log("⭐ Equipando mejores animales...")
    
    local ok, result = pcall(function()
        return animalGuiAction:InvokeServer("EquipBest")
    end)
    
    if ok then
        self.Utils:log("✅ Mejores animales equipados")
        return true
    end
    
    return false
end

-- ============================================
-- 🎁 AUTO OFFLINE REWARD
-- ============================================
function Core:claimOfflineReward()
    local remotes = self.Shared.Services.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return false end
    
    local offlineReward = remotes:FindFirstChild("OfflineReward")
    if not offlineReward then return false end
    
    self.Utils:log("🎁 Reclamando recompensa offline...")
    
    local ok, result = pcall(function()
        return offlineReward:InvokeServer("Get")
    end)
    
    if ok and result then
        self.Utils:log("✅ Recompensa offline reclamada")
        return true
    end
    
    return false
end

-- ============================================
-- 🎯 AUTO-DETECT TREADMILL
-- ============================================
function Core:autoDetectTreadmill()
    self.Utils:log("🔍 Buscando treadmill automáticamente...")
    local Workspace = self.Shared.Services.Workspace
    local essentials = Workspace:FindFirstChild("Essentials")
    if not essentials then return false end
    local tycoons = essentials:FindFirstChild("Tycoons")
    if not tycoons then return false end
    
    local player = self.Shared.Player
    local char = player.Character
    local myPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
    
    for _, tycoon in ipairs(tycoons:GetChildren()) do
        if tycoon:IsA("Model") or tycoon:IsA("Folder") then
            local owner = tycoon:GetAttribute("Owner") or tycoon:GetAttribute("OwnerUserId") or tycoon:GetAttribute("PlotOwner")
            if owner == player.Name or owner == tostring(player.UserId) then
                local region = tycoon:FindFirstChild("TreadmillRegion")
                if region then
                    local inv = region:FindFirstChild("inv")
                    if inv then
                        local pos = inv:IsA("BasePart") and inv.Position or inv:GetPivot().Position
                        _G.MyTreadmill = region
                        _G.MyTreadmillPos = pos
                        _G.MyPlot = tycoon
                        _G.MyTreadmillInv = inv
                        self.Utils:log("✅ Treadmill detectado por Owner: " .. tycoon.Name)
                        self:updateTreadmillUI(true, tycoon.Name)
                        return true
                    end
                end
            end
        end
    end
    
    if myPos then
        local closest, closestDist, closestTycoon = nil, math.huge, nil
        for _, tycoon in ipairs(tycoons:GetChildren()) do
            if tycoon:IsA("Model") or tycoon:IsA("Folder") then
                local region = tycoon:FindFirstChild("TreadmillRegion")
                if region then
                    local inv = region:FindFirstChild("inv")
                    if inv then
                        local pos = inv:IsA("BasePart") and inv.Position or inv:GetPivot().Position
                        local dist = (myPos - pos).Magnitude
                        if dist < closestDist and dist < 300 then
                            closestDist = dist
                            closest = {region = region, pos = pos, inv = inv}
                            closestTycoon = tycoon
                        end
                    end
                end
            end
        end
        if closest then
            _G.MyTreadmill = closest.region
            _G.MyTreadmillPos = closest.pos
            _G.MyPlot = closestTycoon
            _G.MyTreadmillInv = closest.inv
            self.Utils:log("✅ Treadmill detectado por distancia: " .. closestTycoon.Name)
            self:updateTreadmillUI(true, closestTycoon.Name)
            return true
        end
    end
    
    if _G.MyTreadmill and _G.MyTreadmillPos and _G.MyTreadmill.Parent then
        self.Utils:log("✅ Usando treadmill guardado en _G")
        self:updateTreadmillUI(true, tostring(_G.MyPlot))
        return true
    end
    
    self.Utils:log(" No se pudo auto-detectar")
    self:updateTreadmillUI(false, "No detectado")
    return false
end

function Core:updateTreadmillUI(success, name)
    if self.GUI.treadmillInfo then
        if success then
            self.GUI.treadmillInfo.Text = "🏃 Plot: " .. name .. " ✅"
            self.GUI.treadmillInfo.TextColor3 = self.Config.success
        else
            self.GUI.treadmillInfo.Text = "🏃 Treadmill: ❌ No detectado"
            self.GUI.treadmillInfo.TextColor3 = self.Config.danger
        end
    end
end

function Core:redetectTreadmill()
    self.Utils:log("🔄 Re-detectando treadmill...")
    if self.GUI.treadmillInfo then
        self.GUI.treadmillInfo.Text = "🏃 Buscando..."
        self.GUI.treadmillInfo.TextColor3 = self.Config.accentGold
    end
    _G.MyTreadmill = nil
    _G.MyTreadmillPos = nil
    _G.MyPlot = nil
    return self:autoDetectTreadmill()
end

-- ============================================
-- 🏃 FUNCIONES TREADMILL
-- ============================================
function Core:getTreadmillPart()
    if _G.MyTreadmill and _G.MyTreadmill.Parent then return _G.MyTreadmill end
    local Workspace = self.Shared.Services.Workspace
    local essentials = Workspace:FindFirstChild("Essentials")
    if not essentials then return nil end
    local tycoons = essentials:FindFirstChild("Tycoons")
    if not tycoons then return nil end
    for _, tycoon in ipairs(tycoons:GetChildren()) do
        if tycoon:IsA("Model") or tycoon:IsA("Folder") then
            local region = tycoon:FindFirstChild("TreadmillRegion")
            if region then
                local inv = region:FindFirstChild("inv")
                if inv then return inv end
            end
        end
    end
    return nil
end

function Core:getTreadmillPosition()
    if _G.MyTreadmillPos then return _G.MyTreadmillPos end
    local inv = self:getTreadmillPart()
    if not inv then return nil end
    if inv:IsA("BasePart") then return inv.Position end
    local ok, pivot = pcall(function() return inv:GetPivot().Position end)
    return ok and pivot or nil
end

function Core:isPlayerOnTreadmill()
    local treadmillPos = self:getTreadmillPosition()
    if not treadmillPos then return false end
    local character = self.Shared.Player.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    return (rootPart.Position - treadmillPos).Magnitude < 25
end

function Core:tpToTreadmill()
    local treadmillPos = self:getTreadmillPosition()
    if not treadmillPos then 
        self.Utils:log("❌ Treadmill no encontrado")
        self:updateTreadmillUI(false, "No detectado")
        return false 
    end
    
    self.Utils:log("🏃 TP a: " .. string.format("%.1f, %.1f, %.1f", treadmillPos.X, treadmillPos.Y, treadmillPos.Z))
    self.Utils:teleportTo(treadmillPos, Vector3.new(0, 3, 0))
    task.wait(0.5)
    
    local inv = self:getTreadmillPart()
    if inv then
        for _, desc in ipairs(inv:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                pcall(function() fireproximityprompt(desc) end)
                break
            end
        end
    end
    
    self.State.onTreadmill = true
    self.Utils:log("✅ TP al Treadmill exitoso")
    self.GUI.statusLabel.Text = "🏃 En Treadmill..."
    self.GUI.statusLabel.TextColor3 = self.Config.accentCyan
    
    task.wait(1)
    if self.Switches.boost and self.Switches.boost.state then
        self:claimTreadmillBoost()
    end
    
    return true
end

function Core:leaveTreadmill()
    if self.State.onTreadmill then
        self.State.onTreadmill = false
        self.State.treadmillTime = 0
        self.Utils:log("🚪 Saliendo del Treadmill")
    end
end

-- ============================================
--  EVENTOS (Switches corregidos)
-- ============================================
function Core:connectEvents()
    local GUI = self.GUI
    local State = self.State
    
    GUI.btnLoop.MouseButton1Click:Connect(function()
        if not State.loopRunning then
            GUI.btnLoop.Text = "▶ LOOP ACTIVO"
            GUI.btnLoop.BackgroundColor3 = self.Config.success
            task.spawn(function() self:mainLoop() end)
        end
    end)
    
    GUI.btnStop.MouseButton1Click:Connect(function()
        State.loopRunning = false
        GUI.btnLoop.Text = "▶ INICIAR LOOP"
        GUI.btnLoop.BackgroundColor3 = self.Config.accentPink
        if State.onTreadmill then self:leaveTreadmill() end
    end)
    
    if GUI.btnClearLog then
        GUI.btnClearLog.MouseButton1Click:Connect(function()
            State.robLog = {}
            for _, child in pairs(GUI.logScroll:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end
            self.Utils:log("📋 Registro limpiado")
        end)
    end
    
    if GUI.btnRedetect then
        GUI.btnRedetect.MouseButton1Click:Connect(function()
            self:redetectTreadmill()
        end)
    end
    
    GUI.delayInput:GetPropertyChangedSignal("Text"):Connect(function()
        local clean = GUI.delayInput.Text:gsub("[^0-9.]", "")
        if clean ~= GUI.delayInput.Text then GUI.delayInput.Text = clean end
    end)
    
    GUI.nameFilter:GetPropertyChangedSignal("Text"):Connect(function()
        self:liveScan()
    end)
    
    GUI.btnMin.MouseButton1Click:Connect(function()
        State.isMinimized = not State.isMinimized
        GUI.content.Visible = not State.isMinimized
        GUI.statusBar.Visible = not State.isMinimized
        if State.isMinimized then
            GUI.mainFrame.Size = UDim2.new(0, self.Config.width, 0, 38)
            GUI.btnMin.Text = "+"
        else
            GUI.mainFrame.Size = UDim2.new(0, self.Config.width, 0, self.Config.height)
            GUI.btnMin.Text = "−"
        end
    end)
    
    GUI.btnClose.MouseButton1Click:Connect(function()
        State.loopRunning = false
        if State.speedEnabled then
            local char = self.Shared.Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
        self:clearAllEsp()
        GUI.screenGui:Destroy()
    end)
    
    -- ✅ SWITCHES: UN SOLO handler cada uno
    self.Switches.esp.button.MouseButton1Click:Connect(function()
        State.espEnabled = not State.espEnabled
        self.Switches.esp:setState(State.espEnabled)
        if not State.espEnabled then self:clearAllEsp() end
        self:updateEspVisibility()
        self.Utils:log(State.espEnabled and "👁️ ESP ON" or "👁️ ESP OFF")
    end)
    
    self.Switches.speed.button.MouseButton1Click:Connect(function()
        State.speedEnabled = not State.speedEnabled
        self.Switches.speed:setState(State.speedEnabled)
        if not State.speedEnabled then
            local char = self.Shared.Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
        self.Utils:log(State.speedEnabled and "🏃 Speed ON" or "🏃 Speed OFF")
    end)
    
    self.Switches.afk.button.MouseButton1Click:Connect(function()
        State.afkEnabled = not State.afkEnabled
        self.Switches.afk:setState(State.afkEnabled)
        if State.afkEnabled then State.lastAfk = tick() end
        self.Utils:log(State.afkEnabled and "🛡️ AFK ON" or "🛡️ AFK OFF")
    end)
    
    self.Switches.treadmill.button.MouseButton1Click:Connect(function()
        State.treadmillEnabled = not State.treadmillEnabled
        self.Switches.treadmill:setState(State.treadmillEnabled)
        if not State.treadmillEnabled and State.onTreadmill then
            self:leaveTreadmill()
        end
        self.Utils:log(State.treadmillEnabled and "🏃 Treadmill ON" or "🏃 Treadmill OFF")
        if State.treadmillEnabled then
            task.spawn(function()
                task.wait(0.5)
                if #self:getFilteredEggs() == 0 then
                    self:tpToTreadmill()
                end
            end)
        end
    end)
    
    -- ✅ NUEVOS SWITCHES
    if self.Switches.boost then
        self.Switches.boost.button.MouseButton1Click:Connect(function()
            State.boostEnabled = not State.boostEnabled
            self.Switches.boost:setState(State.boostEnabled)
            self.Utils:log(State.boostEnabled and "⚡ Auto Boost ON" or "⚡ Auto Boost OFF")
        end)
    end
    
    if self.Switches.placeEgg then
        self.Switches.placeEgg.button.MouseButton1Click:Connect(function()
            State.placeEggEnabled = not State.placeEggEnabled
            self.Switches.placeEgg:setState(State.placeEggEnabled)
            self.Utils:log(State.placeEggEnabled and "📍 Auto Place ON" or "📍 Auto Place OFF")
        end)
    end
    
    if self.Switches.openEgg then
        self.Switches.openEgg.button.MouseButton1Click:Connect(function()
            State.openEggEnabled = not State.openEggEnabled
            self.Switches.openEgg:setState(State.openEggEnabled)
            self.Utils:log(State.openEggEnabled and "🔓 Auto Open ON" or " Auto Open OFF")
        end)
    end
    
    if self.Switches.sell then
        self.Switches.sell.button.MouseButton1Click:Connect(function()
            State.sellEnabled = not State.sellEnabled
            self.Switches.sell:setState(State.sellEnabled)
            self.Utils:log(State.sellEnabled and "💰 Auto Sell ON" or "💰 Auto Sell OFF")
        end)
    end
    
    if self.Switches.equip then
        self.Switches.equip.button.MouseButton1Click:Connect(function()
            State.equipEnabled = not State.equipEnabled
            self.Switches.equip:setState(State.equipEnabled)
            self.Utils:log(State.equipEnabled and "⭐ Equip Best ON" or "⭐ Equip Best OFF")
        end)
    end
    
    if self.Switches.rebirth then
        self.Switches.rebirth.button.MouseButton1Click:Connect(function()
            State.rebirthEnabled = not State.rebirthEnabled
            self.Switches.rebirth:setState(State.rebirthEnabled)
            self.Utils:log(State.rebirthEnabled and "🔄 Auto Rebirth ON" or "🔄 Auto Rebirth OFF")
        end)
    end
    
    if self.Switches.offline then
        self.Switches.offline.button.MouseButton1Click:Connect(function()
            State.offlineRewardEnabled = not State.offlineRewardEnabled
            self.Switches.offline:setState(State.offlineRewardEnabled)
            self.Utils:log(State.offlineRewardEnabled and "🎁 Offline Reward ON" or "🎁 Offline Reward OFF")
        end)
    end
    
    -- Hotkeys
    self.Shared.Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if self.Shared.Services.UserInputService:GetFocusedTextBox() then return end
        State.lastInput = tick()
        if input.KeyCode == Enum.KeyCode.F1 then
            if State.loopRunning then GUI.btnStop:Fire() else GUI.btnLoop:Fire() end
        elseif input.KeyCode == Enum.KeyCode.F2 then
            self.Switches.treadmill:setState(not self.Switches.treadmill.state)
        elseif input.KeyCode == Enum.KeyCode.F3 then
            self.Switches.esp:setState(not self.Switches.esp.state)
        elseif input.KeyCode == Enum.KeyCode.F4 then
            self.Switches.speed:setState(not self.Switches.speed.state)
        elseif input.KeyCode == Enum.KeyCode.F5 then
            self.Switches.afk:setState(not self.Switches.afk.state)
        elseif input.KeyCode == Enum.KeyCode.F6 then
            self:applyPreset("TOP")
        elseif input.KeyCode == Enum.KeyCode.F7 then
            self:applyPreset("LEG")
        elseif input.KeyCode == Enum.KeyCode.F8 then
            self:applyPreset("ALL")
        end
    end)
end

function Core:applyPreset(type)
    for _, r in ipairs(self.Shared.Rarities) do
        if type == "TOP" then self.State.stealFilters[r.name] = (r.name == "God" or r.name == "Exclusive" or r.name == "OG")
        elseif type == "LEG" then self.State.stealFilters[r.name] = (r.priority >= 6)
        elseif type == "ALL" then self.State.stealFilters[r.name] = true end
    end
    self:updateFilterUI()
    self.Utils:log(" Preset aplicado: " .. type)
end

-- ============================================
-- 🔄 LOOPS PRINCIPALES
-- ============================================
function Core:StartLoops(Shared)
    -- Speed loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.speedEnabled then
                local character = self.Shared.Player.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.WalkSpeed = self.Config.speedValue end
                end
            end
            task.wait(0.5)
        end
    end)
    
    -- AFK loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.afkEnabled then
                local timeIdle = tick() - self.State.lastInput
                local timeSinceAction = tick() - self.State.lastAfk
                if timeIdle >= self.Config.afkIdleTime then
                    if not self.State.isAfk then self.State.isAfk = true end
                    local randomInterval = math.random(self.Config.afkInterval[1], self.Config.afkInterval[2])
                    if timeSinceAction >= randomInterval then
                        self:performAfkAction()
                    end
                else
                    self.State.isAfk = false
                end
            end
            task.wait(1)
        end
    end)
    
    -- ESP lines loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.espEnabled then self:updateEspLines() end
            task.wait(0.2)
        end
    end)
    
    -- Live scan loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            self:liveScan()
            task.wait(0.8)
        end
    end)
    
    -- ✅ Auto Sell loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.sellEnabled then
                local timeSinceSell = tick() - self.State.lastSell
                if timeSinceSell >= self.Config.sellInterval then
                    self:sellAll()
                    self.State.lastSell = tick()
                end
            end
            task.wait(5)
        end
    end)
    
    -- ✅ Auto Open Egg loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.openEggEnabled then
                self:checkAndOpenEggs()
            end
            task.wait(self.Config.openEggDelay)
        end
    end)
    
    -- ✅ Auto Place Egg loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.placeEggEnabled then
                self:checkAndPlaceEggs()
            end
            task.wait(self.Config.placeEggDelay)
        end
    end)
    
    -- ✅ Auto Equip Best loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.equipEnabled then
                self:equipBest()
            end
            task.wait(30)
        end
    end)
    
    -- ✅ Auto Rebirth loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.rebirthEnabled then
                local success = self:doRebirth()
                if success then
                    task.wait(self.Config.rebirthInterval)
                else
                    task.wait(60)
                end
            else
                task.wait(2)
            end
        end
    end)
    
    -- ✅ Auto Offline Reward loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.offlineRewardEnabled then
                self:claimOfflineReward()
            end
            task.wait(120)
        end
    end)
    
    -- ✅ Auto Boost Claim loop
    task.spawn(function()
        while self.GUI.screenGui and self.GUI.screenGui.Parent do
            if self.State.onTreadmill and self.Switches.boost and self.Switches.boost.state then
                if self.State.currentBoostUUID then
                    self:claimTreadmillBoost()
                    task.wait(3)
                end
            end
            task.wait(1)
        end
    end)
    
    local Workspace = self.Shared.Services.Workspace
    local spawnedEggsFolder = Workspace:FindFirstChild("SpawnedEggs")
    if spawnedEggsFolder then
        spawnedEggsFolder.ChildAdded:Connect(function()
            task.wait(0.2)
            self:liveScan()
        end)
        spawnedEggsFolder.ChildRemoved:Connect(function()
            task.wait(0.2)
            self:liveScan()
        end)
    end
    
    local character = self.Shared.Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = self.Config.speedValue end
    end
    
    self.GUI.statusLabel.Text = "✅ Listo - Presiona INICIAR LOOP"
    self.GUI.statusLabel.TextColor3 = self.Config.success
    self:updateStats()
    self:updateFilterUI()
end

-- ✅ Funciones helper para huevos
function Core:checkAndOpenEggs()
    local playerGui = self.Shared.Player:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    local mainGui = playerGui:FindFirstChild("MainGui")
    if not mainGui then return end
    
    -- Buscar huevos listos para abrir en el inventario
    local eggsFolder = mainGui:FindFirstChild("Eggs") or mainGui:FindFirstChild("Inventory")
    if not eggsFolder then return end
    
    for _, egg in ipairs(eggsFolder:GetChildren()) do
        if egg:IsA("Frame") or egg:IsA("TextButton") then
            local readyLabel = egg:FindFirstChild("Ready") or egg:FindFirstChild("Open")
            if readyLabel and readyLabel.Visible then
                local uuid = egg:GetAttribute("UUID") or egg.Name
                if uuid then
                    self:openEgg(uuid)
                    task.wait(0.5)
                end
            end
        end
    end
end

function Core:checkAndPlaceEggs()
    local playerGui = self.Shared.Player:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    local mainGui = playerGui:FindFirstChild("MainGui")
    if not mainGui then return end
    
    local inventory = mainGui:FindFirstChild("Inventory")
    if not inventory then return end
    
    -- Obtener coordenadas del plot
    local plotPos = self:getPlotPosition()
    if not plotPos then return end
    
    for _, item in ipairs(inventory:GetChildren()) do
        if item:IsA("Frame") or item:IsA("TextButton") then
            local uuid = item:GetAttribute("UUID") or item.Name
            if uuid and not item:GetAttribute("Placed") then
                local x = plotPos.X + math.random(-5, 5)
                local y = plotPos.Y + math.random(-5, 5)
                self:placeEgg(uuid, x, y)
                item:SetAttribute("Placed", true)
                task.wait(0.5)
            end
        end
    end
end

function Core:getPlotPosition()
    if _G.MyPlot then
        local plotArea = _G.MyPlot:FindFirstChild("PlotArea")
        if plotArea and plotArea:IsA("BasePart") then
            return plotArea.Position
        end
    end
    return Vector3.new(0, 0, 0)
end

function Core:updateStats()
    self.GUI.statsLabel.Text = string.format("🥚 %d | 💰 %d | 🔄 %d", 
        self.State.stolenCount, self.State.sellCount, self.State.openCount)
end

function Core:tpToSpawn()
    local Workspace = self.Shared.Services.Workspace
    local essentials = Workspace:FindFirstChild("Essentials")
    if not essentials then return false end
    local tycoons = essentials:FindFirstChild("Tycoons")
    if not tycoons then return false end
    local targetTycoon = _G.MyPlot or tycoons:FindFirstChild("1") or tycoons:FindFirstChild(1)
    if not targetTycoon then return false end
    local plotArea = targetTycoon:FindFirstChild("PlotArea") or targetTycoon:FindFirstChild("Base")
    if not plotArea then return false end
    local pos = plotArea:IsA("BasePart") and plotArea.Position or plotArea:GetPivot().Position
    return self.Utils:teleportTo(pos, Vector3.new(0, 3, 0))
end

function Core:stealEgg(egg)
    if self.cooldowns[egg] then return false end
    self.cooldowns[egg] = true
    task.delay(2, function() self.cooldowns[egg] = nil end)
    local stealPrompt = egg:FindFirstChild("Steal")
    if not stealPrompt or not stealPrompt:IsA("ProximityPrompt") then return false end
    self.Utils:teleportTo(egg.Position, Vector3.new(0, 3, 0))
    task.wait(0.2)
    return pcall(function() fireproximityprompt(stealPrompt) end)
end

function Core:detectRarityFast(egg)
    if self.rarityCache[egg] then return self.rarityCache[egg] end
    local rarity = self.Utils:detectRarity(egg)
    self.rarityCache[egg] = rarity
    return rarity
end

function Core:removeEsp(egg)
    if self.State.espObjects[egg] then
        local esp = self.State.espObjects[egg]
        if esp.highlight then esp.highlight:Destroy() end
        if esp.billboard then esp.billboard:Destroy() end
        if esp.line then esp.line:Destroy() end
        self.State.espObjects[egg] = nil
    end
    self.rarityCache[egg] = nil
end

function Core:createEsp(egg, rarity)
    if self.State.espObjects[egg] then return end
    local color = self.Utils:getRarityColor(rarity)
    local weight = self.Utils:getEggWeight(egg)
    local esp = {}
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = egg
    esp.highlight = highlight
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 180, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Parent = egg
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 0
    bg.Parent = billboard
    self.Utils:createCorner(bg, 6)
    self.Utils:createStroke(bg, color, 2, 0)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -8, 0, 14)
    nameLabel.Position = UDim2.new(0, 4, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = " " .. egg.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = bg
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Size = UDim2.new(1, -8, 0, 12)
    rarityLabel.Position = UDim2.new(0, 4, 0, 16)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = "⭐ " .. rarity
    rarityLabel.TextColor3 = color
    rarityLabel.TextSize = 9
    rarityLabel.Font = Enum.Font.GothamBold
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    rarityLabel.Parent = bg
    local kgLabel = Instance.new("TextLabel")
    kgLabel.Size = UDim2.new(1, -8, 0, 12)
    kgLabel.Position = UDim2.new(0, 4, 0, 28)
    kgLabel.BackgroundTransparency = 1
    kgLabel.Text = string.format("⚖️ %.2f kg", weight)
    kgLabel.TextColor3 = self.Config.accentGold
    kgLabel.TextSize = 8
    kgLabel.Font = Enum.Font.Gotham
    kgLabel.TextXAlignment = Enum.TextXAlignment.Left
    kgLabel.Parent = bg
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, -8, 0, 12)
    distLabel.Position = UDim2.new(0, 4, 0, 40)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "📍 0 studs"
    distLabel.TextColor3 = self.Config.textSecondary
    distLabel.TextSize = 8
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = bg
    esp.distLabel = distLabel
    esp.billboard = billboard
    local linePart = Instance.new("Part")
    linePart.Anchored = true
    linePart.CanCollide = false
    linePart.CanQuery = false
    linePart.Material = Enum.Material.Neon
    linePart.Color = color
    linePart.Transparency = 0.4
    linePart.Size = Vector3.new(0.08, 0.08, 1)
    linePart.Parent = self.Shared.Services.Workspace
    esp.line = linePart
    self.State.espObjects[egg] = esp
    self.State.espCount = self.State.espCount + 1
end

function Core:updateEspLines()
    local character = self.Shared.Player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local playerPos = rootPart.Position
    for egg, esp in pairs(self.State.espObjects) do
        if esp.line and egg.Parent then
            local eggPos = egg.Position
            local distance = (eggPos - playerPos).Magnitude
            local midpoint = (playerPos + eggPos) / 2
            esp.line.CFrame = CFrame.new(midpoint, eggPos)
            esp.line.Size = Vector3.new(0.08, 0.08, distance)
            if esp.distLabel then
                esp.distLabel.Text = string.format("📍 %.1f studs", distance)
            end
        end
    end
end

function Core:updateEspVisibility()
    for egg, esp in pairs(self.State.espObjects) do
        local rarity = self:detectRarityFast(egg)
        local shouldShow = self.State.espEnabled and self.Utils:passesEspFilter(rarity)
        if esp.highlight then esp.highlight.Enabled = shouldShow end
        if esp.billboard then esp.billboard.Enabled = shouldShow end
        if esp.line then esp.line.Transparency = shouldShow and 0.4 or 1 end
    end
end

function Core:clearAllEsp()
    for egg, _ in pairs(self.State.espObjects) do self:removeEsp(egg) end
    self.State.espCount = 0
    self.rarityCache = {}
end

function Core:addRobLog(eggName, rarity, weight, success)
    local time = os.date("%H:%M:%S")
    local color = self.Utils:getRarityColor(rarity)
    table.insert(self.State.robLog, 1, {time = time, name = eggName, rarity = rarity, weight = weight, success = success, color = color})
    if #self.State.robLog > 20 then table.remove(self.State.robLog, 21) end
    if not self.GUI.logScroll then return end
    for _, child in pairs(self.GUI.logScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, rob in ipairs(self.State.robLog) do
        if i > 10 then break end
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, 0, 0, 14)
        entry.BackgroundColor3 = rob.success and Color3.fromRGB(20, 35, 30) or Color3.fromRGB(35, 20, 25)
        entry.BorderSizePixel = 0
        entry.LayoutOrder = i
        entry.Parent = self.GUI.logScroll
        self.Utils:createCorner(entry, 3)
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 14, 1, 0)
        iconLabel.Position = UDim2.new(0, 3, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = rob.success and "✅" or "❌"
        iconLabel.TextSize = 8
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextColor3 = Color3.new(1, 1, 1)
        iconLabel.TextXAlignment = Enum.TextXAlignment.Left
        iconLabel.Parent = entry
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 75, 1, 0)
        nameLabel.Position = UDim2.new(0, 18, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = rob.name
        nameLabel.TextSize = 8
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entry
        local rarityLabel = Instance.new("TextLabel")
        rarityLabel.Size = UDim2.new(0, 50, 1, 0)
        rarityLabel.Position = UDim2.new(0, 95, 0, 0)
        rarityLabel.BackgroundTransparency = 1
        rarityLabel.Text = rob.rarity
        rarityLabel.TextSize = 7
        rarityLabel.Font = Enum.Font.GothamBold
        rarityLabel.TextColor3 = rob.color
        rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
        rarityLabel.Parent = entry
        local kgLabel = Instance.new("TextLabel")
        kgLabel.Size = UDim2.new(0, 40, 1, 0)
        kgLabel.Position = UDim2.new(0, 147, 0, 0)
        kgLabel.BackgroundTransparency = 1
        kgLabel.Text = string.format("%.1fkg", rob.weight)
        kgLabel.TextSize = 7
        kgLabel.Font = Enum.Font.Gotham
        kgLabel.TextColor3 = self.Config.accentGold
        kgLabel.TextXAlignment = Enum.TextXAlignment.Left
        kgLabel.Parent = entry
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(0, 40, 1, 0)
        timeLabel.Position = UDim2.new(1, -42, 0, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = rob.time
        timeLabel.TextSize = 7
        timeLabel.Font = Enum.Font.Code
        timeLabel.TextColor3 = self.Config.textMuted
        timeLabel.TextXAlignment = Enum.TextXAlignment.Right
        timeLabel.Parent = entry
    end
end

function Core:liveScan()
    local Workspace = self.Shared.Services.Workspace
    local spawnedEggs = Workspace:FindFirstChild("SpawnedEggs")
    if not spawnedEggs then return end
    local newEggs = {}
    local filterText = self.GUI.nameFilter.Text:lower()
    for _, egg in ipairs(spawnedEggs:GetChildren()) do
        if egg:IsA("MeshPart") or egg:IsA("BasePart") then
            local rarity = self:detectRarityFast(egg)
            table.insert(newEggs, {egg = egg, rarity = rarity, priority = self.Utils:getRarityPriority(rarity)})
            if not self.State.eggEntries[egg] then self:createEggEntry(egg, rarity) end
            if self.State.espEnabled and not self.State.espObjects[egg] then self:createEsp(egg, rarity) end
        end
    end
    table.sort(newEggs, function(a, b) return a.priority > b.priority end)
    for i, eggData in ipairs(newEggs) do
        local entry = self.State.eggEntries[eggData.egg]
        if entry then entry.LayoutOrder = i end
    end
    for egg, entry in pairs(self.State.eggEntries) do
        if not egg.Parent then
            entry:Destroy()
            self.State.eggEntries[egg] = nil
            self:removeEsp(egg)
        else
            local nameMatch = filterText == "" or egg.Name:lower():find(filterText)
            entry.Visible = nameMatch
        end
    end
    for egg, esp in pairs(self.State.espObjects) do if not egg.Parent then self:removeEsp(egg) end end
    self:updateEspVisibility()
    self.State.eggs = newEggs
    self:updateStats()
end

function Core:createEggEntry(egg, rarity)
    if self.State.eggEntries[egg] then return end
    local color = self.Utils:getRarityColor(rarity)
    local weight = self.Utils:getEggWeight(egg)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, 0, 0, 28)
    entry.BackgroundColor3 = self.Config.bgGlass
    entry.BorderSizePixel = 0
    entry.LayoutOrder = 100 - self.Utils:getRarityPriority(rarity)
    entry.Name = "EggEntry_" .. egg.Name
    entry.Parent = self.GUI.scrollFrame
    self.Utils:createCorner(entry, 5)
    self.Utils:createStroke(entry, color, 1, 0.6)
    local rarityBar = Instance.new("Frame")
    rarityBar.Name = "RarityBar"
    rarityBar.Size = UDim2.new(0, 3, 1, -4)
    rarityBar.Position = UDim2.new(0, 2, 0, 2)
    rarityBar.BackgroundColor3 = color
    rarityBar.BorderSizePixel = 0
    rarityBar.Parent = entry
    self.Utils:createCorner(rarityBar, 2)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 0, 12)
    nameLabel.Position = UDim2.new(0, 8, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = egg.Name
    nameLabel.TextColor3 = self.Config.textPrimary
    nameLabel.TextSize = 9
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = entry
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Name = "RarityLabel"
    rarityLabel.Size = UDim2.new(1, -70, 0, 10)
    rarityLabel.Position = UDim2.new(0, 8, 0, 14)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = rarity
    rarityLabel.TextColor3 = color
    rarityLabel.TextSize = 7
    rarityLabel.Font = Enum.Font.GothamBold
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    rarityLabel.Parent = entry
    local kgLabel = Instance.new("TextLabel")
    kgLabel.Name = "KgLabel"
    kgLabel.Size = UDim2.new(0, 40, 0, 10)
    kgLabel.Position = UDim2.new(1, -75, 0, 14)
    kgLabel.BackgroundTransparency = 1
    kgLabel.Text = string.format("⚖️%.1fkg", weight)
    kgLabel.TextColor3 = self.Config.accentGold
    kgLabel.TextSize = 7
    kgLabel.Font = Enum.Font.GothamBold
    kgLabel.TextXAlignment = Enum.TextXAlignment.Right
    kgLabel.Parent = entry
    self.State.eggEntries[egg] = entry
end

function Core:getFilteredEggs()
    local filterText = self.GUI.nameFilter.Text:lower()
    local filtered = {}
    for _, eggData in ipairs(self.State.eggs) do
        local egg = eggData.egg
        local rarity = eggData.rarity
        local nameMatch = filterText == "" or egg.Name:lower():find(filterText)
        local rarityMatch = self.State.stealFilters[rarity] or false
        if nameMatch and rarityMatch then table.insert(filtered, eggData) end
    end
    return filtered
end

function Core:updateFilterUI()
    for _, item in ipairs(self.Buttons.steal) do
        if self.State.stealFilters[item.rarity.name] then
            item.button.BackgroundColor3 = item.rarity.color
            item.button.Text = item.rarity.icon .. " " .. item.rarity.short
            item.button.TextColor3 = Color3.new(0, 0, 0)
        else
            item.button.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            item.button.Text = "✗" .. item.rarity.short
            item.button.TextColor3 = self.Config.textMuted
        end
    end
end

function Core:performAfkAction()
    local methods = {
        function() 
            self.State.currentSlot = (self.State.currentSlot % 9) + 1
            local keys = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine}
            pcall(function()
                self.Shared.Services.UserInputService:SimulateKeyPress(keys[self.State.currentSlot])
                task.wait(0.08)
                self.Shared.Services.UserInputService:SimulateInputRelease(keys[self.State.currentSlot])
            end)
            return true
        end,
        function()
            pcall(function()
                self.Shared.Services.UserInputService:SimulateKeyPress(Enum.KeyCode.B)
                task.wait(0.15)
                self.Shared.Services.UserInputService:SimulateInputRelease(Enum.KeyCode.B)
            end)
            return true
        end,
        function()
            local cam = self.Shared.Services.Workspace.CurrentCamera
            if not cam then return false end
            local orig = cam.CFrame
            pcall(function()
                for i = 1, 5 do
                    cam.CFrame = orig * CFrame.Angles(0, math.rad(i * 15), 0)
                    task.wait(0.02)
                end
                cam.CFrame = orig
            end)
            return true
        end,
        function()
            local char = self.Shared.Player.Character
            if not char then return false end
            local hum = char:FindFirstChild("Humanoid")
            if not hum then return false end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            return true
        end,
    }
    local method = methods[math.random(1, #methods)]
    local success = method()
    if success then
        self.State.afkCount = self.State.afkCount + 1
        self.State.lastAfk = tick()
        self:updateStats()
    end
    return success
end

function Core:mainLoop()
    self.State.loopRunning = true
    self.Utils:log("🔄 LOOP INICIADO")
    self.GUI.statusLabel.Text = "🔄 Loop activo"
    self.GUI.statusLabel.TextColor3 = self.Config.accentGold
    while self.State.loopRunning and self.GUI.screenGui and self.GUI.screenGui.Parent do
        local delay = tonumber(self.GUI.delayInput.Text) or 0.5
        self:liveScan()
        local filteredEggs = self:getFilteredEggs()
        if #filteredEggs > 0 then
            if self.State.onTreadmill then self:leaveTreadmill() end
            self.GUI.statusLabel.Text = string.format("🎯 %d huevos para robar", #filteredEggs)
            self.GUI.statusLabel.TextColor3 = self.Config.accentGold
            for i, eggData in ipairs(filteredEggs) do
                if not self.State.loopRunning then break end
                self:liveScan()
                local newFiltered = self:getFilteredEggs()
                if #newFiltered == 0 then break end
                local egg = eggData.egg
                if not egg.Parent then continue end
                local rarity = eggData.rarity
                local weight = self.Utils:getEggWeight(egg)
                self.GUI.statusLabel.Text = string.format(" %s [%s] %.1fkg (%d/%d)", egg.Name, rarity, weight, i, #filteredEggs)
                self.GUI.statusLabel.TextColor3 = self.Config.accentPink
                local success = self:stealEgg(egg)
                if success then
                    self.State.stolenCount = self.State.stolenCount + 1
                    self:addRobLog(egg.Name, rarity, weight, true)
                    self.Utils:log("✅ Robado: " .. egg.Name)
                    self:tpToSpawn()
                    task.wait(0.5)
                else
                    self.State.failedCount = self.State.failedCount + 1
                    self:addRobLog(egg.Name, rarity, weight, false)
                    self.Utils:log("❌ Falló: " .. egg.Name)
                end
                self:updateStats()
                task.wait(delay)
            end
        else
            if self.State.treadmillEnabled then
                if not self.State.onTreadmill then
                    self:tpToTreadmill()
                end
                while self.State.loopRunning and self.GUI.screenGui and self.GUI.screenGui.Parent and self.State.treadmillEnabled do
                    task.wait(self.Config.treadmillCheckInterval)
                    self.State.treadmillTime = self.State.treadmillTime + self.Config.treadmillCheckInterval
                    self:updateStats()
                    self:liveScan()
                    local newFiltered = self:getFilteredEggs()
                    if #newFiltered > 0 then
                        self:leaveTreadmill()
                        break
                    end
                    if not self:isPlayerOnTreadmill() then
                        self:tpToTreadmill()
                    end
                    self.GUI.statusLabel.Text = string.format("🏃 Treadmill %.0fs", self.State.treadmillTime)
                    self.GUI.statusLabel.TextColor3 = self.Config.accentCyan
                end
            else
                self.GUI.statusLabel.Text = "⏳ Esperando huevos..."
                self.GUI.statusLabel.TextColor3 = self.Config.textSecondary
                task.wait(2)
            end
        end
        task.wait(0.5)
    end
    self.GUI.statusLabel.Text = "⏸ Loop detenido"
    self.GUI.statusLabel.TextColor3 = self.Config.textSecondary
    self.Utils:log("⏸ LOOP DETENIDO")
end

return Core