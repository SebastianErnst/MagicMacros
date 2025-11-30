function Paladin:OneButtonProtection()
    local holyStrike = Spell:new("Holy Strike")
    local zeal = Buff:new("Zeal")
    local holyShield = Spell:new("Holy Shield")
    local consecration = Spell:new("Consecration")
    local greaterBlessingOfSanctuary = Spell:new("Greater Blessing of Sanctuary")

    Combat:startAutoAttack()

    if zeal:getBuffApplications() == 3 then
        Paladin:SmartCrusaderStrike()
    else
        holyStrike:cast()
    end

    holyShield:cast()
    Paladin:SealOfRighteousness()

    if holyStrike:isInRange() then
        consecration:cast()
    end

    greaterBlessingOfSanctuary:cast()
end