Debuff = {}
Debuff.__index = Debuff


function Debuff:new(name)
    function findDebuffIndexByTextureName(textureName)
        local i = 1
        while UnitDebuff("target", i) do
            local isSameTexture = strfind(UnitDebuff("target", i), textureName)

            if isSameTexture then
                return i
            end

            i = i + 1
        end

        return -1
    end

    local textureName = NamesToTexturesMapping[name]
    local debuffIndex = findDebuffIndexByTextureName(textureName)

    local public = {}
    function public.isDebuffed()
        if debuffIndex >= 0 then
            return true
        end

        return false
    end

    return public
end
