function Hunter:OneButtonHunterPetPullReset()
    local furiousHowl = Buff:new("Furious Howl")
    local feignDeath = Spell:new("Feign Death")
    local feignDeathBuff = Buff:new("Feign Death")

    furiousHowl:cast()

    if UnitExists("pet") and not UnitIsDead("pet") then
        if feignDeathBuff:isBuffed() then
            CastSpellByName("Eyes of the Beast")
        end
        if furiousHowl:isBuffed() then
            feignDeath:cast()
        end
    end
    CastSpellByName("Call Pet")
    CastSpellByName("Revive Pet")
end
