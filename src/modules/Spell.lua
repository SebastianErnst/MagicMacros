Spell = {}
Spell.__index = Spell

function Spell:new(name)
    local textureName = NamesToTexturesMapping[name]
    local slotId = Slot:findSlotIndexByTextureName(textureName)
    local public = {}

    function public:getTextureName()
        return textureName
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
        if IsActionInRange(slotId) == 1 then
            return true
        else
            return false
        end


        return false
    end

    return public
end
