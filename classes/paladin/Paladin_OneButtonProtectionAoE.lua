function Paladin_OneButtonProtectionAoe()
    local textureName = "Spell_Holy_CrusaderStrike"
    local buffIndex = buffs_getBuffIndexByTextureName(textureName)

    combat_StartAutoAttack()

    if combat_isTextureNameInRange("INV_Sword_01") then
        CastSpellByName("Consecration")
    end

    CastSpellByName("Holy Shield")

    if GetPlayerBuffApplications(buffIndex) == 3 then
        Paladin_SmartCrusaderStrike()
    else
        CastSpellByName("Holy Strike")
    end

    local textureName = "Spell_Holy_RighteousnessAura"
    local isAlreadyDebuffed = buffs_findDebuffByTextureName(textureName)
    local currentManaPercentage = UnitMana("player") / UnitManaMax("player") * 100;

    if isAlreadyDebuffed and currentManaPercentage >= 50 then
        Paladin_SoR()
    else
        Paladin_SoW()
    end

    CastSpellByName("Greater Blessing of Sanctuary")
end
