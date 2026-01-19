Spell = {}
Spell.__index = Spell

function Spell:new(name, unit)
    local spellInfo = Utils:getSpellInfoByName(name)
    local icon = spellInfo.icon
    local slotId = Slot:findSlotIndexByIcon(icon)
     if slotId == -1 then
            print("Spell not found in action bar: " .. name)
            return 0
        end
    local public = {}

    function public:getIcon()
        return icon
    end

    function public:cast()
        CastSpellByName(name)
    end

    function public:getCooldown()       
        local startTime, duration = GetActionCooldown(slotId)
        local cooldown = startTime - GetTime() + duration
        
        return cooldown
    end

    function public:isInRange()
        return IsActionInRange(slotId) == 1
    end

    return public
end
