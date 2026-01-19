CombatEventHandler = {}
CombatEventHandler.__index = CombatEventHandler

-- Singleton Pattern
local instance = nil

function CombatEventHandler:getInstance()
    if not instance then
        instance = CombatEventHandler:new()
    end
    return instance
end

function CombatEventHandler:new()
    local _frame = CreateFrame("Frame")
    local _updateFrame = CreateFrame("Frame")
    local _listeners = {}
    local _registered = false
    local _castTracking = {}
    local _updateCallbacks = {}
    
    local public = {}
    
    -- Private: Handle Spell Self Damage Events
    local function handleSpellSelfDamage(message)
        if not message then
            return
        end
        
        -- Prüfe auf Resist/Immune/Miss
        if string.find(message, "resist") or 
           string.find(message, "immune") or 
           string.find(message, "miss") then
            
            -- Extrahiere Spell-Namen
            local spellName = extractSpellName(message)
            
            if spellName then
                notifyListeners("SPELL_RESISTED", spellName)
            end
        end
    end

    -- Public: Initialize event handler
    function public:initialize()
        if _registered then
            return
        end
        
        -- Registriere Combat-Events
        _frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
        
        _frame:SetScript("OnEvent", function()
            local event = event
            local message = arg1
            
            if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
                handleSpellSelfDamage(message)
            end
        end)
        
        -- OnUpdate für Cast-Tracking und Update Callbacks
        _updateFrame:SetScript("OnUpdate", function()
            local currentTime = GetTime()
            
            -- Handle cast tracking
            for key, tracking in pairs(_castTracking) do
                local elapsed = currentTime - tracking.startTime
                
                -- Warte auf Castzeit
                if elapsed < tracking.castTime then
                    -- Noch im Cast
                else
                    -- Cast abgeschlossen
                    if tracking.onComplete then
                        tracking.onComplete()
                    end
                    _castTracking[key] = nil
                end
            end
            
            -- Handle update callbacks
            for key, callback in pairs(_updateCallbacks) do
                callback()
            end
        end)
        
        _registered = true
    end
    
    -- Public: Track a spell cast
    function public:trackCast(key, castTime, onComplete)
        _castTracking[key] = {
            startTime = GetTime(),
            castTime = castTime,
            onComplete = onComplete
        }
    end
    
    -- Public: Cancel cast tracking
    function public:cancelCastTracking(key)
        _castTracking[key] = nil
    end
    
    -- Public: Register update callback
    function public:registerUpdateCallback(key, callback)
        _updateCallbacks[key] = callback
    end
    
    -- Public: Unregister update callback
    function public:unregisterUpdateCallback(key)
        _updateCallbacks[key] = nil
    end
    
    -- Public: Register a listener for specific event and spell
    function public:registerListener(eventType, spellName, callback)
        if not _listeners[eventType] then
            _listeners[eventType] = {}
        end
        
        if not _listeners[eventType][spellName] then
            _listeners[eventType][spellName] = {}
        end
        
        table.insert(_listeners[eventType][spellName], callback)
    end
    
    return public
end
