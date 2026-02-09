Spell = {}
Spell.__index = Spell

function Spell:new(nameOrId, unit)
    local unit = unit or "target"
    
    local spellId
    if type(nameOrId) == "number" then
        spellId = nameOrId
    else
        spellId = GetSpellIdForName(nameOrId)
        if not spellId or spellId == 0 then
            error("Spell not found: " .. nameOrId)
        end
    end

    local spellRec = GetSpellRec and GetSpellRec(spellId)
    
    local name
    if spellRec and spellRec.name then
        name = spellRec.name
    end

    local icon
    if spellRec and spellRec.spellIconID then
        icon = GetSpellIconTexture(spellRec.spellIconID)
    end

    local public = {}

    function public:getIcon()
        return icon
    end

    function public:cast()
        CastSpellByName(name, unit)
    end

    function public:getCooldown()
        local cd = GetSpellIdCooldown(spellId)
        if cd and cd.cooldownRemainingMs then
            return cd.cooldownRemainingMs / 1000 
        end

        return 0
    end

    function public:isInRange()
        local inRange = IsSpellInRange(spellId, unit or "target")

        return inRange == 1
    end

    function public:isUsable()
        local usable, noMana = IsSpellUsable(spellId)

        return usable == 1, noMana == 1
    end

    function public:getSpellId()
        return spellId
    end

    return public
end