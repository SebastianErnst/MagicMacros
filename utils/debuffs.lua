function buffs_findDebuffByTextureName(textureName)
    local i = 1
    while UnitDebuff("target", i) do
        local isSameTexture = strfind(UnitDebuff("target", i), textureName)

        if isSameTexture then
            return i
        end
        i = i + 1
    end
end