--local frame = CreateFrame("Frame")
--frame:RegisterEvent("SPELLCAST_START")
--frame:RegisterEvent("SPELLCAST_FAILED")
--frame:RegisterEvent("SPELLCAST_INTERRUPTED")
--
--frame:SetScript("OnEvent", function()
--    if event == "SPELLCAST_START" then
--        -- Spell wurde erfolgreich gestartet
--    elseif event == "SPELLCAST_FAILED" then
--        -- Spell ist fehlgeschlagen (arg1 enthält Fehlergrund)
--    elseif event == "SPELLCAST_INTERRUPTED" then
--        -- Spell wurde unterbrochen
--    end
--end)

function Paladin:OneButtonProtectionAoeFarm()
    local holyStrike = Spell:new("Holy Strike")
    local holyShield = Spell:new("Holy Shield")
    local consecration = Spell:new("Consecration")
    local exorcism = Spell:new("Exorcism")

    Combat:startAutoAttack()

    if holyStrike:isInRange() then
        consecration:cast()
    end

    Paladin:SealOfWisdom()

    Paladin:SmartCrusaderStrike()

    holyShield:cast()

    exorcism:cast()
end
