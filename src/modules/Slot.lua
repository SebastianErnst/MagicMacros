Slot = {}
Slot.__index = Slot

function Slot:findSlotIndexByIcon(icon)
    for i = 1, 172 do
        if GetActionTexture(i) then
            local currentAura = Utils:getIconFromTexturePath(GetActionTexture(i))
            currentAura = Utils:decapitalizeIconName(currentAura)
            local isSameTexture = strfind(currentAura, icon)
            if isSameTexture then
                return i
            end
        end
    end

    return -1
end
