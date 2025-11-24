function Paladin_SmartCrusaderStrike()
    local textureName = "Spell_Holy_CrusaderStrike"
    local buffIndex = buffs_getBuffIndexByTextureName(textureName)

    if buffIndex == nil then
        CastSpellByName("Crusader Strike")
    end

    if buffIndex and (GetPlayerBuffTimeLeft(buffIndex) < 7 or GetPlayerBuffApplications(buffIndex) < 3) then
        CastSpellByName("Crusader Strike")
    end

    CastSpellByName("Holy Strike")
end