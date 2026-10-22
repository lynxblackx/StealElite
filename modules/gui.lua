-- ============================================
-- CREACIÓN DE GUI
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
    self:createStatusBar()
end

function GUI:createMainFrame()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StealEliteV15"
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
    
    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.Config.bgMain),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 40))
    }
    bgGradient.Rotation = 45
    bgGradient.Parent = mainFrame
    
    self.GUI.screenGui = screenGui
    self.GUI.mainFrame = mainFrame
end

function GUI:createHeader()
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = Color3.fromRGB(15, 20, 38)
    header.BorderSizePixel = 0
    header.Parent = self.GUI.mainFrame
    self.Utils:createCorner(header, 14)
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
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
    logoIcon.Size = UDim2.new(0, 32, 0, 32)
    logoIcon.Position = UDim2.new(0, 8, 0, 5)
    logoIcon.BackgroundColor3 = self.Config.bgGlass
    logoIcon.Text = "🥷"
    logoIcon.TextSize = 18
    logoIcon.Font = Enum.Font.GothamBold
    logoIcon.BorderSizePixel = 0
    logoIcon.Parent = header
    self.Utils:createCorner(logoIcon, 8)
    self.Utils:createStroke(logoIcon, self.Config.accentGold, 1, 0.3)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 46, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "STEAL ELITE"
    titleLabel.TextColor3 = self.Config.textPrimary
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 50, 0, 14)
    versionLabel.Position = UDim2.new(0, 46, 1, -18)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v15 PREMIUM"
    versionLabel.TextColor3 = self.Config.accentGold
    versionLabel.TextSize = 8
    versionLabel.Font = Enum.Font.GothamBold
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = header
    
    local btnMin = Instance.new("TextButton")
    btnMin.Size = UDim2.new(0, 22, 0, 22)
    btnMin.Position = UDim2.new(1, -50, 0, 10)
    btnMin.BackgroundColor3 = self.Config.bgGlass
    btnMin.Text = "−"
    btnMin.TextColor3 = self.Config.accentCyan
    btnMin.TextSize = 14
    btnMin.Font = Enum.Font.GothamBold
    btnMin.BorderSizePixel = 0
    btnMin.Parent = header
    self.Utils:createCorner(btnMin, 6)
    self.Utils:createStroke(btnMin, self.Config.accentCyan, 1, 0.5)
    
    local btnClose = Instance.new("TextButton")
    btnClose.Size = UDim2.new(0, 22, 0, 22)
    btnClose.Position = UDim2.new(1, -24, 0, 10)
    btnClose.BackgroundColor3 = self.Config.danger
    btnClose.Text = "✕"
    btnClose.TextColor3 = Color3.new(1, 1, 1)
    btnClose.TextSize = 10
    btnClose.Font = Enum.Font.GothamBold
    btnClose.BorderSizePixel = 0
    btnClose.Parent = header
    self.Utils:createCorner(btnClose, 6)
    
    self.GUI.btnMin = btnMin
    self.GUI.btnClose = btnClose
end

function GUI:createContent()
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 1, -42)
    content.Position = UDim2.new(0, 8, 0, 42)
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
            end
        end)
        return frame
    end
    
    self.GUI.tabRobo = createTab("ROBO", "🎯 ROBO", 2)
    self.GUI.tabMod = createTab("MOD", "️ MOD", 122)
    self.GUI.tabLog = createTab("LOG", " LOG", 242)
end

