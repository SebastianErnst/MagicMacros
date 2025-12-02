function Hunter:OneButtonPetPullReset()
    local furiousHowl = Spell:new("Furious Howl")
    local furiousHowlBuff = Buff:new("Furious Howl")
    local feignDeath = Spell:new("Feign Death")
    local feignDeathBuff = Buff:new("Feign Death")

    furiousHowl:cast()

    if UnitExists("pet") and not UnitIsDead("pet") then
        if feignDeathBuff:isActive() then
            CastSpellByName("Eyes of the Beast")
        end
        if furiousHowlBuff:isActive() then
            feignDeath:cast()
        end
    end
    CastSpellByName("Call Pet")
    CastSpellByName("Revive Pet")
end
