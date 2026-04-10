Debuff = {}
Debuff.__index = Debuff

function Debuff:new(nameOrId, unit)
    unit = unit or "target"
    
    local targetSpellId
    if type(nameOrId) == "number" then
        targetSpellId = nameOrId
    else
        targetSpellId = GetSpellIdForName(nameOrId)
        if not targetSpellId or targetSpellId == 0 then
            error("Debuff spell not found: " .. nameOrId)
        end
    end

    local debuffIndex = -1
    local debuffApplications = 0
    local debuffTimeLeft = 0
    
    local i = 1
    while i <= 40 do
        local texture, count, debuffType, spellId = UnitDebuff(unit, i)
        if not texture then break end
        
        if spellId == targetSpellId then
            debuffIndex = i - 1
            debuffApplications = count or 0
            debuffTimeLeft = 0
            break
        end
        i = i + 1
    end

    local public = {}

    function public:getIndex()
        return debuffIndex
    end

    function public:getStacks()
        return debuffApplications
    end

    function public:getTimeLeft()
        return debuffTimeLeft
    end

    function public:isActive()
        return debuffIndex >= 0
    end

    return public
end    