function GUI:createTabRobo()
    local tabRobo = self.GUI.tabRobo
    
    -- Sección Control de Robo
    local s1, s1Offset = self.Utils:createSection(tabRobo, 
        UDim2.new(1, 0, 0, 62), 
        UDim2.new(0, 0, 0, 0),
        "🎯 CONTROL DE ROBO",
        self.Config.accentGold)
    
    local btnLoop = Instance.new("TextButton")
    btnLoop.Size = UDim2.new(0.62, -3, 0, 32)
    btnLoop.Position = UDim2.new(0, 6, 0, s1Offset)
    btnLoop.BackgroundColor3 = self.Config.accentPink
    btnLoop.Text = "▶ INICIAR LOOP"
    btnLoop.TextColor3 = Color3.new(1, 1, 1)
    btnLoop.TextSize = 10
    btnLoop.Font = Enum.Font.GothamBold
    btnLoop.BorderSizePixel = 0
    btnLoop.AutoButtonColor = false
    btnLoop.Parent = s1
    self.Utils:createCorner(btnLoop, 8)
    self.Utils:createGradient(btnLoop, self.Config.accentPink, Color3.fromRGB(180, 50, 150), 0)
    self.Utils:createStroke(btnLoop, self.Config.accentPink, 1, 0.3)
    
    local btnStop = Instance.new("TextButton")
    btnStop.Size = UDim2.new(0.36, -2, 0, 32)
    btnStop.Position = UDim2.new(0.64, 0, 0, s1Offset)
    btnStop.BackgroundColor3 = self.Config.danger
    btnStop.Text = "⏸ STOP"
    btnStop.TextColor3 = Color3.new(1, 1, 1)
    btnStop.TextSize = 10
    btnStop.Font = Enum.Font.GothamBold
    btnStop.BorderSizePixel = 0
    btnStop.AutoButtonColor = false
    btnStop.Parent = s1
    self.Utils:createCorner(btnStop, 8)
    self.Utils:createStroke(btnStop, self.Config.danger, 1, 0.3)
    
    local delayInput = Instance.new("TextBox")
    delayInput.Size = UDim2.new(0, 50, 0, 22)
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
    self.Utils:createCorner(delayInput, 6)
    self.Utils:createStroke(delayInput, self.Config.accentCyan, 1, 0.7)
    
    local nameFilter = Instance.new("TextBox")
    nameFilter.Size = UDim2.new(1, -62, 0, 22)
    nameFilter.Position = UDim2.new(0, 60, 0, s1Offset + 34)
    nameFilter.BackgroundColor3 = self.Config.bgGlass
    nameFilter.Text = ""
    nameFilter.TextColor3 = self.Config.textPrimary
    nameFilter.TextSize = 9
    nameFilter.Font = Enum.Font.Gotham
    nameFilter.BorderSizePixel = 0
    nameFilter.PlaceholderText = "🔍 Filtrar por nombre..."
    nameFilter.PlaceholderColor3 = self.Config.textMuted
    nameFilter.ClearTextOnFocus = false
    nameFilter.Parent = s1
    self.Utils:createCorner(nameFilter, 6)
    self.Utils:createStroke(nameFilter, self.Config.accentCyan, 1, 0.7)
    
    -- Presets
    local function applyPreset(type)
        for _, r in ipairs(self.Shared.Rarities) do
            if type == "TOP" then self.State.stealFilters[r.name] = (r.name == "God" or r.name == "Exclusive" or r.name == "OG")
            elseif type == "LEG" then self.State.stealFilters[r.name] = (r.priority >= 6)
            elseif type == "ALL" then self.State.stealFilters[r.name] = true end
        end
        if self.Shared.Core then self.Shared.Core:updateFilterUI() end
    end
    
    local btnPresetTop = Instance.new("TextButton")
    btnPresetTop.Size = UDim2.new(0, 108, 0, 22)
    btnPresetTop.Position = UDim2.new(0, 6, 0, 72)
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
    btnPresetLeg.Size = UDim2.new(0, 108, 0, 22)
    btnPresetLeg.Position = UDim2.new(0, 118, 0, 72)
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
    btnPresetAll.Size = UDim2.new(0, 108, 0, 22)
    btnPresetAll.Position = UDim2.new(0, 230, 0, 72)
    btnPresetAll.BackgroundColor3 = self.Config.success
    btnPresetAll.Text = " ALL IN"
    btnPresetAll.TextColor3 = Color3.new(0, 0, 0)
    btnPresetAll.TextSize = 8
    btnPresetAll.Font = Enum.Font.GothamBold
    btnPresetAll.BorderSizePixel = 0
    btnPresetAll.Parent = tabRobo
    self.Utils:createCorner(btnPresetAll, 6)
    btnPresetAll.MouseButton1Click:Connect(function() applyPreset("ALL") end)
    
    -- Filtros de Robo
    local stealButtons = {}
    local pillW = 60
    local pillH = 22
    local pillGapX = 4
    local pillGapY = 3
    local pillStartX = 6
    local pillStartY = 100
    
    for i, rarity in ipairs(self.Shared.Rarities) do
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5
        local x = pillStartX + col * (pillW + pillGapX)
        local y = pillStartY + row * (pillH + pillGapY)
        
        local btn = self.Utils:createPillButton(tabRobo,
            UDim2.new(0, pillW, 0, pillH),
            UDim2.new(0, x, 0, y),
            rarity.icon .. " " .. rarity.short,
            rarity.color,
            7)
        
        table.insert(stealButtons, {button = btn, rarity = rarity})
        
        btn.MouseButton1Click:Connect(function()
            self.State.stealFilters[rarity.name] = not self.State.stealFilters[rarity.name]
            if self.State.stealFilters[rarity.name] then
                btn.BackgroundColor3 = rarity.color
                btn.Text = rarity.icon .. " " .. rarity.short
                btn.TextColor3 = Color3.new(0, 0, 0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
                btn.Text = "✗ " .. rarity.short
                btn.TextColor3 = self.Config.textMuted
            end
        end)
    end
    
    local btnAllSteal = Instance.new("TextButton")
    btnAllSteal.Size = UDim2.new(0, 55, 0, 18)
    btnAllSteal.Position = UDim2.new(0, 6, 0, pillStartY + 2*(pillH + pillGapY) + 2)
    btnAllSteal.BackgroundColor3 = self.Config.success
    btnAllSteal.Text = "✓ TODOS"
    btnAllSteal.TextColor3 = Color3.new(0, 0, 0)
    btnAllSteal.TextSize = 8
    btnAllSteal.Font = Enum.Font.GothamBold
    btnAllSteal.BorderSizePixel = 0
    btnAllSteal.Parent = tabRobo
    self.Utils:createCorner(btnAllSteal, 9)
    btnAllSteal.MouseButton1Click:Connect(function()
        for _, item in ipairs(stealButtons) do
            self.State.stealFilters[item.rarity.name] = true
            item.button.BackgroundColor3 = item.rarity.color
            item.button.Text = item.rarity.icon .. " " .. item.rarity.short
            item.button.TextColor3 = Color3.new(0, 0, 0)
        end
    end)
    
    local btnNoneSteal = Instance.new("TextButton")
    btnNoneSteal.Size = UDim2.new(0, 55, 0, 18)
    btnNoneSteal.Position = UDim2.new(0, 64, 0, pillStartY + 2*(pillH + pillGapY) + 2)
    btnNoneSteal.BackgroundColor3 = self.Config.danger
    btnNoneSteal.Text = "✗ NINGUNO"
    btnNoneSteal.TextColor3 = Color3.new(1, 1, 1)
    btnNoneSteal.TextSize = 8
    btnNoneSteal.Font = Enum.Font.GothamBold
    btnNoneSteal.BorderSizePixel = 0
    btnNoneSteal.Parent = tabRobo
    self.Utils:createCorner(btnNoneSteal, 9)
    btnNoneSteal.MouseButton1Click:Connect(function()
        for _, item in ipairs(stealButtons) do
            self.State.stealFilters[item.rarity.name] = false
            item.button.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            item.button.Text = "✗ " .. item.rarity.short
            item.button.TextColor3 = self.Config.textMuted
        end
    end)
    
    -- Sección Filtros ESP
    local s3, s3Offset = self.Utils:createSection(tabRobo,
        UDim2.new(1, 0, 0, 85),
        UDim2.new(0, 0, 0, 157),
        "👁️ FILTROS DE ESP",
        self.Config.accentCyan)
    
    local espButtons = {}
    for i, rarity in ipairs(self.Shared.Rarities) do
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5
        local x = pillStartX + col * (pillW + pillGapX)
        local y = pillStartY + row * (pillH + pillGapY)
        
        local btn = self.Utils:createPillButton(tabRobo,
            UDim2.new(0, pillW, 0, pillH),
            UDim2.new(0, x, 0, y),
            rarity.icon .. " " .. rarity.short,
            rarity.color,
            7)
        
        table.insert(espButtons, {button = btn, rarity = rarity})
        
        btn.MouseButton1Click:Connect(function()
            self.State.espFilters[rarity.name] = not self.State.espFilters[rarity.name]
            if self.State.espFilters[rarity.name] then
                btn.BackgroundColor3 = rarity.color
                btn.Text = rarity.icon .. " " .. rarity.short
                btn.TextColor3 = Color3.new(0, 0, 0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
                btn.Text = "✗ " .. rarity.short
                btn.TextColor3 = self.Config.textMuted
            end
            if self.Shared.Core then self.Shared.Core:updateEspVisibility() end
        end)
    end
    
    local btnAllEsp = Instance.new("TextButton")
    btnAllEsp.Size = UDim2.new(0, 55, 0, 18)
    btnAllEsp.Position = UDim2.new(0, 6, 0, pillStartY + 2*(pillH + pillGapY) + 2)
    btnAllEsp.BackgroundColor3 = self.Config.success
    btnAllEsp.Text = "✓ TODOS"
    btnAllEsp.TextColor3 = Color3.new(0, 0, 0)
    btnAllEsp.TextSize = 8
    btnAllEsp.Font = Enum.Font.GothamBold
    btnAllEsp.BorderSizePixel = 0
    btnAllEsp.Parent = tabRobo
    self.Utils:createCorner(btnAllEsp, 9)
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
    btnNoneEsp.Size = UDim2.new(0, 55, 0, 18)
    btnNoneEsp.Position = UDim2.new(0, 64, 0, pillStartY + 2*(pillH + pillGapY) + 2)
    btnNoneEsp.BackgroundColor3 = self.Config.danger
    btnNoneEsp.Text = " NINGUNO"
    btnNoneEsp.TextColor3 = Color3.new(1, 1, 1)
    btnNoneEsp.TextSize = 8
    btnNoneEsp.Font = Enum.Font.GothamBold
    btnNoneEsp.BorderSizePixel = 0
    btnNoneEsp.Parent = tabRobo
    self.Utils:createCorner(btnNoneEsp, 9)
    btnNoneEsp.MouseButton1Click:Connect(function()
        for _, item in ipairs(espButtons) do
            self.State.espFilters[item.rarity.name] = false
            item.button.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
            item.button.Text = "✗ " .. item.rarity.short
            item.button.TextColor3 = self.Config.textMuted
        end
        if self.Shared.Core then self.Shared.Core:updateEspVisibility() end
    end)
    
    -- Sección Módulos
    local s4, s4Offset = self.Utils:createSection(tabRobo,
        UDim2.new(1, 0, 0, 65),
        UDim2.new(0, 0, 0, 247),
        "⚙️ MODULOS",
        self.Config.accentCyan)
    
    local switchEsp = self.Utils:createSwitch(s4, UDim2.new(0, 0, 0, s4Offset + 4), "👁️ ESP", true)
    local switchSpeed = self.Utils:createSwitch(s4, UDim2.new(0, 115, 0, s4Offset + 4), "🏃 Speed", true)
    local switchAfk = self.Utils:createSwitch(s4, UDim2.new(0, 230, 0, s4Offset + 4), "🛡️ AFK", true)
    local switchTreadmill = self.Utils:createSwitch(s4, UDim2.new(0, 0, 0, s4Offset + 34), "🏃 Treadmill", false)
    
    self.Switches.esp = switchEsp
    self.Switches.speed = switchSpeed
    self.Switches.afk = switchAfk
    self.Switches.treadmill = switchTreadmill
    
    -- Sección Lista de Huevos
    local s5, s5Offset = self.Utils:createSection(tabRobo,
        UDim2.new(1, 0, 0, 95),
        UDim2.new(0, 0, 0, 317),
        "🥚 HUEVOS DETECTADOS",
        self.Config.accentGold)
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -12, 1, -32)
    scrollFrame.Position = UDim2.new(0, 6, 0, s5Offset + 2)
    scrollFrame.BackgroundColor3 = self.Config.bgGlass
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = self.Config.accentCyan
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = s5
    self.Utils:createCorner(scrollFrame, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    -- ✅ CORREGIDO: UDim en lugar de UDim2
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 2)
    listPadding.PaddingLeft = UDim.new(0, 2)      -- ✅ CORREGIDO
    listPadding.PaddingRight = UDim.new(0, 2)     -- ✅ CORREGIDO
    listPadding.Parent = scrollFrame
    
    -- Sección Registro de Robos
    local s6, s6Offset = self.Utils:createSection(tabRobo,
        UDim2.new(1, 0, 0, 75),
        UDim2.new(0, 0, 0, 417),
        "📋 REGISTRO DE ROBOS",
        self.Config.accentCyan)
    
    local btnClearLog = Instance.new("TextButton")
    btnClearLog.Size = UDim2.new(0, 50, 0, 16)
    btnClearLog.Position = UDim2.new(1, -56, 0, 6)
    btnClearLog.BackgroundColor3 = self.Config.bgGlass
    btnClearLog.Text = "️ Limpiar"
    btnClearLog.TextColor3 = self.Config.textSecondary
    btnClearLog.TextSize = 7
    btnClearLog.Font = Enum.Font.GothamBold
    btnClearLog.BorderSizePixel = 0
    btnClearLog.Parent = s6
    self.Utils:createCorner(btnClearLog, 4)
    self.Utils:createStroke(btnClearLog, self.Config.accentCyan, 1, 0.7)
    
    local logScroll = Instance.new("ScrollingFrame")
    logScroll.Size = UDim2.new(1, -12, 1, -32)
    logScroll.Position = UDim2.new(0, 6, 0, s6Offset + 2)
    logScroll.BackgroundColor3 = self.Config.bgGlass
    logScroll.BorderSizePixel = 0
    logScroll.ScrollBarThickness = 3
    logScroll.ScrollBarImageColor3 = self.Config.accentCyan
    logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logScroll.Parent = s6
    self.Utils:createCorner(logScroll, 6)
    
    local logListLayout = Instance.new("UIListLayout")
    logListLayout.Padding = UDim.new(0, 1)
    logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logListLayout.Parent = logScroll
    
    -- ✅ CORREGIDO: UDim en lugar de UDim2
    local logListPadding = Instance.new("UIPadding")
    logListPadding.PaddingTop = UDim.new(0, 2)
    logListPadding.PaddingLeft = UDim.new(0, 2)      -- ✅ CORREGIDO
    logListPadding.PaddingRight = UDim.new(0, 2)     -- ✅ CORREGIDO
    logListPadding.Parent = logScroll
    
    -- Guardar referencias
    self.GUI.btnLoop = btnLoop
    self.GUI.btnStop = btnStop
    self.GUI.delayInput = delayInput
    self.GUI.nameFilter = nameFilter
    self.GUI.scrollFrame = scrollFrame
    self.GUI.logScroll = logScroll
    self.GUI.btnClearLog = btnClearLog
    self.Buttons.steal = stealButtons
    self.Buttons.esp = espButtons
end

function GUI:createStatusBar()
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 28)
    statusBar.Position = UDim2.new(0, 0, 1, -28)
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
    statsLabel.Text = " 0 | 👁️ 0 |  0s"
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