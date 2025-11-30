Utils = {}
Utils.__index = Utils

function Utils:printAllVisibleBuffs(target)
    if not target then
        target = "player"
    end

    Utils:printSeperator()

    for i = 0, 63 do
        if UnitBuff(target, i) then
            print(UnitBuff("player", i))
        end
    end
    Utils:printSeperator()
end

function Utils:printAllSlots()
    for i = 1, 172 do
        if GetActionText(i) then
            print(GetActionText(i))
        end
    end
    Utils:printSeperator()
end

function Utils:printSeperator()
    print("---------------------------")
end

function Utils:printSpellbookSpell()
    local output = ""
    local currentName = ""
    local currentSpellId = 0
    for i = 1, 172 do
        if GetSpellName(i, BOOKTYPE_SPELL) then
            local name, _, spellId = GetSpellName(i, BOOKTYPE_SPELL)
            if currentName == "" then
                currentName = name
                currentSpellId = spellId
            end

            if currentName ~= name then
                local _, _, currentTexture = SpellInfo(currentSpellId)
                currentTexture = Utils:stringSplit(currentTexture, "\\")[3]
                output = output .. "[\"" .. currentName .. "\"] = \"" .. currentTexture .. "\",\n"
                currentName = name
                currentSpellId = spellId
            end
        end
    end
    for i = 1, 172 do
        if GetSpellName(i, BOOKTYPE_PET) then
            local name, _, spellId = GetSpellName(i, BOOKTYPE_PET)
            if currentName == "" then
                currentName = name
                currentSpellId = spellId
            end

            if currentName ~= name then
                local _, _, currentTexture = SpellInfo(currentSpellId)
                currentTexture = Utils:stringSplit(currentTexture, "\\")[3]
                output = output .. "[\"" .. currentName .. "\"] = \"" .. currentTexture .. "\",\n"
                currentName = name
                currentSpellId = spellId
            end
        end
    end
    ExportFile("sachengibtsdiegibtsgarnicht", output)
end

function Utils:stringSplit(str, sep)
    local parts = {}
    local start = 1

    while true do
        local pos = string.find(str, sep, start, true)
        if not pos then
            table.insert(parts, string.sub(str, start))
            break
        end
        table.insert(parts, string.sub(str, start, pos - 1))
        start = pos + 1
    end

    return parts
end
