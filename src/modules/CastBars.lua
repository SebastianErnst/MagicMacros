CastBars = {}
CastBars.__index = CastBars

-- Singleton Pattern
local instance = nil

function CastBars:getInstance()
    if not instance then
        instance = CastBars:new()
    end
    return instance
end

function CastBars:new()
    local _active = {}
    
    local public = {}
    
    -- Private: Get or create a castbar by key
    local function getOrCreate(key, options)
        if _active[key] then
            return _active[key]
        end
        
        local opts = options or {}
        local castBar = CastBar:new({
            width = opts.width or 195,
            height = opts.height or 13,
            x = opts.x or 0,
            y = opts.y or -100,
            color = opts.color or {r = 0.5, g = 0, b = 0.5, a = 1}
        })
        castBar:create()
        
        _active[key] = castBar
        return castBar
    end
    
    -- Public: Create or get a castbar by key
    function public:getOrCreate(key, options)
        return getOrCreate(key, options)
    end
    
    -- Public: Hide a castbar by key
    function public:hide(key)
        if _active[key] then
            _active[key]:hide()
        end
    end
    
    -- Public: Remove a castbar by key
    function public:remove(key)
        if _active[key] then
            _active[key]:hide()
            _active[key] = nil
        end
    end
    
    -- Public: Update a castbar by key
    function public:update(key, value, text)
        if _active[key] then
            _active[key]:setValue(value)
            if text then
                _active[key]:setText(text)
            end
        end
    end
    
    -- Public: Show a castbar by key
    function public:show(key, maxValue, currentValue, text)
        if _active[key] then
            _active[key]:setMaxValue(maxValue)
            _active[key]:setValue(currentValue)
            if text then
                _active[key]:setText(text)
            end
            _active[key]:show()
        end
    end
    
    -- Public: Get active castbars
    function public:getActive()
        return _active
    end
    
    return public
end
