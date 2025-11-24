function Paladin_OneButtonProtection()
    local textureName = "Spell_Holy_CrusaderStrike"
    local buffIndex = buffs_getBuffIndexByTextureName(textureName)

    combat_StartAutoAttack()

    if GetPlayerBuffApplications(buffIndex) == 3 then
        Paladin_SmartCrusaderStrike()
    else
        CastSpellByName("Holy Strike")
    end

    CastSpellByName("Holy Shield")
    Paladin_SoR()

    if combat_isTextureNameInRange("INV_Sword_01") then
        CastSpellByName("Consecration")
    end

    CastSpellByName("Greater Blessing of Sanctuary")
end
