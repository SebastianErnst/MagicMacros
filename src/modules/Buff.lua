Buff = {}
Buff.__index = Buff

function Buff:new(name)
    function getBuffIndexByTextureName(textureName)
        local i = 0
        while GetPlayerBuff(i) >= 0 do
            if strfind(GetPlayerBuffTexture(i), textureName) then
                return i
            end
            i = i + 1
        end
        return -1
    end

    function findBuffByTextureName(textureName)
        return self:getBuffIndexByTextureName(textureName) > -1
    end

    local textureName = NamesToTexturesMapping[name]
    local buffIndex = getBuffIndexByTextureName(textureName)
    local buffApplications = GetPlayerBuffApplications(buffIndex)
    local buffTimeLeft = GetPlayerBuffTimeLeft(buffIndex)

    local public = {}

    function public:getBuffIndex()
        return buffIndex
    end

    function public:getBuffApplications()
        return buffApplications
    end

    function public.getBuffTimeLeft()
        return buffTimeLeft
    end

    function public.isBuffed()
        if buffIndex >= 0 then
            return true
        end

        return false
    end

    return public
end
