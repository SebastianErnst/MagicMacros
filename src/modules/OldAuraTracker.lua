OldAuraTracker                         = {}
OldAuraTracker.__index                 = OldAuraTracker

-- SELF
local PATTERN_BUFF_GAIN_SELF        = "^You gain (.+)%.$"
local PATTERN_BUFF_STACK_GAIN_SELF  = "^You gain (.+) %((%d+)%)$"
local PATTERN_DEBUFF_GAIN_SELF      = "^You are afflicted by (.+)%.$"
local PATTERN_AURA_FADE_SELF        = "^(.+) fades from you%.$"

-- OTHER
local PATTERN_BUFF_GAIN_OTHER       = "^(.+) gains (.+)%.$"
local PATTERN_BUFF_STACK_GAIN_OTHER = "^(.+) gains (.+) %((%d+)%)$"
local PATTERN_DEBUFF_GAIN_OTHER     = "^(.+) is afflicted by (.+)%.$"
local PATTERN_AURA_FADE_OTHER       = "^(.+) fades from (.+)%.$"

-- PET
local PATTERN_PET_BUFF_GAIN         = "^Your pet gains (.+)%.$"
local PATTERN_PET_BUFF_STACK_GAIN   = "^Your pet gains (.+) %((%d+)%)$"
local PATTERN_PET_DEBUFF_GAIN       = "^Your pet is afflicted by (.+)%.$"

