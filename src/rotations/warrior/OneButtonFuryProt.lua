function Warrior:OneButtonFuryProt()
    local bloodThirst = Spell:new("Bloodthrist")
    local revenge = Spell:new("Revenge")
    local sunderArmor = Spell:new("Sunder Armor")
    local heroicStrike = Spell:new("Heroic Strike")

    Combat:startAutoAttack()
    bloodThirst:cast()
    revenge:cast()

    if UnitMana("player") >= 30 then
        sunderArmor:cast()
    end

    if UnitMana("player") >= 42 then
        heroicStrike:cast()
    end
end

--/cast Shield Slam
--/run CastSpellByName("Shield Slam") CastSpellByName("Revenge") if UnitMana("player") >= 30 then CastSpellByName("Sunder Armor") end if UnitMana("player") >= 42 then CastSpellByName("Heroic Strike") end if (not PlayerFrame.inCombat) then AttackTarget() end
