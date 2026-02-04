function Druid:OneButtonFeralTank()
    local maul = Spell:new("Maul")
    local swipe = Spell:new("Swipe")
    local savageBite = Spell:new("Savage Bite")
    local rage = UnitMana("player")
    local clearcasting = Buff:new("Clearcasting")

    Combat:startAutoAttack()

    savageBite:cast()

    if rage >= 32 then
        maul:cast()
    end

    if rage >= 44 then
        swipe:cast()
    end
end