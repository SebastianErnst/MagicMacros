function Paladin_SoW()
    local textureName = "Spell_Holy_RighteousnessAura"
    local isBuffFound = buffs_findBuffByTextureName(textureName)
    local isAlreadyDebuffed = buffs_findDebuffByTextureName(textureName)

    if isBuffFound and not isAlreadyDebuffed then
        if isAlreadyDebuffed then
            CastSpellByName("Judgement")
        end
    else
        CastSpellByName("Seal of Wisdom")
    end
end
