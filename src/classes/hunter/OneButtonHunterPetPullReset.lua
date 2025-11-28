function Hunter:OneButtonHunterPetPullReset()
    local furiousHowl = Abilities:new("Furious Howl")
    local feignDeath = Abilities:new("Feign Death")

    furiousHowl:cast()

    if UnitExists("pet") and not UnitIsDead("pet") then
        if feignDeath:isBuffed() then
            CastSpellByName("Eyes of the Beast")
        end
        if furiousHowl:isBuffed() then
            feignDeath:cast()
        end
    end
    CastSpellByName("Call Pet")
    CastSpellByName("Revive Pet")
end
