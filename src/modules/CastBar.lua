CastBar = {}
CastBar.__index = CastBar

function CastBar:new(options)
    local opts = options or {}
    local width = opts.width or 195
    local height = opts.height or 13
    local x = opts.x or 0
    local y = opts.y or -100
    local color = opts.color or {r = 1, g = 0.7, b = 0, a = 1}
    local backgroundColor = opts.backgroundColor or {r = 0, g = 0, b = 0, a = 0.5}
    local borderColor = opts.borderColor or {r = 0.5, g = 0.5, b = 0.5, a = 1}
    
    local public = {}
    local frame = nil
    
    function public:create()
        if frame then
            return frame
        end
        
        frame = CreateFrame("Frame", nil, UIParent)
        frame:SetWidth(width)
        frame:SetHeight(height)
        frame:SetPoint("CENTER", UIParent, "CENTER", x, y)
        frame:Hide()
        
        local border = CreateFrame("Frame", nil, frame)
        border:SetAllPoints(frame)
        border:SetBackdrop({
            bgFile = "Interface\\TargetingFrame\\UI-StatusBar",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        border:SetBackdropColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        border:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
        
        local bar = CreateFrame("StatusBar", nil, frame)
        bar:SetPoint("TOPLEFT", 4, -4)
        bar:SetPoint("BOTTOMRIGHT", -4, 4)
        bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        bar:SetStatusBarColor(color.r, color.g, color.b, color.a)
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(1)
        frame.bar = bar
        
        local text = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("CENTER", bar, "CENTER")
        frame.text = text
        
        return frame
    end
    
    function public:setMaxValue(maxValue)
        if not frame then public:create() end
        frame.bar:SetMinMaxValues(0, maxValue)
    end
    
    function public:setValue(value)
        if not frame then public:create() end
        frame.bar:SetValue(value)
    end
    
    function public:setText(text)
        if not frame then public:create() end
        frame.text:SetText(text)
    end
    
    function public:show()
        if not frame then public:create() end
        frame:Show()
    end
    
    function public:hide()
        if frame then
            frame:Hide()
        end
    end
    
    function public:isShown()
        if not frame then return false end
        return frame:IsShown()
    end
    
    function public:getFrame()
        return frame
    end
    
    return public
end
