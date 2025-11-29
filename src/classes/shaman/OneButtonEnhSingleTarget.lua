function Shaman:OneButtonEnhSingleTarget()
    local waterShield = Abilities:new("Water Shield")
    local stormShield = Abilities:new("Lightning Shield")
    local lightningStrike = Abilities:new("Lightning Strike")
    local stormStrike = Abilities:new("Stormstrike")
    local earthShock = Abilities:new("Earth Shock")

    if UnitMana("player") < 1000 and waterShield:getBuffApplications() < 2 then
        waterShield:cast()
        return
    end

    if not stormShield:isBuffed() and not waterShield:isBuffed() then
        stormShield:cast()
        return
    end

    stormStrike:cast()
    lightningStrike:cast()
    earthShock:cast()
end
