function Warlock:Corruption()
    local corruption = Spell:new("Holy Strike")
    local corruptionTimer = Timer:new("Corruption", 10)
    
    if corruptionTimer:isRunning() then
        corruptionTimer:cancel()
    end

    corruptionTimer:start()
    corruption:cast()
    
end