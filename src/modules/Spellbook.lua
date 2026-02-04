Spellbook = {}
Spellbook.__index = Spellbook

function Spellbook:getIdByName(name)
    for i = 1, GetNumSpellTabs() do
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for j = offset + 1, offset + numSpells do
            local spellName = GetSpellName(j, "spell")
            if spellName == name then
                return j
            end
        end
    end
    return nil
end