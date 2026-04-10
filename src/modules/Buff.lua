Buff = {}
Buff.__index = Buff

function Buff:new(nameOrId, target)
    target = target or "player"
    
    local targetSpellId
    if type(nameOrId) == "number" then
        targetSpellId = nameOrId
    else
        targetSpellId = GetSpellIdForName(nameOrId)
        if not targetSpellId or targetSpellId == 0 then
            error("Buff spell not found: " .. nameOrId)
        end
    end

    local buffIndex = -1
    local buffApplications = 0
    local buffTimeLeft = 0

    if target == "player" and GetPlayerBuffID then
        for i = 0, 31 do     
            local buffSpellId = GetPlayerBuffID(i)
            if buffSpellId == targetSpellId then
                buffIndex = i
                buffApplications = GetPlayerBuffApplications(i)
                buffTimeLeft = GetPlayerBuffTimeLeft(i)
                break 
            end
        end
    else
        local i = 1
        while true do
            local buffName, rank, icon, count, debuffType, duration, expirationTime = UnitBuff(target, i)
            if not buffName then break end
            
            local buffSpellId = GetSpellIdForName(buffName)
            if buffSpellId == targetSpellId then
                buffIndex = i - 1  
                buffApplications = count or 0
                if expirationTime and expirationTime > 0 then
                    buffTimeLeft = expirationTime - GetTime()
                end
                break
            end
            i = i + 1
            if i > 32 then break end  
        end
    end

    local public = {}

    function public:getIndex()
        return buffIndex
    end

    function public:getStacks()
        return buffApplications
    end

    function public:getTimeLeft()
        return buffTimeLeft
    end

    function public:isActive()
        return buffIndex >= 0
    end

    return public
end