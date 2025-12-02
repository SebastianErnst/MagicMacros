Buff = {}
Buff.__index = Buff

function Buff:new(name)
    local function getBuffIndexByTextureName(textureName)
        for i = 1, 32 do
            if strfind(GetPlayerBuffTexture(i), textureName) then
                return i
            end
        end
        return -1
    end

    local textureName = NamesToTexturesMapping[name]
    local buffIndex = getBuffIndexByTextureName(textureName)
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

    function public.isBuffed()
        return buffIndex >= 0
    end

    return public
end
