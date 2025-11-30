Slot = {}
Slot.__index = Slot

function Slot:findSlotIndexByTextureName(textureName)
    for i = 1, 172 do
        if GetActionTexture(i) then
            local isSameTexture = strfind(GetActionTexture(i), textureName)
            if isSameTexture then
                return i
            end
        end
    end

    return -1
end