function Warlock:Corruption()
    local corruption = Spell:new("Corruption"):withDebuff({
        unit = "target",
        showCastBar = true
    })
    local immolate = Spell:new("Immolate"):withDebuff({
        unit = "target",
        showCastBar = true
    })

    corruption:cast()
    -- immolate:cast()
end
