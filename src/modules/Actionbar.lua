Actionbar = {}
Actionbar.__index = Actionbar

function Actionbar:findFreeSlot()
    for slotId = 120, 1, -1 do
        local actionType, id = GetActionTexture(slotId)
        if actionType == nil then
            return slotId
        end
    end
    return nil
end

function Actionbar:switchToSpell(spellBookId, slotId)
    ClearCursor()
    PickupSpell(spellBookId, "spell")
    PlaceAction(slotId)
    ClearCursor()
end