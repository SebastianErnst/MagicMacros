function Warrior:OneButtonProt()
    local shieldSlam = Spell:new("Shield Slam")
    local revenge = Spell:new("Revenge")
    local sunderArmor = Spell:new("Sunder Armor")
    local heroicStrike = Spell:new("Heroic Strike")

    Combat:startAutoAttack()

    shieldSlam:cast()
    revenge:cast()

    if UnitMana("player") >= 30 then
        sunderArmor:cast()
    end

    if UnitMana("player") >= 42 then
        heroicStrike:cast()
    end
end