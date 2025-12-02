function Paladin:SmartCrusaderStrike()
    local crusaderStrike = Spell:new("Crusader Strike")
    local zeal = Buff:new("Zeal")
    local holyStrike = Spell:new("Holy Strike")

    if not zeal:isBuffed() then
        crusaderStrike:cast()
    end

    if zeal:isBuffed() and (zeal:getBuffTimeLeft() < 7 or zeal:getBuffApplications() < 3) then
        crusaderStrike:cast()
    else
        holyStrike:cast()
    end
end