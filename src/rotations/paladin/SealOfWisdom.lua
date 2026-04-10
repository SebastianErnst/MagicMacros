function Paladin:SealOfWisdom()
    local judgement = Spell:new("Judgement")
    local sealOfWisdom = Spell:new("Seal of Wisdom")
    local sealOfWisdomBuff = Buff:new("Seal of Wisdom")
    local judgementOfWisdomDebuff = Debuff:new(51752)

    if sealOfWisdomBuff:isActive() then
        if not judgementOfWisdomDebuff:isActive() then
            judgement:cast()
        end
    else
        sealOfWisdom:cast()
    end
end
