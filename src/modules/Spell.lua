Spell = {}
Spell.__index = Spell

function Spell:new(name)
    local textureName = NamesToTexturesMapping[name]
    local public = {}

    function public:getTextureName()
        return textureName
    end

    function public:cast()
        CastSpellByName(name)
    end

    function public:isInRange()
        for i = 1, 172 do
            if GetActionTexture(i) then
                local isSameTexture = strfind(GetActionTexture(i), textureName)
                if isSameTexture then
                    if IsActionInRange(i) == 1 then
                        return true
                    else
                        return false
                    end
                end
            end
        end

        return false
    end

    return public
end
