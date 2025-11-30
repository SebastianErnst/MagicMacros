function Paladin:SealOfRighteousness()
    local judgement = Spell:new("Judgement")
    local sealOfRighteousness = Spell:new("Seal of Righteousness")
    local sealOfRighteousnessBuff = Buff:new("Seal of Righteousness")

    if sealOfRighteousnessBuff:isBuffed() then
        judgement:cast()
    else
        sealOfRighteousness:cast()
    end
end