function OldAuraTracker:new()
    local public                  = {}

    -----------------------------------------------------
    -- Private registrierte Buffs/Debuffs pro Unit
    -----------------------------------------------------

    local _watchedBuffs           = {} -- [unit] = { [name] = true }
    local _watchedDebuffs         = {} -- [unit] = { [name] = true }

    local _watchedBuffDurations   = {} -- [unit] = { [name] = duration }
    local _watchedDebuffDurations = {} -- same

    function makeAuraTimerKey(unit, kind, name)
        return unit .. ":" .. kind .. ":" .. name
    end

    -- Name → UnitToken ermitteln
    function resolveUnitTokenByName(name)
        if not name then return nil end

        if name == UnitName("player") then return "player" end
        if UnitExists("pet") and name == UnitName("pet") then return "pet" end
        if UnitExists("target") and name == UnitName("target") then return "target" end

        for i = 1, 4 do
            local u = "party" .. i
            if UnitExists(u) and name == UnitName(u) then
                return u
            end
        end

        return nil
    end


    -----------------------------------------------------
    -- Timer starten/stoppen
    -----------------------------------------------------

    local function startAuraTimer(unit, kind, name)
        local duration

        if kind == "buffs" then
            duration = _watchedBuffDurations[unit] and _watchedBuffDurations[unit][name]
        else
            duration = _watchedDebuffDurations[unit] and _watchedDebuffDurations[unit][name]
        end

        if not duration or duration <= 0 then return end

        local entry     = ensureAuraEntry(unit, kind, name)
        local key       = makeAuraTimerKey(unit, kind, name)
        local now       = GetTime()

        entry.duration  = duration
        entry.expiresAt = now + duration
        entry.timerKey  = key

        local timer     = Timer:new(key, duration)
        timer:start(function()
            entry.active    = false
            entry.stacks    = 0
            entry.expiresAt = nil
            entry.timerKey  = nil
        end)
    end

    local function cancelAuraTimer(unit, kind, name)
        local entry = ensureAuraEntry(unit, kind, name)
        if entry.timerKey then
            Timers.active[entry.timerKey] = nil
            entry.timerKey                = nil
            entry.expiresAt               = nil
        end
    end


    -----------------------------------------------------
    -- Event Handler: Buff/Debuff Gain/Fade
    -----------------------------------------------------

    local function handleBuffGain(unit, name, stacks, rawMsg)
        if not unit or not name then return end
        if not (_watchedBuffs[unit] and _watchedBuffs[unit][name]) then return end

        local entry   = ensureAuraEntry(unit, "buffs", name)
        entry.active  = true
        entry.stacks  = stacks or 1
        entry.lastMsg = rawMsg

        startAuraTimer(unit, "buffs", name)
    end

    local function handleDebuffGain(unit, name, rawMsg)
        if not unit or not name then return end
        if not (_watchedDebuffs[unit] and _watchedDebuffs[unit][name]) then return end

        local entry   = ensureAuraEntry(unit, "debuffs", name)
        entry.active  = true
        entry.stacks  = 1
        entry.lastMsg = rawMsg

        startAuraTimer(unit, "debuffs", name)
    end

    local function handleAuraFade(unit, name, rawMsg)
        if not unit or not name then return end

        local unitState = AuraState[unit]
        if not unitState then return end

        if _watchedBuffs[unit] and _watchedBuffs[unit][name] then
            local entry   = ensureAuraEntry(unit, "buffs", name)
            entry.active  = false
            entry.stacks  = 0
            entry.lastMsg = rawMsg
            cancelAuraTimer(unit, "buffs", name)
        end

        if _watchedDebuffs[unit] and _watchedDebuffs[unit][name] then
            local entry   = ensureAuraEntry(unit, "debuffs", name)
            entry.active  = false
            entry.stacks  = 0
            entry.lastMsg = rawMsg
            cancelAuraTimer(unit, "debuffs", name)
        end
    end


    -----------------------------------------------------
    -- WoW Frame + Event Registration
    -----------------------------------------------------

    local frame = CreateFrame("Frame")

    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

    frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
    --frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
    --
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")

    frame:SetScript("OnEvent", function()
        print()
        --
        -- SELF BUFF STACK GAIN
        --
        local name, stackStr = msg:match(PATTERN_BUFF_STACK_GAIN_SELF)
        if name and stackStr then
            handleBuffGain("player", name, tonumber(stackStr), msg)
            return
        end

        --
        -- SELF BUFF GAIN
        --
        name = msg:match(PATTERN_BUFF_GAIN_SELF)
        if name then
            handleBuffGain("player", name, 1, msg)
            return
        end

        --
        -- SELF DEBUFF GAIN
        --
        name = msg:match(PATTERN_DEBUFF_GAIN_SELF)
        if name then
            handleDebuffGain("player", name, msg)
            return
        end


        --
        -- SELF AURA FADE
        --
        name = msg:match(PATTERN_AURA_FADE_SELF)
        if name then
            handleAuraFade("player", name, msg)
            return
        end


        -------------------------------------------------
        -- PET AURAS
        -------------------------------------------------

        local buffName, stack = msg:match(PATTERN_PET_BUFF_STACK_GAIN)
        if buffName and stack then
            handleBuffGain("pet", buffName, tonumber(stack), msg)
            return
        end

        buffName = msg:match(PATTERN_PET_BUFF_GAIN)
        if buffName then
            handleBuffGain("pet", buffName, 1, msg)
            return
        end

        buffName = msg:match(PATTERN_PET_DEBUFF_GAIN)
        if buffName then
            handleDebuffGain("pet", buffName, msg)
            return
        end


        -------------------------------------------------
        -- OTHER UNITS (target, party)
        -------------------------------------------------

        -- STACKED
        local unitName, bName, st = msg:match(PATTERN_BUFF_STACK_GAIN_OTHER)
        if unitName and bName and st then
            local unit = resolveUnitTokenByName(unitName)
            if unit then
                handleBuffGain(unit, bName, tonumber(st), msg)
            end
            return
        end

        -- BUFF
        unitName, bName = msg:match(PATTERN_BUFF_GAIN_OTHER)
        if unitName and bName then
            local unit = resolveUnitTokenByName(unitName)
            if unit then
                handleBuffGain(unit, bName, 1, msg)
            end
            return
        end

        -- DEBUFF
        unitName, bName = msg:match(PATTERN_DEBUFF_GAIN_OTHER)
        if unitName and bName then
            local unit = resolveUnitTokenByName(unitName)
            if unit then
                handleDebuffGain(unit, bName, msg)
            end
            return
        end

        -- FADE OTHER
        local fadedName, fadedUnit = msg:match(PATTERN_AURA_FADE_OTHER)
        if fadedName and fadedUnit then
            local unit = resolveUnitTokenByName(fadedUnit)
            if unit then
                handleAuraFade(unit, fadedName, msg)
            end
        end
    end)


    -----------------------------------------------------
    -- Public API
    -----------------------------------------------------

    function public:registerBuff(name, unitToken, duration)
        local unit = unitToken or "player"
        local watcher = ensureWatcherTable(_watchedBuffs, unit)
        watcher[name] = true

        if duration then
            local durTable = ensureWatcherTable(_watchedBuffDurations, unit)
            durTable[name] = duration
        end

        ensureAuraEntry(unit, "buffs", name)
    end

    function public:registerDebuff(name, unitToken, duration)
        local unit = unitToken or "player"
        local watcher = ensureWatcherTable(_watchedDebuffs, unit)
        watcher[name] = true

        if duration then
            local durTable = ensureWatcherTable(_watchedDebuffDurations, unit)
            durTable[name] = duration
        end

        ensureAuraEntry(unit, "debuffs", name)
    end

    -- Query API

    function public:isBuffActive(name, unitToken)
        local unit = unitToken or "player"
        local unitState = AuraState[unit]
        if not unitState then return false end
        local entry = unitState.buffs[name]
        return entry and entry.active or false
    end

    function public:getBuffStacks(name, unitToken)
        local unit = unitToken or "player"
        local entry = AuraState[unit] and AuraState[unit].buffs[name]
        if entry and entry.active then
            return entry.stacks or 0
        end
        return 0
    end

    function public:isDebuffActive(name, unitToken)
        local unit = unitToken or "player"
        local entry = AuraState[unit] and AuraState[unit].debuffs[name]
        return entry and entry.active or false
    end

    function public:getDebuffStacks(name, unitToken)
        local unit = unitToken or "player"
        local entry = AuraState[unit] and AuraState[unit].debuffs[name]
        if entry and entry.active then
            return entry.stacks or 0
        end
        return 0
    end

    function public:getBuffInfo(name, unitToken)
        local unit = unitToken or "player"
        return AuraState[unit] and AuraState[unit].buffs[name]
    end

    function public:getDebuffInfo(name, unitToken)
        local unit = unitToken or "player"
        return AuraState[unit] and AuraState[unit].debuffs[name]
    end

    return public
end

---------------------------------------------------------
-- Globale Instanz
---------------------------------------------------------

OldAuraTrackerInstance = OldAuraTrackerInstance or OldAuraTracker:new()