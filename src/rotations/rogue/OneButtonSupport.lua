function Rogue:OneButtonSupport()
    local markForDeath                        = Spell:new("Mark for Death")
    local markForDeathBuff                    = Buff:new("Mark for Death")
    local shadowOfDeath                       = Spell:new("Shadow of Death")
    local hemorrhage                          = Spell:new("Hemorrhage")
    local preparation                         = Spell:new("Preparation")
    local eviscerate                          = Spell:new("Eviscerate")
    local ghostlyStrike                       = Spell:new("Ghostly Strike")
    local sliceAndDice                        = Spell:new("Slice and Dice")
    local sliceAndDiceBuff                    = Buff:new("Slice and Dice")
    local comboPoints                         = GetComboPoints()
    local rupture                             = Spell:new("Rupture")
    local ruptureBuff                         = Buff:new("Taste for Blood")
    local energy                              = UnitMana("player")

    local ruptureBuffMinDuration              = 1
    local ruptureBuffMinDurationForBigCombo   = 4
    local ruptureBuffMinDurationForEviscerate = 5

    Combat:startAutoAttack()

    if ruptureBuff:getTimeLeft() < ruptureBuffMinDuration and
        not markForDeathBuff:isActive() and
        comboPoints == 5 then
        rupture:cast()
        return
    end

    -- 0. Preparation nutzen wenn ready und beide CDs down sind und Mark for Death Buff nicht aktiv
    if preparation:getCooldown() <= 0 and
        markForDeath:getCooldown() > 0 and
        shadowOfDeath:getCooldown() > 0 and
        not markForDeathBuff:isActive() then
        preparation:cast()
        return
    end

    if ruptureBuff:getTimeLeft() > ruptureBuffMinDurationForBigCombo or markForDeathBuff:isActive() then
        -- 1. Mark for Death bei 3+ CP
        if comboPoints >= 3 and markForDeath:getCooldown() <= 0 then
            markForDeath:cast()
            return
        end

        -- 2. Shadow of Death bei 5 CP (höchste Prio bei 5 CP)
        if comboPoints == 5 and
            shadowOfDeath:getCooldown() <= 0 and
            markForDeath:getCooldown() > 50 and
            markForDeath:getCooldown() > 0
        then
            shadowOfDeath:cast()
            return
        end
    end

    if shadowOfDeath:getCooldown() > 0 and
        ((sliceAndDiceBuff:getTimeLeft() < 2) and comboPoints >= 1 and comboPoints <= 2) then
        sliceAndDice:cast()
        return
    end

    -- 5. Eviscerate bei 5 CP
    if comboPoints == 5 and shadowOfDeath:getCooldown() > 10 and
        ruptureBuff:getTimeLeft() > ruptureBuffMinDurationForEviscerate then
        -- 4. Slice and Dice mit 1 oder 2 CP a1ufrecht erhalten
        eviscerate:cast()
        return
    end

    if not (comboPoints == 5) or energy > 60 then
        ghostlyStrike:cast()
        hemorrhage:cast()
        return
    end
end
