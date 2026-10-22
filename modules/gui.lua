-- ============================================
-- GUI - CON DETECTOR INTEGRADO
-- ============================================
local GUI = {}

function GUI:Build(Shared)
    self.Shared = Shared
    self.Config = Shared.Config
    self.Utils = Shared.Utils
    self.State = Shared.State
    self.GUI = Shared.GUI
    self.Switches = Shared.Switches
    self.Buttons = Shared.Buttons
    
    self:createMainFrame()
    self:createHeader()
    self:createContent()
    self:createTabs()
    self:createTabRobo()
    self:createTabMod()
    self:createTabLog()
    self:createStatusBar()
end

function GUI:createMainFrame()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StealEliteV16"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = self.Shared.Services.CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, self.Config.width, 0, self.Config.height)
    mainFrame.Position = UDim2.new(0.82, 0, 0.5, -self.Config.height/2)
    mainFrame.BackgroundColor3 = self.Config.bgMain
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    self.Utils:createCorner(mainFrame, 14)
    self.Utils:createStroke(mainFrame, self.Config.accentCyan, 1.5, 0.4)
    
    self.GUI.screenGui = screenGui
    self.GUI.mainFrame = mainFrame
end

function GUI:createHeader()
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 38)
    header.BackgroundColor3 = Color3.fromRGB(15, 20, 38)
    header.BorderSizePixel = 0
    header.Parent = self.GUI.mainFrame
    self.Utils:createCorner(header, 14)
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 8)
    headerFix.Position = UDim2.new(0, 0, 1, -8)
    headerFix.BackgroundColor3 = Color3.fromRGB(15, 20, 38)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 2)
    headerLine.Position = UDim2.new(0, 0, 1, -1)
    headerLine.BorderSizePixel = 0
    headerLine.Parent = header
    self.Utils:createGradient(headerLine, self.Config.accentCyan, self.Config.accentGold, 90)
    
    local logoIcon = Instance.new("TextLabel")
    logoIcon.Size = UDim2.new(0, 26, 0, 26)
    logoIcon.Position = UDim2.new(0, 6, 0, 6)
    logoIcon.BackgroundColor3 = self.Config.bgGlass
    logoIcon.Text = "🥷"
    logoIcon.TextSize = 14
    logoIcon.Font = Enum.Font.GothamBold
    logoIcon.BorderSizePixel = 0
    logoIcon.Parent = header
    self.Utils:createCorner(logoIcon, 6)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 36, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "STEAL ELITE"
    titleLabel.TextColor3 = self.Config.textPrimary
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 70, 0, 12)
    versionLabel.Position = UDim2.new(0, 36, 1, -16)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v16 DETECTOR"
    versionLabel.TextColor3 = self.Config.accentGold
    versionLabel.TextSize = 7
    versionLabel.Font = Enum.Font.GothamBold
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = header
    
    local btnMin = Instance.new("TextButton")
    btnMin.Size = UDim2.new(0, 20, 0, 20)
    btnMin.Position = UDim2.new(1, -44, 0, 9)
    btnMin.BackgroundColor3 = self.Config.bgGlass
    btnMin.Text = "−"
    btnMin.TextColor3 = self.Config.accentCyan
    btnMin.TextSize = 12
    btnMin.Font = Enum.Font.GothamBold
    btnMin.BorderSizePixel = 0
    btnMin.Parent = header
    self.Utils:createCorner(btnMin, 5)
    
    local btnClose = Instance.new("TextButton")
    btnClose.Size = UDim2.new(0, 20, 0, 20)
    btnClose.Position = UDim2.new(1, -22, 0, 9)
    btnClose.BackgroundColor3 = self.Config.danger
    btnClose.Text = "✕"
    btnClose.TextColor3 = Color3.new(1, 1, 1)
    btnClose.TextSize = 10
    btnClose.Font = Enum.Font.GothamBold
    btnClose.BorderSizePixel = 0
    btnClose.Parent = header
    self.Utils:createCorner(btnClose, 5)
    
    self.GUI.btnMin = btnMin
    self.GUI.btnClose = btnClose
