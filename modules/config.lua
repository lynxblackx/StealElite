-- ============================================
-- CONFIGURACIÓN
-- ============================================
return {
    CONFIG = {
        bgMain = Color3.fromRGB(10, 14, 26),
        bgSection = Color3.fromRGB(20, 26, 45),
        bgGlass = Color3.fromRGB(25, 32, 55),
        borderGlow = Color3.fromRGB(0, 212, 255),
        accentCyan = Color3.fromRGB(0, 212, 255),
        accentGold = Color3.fromRGB(255, 184, 0),
        accentPink = Color3.fromRGB(255, 80, 180),
        textPrimary = Color3.fromRGB(240, 245, 255),
        textSecondary = Color3.fromRGB(160, 175, 200),
        textMuted = Color3.fromRGB(100, 115, 140),
        success = Color3.fromRGB(80, 255, 160),
        danger = Color3.fromRGB(255, 90, 90),
        width = 360,
        height = 580,
        speedValue = 50,
        afkInterval = {40, 80},
        afkIdleTime = 25,
        treadmillCheckInterval = 1.5,
        espShowDistance = true, -- ✅ NUEVO: mostrar distancia en ESP
        espMaxDistance = 500
    },
    
    RARITIES = {
        {name = "God",         short = "GOD", color = Color3.fromRGB(222, 0, 0),     priority = 9, icon = "👑"},
        {name = "Exclusive",   short = "EXC", color = Color3.fromRGB(255, 50, 255),  priority = 8, icon = "💎"},
        {name = "OG",          short = "OG",  color = Color3.fromRGB(255, 140, 0),   priority = 7, icon = "🔥"},
        {name = "Legendary",   short = "LEG", color = Color3.fromRGB(241, 197, 0),   priority = 6, icon = "⭐"},
        {name = "Mythic",      short = "MYT", color = Color3.fromRGB(255, 100, 100), priority = 5, icon = "🌟"},
        {name = "Secret",      short = "SEC", color = Color3.fromRGB(0, 255, 255),   priority = 4, icon = "🔮"},
        {name = "Epic",        short = "EPI", color = Color3.fromRGB(137, 0, 216),   priority = 3, icon = "💜"},
        {name = "Rare",        short = "RAR", color = Color3.fromRGB(0, 142, 216),   priority = 2, icon = "💙"},
        {name = "Common",      short = "COM", color = Color3.fromRGB(111, 255, 0),   priority = 1, icon = "💚"},
    }
}