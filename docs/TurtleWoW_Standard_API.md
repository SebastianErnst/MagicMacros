# Turtle WoW Standard API Dokumentation

## Übersicht
Standard Lua API Funktionen für World of Warcraft 1.12.1 Turtle WoW.  
Diese API ist im Client verfügbar ohne SuperWoW oder Nampower.

**Quelle:** https://github.com/SabineWren/wow-api-type-definitions

---

## Kategorien

- [Aura/Buff/Debuff](#aurabuffdebuff)
- [Spell/Casting](#spellcasting)
- [Unit](#unit)
- [Item/Inventory](#iteminventory)
- [Bag/Container](#bagcontainer)
- [Action Bar](#action-bar)
- [Target/Combat](#targetcombat)
- [Group/Raid](#groupraid)
- [Chat/Communication](#chatcommunication)
- [Map/Location](#maplocation)
- [Quest](#quest)
- [Pet](#pet)
- [Macro](#macro)
- [Frame/UI](#frameui)

---

## Aura/Buff/Debuff

### CancelPlayerBuff(index)
- **Parameter:** `index` (number): Buff-Index (0-basiert)
- **Beschreibung:** Entfernt einen Buff vom Spieler. Nicht Hardware-Event-limitiert.
- **Hinweis:** 0-basiert, nicht wie UnitBuff()

### CancelTrackingBuff()
- **Beschreibung:** Bricht aktuellen Tracking-Buff ab (Find Minerals, etc.)

### GetPlayerBuff(buffIndex, auraFilter)
- **Parameter:**
  - `buffIndex` (number): Buff-Index (0-basiert)
  - `auraFilter` (string): "HELPFUL", "HARMFUL", "PASSIVE"
- **Rückgabe:**
  - `buffIndex` (number): Index für weitere GetPlayerBuff-Funktionen (< 0 = kein Buff)
  - `untilCancelled` (number): 1 wenn Buff nicht ausläuft (Aura, Aspect, etc.)

### GetPlayerBuffApplications(buffIndex)
- **Parameter:** `buffIndex` (number): 0-basiert
- **Rückgabe:** `stacks` (number): Anzahl der Stacks

### GetPlayerBuffDispelType(buffIndex)
- **Parameter:** `buffIndex` (number): 0-basiert
- **Rückgabe:** `type` (string): "Magic", "Curse", "Disease", "Poison"

### GetPlayerBuffTexture(buffIndex)
- **Parameter:** `buffIndex` (number): 0-basiert
- **Rückgabe:** `path` (string|nil): Textur-Pfad oder nil

### GetPlayerBuffTimeLeft(buffIndex)
- **Parameter:** `buffIndex` (number): 0-basiert
- **Rückgabe:** `timeLeft` (number): Verbleibende Zeit in Sekunden

### UnitBuff(unit, index, [showCastable])
- **Parameter:**
  - `unit` (string): Unit-Token
  - `index` (number): 1-basiert (1-40)
  - `showCastable` (boolean): Optional
- **Rückgabe:** `name`, `rank`, `icon`, `count`, `debuffType`, `duration`

### UnitDebuff(unit, index, [showDispellable])
- **Parameter:**
  - `unit` (string): Unit-Token
  - `index` (number): 1-basiert (1-40)
  - `showDispellable` (boolean): Optional
- **Rückgabe:** `name`, `rank`, `icon`, `count`, `debuffType`, `duration`

---

## Spell/Casting

### CastShapeshiftForm(spellIndex)
- **Parameter:** `spellIndex` (number): Stance/Form-Index
- **Beschreibung:** Castet Shapeshift/Stance

### CastSpell(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spellbook-Slot
  - `bookType` (string): "spell" oder "pet"
- **Beschreibung:** Castet Spell über Spellbook-Index

### CastSpellByName(name, [isSelf])
- **Parameter:**
  - `name` (string): Spell-Name, optional mit Rang "Flash Heal(Rank 2)"
  - `isSelf` (boolean): true/1 für Selbst-Cast
- **Beschreibung:** Castet Spell über Namen
- **Beispiel:**
  ```lua
  CastSpellByName("Flash Heal") -- Höchster Rang auf Target
  CastSpellByName("Flash Heal(Rank 2)") -- Rang 2
  CastSpellByName("Flash Heal", 1) -- Auf sich selbst
  ```

### GetNumShapeshiftForms()
- **Rückgabe:** `count` (number): Anzahl Stances/Forms/Auras
- **Hinweis:** Kann 0 zurückgeben vor UNIT_AURA Event

### GetNumSpellTabs()
- **Rückgabe:** `numTabs` (number): Anzahl Spellbook-Tabs

### GetQuestLogRewardSpell()
- **Rückgabe:** `texturePath`, `spellName`, `isTradeskillSpell`, `isSpellLearned`
- **Beschreibung:** Quest-Reward Spell aus Quest-Log

### GetRewardSpell()
- **Rückgabe:** `texturePath`, `spellName`, `isTradeskillSpell`, `isSpellLearned`
- **Beschreibung:** Quest-Reward Spell aus Gossip-Fenster

### GetShapeshiftFormCooldown(index)
- **Parameter:** `index` (number): Form-Index
- **Rückgabe:** `startTime`, `duration`, `isActive`

### GetShapeshiftFormInfo(index)
- **Parameter:** `index` (number): Form-Index
- **Rückgabe:** `texturePath`, `isActive`, `canCast`, `spellIndex`

### GetSpellAutocast(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Rückgabe:** `autocastable`, `autostate`

### GetSpellCooldown(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Rückgabe:** `startTime`, `duration`, `enabled`

### GetSpellName(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Rückgabe:** `name`, `rank`

### GetSpellTexture(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Rückgabe:** `texture` (string): Textur-Pfad

### IsCurrentCast(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Rückgabe:** `isCasting` (boolean)

### IsSpellPassive(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Rückgabe:** `isPassive` (boolean)

### SpellCanTargetUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `canTarget` (boolean)

### SpellIsTargeting()
- **Rückgabe:** `isTargeting` (boolean): Ob Spell auf Targeting wartet

### SpellStopCasting()
- **Beschreibung:** Stoppt aktuellen Cast

### SpellStopTargeting()
- **Beschreibung:** Bricht Spell-Targeting ab

### SpellTargetUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Beschreibung:** Targetiert Unit für aktuellen Spell

### ToggleSpellAutocast(spellIndex, bookType)
- **Parameter:**
  - `spellIndex` (number): Spell-Index
  - `bookType` (string): "spell" oder "pet"
- **Beschreibung:** Togglet Autocast für Pet-Spell

---

## Unit

### AssistUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Beschreibung:** Assistiert die Unit

### FollowUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Beschreibung:** Folgt der Unit

### StartDuelUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Beschreibung:** Fordert Unit zum Duell heraus

### UnitAffectingCombat(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `inCombat` (boolean): Ob Unit im Kampf oder Aggro hat
- **Hinweis:** false wenn out of range oder nur Proximity-Aggro

### UnitArmor(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `base`, `effective`, `armor`, `bonus`, `malus`

### UnitAttackBothHands(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `mainBase`, `mainMod`, `offBase`, `offMod`

### UnitAttackPower(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `base`, `bonus`, `malus`

### UnitAttackSpeed(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `mainSpeed`, `offSpeed` (Sekunden)

### UnitCanAssist(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `canAssist` (boolean)

### UnitCanAttack(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `canAttack` (boolean)

### UnitCanCooperate(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `canCooperate` (boolean)

### UnitCharacterPoints(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `talentPoints` (number): Verfügbare Talentpunkte

### UnitClass(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `classLocalized`, `classEnglish`
- **Beispiel:** "Magier", "MAGE"

### UnitClassification(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `classification` (string): "normal", "elite", "rare", "rareelite", "worldboss"

### UnitCreatureFamily(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `family` (string): Pet-Familie (Beast, Demon, etc.)

### UnitCreatureType(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `type` (string): Kreatur-Typ (Humanoid, Beast, etc.)

### UnitDamage(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `mainMin`, `mainMax`, `offMin`, `offMax`, `physBonus`, `negBonus`, `modPercent`

### UnitDefense(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `base`, `modifier`

### UnitExists(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `exists` (boolean)

### UnitFactionGroup(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `faction` (string): "Alliance", "Horde", nil

### UnitGUID(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `guid` (string): Format "Player-SERVER-ID" oder nil

### UnitHealth(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `health` (number): Aktuelle Gesundheit

### UnitHealthMax(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `maxHealth` (number): Maximale Gesundheit

### UnitInParty(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `inParty` (boolean)

### UnitInRaid(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `inRaid` (boolean)

### UnitIsAFK(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isAFK` (boolean)

### UnitIsConnected(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isConnected` (boolean)

### UnitIsCorpse(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isCorpse` (boolean)

### UnitIsDead(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isDead` (boolean)

### UnitIsDND(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isDND` (boolean): Do Not Disturb

### UnitIsEnemy(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `isEnemy` (boolean)

### UnitIsFriend(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `isFriend` (boolean)

### UnitIsGhost(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isGhost` (boolean)

### UnitIsPVP(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isPVP` (boolean): PVP-flagged

### UnitIsPVPFreeForAll(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isFFA` (boolean): FFA-PVP

### UnitIsPlayer(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isPlayer` (boolean)

### UnitIsTapped(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isTapped` (boolean): Von anderem Spieler getagged

### UnitIsTappedByPlayer(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isTappedByPlayer` (boolean): Von dir getagged

### UnitIsUnit(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `isSame` (boolean)

### UnitIsVisible(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isVisible` (boolean)

### UnitLevel(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `level` (number): -1 für Skull-Level

### UnitMana(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `mana` (number): Aktuelles Mana/Power

### UnitManaMax(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `maxMana` (number): Maximales Mana/Power

### UnitName(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `name` (string): Name der Unit

### UnitPlayerControlled(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `isControlled` (boolean): Von Spieler kontrolliert

### UnitPowerType(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `powerType`, `powerToken` (number, string)
- **Power-Types:** 0=Mana, 1=Rage, 2=Focus, 3=Energy, 4=Happiness

### UnitRace(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `raceLocalized`, `raceEnglish`
- **Beispiel:** "Mensch", "Human"

### UnitRangedAttack(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `base`, `modifier`

### UnitRangedAttackPower(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `base`, `bonus`, `malus`

### UnitRangedDamage(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `min`, `max`, `physBonus`, `negBonus`, `modPercent`

### UnitRealGUID(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `guid` (string): Real GUID, nicht Player-GUID-Format

### UnitReaction(unit, otherUnit)
- **Parameter:** `unit`, `otherUnit` (string): Unit-Tokens
- **Rückgabe:** `reaction` (number): 1-8 (1=Hated, 4=Neutral, 8=Exalted)

### UnitResistance(unit, school)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `school` (number): 0=Physical, 1=Holy, 2=Fire, 3=Nature, 4=Frost, 5=Shadow, 6=Arcane
- **Rückgabe:** `base`, `total`

### UnitSex(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `sex` (number): 1=Unknown, 2=Male, 3=Female

### UnitStat(unit, statIndex)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `statIndex` (number): 1=STR, 2=AGI, 3=STA, 4=INT, 5=SPI
- **Rückgabe:** `stat`, `bonus`, `malus`

---

## Item/Inventory

### GetItemInfo(itemId)
### GetItemInfo(itemString)
- **Parameter:** `itemId` (number) oder `itemString` (string)
- **Rückgabe:** `name`, `itemString`, `quality`, `minLevel`, `type`, `subType`, `stackCount`, `equipLoc`, `texture`
- **Beispiel:**
  ```lua
  local name, link, quality = GetItemInfo(19019) -- Thunderfury
  ```

### GetItemQualityColor(quality)
- **Parameter:** `quality` (number): 0-6 (Poor-Artifact)
- **Rückgabe:** `r`, `g`, `b`, `hex`

### GetInventoryItemBroken(unit, slotId)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `slotId` (number): Equipment-Slot
- **Rückgabe:** `isBroken` (boolean)

### GetInventoryItemCooldown(unit, slotId)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `slotId` (number): Equipment-Slot
- **Rückgabe:** `start`, `duration`, `enabled`

### GetInventoryItemCount(unit, slotId)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `slotId` (number): Equipment-Slot
- **Rückgabe:** `count` (number): Stack-Count

### GetInventoryItemLink(unit, slotId)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `slotId` (number): Equipment-Slot
- **Rückgabe:** `itemLink` (string)

### GetInventoryItemQuality(unit, slotId)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `slotId` (number): Equipment-Slot
- **Rückgabe:** `quality` (number): 0-6

### GetInventoryItemTexture(unit, slotId)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `slotId` (number): Equipment-Slot
- **Rückgabe:** `texture` (string)

### GetInventorySlotInfo(slotName)
- **Parameter:** `slotName` (string): z.B. "HeadSlot", "HandsSlot"
- **Rückgabe:** `slotId`, `texturePath`

### EquipItemByName(itemName, [slot])
- **Parameter:**
  - `itemName` (string): Item-Name
  - `slot` (number): Optional, spezifischer Slot
- **Beschreibung:** Equipped Item aus Inventar

### HasWandEquipped()
- **Rückgabe:** `hasWand` (boolean)

### OffhandHasWeapon()
- **Rückgabe:** `hasOffhand` (boolean)

### UseInventoryItem(slotId)
- **Parameter:** `slotId` (number): Equipment-Slot
- **Beschreibung:** Benutzt equipped Item

---

## Bag/Container

### GetBagName(bagId)
- **Parameter:** `bagId` (number): 0-4
- **Rückgabe:** `name` (string): Bag-Name

### GetContainerItemCooldown(bagId, slot)
- **Parameter:**
  - `bagId` (number): 0-4
  - `slot` (number): Slot im Bag
- **Rückgabe:** `start`, `duration`, `enabled`

### GetContainerItemInfo(bagId, slot)
- **Parameter:**
  - `bagId` (number): 0-4
  - `slot` (number): Slot im Bag
- **Rückgabe:** `texture`, `count`, `locked`, `quality`, `readable`

### GetContainerItemLink(bagId, slot)
- **Parameter:**
  - `bagId` (number): 0-4
  - `slot` (number): Slot im Bag
- **Rückgabe:** `itemLink` (string)

### GetContainerNumFreeSlots(bagId)
- **Parameter:** `bagId` (number): 0-4
- **Rückgabe:** `freeSlots`, `bagType`

### GetContainerNumSlots(bagId)
- **Parameter:** `bagId` (number): 0-4
- **Rückgabe:** `numSlots` (number)

### PickupBagFromSlot(slot)
- **Parameter:** `slot` (number): Bag-Slot (20-23)
- **Beschreibung:** Nimmt Bag auf Cursor

### PickupContainerItem(bagId, slot)
- **Parameter:**
  - `bagId` (number): 0-4
  - `slot` (number): Slot im Bag
- **Beschreibung:** Nimmt Item auf Cursor

### PutItemInBag(inventorySlot)
- **Parameter:** `inventorySlot` (number): Inventory-Slot
- **Beschreibung:** Legt Cursor-Item in Slot

### SplitContainerItem(bagId, slot, amount)
- **Parameter:**
  - `bagId` (number): 0-4
  - `slot` (number): Slot im Bag
  - `amount` (number): Anzahl zu splitten
- **Beschreibung:** Splittet Stack

### UseContainerItem(bagId, slot, [onSelf])
- **Parameter:**
  - `bagId` (number): 0-4
  - `slot` (number): Slot im Bag
  - `onSelf` (boolean): Optional, auf sich selbst
- **Beschreibung:** Benutzt Item aus Bag

---

## Action Bar

### GetActionCooldown(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot (1-120)
- **Rückgabe:** `start`, `duration`, `enabled`

### GetActionCount(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `count` (number): Item-Count oder Spell-Stacks

### GetActionText(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `text` (string): Makro-Name

### GetActionTexture(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `texture` (string)

### HasAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `hasAction` (boolean)

### IsActionInRange(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `inRange` (boolean|nil): 1=in range, 0=out of range, nil=no target

### IsAttackAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `isAttack` (boolean)

### IsAutoRepeatAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `isAutoRepeat` (boolean)

### IsCurrentAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `isCurrent` (boolean)

### IsUsableAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Rückgabe:** `usable`, `noMana`

### PickupAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Beschreibung:** Nimmt Action auf Cursor

### PlaceAction(slot)
- **Parameter:** `slot` (number): Action-Bar-Slot
- **Beschreibung:** Legt Cursor-Action in Slot

### UseAction(slot, [checkCursor], [onSelf])
- **Parameter:**
  - `slot` (number): Action-Bar-Slot
  - `checkCursor` (number): Optional, 1 um Cursor zu prüfen
  - `onSelf` (number): Optional, 1 für Selbst-Cast
- **Beschreibung:** Führt Action aus

---

## Target/Combat

### AssistByName(name)
- **Parameter:** `name` (string): Spieler-Name
- **Beschreibung:** Assistiert Spieler nach Namen

### AttackTarget()
- **Beschreibung:** Greift aktuelles Target an

### ClearTarget()
- **Beschreibung:** Leert Target

### TargetByName(name, [exactMatch])
- **Parameter:**
  - `name` (string): Unit-Name
  - `exactMatch` (boolean): Optional, nur exakte Matches
- **Beschreibung:** Targetiert nach Namen

### TargetLastEnemy()
- **Beschreibung:** Targetiert letzten Feind

### TargetLastTarget()
- **Beschreibung:** Targetiert vorheriges Target

### TargetNearestEnemy([reverse])
- **Parameter:** `reverse` (boolean): Optional, für fernere Feinde
- **Beschreibung:** Targetiert nächsten Feind

### TargetNearestFriend([reverse])
- **Parameter:** `reverse` (boolean): Optional, für fernere Freunde
- **Beschreibung:** Targetiert nächsten Freund

### TargetUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Beschreibung:** Targetiert Unit

### GetRaidTargetIndex(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `index` (number): 1-8 (Marker-Index) oder nil

### SetRaidTarget(unit, index)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `index` (number): 1-8 (1=Star, 8=Skull)
- **Beschreibung:** Setzt Raid-Marker

---

## Group/Raid

### GetNumPartyMembers()
- **Rückgabe:** `count` (number): Anzahl Party-Mitglieder (ohne sich selbst)

### GetNumRaidMembers()
- **Rückgabe:** `count` (number): Anzahl Raid-Mitglieder (mit sich selbst)

### GetPartyLeaderIndex()
- **Rückgabe:** `index` (number): Party-Leader-Index oder 0

### GetRaidRosterInfo(index)
- **Parameter:** `index` (number): 1-40
- **Rückgabe:** `name`, `rank`, `subgroup`, `level`, `class`, `fileName`, `zone`, `online`, `isDead`, `role`, `isML`

### InCombatLockdown()
- **Rückgabe:** `inCombat` (boolean)

### IsInGroup()
- **Rückgabe:** `inGroup` (boolean)

### IsInRaid()
- **Rückgabe:** `inRaid` (boolean)

### IsRaidLeader()
- **Rückgabe:** `isLeader` (boolean)

### IsRaidOfficer()
- **Rückgabe:** `isOfficer` (boolean)

### UninviteUnit(name)
- **Parameter:** `name` (string): Spieler-Name
- **Beschreibung:** Kickt Spieler aus Gruppe

### PromoteToLeader(unit)
- **Parameter:** `unit` (string): Unit-Token oder Name
- **Beschreibung:** Promoted Spieler zum Leader

---

## Chat/Communication

### SendChatMessage(msg, [chatType], [language], [channel])
- **Parameter:**
  - `msg` (string): Nachricht
  - `chatType` (string): "SAY", "YELL", "PARTY", "RAID", "GUILD", "WHISPER", "CHANNEL"
  - `language` (string): Optional, Sprache
  - `channel` (string): Optional, für WHISPER/CHANNEL
- **Beschreibung:** Sendet Chat-Nachricht

### ChatFrameGetChannelInfo(channelNumber)
- **Parameter:** `channelNumber` (number): Channel-Nummer
- **Rückgabe:** `name`, `header`, `collapsed`, `channelNumber`, `count`, `active`, `category`

### GetChannelName(channel)
- **Parameter:** `channel` (string): Channel-Name
- **Rückgabe:** `id`, `name`

### JoinChannelByName(channel, [password])
- **Parameter:**
  - `channel` (string): Channel-Name
  - `password` (string): Optional
- **Rückgabe:** `type`, `name`

### LeaveChannelByName(channel)
- **Parameter:** `channel` (string): Channel-Name
- **Beschreibung:** Verlässt Channel

---

## Map/Location

### GetPlayerMapPosition(unit)
- **Parameter:** `unit` (string): "player" oder "party1"-"party4"
- **Rückgabe:** `x`, `y` (0-1 Koordinaten auf aktueller Karte)

### GetRealZoneText()
- **Rückgabe:** `zone` (string): Aktueller Zonen-Name

### GetSubZoneText()
- **Rückgabe:** `subzone` (string): Aktueller SubZonen-Name

### GetZoneText()
- **Rückgabe:** `zone` (string): Zonen-Name

### SetMapToCurrentZone()
- **Beschreibung:** Setzt Weltkarte auf aktuelle Zone

---

## Quest

### GetNumQuestLogEntries()
- **Rückgabe:** `numEntries`, `numQuests`

### GetQuestLogTitle(index)
- **Parameter:** `index` (number): Quest-Log-Index
- **Rückgabe:** `title`, `level`, `tag`, `isHeader`, `isCollapsed`, `isComplete`

### SelectQuestLogEntry(index)
- **Parameter:** `index` (number): Quest-Log-Index
- **Beschreibung:** Wählt Quest im Log

### IsQuestCompletable()
- **Rückgabe:** `completable` (boolean)

### IsQuestWatched(index)
- **Parameter:** `index` (number): Quest-Log-Index
- **Rückgabe:** `watched` (boolean)

### AddQuestWatch(index)
- **Parameter:** `index` (number): Quest-Log-Index
- **Beschreibung:** Fügt Quest zum Tracker hinzu

### RemoveQuestWatch(index)
- **Parameter:** `index` (number): Quest-Log-Index
- **Beschreibung:** Entfernt Quest vom Tracker

---

## Pet

### PetAttack()
- **Beschreibung:** Pet greift an

### PetFollow()
- **Beschreibung:** Pet folgt

### PetStopAttack()
- **Beschreibung:** Pet stoppt Angriff

### PetWait()
- **Beschreibung:** Pet wartet

### GetPetActionCooldown(index)
- **Parameter:** `index` (number): Pet-Action-Bar-Slot
- **Rückgabe:** `start`, `duration`, `enabled`

### GetPetActionInfo(index)
- **Parameter:** `index` (number): Pet-Action-Bar-Slot
- **Rückgabe:** `name`, `texture`, `isToken`, `isActive`, `autoCastAllowed`, `autoCastEnabled`

### GetPetExperience()
- **Rückgabe:** `currXP`, `nextLevelXP`

### GetPetFoodTypes()
- **Rückgabe:** List of food types pet can eat

### GetPetHappiness()
- **Rückgabe:** `happiness`, `damagePercentage`, `loyaltyRate`

### GetPetTimeRemaining()
- **Rückgabe:** `timeRemaining` (number): Millisekunden bis Despawn

### HasPetUI()
- **Rückgabe:** `hasPet` (boolean)

---

## Macro

### GetNumMacros()
- **Rückgabe:** `numAccountMacros`, `numCharMacros`

### GetMacroInfo(index)
- **Parameter:** `index` (number): Makro-Index
- **Rückgabe:** `name`, `iconTexture`, `body`, `isLocal`

### GetMacroIndexByName(name)
- **Parameter:** `name` (string): Makro-Name
- **Rückgabe:** `index` (number): Makro-Index oder 0

### GetMacroName(index)
- **Parameter:** `index` (number): Makro-Index
- **Rückgabe:** `name` (string)

### EditMacro(index, name, iconTexture, body, [isLocal])
- **Parameter:**
  - `index` (number): Makro-Index
  - `name` (string): Neuer Name
  - `iconTexture` (string): Icon-Pfad
  - `body` (string): Makro-Text
  - `isLocal` (boolean): Optional, Charakter-spezifisch
- **Beschreibung:** Bearbeitet Makro

### CreateMacro(name, iconTexture, body, [isLocal])
- **Parameter:**
  - `name` (string): Makro-Name
  - `iconTexture` (string): Icon-Pfad
  - `body` (string): Makro-Text
  - `isLocal` (boolean): Optional, für Charakter-Makro
- **Rückgabe:** `index` (number): Index des neuen Makros

### DeleteMacro(index)
- **Parameter:** `index` (number): Makro-Index
- **Beschreibung:** Löscht Makro

---

## Frame/UI

### GetTime()
- **Rückgabe:** `time` (number): Zeit seit Start in Sekunden

### GetFramerate()
- **Rückgabe:** `fps` (number): Aktuelle FPS

### GetNetStats()
- **Rückgabe:** `down`, `up`, `lagHome`, `lagWorld`

### IsShiftKeyDown()
- **Rückgabe:** `isDown` (boolean)

### IsControlKeyDown()
- **Rückgabe:** `isDown` (boolean)

### IsAltKeyDown()
- **Rückgabe:** `isDown` (boolean)

### Screenshot()
- **Beschreibung:** Macht Screenshot

### UIErrorsFrame:AddMessage(text)
- **Parameter:** `text` (string): Fehler-Text
- **Beschreibung:** Zeigt UI-Error-Message

### DEFAULT_CHAT_FRAME:AddMessage(text, [r], [g], [b])
- **Parameter:**
  - `text` (string): Nachricht
  - `r`, `g`, `b` (number): Optional, RGB-Farben 0-1
- **Beschreibung:** Zeigt Nachricht im Chat

---

## Wichtige Unit-Tokens

- `player` - Der Spieler selbst
- `target` - Aktuelles Target
- `mouseover` - Unit unter der Maus
- `pet` - Pet des Spielers
- `targettarget` - Target des Targets
- `party1` bis `party4` - Party-Mitglieder
- `raid1` bis `raid40` - Raid-Mitglieder
- `playertarget` - Target des Spielers (gleich wie target)
- `pettarget` - Target des Pets
- `focus` - Focus-Target (wenn gesetzt)

## Equipment Slots

- 0 = Ammo
- 1 = Head
- 2 = Neck
- 3 = Shoulder
- 4 = Shirt
- 5 = Chest
- 6 = Waist
- 7 = Legs
- 8 = Feet
- 9 = Wrist
- 10 = Hands
- 11 = Finger1
- 12 = Finger2
- 13 = Trinket1
- 14 = Trinket2
- 15 = Back
- 16 = MainHand
- 17 = OffHand
- 18 = Ranged
- 19 = Tabard

## Item Quality

- 0 = Poor (Grey)
- 1 = Common (White)
- 2 = Uncommon (Green)
- 3 = Rare (Blue)
- 4 = Epic (Purple)
- 5 = Legendary (Orange)
- 6 = Artifact (Gold)

## Power Types

- 0 = Mana
- 1 = Rage
- 2 = Focus (Hunter Pet)
- 3 = Energy
- 4 = Happiness (Hunter Pet)

---

## Type Definitions für IDE

Für Autocomplete in der IDE kann das Repository geklont werden:
```bash
git clone https://github.com/SabineWren/wow-api-type-definitions.git
```

Dann in `.luarc.json` einbinden:
```json
{
   "workspace.library": ["wow-api-type-definitions"]
}
```

---

## Weitere Ressourcen

- **Repository:** https://github.com/SabineWren/wow-api-type-definitions
- **WoWpedia (2006):** https://wowpedia.fandom.com/wiki/World_of_Warcraft_API?oldid=293146
- **Shagu Vanilla API:** https://github.com/shagu/wow-vanilla-api