end

function GUI:createContent()
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -12, 1, -38)
    content.Position = UDim2.new(0, 6, 0, 38)
    content.BackgroundTransparency = 1
    content.Parent = self.GUI.mainFrame
    self.GUI.content = content
end

function GUI:createTabs()
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 26)
    tabContainer.BackgroundColor3 = self.Config.bgMain
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = self.GUI.content
    
    local tabs = {}
    local function createTab(name, text, xPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 116, 1, 0)
        btn.Position = UDim2.new(0, xPos, 0, 0)
        btn.BackgroundColor3 = name == "ROBO" and self.Config.bgGlass or self.Config.bgMain
        btn.Text = text
        btn.TextColor3 = name == "ROBO" and self.Config.accentCyan or self.Config.textMuted
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = tabContainer
        self.Utils:createCorner(btn, 6)
        if name == "ROBO" then self.Utils:createStroke(btn, self.Config.accentCyan, 1, 0.5) end
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, -26)
        frame.Position = UDim2.new(0, 0, 0, 26)
        frame.BackgroundColor3 = self.Config.bgMain
        frame.BorderSizePixel = 0
        frame.Visible = name == "ROBO"
        frame.Parent = self.GUI.content
        self.Utils:createCorner(frame, 8)
        
        tabs[name] = {btn = btn, frame = frame}
        btn.MouseButton1Click:Connect(function()
            for tName, tData in pairs(tabs) do
                tData.frame.Visible = (tName == name)
                tData.btn.BackgroundColor3 = (tName == name) and self.Config.bgGlass or self.Config.bgMain
                tData.btn.TextColor3 = (tName == name) and self.Config.accentCyan or self.Config.textMuted
                local s = tData.btn:FindFirstChildOfClass("UIStroke")
                if tName == name then
                    if not s then self.Utils:createStroke(tData.btn, self.Config.accentCyan, 1, 0.5)
                    else s.Color = self.Config.accentCyan end
                elseif s then s:Destroy() end
            end
        end)
        return frame
    end
    
    self.GUI.tabRobo = createTab("ROBO", "🎯 ROBO", 2)
    self.GUI.tabMod = createTab("MOD", "⚙️ MOD", 122)
    self.GUI.tabLog = createTab("LOG", "📋 LOG", 242)
end

