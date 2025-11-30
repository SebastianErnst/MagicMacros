function Paladin:SealOfWisdom()
    local judgement = Spell:new("Judgement")
    local sealOfWidsom = Spell:new("Seal of Wisdom")
    local sealOfWidsomBuff = Buff:new("Seal of Wisdom")
    local sealOfWidsomDebuff = Debuff:new("Seal of Wisdom")

    if sealOfWidsomBuff:isBuffed() then
        if not sealOfWidsomDebuff:isDebuffed() then
            judgement:cast()
        end
    else
        sealOfWidsom:cast()
    end
end
