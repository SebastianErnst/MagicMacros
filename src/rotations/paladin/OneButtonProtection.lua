function Paladin:OneButtonProtection()
    local holyStrike = Spell:new("Holy Strike")
    local zeal = Buff:new(51300)
    local holyShield = Spell:new("Holy Shield")
    local consecration = Spell:new("Consecration")
    local greaterBlessingOfSanctuary = Spell:new("Greater Blessing of Sanctuary")
    local manaPercentage = UnitMana("player") / UnitManaMax("player") * 100
    local exorcism = Spell:new("Exorcism")

    Combat:startAutoAttack()

    if zeal:getStacks() == 3 then
        Paladin:SmartCrusaderStrike()
    end

    holyStrike:cast()
    holyShield:cast()
    Paladin:SealOfRighteousness()

    if holyStrike:isInRange() then
        consecration:cast()
    end

    exorcism:cast()

    if holyStrike:getCooldown() <= 1 and holyStrike:getCooldown() > 0 then
        return
    end

    if manaPercentage >= 50 and UnitPlayerOrPetInRaid("player") then
        greaterBlessingOfSanctuary:cast()
    end
end
