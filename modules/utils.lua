-- ============================================
-- UTILIDADES CON SWITCHES CORREGIDOS
-- ============================================
local Utils = {}

function Utils:init(Shared)
    self.Shared = Shared
    self.Config = Shared.Config
end

function Utils:createCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

function Utils:createStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or self.Config.borderGlow
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.5
    s.Parent = parent
    return s
end

function Utils:createGradient(parent, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

function Utils:createPillButton(parent, size, position, text, color, textSize)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.TextSize = textSize or 8
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    self:createCorner(btn, 12)
    self:createStroke(btn, color, 1, 0.3)
    return btn
end

-- ✅ SWITCH CON CALLBACK CORREGIDO
function Utils:createSwitch(parent, position, text, initialState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 110, 0, 28)
    container.Position = position
    container.BackgroundColor3 = self.Config.bgGlass
    container.BorderSizePixel = 0
    container.Parent = parent
    self:createCorner(container, 14)
    self:createStroke(container, self.Config.borderGlow, 1, 0.7)
    
    -- Track (fondo del switch)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 44, 0, 20)
    track.Position = initialState and UDim2.new(1, -48, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    track.BackgroundColor3 = initialState and self.Config.success or self.Config.textMuted
    track.BorderSizePixel = 0
    track.Parent = container
    self:createCorner(track, 10)
    
    -- Thumb (bolita del switch)
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = initialState and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 6, 0.5, -8)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    self:createCorner(thumb, 8)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -52, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Config.textPrimary
    label.TextSize = 9
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Botón invisible para clicks
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container
    
    -- Objeto del switch
    local switchObj = {
        container = container,
        track = track,
        thumb = thumb,
        label = label,
        button = btn,
        state = initialState,
        callback = callback,
        setState = function(self, newState)
            if self.state == newState then return end -- Evitar cambios duplicados
            self.state = newState
            self.track.Position = newState and UDim2.new(1, -48, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
            self.track.BackgroundColor3 = newState and self.Config.success or self.Config.textMuted
            self.thumb.Position = newState and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 6, 0.5, -8)
            if self.callback then
                self.callback(newState)
            end
        end
    }
    
    -- Click handler
    btn.MouseButton1Click:Connect(function()
        switchObj:setState(not switchObj.state)
    end)
    
    return switchObj
end

function Utils:createSection(parent, size, position, title, titleColor)
    local section = Instance.new("Frame")
    section.Size = size
    section.Position = position
    section.BackgroundColor3 = self.Config.bgSection
    section.BorderSizePixel = 0
    section.Parent = parent
    self:createCorner(section, 10)
    self:createStroke(section, self.Config.accentCyan, 1, 0.7)
    
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -12, 0, 16)
        titleLabel.Position = UDim2.new(0, 8, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = titleColor or self.Config.accentCyan
        titleLabel.TextSize = 10
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = section
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -16, 0, 1)
        line.Position = UDim2.new(0, 8, 0, 24)
        line.BorderSizePixel = 0
        line.Parent = section
        self:createGradient(line, self.Config.accentCyan, Color3.fromRGB(0, 100, 150), 0)
        line.BackgroundTransparency = 0.3
        
        return section, 30
    end
    return section, 6
end

function Utils:log(msg)
    print("[StealElite] " .. msg)
end

function Utils:teleportTo(position, offset)
    local character = self.Shared.Player.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    rootPart.CFrame = CFrame.new(position + (offset or Vector3.new(0, 3, 0)))
    return true
end

function Utils:detectRarity(egg)
    local State = self.Shared.State
    local Rarities = self.Shared.Rarities
    
    if State.rarityCache and State.rarityCache[egg] then
        return State.rarityCache[egg]
    end
    
    local rarityAttr = egg:GetAttribute("Rarity")
    if rarityAttr and type(rarityAttr) == "string" then
        for _, r in ipairs(Rarities) do
            if rarityAttr == r.name then
                if not State.rarityCache then State.rarityCache = {} end
                State.rarityCache[egg] = r.name
                return r.name
            end
        end
    end
    
    local eggGui = egg:FindFirstChild("EggGui")
    if eggGui then
        for _, obj in ipairs(eggGui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Text and obj.Text ~= "" then
                local c = obj.TextColor3
                if c.R > 0.85 and c.G < 0.1 and c.B < 0.1 then return "God" end
                if c.R > 0.9 and c.G < 0.3 and c.B > 0.8 then return "Exclusive" end
                if c.R > 0.9 and c.G > 0.5 and c.G < 0.6 and c.B < 0.1 then return "OG" end
                if c.R > 0.9 and c.G > 0.75 and c.B < 0.1 then return "Legendary" end
                if c.R > 0.9 and c.G < 0.5 and c.B < 0.5 then return "Mythic" end
                if c.R < 0.1 and c.G > 0.9 and c.B > 0.9 then return "Secret" end
                if c.R > 0.5 and c.R < 0.6 and c.G < 0.1 and c.B > 0.8 then return "Epic" end
                if c.R < 0.1 and c.G > 0.5 and c.G < 0.6 and c.B > 0.8 then return "Rare" end
                if c.R > 0.4 and c.R < 0.5 and c.G > 0.95 and c.B < 0.1 then return "Common" end
            end
        end
    end
    
    return "Unknown"
end

function Utils:getEggWeight(egg)
    return tonumber(egg:GetAttribute("WeightKG")) or 0
end

function Utils:getRarityPriority(rarity)
    for _, r in ipairs(self.Shared.Rarities) do
        if r.name == rarity then return r.priority end
    end
    return 0
end

function Utils:getRarityColor(rarity)
    for _, r in ipairs(self.Shared.Rarities) do
        if r.name == rarity then return r.color end
    end
    return self.Config.textMuted
end

function Utils:passesStealFilter(rarity)
    return self.Shared.State.stealFilters[rarity] or false
end

function Utils:passesEspFilter(rarity)
    return self.Shared.State.espFilters[rarity] or false
end

return Utils