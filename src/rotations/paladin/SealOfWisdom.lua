function Paladin:SealOfWisdom()
    local judgement = Spell:new("Judgement")
    local sealOfWidsom = Spell:new("Seal of Wisdom")
    local sealOfWidsomBuff = Buff:new("Seal of Wisdom")
    local sealOfWidsomDebuff = Debuff:new("Seal of Wisdom")

    if sealOfWidsomBuff:isActive() then
        if not sealOfWidsomDebuff:isActive() then
            judgement:cast()
        end
    else
        sealOfWidsom:cast()
    end
end
