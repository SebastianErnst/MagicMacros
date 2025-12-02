Combat = {}
Combat.__index = Combat

function Combat:startAutoAttack()
        if (not PlayerFrame.inCombat) then
        AttackTarget()
    end
end