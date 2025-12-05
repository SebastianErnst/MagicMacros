Buff = {}
Buff.__index = Buff

function Buff:new(name)
    local function getBuffIndexByIcon(icon)
        local currentAura = nil
        for i = 0, 32 do            
            if GetPlayerBuffTexture(i) then
                local currentAura = Utils:getIconFromTexturePath(GetPlayerBuffTexture(i))
                currentAura = Utils:decapitalizeIconName(currentAura)
                if currentAura == icon then
                    return i
                end
            end
        end
        return -1
    end

    local spellInfo = Utils:getSpellInfoByName(name)
    local icon = spellInfo.icon
    local buffIndex = getBuffIndexByIcon(icon)
    local buffApplications = GetPlayerBuffApplications(buffIndex)
    local buffTimeLeft = GetPlayerBuffTimeLeft(buffIndex)

    local public = {}

    function public:getIndex()
        return buffIndex
    end

    function public:getStacks()
        return buffApplications
    end

    function public.getTimeLeft()
        return buffTimeLeft
    end

    function public.isActive()
        return buffIndex >= 0
    end

    return public
end