function GUI:createTabRobo()
    local tabRobo = self.GUI.tabRobo
    
    -- CONTROL DE ROBO
    local s1, s1Offset = self.Utils:createSection(tabRobo, 
        UDim2.new(1, 0, 0, 62), 
        UDim2.new(0, 0, 0, 0),
        "🎯 CONTROL DE ROBO",
        self.Config.accentGold)
    
    local btnLoop = Instance.new("TextButton")
    btnLoop.Size = UDim2.new(0.62, -3, 0, 30)
    btnLoop.Position = UDim2.new(0, 6, 0, s1Offset)
    btnLoop.BackgroundColor3 = self.Config.accentPink
    btnLoop.Text = "▶ INICIAR LOOP"
    btnLoop.TextColor3 = Color3.new(1, 1, 1)
    btnLoop.TextSize = 10
    btnLoop.Font = Enum.Font.GothamBold
    btnLoop.BorderSizePixel = 0
    btnLoop.AutoButtonColor = false
    btnLoop.Parent = s1
    self.Utils:createCorner(btnLoop, 7)
    self.Utils:createGradient(btnLoop, self.Config.accentPink, Color3.fromRGB(180, 50, 150), 0)
    
    local btnStop = Instance.new("TextButton")
    btnStop.Size = UDim2.new(0.36, -2, 0, 30)
    btnStop.Position = UDim2.new(0.64, 0, 0, s1Offset)
    btnStop.BackgroundColor3 = self.Config.danger
    btnStop.Text = " STOP"
    btnStop.TextColor3 = Color3.new(1, 1, 1)
    btnStop.TextSize = 10
    btnStop.Font = Enum.Font.GothamBold
    btnStop.BorderSizePixel = 0
    btnStop.AutoButtonColor = false
    btnStop.Parent = s1
    self.Utils:createCorner(btnStop, 7)
    
    local delayInput = Instance.new("TextBox")
    delayInput.Size = UDim2.new(0, 45, 0, 22)
    delayInput.Position = UDim2.new(0, 6, 0, s1Offset + 34)
    delayInput.BackgroundColor3 = self.Config.bgGlass
    delayInput.Text = "0.5"
    delayInput.TextColor3 = self.Config.textPrimary
    delayInput.TextSize = 10
    delayInput.Font = Enum.Font.GothamBold
    delayInput.BorderSizePixel = 0
    delayInput.PlaceholderText = "Delay"
    delayInput.PlaceholderColor3 = self.Config.textMuted
    delayInput.ClearTextOnFocus = false
    delayInput.Parent = s1
    self.Utils:createCorner(delayInput, 5)
    
    local nameFilter = Instance.new("TextBox")
    nameFilter.Size = UDim2.new(1, -55, 0, 22)
    nameFilter.Position = UDim2.new(0, 55, 0, s1Offset + 34)
    nameFilter.BackgroundColor3 = self.Config.bgGlass
    nameFilter.Text = ""
    nameFilter.TextColor3 = self.Config.textPrimary
    nameFilter.TextSize = 9
    nameFilter.Font = Enum.Font.Gotham
    nameFilter.BorderSizePixel = 0
    nameFilter.PlaceholderText = "🔍 Filtrar nombre..."
    nameFilter.PlaceholderColor3 = self.Config.textMuted
    nameFilter.ClearTextOnFocus = false
    nameFilter.Parent = s1
    self.Utils:createCorner(nameFilter, 5)
    
    -- PRESETS
    local function applyPreset(type)
        for _, r in ipairs(self.Shared.Rarities) do
            if type == "TOP" then self.State.stealFilters[r.name] = (r.name == "God" or r.name == "Exclusive" or r.name == "OG")
            elseif type == "LEG" then self.State.stealFilters[r.name] = (r.priority >= 6)
            elseif type == "ALL" then self.State.stealFilters[r.name] = true end
        end
        if self.Shared.Core then self.Shared.Core:updateFilterUI() end
        if self.Shared.Settings then self.Shared.Settings:save() end
    end
    
    local btnPresetTop = Instance.new("TextButton")
    btnPresetTop.Size = UDim2.new(0, 108, 0, 20)
    btnPresetTop.Position = UDim2.new(0, 6, 0, 70)
    btnPresetTop.BackgroundColor3 = self.Config.accentGold
    btnPresetTop.Text = "👑 TOP (GOD+EXC+OG)"
    btnPresetTop.TextColor3 = Color3.new(0, 0, 0)
    btnPresetTop.TextSize = 8
    btnPresetTop.Font = Enum.Font.GothamBold
    btnPresetTop.BorderSizePixel = 0
    btnPresetTop.Parent = tabRobo
    self.Utils:createCorner(btnPresetTop, 6)
    btnPresetTop.MouseButton1Click:Connect(function() applyPreset("TOP") end)
    
    local btnPresetLeg = Instance.new("TextButton")
    btnPresetLeg.Size = UDim2.new(0, 108, 0, 20)
    btnPresetLeg.Position = UDim2.new(0, 118, 0, 70)
    btnPresetLeg.BackgroundColor3 = self.Config.accentCyan
    btnPresetLeg.Text = "⭐ LEG+ (LEG+)"
    btnPresetLeg.TextColor3 = Color3.new(0, 0, 0)
    btnPresetLeg.TextSize = 8
    btnPresetLeg.Font = Enum.Font.GothamBold
    btnPresetLeg.BorderSizePixel = 0
    btnPresetLeg.Parent = tabRobo
    self.Utils:createCorner(btnPresetLeg, 6)
    btnPresetLeg.MouseButton1Click:Connect(function() applyPreset("LEG") end)
    
    local btnPresetAll = Instance.new("TextButton")
    btnPresetAll.Size = UDim2.new(0, 108, 0, 20)
    btnPresetAll.Position = UDim2.new(0, 230, 0, 70)
    btnPresetAll.BackgroundColor3 = self.Config.success
    btnPresetAll.Text = " ALL IN"
    btnPresetAll.TextColor3 = Color3.new(0, 0, 0)
    btnPresetAll.TextSize = 8
    btnPresetAll.Font = Enum.Font.GothamBold
    btnPresetAll.BorderSizePixel = 0
    btnPresetAll.Parent = tabRobo
    self.Utils:createCorner(btnPresetAll, 6)
    btnPresetAll.MouseButton1Click:Connect(function() applyPreset("ALL") end)
    
    -- FILTROS DE ROBO
    local s2, s2Offset = self.Utils:createSection(tabRobo,
        UDim2.new(1, 0, 0, 85),
        UDim2.new(0, 0, 0, 96),
        "🎯 FILTROS DE ROBO",
        self.Config.accentGold)
    
    local stealButtons = {}
    local pillW, pillH, pillGapX, pillGapY = 62, 20, 4, 2
    local pillStartX = 6
    local pillStartY = s2Offset + 2
    
    for i, rarity in ipairs(self.Shared.Rarities) do
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5
        local x = pillStartX + col * (pillW + pillGapX)
        local y = pillStartY + row * (pillH + pillGapY)
        
        local btn = self.Utils:createPillButton(s2,
            UDim2.new(0, pillW, 0, pillH),
            UDim2.new(0, x, 0, y),
            rarity.icon .. " " .. rarity.short,
            rarity.color, 7)
        
        table.insert(stealButtons, {button = btn, rarity = rarity})
        
        btn.MouseButton1Click:Connect(function()
            self.State.stealFilters[rarity.name] = not self.State.stealFilters[rarity.name]
            if self.State.stealFilters[rarity.name] then
                btn.BackgroundColor3 = rarity.color
                btn.Text = rarity.icon .. " " .. rarity.short
                btn.TextColor3 = Color3.new(0, 0, 0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
                btn.Text = "✗" .. rarity.short
                btn.TextColor3 = self.Config.textMuted
            end
            if self.Shared.Settings then self.Shared.Settings:save() end
        end)
    end
    
    local btnAllSteal = Instance.new("TextButton")
    btnAllSteal.Size = UDim2.new(0, 55, 0, 16)
    btnAllSteal.Position = UDim2.new(0, 6, 0, pillStartY + 2*(pillH + pillGapY) + 2)
    btnAllSteal.BackgroundColor3 = self.Config.success
    btnAllSteal.Text = "✓ TODOS"
    btnAllSteal.TextColor3 = Color3.new(0, 0, 0)
    btnAllSteal.TextSize = 7
    btnAllSteal.Font = Enum.Font.GothamBold
    btnAllSteal.BorderSizePixel = 0
    btnAllSteal.Parent = s2
    self.Utils:createCorner(btnAllSteal, 5)
    btnAllSteal.MouseButton1Click:Connect(function()
        for _, item in ipairs(stealButtons) do
            self.State.stealFilters[item.rarity.name] = true
            item.button.BackgroundColor3 = item.rarity.color
            item.button.Text = item.rarity.icon .. " " .. item.rarity.short
            item.button.TextColor3 = Color3.new(0, 0, 0)
        end
        if self.Shared.Settings then self.Shared.Settings:save() end
    end)
    
    local btnNoneSteal = Instance.new("TextButton")
    btnNoneSteal.Size = UDim2.new(0, 55, 0, 16)
    btnNoneSteal.Position = UDim2.new(0, 64, 0, pillStartY + 2*(pillH + pillGapY) + 2)
    btnNoneSteal.BackgroundColor3 = self.Config.danger
    btnNoneSteal.Text = "✗ NING"
    btnNoneSteal.TextColor3 = Color3.new(1, 1, 1)
    btnNoneSteal.TextSize = 7
    btnNoneSteal.Font = Enum.Font.GothamBold
    btnNoneSteal.BorderSizePixel = 0
    btnNoneSteal.Parent = s2
    self.Utils:createCorner(btnNoneSteal, 5)
    btnNoneSteal.MouseButton1Click:Connect(function()
        for _, item in ipairs(stealButtons) do
            self.State.stealFilters[item.rarity.name] = false
            item.button.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            item.button.Text = "✗" .. item.rarity.short
            item.button.TextColor3 = self.Config.textMuted
        end
        if self.Shared.Settings then self.Shared.Settings:save() end
    end)
    
    -- FILTROS DE ESP
    local s3, s3Offset = self.Utils:createSection(tabRobo,
        UDim2.new(1, 0, 0, 85),
        UDim2.new(0, 0, 0, 186),
        "👁️ FILTROS DE ESP",
        self.Config.accentCyan)
    
    local espButtons = {}
    local espPillStartY = s3Offset + 2
    
    for i, rarity in ipairs(self.Shared.Rarities) do
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5
        local x = pillStartX + col * (pillW + pillGapX)
        local y = espPillStartY + row * (pillH + pillGapY)
        
        local btn = self.Utils:createPillButton(s3,
            UDim2.new(0, pillW, 0, pillH),
            UDim2.new(0, x, 0, y),
            rarity.icon .. " " .. rarity.short,
            rarity.color, 7)
        
        table.insert(espButtons, {button = btn, rarity = rarity})
        
        btn.MouseButton1Click:Connect(function()
            self.State.espFilters[rarity.name] = not self.State.espFilters[rarity.name]
            if self.State.espFilters[rarity.name] then
                btn.BackgroundColor3 = rarity.color
                btn.Text = rarity.icon .. " " .. rarity.short
                btn.TextColor3 = Color3.new(0, 0, 0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
                btn.Text = "✗" .. rarity.short
                btn.TextColor3 = self.Config.textMuted
            end
            if self.Shared.Core then self.Shared.Core:updateEspVisibility() end
            if self.Shared.Settings then self.Shared.Settings:save() end
        end)
    end
    
    local btnAllEsp = Instance.new("TextButton")
    btnAllEsp.Size = UDim2.new(0, 55, 0, 16)
    btnAllEsp.Position = UDim2.new(0, 6, 0, espPillStartY + 2*(pillH + pillGapY) + 2)
    btnAllEsp.BackgroundColor3 = self.Config.success
    btnAllEsp.Text = "✓ TODOS"
    btnAllEsp.TextColor3 = Color3.new(0, 0, 0)
    btnAllEsp.TextSize = 7
    btnAllEsp.Font = Enum.Font.GothamBold
    btnAllEsp.BorderSizePixel = 0
    btnAllEsp.Parent = s3
    self.Utils:createCorner(btnAllEsp, 5)
    btnAllEsp.MouseButton1Click:Connect(function()
        for _, item in ipairs(espButtons) do
            self.State.espFilters[item.rarity.name] = true
            item.button.BackgroundColor3 = item.rarity.color
            item.button.Text = item.rarity.icon .. " " .. item.rarity.short
            item.button.TextColor3 = Color3.new(0, 0, 0)
        end
        if self.Shared.Core then self.Shared.Core:updateEspVisibility() end
    end)
    
    local btnNoneEsp = Instance.new("TextButton")
    btnNoneEsp.Size = UDim2.new(0, 55, 0, 16)
    btnNoneEsp.Position = UDim2.new(0, 64, 0, espPillStartY + 2*(pillH + pillGapY) + 2)
    btnNoneEsp.BackgroundColor3 = self.Config.danger
    btnNoneEsp.Text = "✗ NING"
    btnNoneEsp.TextColor3 = Color3.new(1, 1, 1)
    btnNoneEsp.TextSize = 7
    btnNoneEsp.Font = Enum.Font.GothamBold
    btnNoneEsp.BorderSizePixel = 0
    btnNoneEsp.Parent = s3
    self.Utils:createCorner(btnNoneEsp, 5)
    btnNoneEsp.MouseButton1Click:Connect(function()
        for _, item in ipairs(espButtons) do
            self.State.espFilters[item.rarity.name] = false
            item.button.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            item.button.Text = "✗" .. item.rarity.short
            item.button.TextColor3 = self.Config.textMuted
        end
        if self.Shared.Core then self.Shared.Core:updateEspVisibility() end
    end)
    
    self.GUI.btnLoop = btnLoop
    self.GUI.btnStop = btnStop
    self.GUI.delayInput = delayInput
    self.GUI.nameFilter = nameFilter
    self.Buttons.steal = stealButtons
    self.Buttons.esp = espButtons
end

-- ✅ PESTAÑA MOD CON DETECTOR
function GUI:createTabMod()
    local tabMod = self.GUI.tabMod
    
    -- Toggles
    local switchEsp = self.Utils:createSwitch(tabMod, UDim2.new(0, 5, 0, 8), "👁️ ESP Visual", true)
    local switchSpeed = self.Utils:createSwitch(tabMod, UDim2.new(0, 5, 0, 40), "🏃 Speed Boost", true)
    local switchAfk = self.Utils:createSwitch(tabMod, UDim2.new(0, 5, 0, 72), "🛡️ Anti-AFK", true)
    local switchTreadmill = self.Utils:createSwitch(tabMod, UDim2.new(0, 5, 0, 104), "🏃 Auto Treadmill", false)
    
    self.Switches.esp = switchEsp
    self.Switches.speed = switchSpeed
    self.Switches.afk = switchAfk
    self.Switches.treadmill = switchTreadmill
    
    -- ✅ Indicador de Treadmill detectado
    local treadmillInfo = Instance.new("TextLabel")
    treadmillInfo.Size = UDim2.new(1, -10, 0, 14)
    treadmillInfo.Position = UDim2.new(0, 5, 0, 136)
    treadmillInfo.BackgroundTransparency = 1
    treadmillInfo.Text = "🏃 Treadmill: Detectando..."
    treadmillInfo.TextColor3 = self.Config.textMuted
    treadmillInfo.TextSize = 8
    treadmillInfo.Font = Enum.Font.GothamBold
    treadmillInfo.TextXAlignment = Enum.TextXAlignment.Left
    treadmillInfo.Parent = tabMod
    
    -- ✅ Botón Re-detectar
    local btnRedetect = Instance.new("TextButton")
    btnRedetect.Size = UDim2.new(1, -10, 0, 20)
    btnRedetect.Position = UDim2.new(0, 5, 0, 152)
    btnRedetect.BackgroundColor3 = self.Config.accentCyan
    btnRedetect.Text = "🔍 Re-detectar Treadmill"
    btnRedetect.TextColor3 = Color3.new(0, 0, 0)
    btnRedetect.TextSize = 8
    btnRedetect.Font = Enum.Font.GothamBold
    btnRedetect.BorderSizePixel = 0
    btnRedetect.Parent = tabMod
    self.Utils:createCorner(btnRedetect, 5)
    
    -- Info de atajos
    local hkInfo = Instance.new("TextLabel")
    hkInfo.Size = UDim2.new(1, -10, 0, 80)
    hkInfo.Position = UDim2.new(0, 5, 0, 180)
    hkInfo.BackgroundColor3 = self.Config.bgGlass
    hkInfo.BorderSizePixel = 0
    hkInfo.Text = "⌨️ ATAJOS:\nF1:Loop F2:Tread F3:ESP\nF4:Speed F5:AFK\nF6:TOP F7:LEG F8:ALL"
    hkInfo.TextColor3 = self.Config.textMuted
    hkInfo.TextSize = 8
    hkInfo.Font = Enum.Font.Code
    hkInfo.TextXAlignment = Enum.TextXAlignment.Left
    hkInfo.TextYAlignment = Enum.TextYAlignment.Top
    hkInfo.Parent = tabMod
    self.Utils:createCorner(hkInfo, 6)
    self.Utils:createStroke(hkInfo, self.Config.accentCyan, 1, 0.5)
    
    -- Guardar referencias
    self.GUI.treadmillInfo = treadmillInfo
    self.GUI.btnRedetect = btnRedetect
end

-- ✅ PESTAÑA LOG
function GUI:createTabLog()
    local tabLog = self.GUI.tabLog
    
    local btnClearLog = Instance.new("TextButton")
    btnClearLog.Size = UDim2.new(0, 60, 0, 20)
    btnClearLog.Position = UDim2.new(1, -65, 0, 5)
    btnClearLog.BackgroundColor3 = self.Config.bgGlass
    btnClearLog.Text = "🗑️ Limpiar"
    btnClearLog.TextColor3 = self.Config.textSecondary
    btnClearLog.TextSize = 8
    btnClearLog.Font = Enum.Font.GothamBold
    btnClearLog.BorderSizePixel = 0
    btnClearLog.Parent = tabLog
    self.Utils:createCorner(btnClearLog, 5)
    
    local logScroll = Instance.new("ScrollingFrame")
    logScroll.Size = UDim2.new(1, -10, 1, -30)
    logScroll.Position = UDim2.new(0, 5, 0, 30)
    logScroll.BackgroundColor3 = self.Config.bgGlass
    logScroll.BorderSizePixel = 0
    logScroll.ScrollBarThickness = 3
    logScroll.ScrollBarImageColor3 = self.Config.accentCyan
    logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logScroll.Parent = tabLog
    self.Utils:createCorner(logScroll, 6)
    
    local logListLayout = Instance.new("UIListLayout")
    logListLayout.Padding = UDim.new(0, 2)
    logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logListLayout.Parent = logScroll
    
    local logListPadding = Instance.new("UIPadding")
    logListPadding.PaddingTop = UDim.new(0, 3)
    logListPadding.PaddingLeft = UDim.new(0, 3)
    logListPadding.PaddingRight = UDim.new(0, 3)
    logListPadding.Parent = logScroll
    
    self.GUI.logScroll = logScroll
    self.GUI.btnClearLog = btnClearLog
end

function GUI:createStatusBar()
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 24)
    statusBar.Position = UDim2.new(0, 0, 1, -24)
    statusBar.BackgroundColor3 = Color3.fromRGB(15, 20, 38)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = self.GUI.mainFrame
    
    local statusLine = Instance.new("Frame")
    statusLine.Size = UDim2.new(1, 0, 0, 1)
    statusLine.Position = UDim2.new(0, 0, 0, 0)
    statusLine.BorderSizePixel = 0
    statusLine.Parent = statusBar
    self.Utils:createGradient(statusLine, self.Config.accentGold, self.Config.accentCyan, 90)
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.5, -5, 1, 0)
    statusLabel.Position = UDim2.new(0, 5, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "✅ Listo"
    statusLabel.TextColor3 = self.Config.success
    statusLabel.TextSize = 9
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusBar
    
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(0.5, -5, 1, 0)
    statsLabel.Position = UDim2.new(0.5, 0, 0, 0)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "🥚 0 | 👁️ 0 | 🏃 0s"
    statsLabel.TextColor3 = self.Config.textSecondary
    statsLabel.TextSize = 8
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextXAlignment = Enum.TextXAlignment.Right
    statsLabel.Parent = statusBar
    
    self.GUI.statusBar = statusBar
    self.GUI.statusLabel = statusLabel
    self.GUI.statsLabel = statsLabel
end

return GUI