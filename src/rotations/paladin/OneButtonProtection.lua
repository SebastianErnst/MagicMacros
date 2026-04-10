function Paladin:OneButtonProtection()
    local holyStrike = Spell:new("Holy Strike")
    local zeal = Buff:new(51300)
    local holyShield = Spell:new("Holy Shield")
    local consecration = Spell:new("Consecration")
    local greaterBlessingOfSanctuary = Spell:new("Greater Blessing of Sanctuary")
    local manaPercentage = UnitMana("player") / UnitManaMax("player") * 100
    local exorcism = Spell:new("Exorcism")

    Combat:startAutoAttack()

    if zeal:getStacks() == 3 then
        Paladin:SmartCrusaderStrike()
    end

    holyStrike:cast()
    holyShield:cast()
    Paladin:SealOfRighteousness()

    if holyStrike:isInRange() then
        consecration:cast()
    end

    exorcism:cast()

    if holyStrike:getCooldown() <= 1 and holyStrike:getCooldown() > 0 then
        return
    end

    if manaPercentage >= 50 and UnitPlayerOrPetInRaid("player") then
        greaterBlessingOfSanctuary:cast()
    end
end

function Paladin:OneButtonRetribution()
    local holyStrike = Spell:new("Holy Strike")
    local crusaderStrike = Spell:new("Crusader Strike")
    local consecration = Spell:new("Consecration")
    local manaPercentage = UnitMana("player") / UnitManaMax("player") * 100
    local exorcism = Spell:new("Exorcism")
    local holyMight = Buff:new(51354)
    local zeal = Buff:new(51300)

    Combat:startAutoAttack()

    -- if holyMight:getTimeLeft() <= 6 then
    --     holyStrike:cast()
    -- else 
    --     crusaderStrike:cast()
    -- end
    
    --  if zeal:getStacks() == 3 then
        Paladin:SmartCrusaderStrike()
    -- end

    -- holyStrike:cast()
    Paladin:SealOfRighteousness()
    -- Paladin:SealOfCommand()
    exorcism:cast()

    if holyStrike:isInRange() and manaPercentage >= 25 then
        consecration:cast()
    end
end

function Paladin:SealOfCommand()
    local judgement = Spell:new("Judgement")
    local sealOfCommand = Spell:new("Seal of Command")
    local sealOfCommandBuff = Buff:new("Seal of Command")

    if sealOfCommandBuff:isActive() then
        judgement:cast()
    else
        sealOfCommand:cast()
    end
end

function Paladin:OneButtonStacheln()
    local holyStrike = Spell:new("Holy Strike")
    local holyShield = Spell:new("Holy Shield")
    local consecration = Spell:new("Consecration")
    local greaterBlessingOfSanctuary = Spell:new("Greater Blessing of Sanctuary")
    local lifePercentage = UnitHealth("player") / UnitHealthMax("player") * 100
    local forceReactiveDisc = "Force Reactive Disk"
    local jadeStoneProtector = "Jadestone Protector"
    local greaterBlessingOfSanctuary = Spell:new("Greater Blessing of Sanctuary")
    local greaterBlessingOfSanctuaryBuff = Buff:new("Greater Blessing of Sanctuary")

    Combat:startAutoAttack()
    if lifePercentage <= 40 then
        EquipItemByName(forceReactiveDisc)
    elseif lifePercentage >= 75 then
        EquipItemByName(jadeStoneProtector)
    end

    if not greaterBlessingOfSanctuaryBuff:isActive() then
        greaterBlessingOfSanctuary:cast()
    end

    Paladin:SealOfWisdom()

    consecration:cast()
    holyShield:cast()
    Paladin:SmartCrusaderStrike()
end

function EquipItemByName(itemName)
    for i=0,4 do 
        for j=1,GetContainerNumSlots(i) do 
            local l=GetContainerItemLink(i,j) 
            if l and string.find(l, itemName) then 
                PickupContainerItem(i,j) 
                AutoEquipCursorItem() 
                return true
            end 
        end 
    end
    return false
end
