# Nampower API Dokumentation

## Übersicht
Nampower ist eine DLL-Erweiterung für WoW 1.12.1, die Spell-Queuing, automatische Wiederholungen und viele neue Lua-Funktionen hinzufügt.

**Version:** 2.29.0  
**Repository:** https://gitea.com/avitasia/nampower

---

## Performance-Hinweis: Wiederverwendbare Table-Referenzen

⚠️ **WICHTIG:** Viele Nampower-Funktionen verwenden wiederverwendbare Table-Referenzen für Performance. Die gleiche Table wird bei jedem Aufruf mit neuen Daten überschrieben!

### Betroffene Funktionen:
- `GetCastInfo()`, `GetEquippedItems()`, `GetBagItems()`, `GetBagItem()`, `GetEquippedItem()`
- `GetSpellIdCooldown()`, `GetItemIdCooldown()`, `GetTrinkets()`
- `GetItemStats()`, `GetUnitData()`, `GetSpellRec()` (+ Field-Varianten)

### Sichere Verwendung:
```lua
-- ✓ SICHER - Werte sofort extrahieren
local castInfo = GetCastInfo()
if castInfo then
    local spellId = castInfo.spellId
    local remaining = castInfo.castRemainingMs
    -- spellId und remaining später verwenden
end

-- ✗ UNSICHER - Table-Referenz speichern
local cast1 = GetCastInfo()
-- später...
local cast2 = GetCastInfo() 
-- cast1 und cast2 zeigen auf die GLEICHE Table!

-- ✓ SICHER - Copy-Parameter verwenden
local itemStats = GetItemStats(19019, 1)  -- 1 = unabhängige Kopie
-- Jetzt sicher zu speichern!
```

---

## Spell/Item/Unit Information

### GetItemStats(itemId, [copy])
- **Parameter:**
  - `itemId` (number): Item-ID
  - `copy` (number): Optional, `1` für unabhängige Kopie
- **Rückgabe:** Table mit allen ItemStats-Feldern oder nil
- **Felder:** `displayName`, `description`, `itemLevel`, `quality`, `delay`, `bonusStat`, `bonusAmount`, etc.
- **Beschreibung:** Gibt vollständige Item-Statistiken zurück
- **Beispiel:**
  ```lua
  local stats = GetItemStats(19019) -- Thunderfury
  if stats then
      print(stats.displayName)
      print("Item Level: " .. stats.itemLevel)
  end
  ```
- **Feldliste:** Siehe DBC_FIELDS.md im Repository

### GetItemStatsField(itemId, fieldName, [copy])
- **Parameter:**
  - `itemId` (number): Item-ID
  - `fieldName` (string): Feldname
  - `copy` (number): Optional, `1` für Kopie bei Array-Feldern
- **Rückgabe:** Feldwert oder nil
- **Beschreibung:** Schneller Zugriff auf einzelnes Item-Feld
- **Beispiel:**
  ```lua
  local name = GetItemStatsField(19019, "displayName")
  local ilvl = GetItemStatsField(22589, "itemLevel")
  local quality = GetItemStatsField(19019, "quality") -- 5 = Legendary
  local delay = GetItemStatsField(19019, "delay") -- Weapon speed in ms
  ```

### FindPlayerItemSlot(itemIdOrName)
- **Parameter:** `itemIdOrName` (number|string): Item-ID oder Name
- **Rückgabe:**
  - `bagIndex` (number|nil): Bag-Index oder nil wenn equipped
    - `nil` = Equipped (slot in 2. Wert)
    - `0` = Inventory Pack
    - `1-4` = Regular Bags
    - `-1` = Bank
    - `5-10` = Bank Bags
    - `-2` = Keyring
  - `slotIndex` (number): Slot-Nummer (1-indexed)
- **Beschreibung:** Findet Item im Inventar des Spielers
- **Beispiel:**
  ```lua
  local bag, slot = FindPlayerItemSlot(19019)
  if bag == nil and slot then
      print("Item equipped in slot " .. slot)
  elseif bag then
      print("Found in bag " .. bag .. " slot " .. slot)
  end
  ```

### UseItemIdOrName(itemIdOrName, [target])
- **Parameter:**
  - `itemIdOrName` (number|string): Item-ID oder Name
  - `target` (string|number): Optional, Unit-Token oder GUID
- **Rückgabe:** `1` bei Erfolg, `0` bei Fehler
- **Beschreibung:** Benutzt erstes gefundenes Item im Inventar
- **Beispiel:**
  ```lua
  UseItemIdOrName("Hearthstone")
  UseItemIdOrName(13446, "player") -- Health Potion auf sich selbst
  ```

### GetEquippedItems(unitToken)
- **Parameter:** `unitToken` (string): Unit-Token oder GUID
- **Rückgabe:** Table mit Equipment-Slots (0-18) als Keys
- **Item-Felder (Spieler):** `itemId`, `stackCount`, `duration`, `spellCharges`, `flags`, `permanentEnchantId`, `tempEnchantId`, `tempEnchantmentTimeLeftMs`, `tempEnchantmentCharges`, `durability`, `maxDurability`
- **Item-Felder (Andere):** `itemId`, `permanentEnchantId`, `tempEnchantId`
- **Beschreibung:** Gibt alle equipped Items einer Unit zurück
- **Beispiel:**
  ```lua
  local items = GetEquippedItems("target")
  if items and items[15] then -- Slot 15 = main hand
      print("Main hand: " .. items[15].itemId)
  end
  ```

### GetEquippedItem(unitToken, slot)
- **Parameter:**
  - `unitToken` (string): Unit-Token oder GUID
  - `slot` (number): Equipment-Slot (0-18)
    - 1=Head, 2=Neck, 3=Shoulder, 4=Shirt, 5=Chest
    - 6=Waist, 7=Legs, 8=Feet, 9=Wrist, 10=Hands
    - 11=Finger1, 12=Finger2, 13=Trinket1, 14=Trinket2
    - 15=Back, 16=MainHand, 17=OffHand, 18=Ranged, 19=Tabard
- **Rückgabe:** Item-Info-Table oder nil
- **Beschreibung:** Gibt Info für spezifischen Equipment-Slot
- **Beispiel:**
  ```lua
  local weapon = GetEquippedItem("target", 16)
  if weapon then
      print("Weapon ID: " .. weapon.itemId)
  end
  ```

### GetBagItems([bagIndex])
- **Parameter:** `bagIndex` (number): Optional, spezifischer Bag
- **Rückgabe:** Table mit Bag-Contents
- **Bag-Indices:** 0, 1-4, -1, 5-10, -2
- **Beschreibung:** Gibt Items in Bags zurück
- **Beispiel:**
  ```lua
  local allItems = GetBagItems()
  for bagIndex, bagContents in pairs(allItems) do
      for slot, itemInfo in pairs(bagContents) do
          print("Bag " .. bagIndex .. " Slot " .. slot .. ": " .. itemInfo.itemId)
      end
  end
  ```

### GetBagItem(bagIndex, slot)
- **Parameter:**
  - `bagIndex` (number): Bag-Index
  - `slot` (number): Slot-Nummer (1-indexed)
- **Rückgabe:** Item-Info-Table oder nil
- **Beschreibung:** Gibt Item in spezifischem Bag-Slot zurück
- **Beispiel:**
  ```lua
  local item = GetBagItem(1, 1)
  if item then
      print("Item: " .. item.itemId .. " x" .. item.stackCount)
  end
  ```

### GetAmmo()
- **Rückgabe:**
  - `ammoId` (number): Munitions-Item-ID
  - `count` (number): Gesamtanzahl in Backpack + Bags 1-4
- **Beschreibung:** Gibt equipped Munition und Anzahl zurück
- **Beispiel:**
  ```lua
  local ammoId, count = GetAmmo()
  if ammoId then
      print("Ammo ID: " .. ammoId .. " Count: " .. count)
      if count < 200 then
          print("Low ammo!")
      end
  end
  ```

### GetSpellRec(spellId, [copy])
- **Parameter:**
  - `spellId` (number): Spell-ID
  - `copy` (number): Optional, `1` für Kopie
- **Rückgabe:** Table mit SpellRec-Feldern oder nil
- **Felder:** `name`, `rank`, `castTime`, `manaCost`, `school`, `rangeMax`, `spellIconID`, etc.
- **Beschreibung:** Gibt vollständige Spell-Record-Daten zurück
- **Feldliste:** Siehe DBC_FIELDS.md im Repository

### GetSpellRecField(spellId, fieldName, [copy])
- **Parameter:**
  - `spellId` (number): Spell-ID
  - `fieldName` (string): Feldname
  - `copy` (number): Optional, `1` für Kopie bei Arrays
- **Rückgabe:** Feldwert oder nil
- **Beschreibung:** Schneller Zugriff auf einzelnes Spell-Feld
- **Beispiel:**
  ```lua
  local name = GetSpellRecField(116, "name") -- "Frostbolt"
  local rank = GetSpellRecField(116, "rank") -- "Rank 1"
  local castTime = GetSpellRecField(133, "castTime") -- in ms
  local school = GetSpellRecField(116, "school") -- 4 = Frost
  ```

### GetSpellModifiers(spellId, modifierType)
- **Parameter:**
  - `spellId` (number): Spell-ID
  - `modifierType` (number): Modifier-Typ
- **Rückgabe:**
  - `flatMod` (number): Flacher Bonus (z.B. +50 Schaden)
  - `percentMod` (number): Prozent-Bonus (z.B. 10 für +10%)
  - `ret` (number): Ob Modifier vorhanden
- **Modifier-Typen:**
  - 0=DAMAGE, 1=DURATION, 2=THREAT, 3=ATTACK_POWER, 4=CHARGES, 5=RANGE
  - 6=RADIUS, 7=CRITICAL_CHANCE, 10=CASTING_TIME, 11=COOLDOWN, 14=COST
  - 15=CRIT_DAMAGE_BONUS, 23=HASTE, 24=SPELL_BONUS_DAMAGE
- **Beschreibung:** Gibt aktuelle Spell-Modifier zurück
- **Beispiel:**
  ```lua
  local flat, percent = GetSpellModifiers(116, 0) -- Frostbolt damage
  print("Flat bonus: " .. flat)
  print("Percent bonus: " .. percent .. "%")
  ```

### GetUnitData(unitToken, [copy])
- **Parameter:**
  - `unitToken` (string): Unit-Token oder GUID
  - `copy` (number): Optional, `1` für Kopie
- **Rückgabe:** Table mit allen Unit-Feldern oder nil
- **Felder:** `health`, `maxHealth`, `level`, `displayId`, `power1`, `aura`, `resistances`, etc.
- **Beschreibung:** Gibt Low-Level Unit-Daten zurück
- **Feldliste:** Siehe UNIT_FIELDS.md im Repository
- **Beispiel:**
  ```lua
  local data = GetUnitData("target")
  if data then
      print("Health: " .. data.health .. "/" .. data.maxHealth)
      print("Level: " .. data.level)
  end
  ```

### GetUnitField(unitToken, fieldName, [copy])
- **Parameter:**
  - `unitToken` (string): Unit-Token oder GUID
  - `fieldName` (string): Feldname
  - `copy` (number): Optional, `1` für Kopie bei Arrays
- **Rückgabe:** Feldwert, Table bei Arrays, oder nil
- **Beschreibung:** Schneller Zugriff auf einzelnes Unit-Feld
- **Beispiel:**
  ```lua
  local health = GetUnitField("target", "health")
  local mana = GetUnitField("player", "power1")
  local auras = GetUnitField("target", "aura") -- returns table
  ```

---

## Spell Casting & Queuing

### QueueSpellByName(spellName)
- **Parameter:** `spellName` (string): Spell-Name
- **Beschreibung:** Erzwingt Spell-Queue unabhängig vom Queue-Fenster. Nur 1 GCD-Spell und 5 Non-GCD-Spells können gequeued werden
- **Beispiel:**
  ```lua
  /run QueueSpellByName("Frostbolt");QueueSpellByName("Frostbolt")
  -- Castet 2 Frostbolts hintereinander
  ```

### CastSpellByNameNoQueue(spellName)
- **Parameter:** `spellName` (string): Spell-Name
- **Beschreibung:** Erzwingt Cast ohne Queue, auch wenn Einstellungen Queue aktivieren würden
- **Verwendung:** Für Addon-Kompatibilität

### QueueScript(script, [priority])
- **Parameter:**
  - `script` (string): Lua-Script als String
  - `priority` (number): Optional, 1-3 (Default: 1)
- **Priority:**
  - 1 = Vor allen gequeuten Spells
  - 2 = Nach Non-GCD Spells, vor normalen Spells
  - 3 = Nach allen gequeuten Spells
- **Beschreibung:** Queued beliebigen Script mit Spell-Queue-Logik
- **Beispiel:**
  ```lua
  /run QueueScript('SlashCmdList.EQUIP("Libram of +heal")')
  ```

### IsSpellInRange(spellNameOrId, [target])
- **Parameter:**
  - `spellNameOrId` (string|number): Spell-Name oder ID
  - `target` (string): Optional, Unit-Token oder GUID
- **Rückgabe:**
  - `1` = In Range
  - `0` = Out of Range
  - `-1` = Spell nicht für Range-Check geeignet
- **Beschreibung:** Prüft ob Spell in Reichweite ist
- **Beispiel:**
  ```lua
  local inRange = IsSpellInRange("Frostbolt")
  if inRange == 1 then
      print("In range")
  end
  ```

### IsSpellUsable(spellNameOrId)
- **Parameter:** `spellNameOrId` (string|number): Spell-Name oder ID
- **Rückgabe:**
  - `usable` (number): 1 wenn benutzbar, 0 wenn nicht
  - `noMana` (number): 1 bei Mana-Mangel, 0 sonst
- **Beschreibung:** Prüft ob Spell benutzbar ist (z.B. Reactive-Spells)
- **Hinweis:** Usable ≠ Castable
- **Beispiel:**
  ```lua
  local usable, noMana = IsSpellUsable("Frostbolt")
  if usable == 1 then
      print("Spell usable")
  end
  ```

### ChannelStopCastingNextTick()
- **Beschreibung:** Stoppt Channeling beim nächsten Tick wenn Queue-Channeling aktiviert ist

---

## Cast Information

### GetCurrentCastingInfo()
- **Rückgabe:**
  - `castingSpellId` (number): Casting Spell-ID oder 0
  - `visualSpellId` (number): Visual Spell-ID oder 0
  - `autoRepeatSpellId` (number): Auto-Repeat Spell-ID oder 0
  - `isCasting` (number): 1 wenn Cast-Time-Spell, 0 sonst
  - `isChanneling` (number): 1 wenn Channeling, 0 sonst
  - `isOnSwingPending` (number): 1 wenn On-Swing pending, 0 sonst
  - `isAutoAttacking` (number): 1 wenn Auto-Attack, 0 sonst
- **Beschreibung:** Gibt grundlegende Cast-Informationen zurück
- **Hinweis:** Veraltet, GetCastInfo() ist besser

### GetCastInfo()
- **Rückgabe:** Table oder nil wenn kein Cast aktiv
- **Felder:**
  - `castId` (number): Eindeutige Cast-ID
  - `spellId` (number): Spell-ID
  - `guid` (number): Target-GUID (0 wenn kein Ziel)
  - `castType` (number): 0=NORMAL, 3=CHANNEL, 4=TARGETING
  - `castStartS` (number): Start-Zeit in WoW-Zeit (Sekunden)
  - `castEndS` (number): End-Zeit in WoW-Zeit (Sekunden)
  - `castRemainingMs` (number): Verbleibende Zeit in Millisekunden
  - `castDurationMs` (number): Gesamt-Dauer in Millisekunden
  - `gcdEndS` (number): GCD-End-Zeit in Sekunden
  - `gcdRemainingMs` (number): Verbleibende GCD in Millisekunden
- **Beschreibung:** Detaillierte Cast-Informationen
- **Beispiel:**
  ```lua
  local info = GetCastInfo()
  if info then
      print("Casting: " .. info.spellId)
      print("Remaining: " .. info.castRemainingMs .. "ms")
      print("GCD remaining: " .. info.gcdRemainingMs .. "ms")
  end
  ```

---

## Cooldown Information

### GetSpellIdCooldown(spellId)
- **Parameter:** `spellId` (number): Spell-ID
- **Rückgabe:** Table mit Cooldown-Details
- **Felder:**
  - `isOnCooldown` (number): 1 wenn auf CD, 0 sonst
  - `cooldownRemainingMs` (number): Maximale verbleibende CD in ms
  - `itemId` (number): Item-ID (0 wenn keins)
  - `itemHasActiveSpell` (number): 1 wenn Item aktiven Spell hat
  - `itemActiveSpellId` (number): Spell-ID des Item-Spells
  - **Individual CD:** `individualStartS`, `individualDurationMs`, `individualRemainingMs`, `isOnIndividualCooldown`
  - **Category CD:** `categoryId`, `categoryStartS`, `categoryDurationMs`, `categoryRemainingMs`, `isOnCategoryCooldown`
  - **GCD:** `gcdCategoryId`, `gcdCategoryStartS`, `gcdCategoryDurationMs`, `gcdCategoryRemainingMs`, `isOnGcdCategoryCooldown`
- **Beschreibung:** Detaillierte Cooldown-Info für Spell
- **Beispiel:**
  ```lua
  local cd = GetSpellIdCooldown(116) -- Frostbolt
  if cd.isOnCooldown == 0 then
      print("Ready!")
  else
      print("CD: " .. cd.cooldownRemainingMs .. "ms")
  end
  ```

### GetItemIdCooldown(itemId)
- **Parameter:** `itemId` (number): Item-ID
- **Rückgabe:** Table mit Cooldown-Details (wie GetSpellIdCooldown)
- **Beschreibung:** Cooldown-Info für Item
- **Beispiel:**
  ```lua
  local cd = GetItemIdCooldown(12345)
  if cd.isOnCooldown == 0 then
      print("Trinket ready!")
  end
  ```

### GetTrinkets([copy])
- **Parameter:** `copy` (number): Optional, `1` für Kopie
- **Rückgabe:** Table mit Trinket-Liste
- **Entry-Felder:**
  - `itemId` (number): Item-ID
  - `trinketName` (string): Name ("Unknown" wenn nicht verfügbar)
  - `texture` (string): Icon-Textur
  - `itemLevel` (number): Item-Level
  - `bagIndex` (number|nil): nil wenn equipped, sonst 0-4
  - `slotIndex` (number): 1-indexed Slot (1/2 für equipped)
- **Beschreibung:** Gibt equipped und Bag-Trinkets zurück
- **Beispiel:**
  ```lua
  local trinkets = GetTrinkets()
  for _, trinket in ipairs(trinkets) do
      print(trinket.trinketName .. " ilvl " .. trinket.itemLevel)
  end
  ```

### GetTrinketCooldown(slotOrItemIdOrName)
- **Parameter:** `slotOrItemIdOrName` (number|string)
  - `1` oder `13` = Erster Trinket-Slot
  - `2` oder `14` = Zweiter Trinket-Slot
  - Andere number = Item-ID
  - String = Item-Name
- **Rückgabe:** Cooldown-Table oder `-1` wenn nicht gefunden
- **Beschreibung:** Cooldown-Info für equipped Trinket
- **Beispiel:**
  ```lua
  local cd = GetTrinketCooldown(1)
  if cd ~= -1 and cd.isOnCooldown == 0 then
      print("Trinket ready!")
  end
  ```

### UseTrinket(slotOrItemIdOrName, [target])
- **Parameter:**
  - `slotOrItemIdOrName` (number|string): Wie GetTrinketCooldown
  - `target` (string|number): Optional, Unit-Token oder GUID
- **Rückgabe:**
  - `1` = Erfolg
  - `0` = Gefunden aber Use fehlgeschlagen
  - `-1` = Nicht gefunden
- **Beschreibung:** Benutzt equipped Trinket
- **Beispiel:**
  ```lua
  UseTrinket(1) -- Ersten Trinket-Slot
  UseTrinket("Royal Seal of Eldre'Thalas", "target")
  ```

---

## Spell/Item Lookups

### GetSpellIdForName(spellName)
- **Parameter:** `spellName` (string): Spell-Name
- **Rückgabe:** `spellId` (number): Max-Rang Spell-ID oder 0
- **Beschreibung:** Gibt Spell-ID für Namen zurück (nur Spellbook)
- **Beispiel:**
  ```lua
  local id = GetSpellIdForName("Frostbolt")
  local id2 = GetSpellIdForName("Frostbolt(Rank 1)")
  ```

### GetSpellNameAndRankForId(spellId)
- **Parameter:** `spellId` (number): Spell-ID
- **Rückgabe:**
  - `name` (string): Spell-Name
  - `rank` (string): Rang (z.B. "Rank 1")
- **Beschreibung:** Gibt Namen und Rang für Spell-ID zurück
- **Beispiel:**
  ```lua
  local name, rank = GetSpellNameAndRankForId(116)
  -- "Frostbolt", "Rank 1"
  ```

### GetSpellSlotTypeIdForName(spellName)
- **Parameter:** `spellName` (string): Spell-Name
- **Rückgabe:**
  - `slot` (number): 1-indexed Spellbook-Slot oder 0
  - `bookType` (string): "spell", "pet" oder "unknown"
  - `spellId` (number): Spell-ID oder 0
- **Beschreibung:** Gibt Spellbook-Position für Spell zurück
- **Beispiel:**
  ```lua
  local slot, bookType, spellId = GetSpellSlotTypeIdForName("Frostbolt")
  ```

### GetNampowerVersion()
- **Rückgabe:**
  - `major` (number): Major-Version
  - `minor` (number): Minor-Version
  - `patch` (number): Patch-Version
- **Beschreibung:** Gibt Nampower-Version zurück
- **Beispiel:**
  ```lua
  local major, minor, patch = GetNampowerVersion()
  -- z.B. 2, 29, 0 für v2.29.0
  ```

### GetItemLevel(itemId)
- **Parameter:** `itemId` (number): Item-ID
- **Rückgabe:** `itemLevel` (number): Item-Level
- **Beschreibung:** Gibt Item-Level zurück
- **Beispiel:**
  ```lua
  local ilvl = GetItemLevel(22589) -- 90 for Atiesh
  ```

### GetItemIconTexture(displayInfoId)
- **Parameter:** `displayInfoId` (number): Display-Info-ID
- **Rückgabe:** `texture` (string): Textur-Pfad oder nil
- **Beschreibung:** Gibt Icon-Textur für Item zurück
- **Beispiel:**
  ```lua
  local displayId = GetItemStatsField(19019, "displayInfoID")
  local texture = GetItemIconTexture(displayId)
  ```

### GetSpellIconTexture(spellIconId)
- **Parameter:** `spellIconId` (number): Spell-Icon-ID
- **Rückgabe:** `texture` (string): Textur-Pfad oder nil
- **Beschreibung:** Gibt Icon-Textur für Spell zurück
- **Beispiel:**
  ```lua
  local iconId = GetSpellRecField(116, "spellIconID")
  local texture = GetSpellIconTexture(iconId)
  ```

---

## Utility Functions

### DisenchantAll(itemIdOrNameOrQuality, [includeSoulbound])
- **Parameter:**
  - `itemIdOrNameOrQuality` (number|string):
    - Number = Item-ID
    - String (Item) = Item-Name
    - String (Quality) = "greens", "blues", "purples", "greens|blues", etc.
  - `includeSoulbound` (number): Optional, `1` um Soulbound einzuschließen
- **Rückgabe:** `1` bei Erfolg, `0` bei Fehler
- **Beschreibung:** Disenchanted automatisch Items im Inventar
- **⚠️ WARNUNG:** Disenchanted ohne Bestätigung! Nur Backpack + Bags 1-4!
- **Beispiel:**
  ```lua
  DisenchantAll("greens") -- Alle grünen Items (außer Soulbound)
  DisenchantAll("blues", 1) -- Alle blauen Items inkl. Soulbound
  DisenchantAll(12345) -- Spezifische Item-ID
  DisenchantAll("Glowing Brightwood Staff", 1)
  ```

---

## Custom Events

### SPELL_QUEUE_EVENT
Feuert wenn Spells gequeued oder dequeued werden
- **Parameter:**
  - `eventCode` (number): Event-Code
  - `spellId` (number): Spell-ID
- **Event-Codes:**
  - 0 = ON_SWING_QUEUED
  - 1 = ON_SWING_QUEUE_POPPED
  - 2 = NORMAL_QUEUED
  - 3 = NORMAL_QUEUE_POPPED
  - 4 = NON_GCD_QUEUED
  - 5 = NON_GCD_QUEUE_POPPED
- **Beispiel:**
  ```lua
  frame:RegisterEvent("SPELL_QUEUE_EVENT", function(eventCode, spellId)
      if eventCode == 2 then
          print("Spell queued: " .. spellId)
      end
  end)
  ```

### SPELL_CAST_EVENT
Feuert wenn Spieler Spell castet (Client-seitig, vor Server-Send)
- **Parameter:**
  - `success` (number): 1 bei Erfolg, 0 bei Fehler
  - `spellId` (number): Spell-ID
  - `castType` (number): Cast-Typ (1=NORMAL, 2=NON_GCD, 3=ON_SWING, 4=CHANNEL, 5=TARGETING, 6=TARGETING_NON_GCD)
  - `targetGuid` (string): Target-GUID oder "0x000000000"
  - `itemId` (number): Item-ID oder 0

### SPELL_START_SELF / SPELL_START_OTHER
Feuert bei Spell-Start-Packet vom Server
- **CVar:** `NP_EnableSpellStartEvents` (Default: 0)
- **Parameter:**
  - `itemId` (number): Item-ID oder 0
  - `spellId` (number): Spell-ID
  - `casterGuid` (string): Caster-GUID
  - `targetGuid` (string): Target-GUID
  - `castFlags` (number): Cast-Flags (Bitmask)
  - `castTime` (number): Cast-Zeit in Millisekunden

### SPELL_GO_SELF / SPELL_GO_OTHER
Feuert wenn Spell-Cast beendet ist (Server)
- **CVar:** `NP_EnableSpellGoEvents` (Default: 0)
- **Parameter:**
  - `itemId` (number): Item-ID oder 0
  - `spellId` (number): Spell-ID
  - `casterGuid` (string): Caster-GUID
  - `targetGuid` (string): Target-GUID
  - `castFlags` (number): Cast-Flags
  - `numTargetsHit` (number): Anzahl getroffener Ziele
  - `numTargetsMissed` (number): Anzahl verfehlter Ziele

### SPELL_FAILED_SELF / SPELL_FAILED_OTHER
Feuert bei Spell-Fehler
- **Parameter (SELF):**
  - `spellId` (number): Spell-ID
  - `spellResult` (number): SpellCastResult enum
  - `failedByServer` (number): 1 wenn Server-Fehler
- **Parameter (OTHER):**
  - `casterGuid` (string): Caster-GUID
  - `spellId` (number): Spell-ID

### SPELL_DELAYED_SELF / SPELL_DELAYED_OTHER
Feuert wenn Spell verzögert wird (z.B. durch Schaden)
- **Parameter:**
  - `casterGuid` (string): Caster-GUID
  - `delayMs` (number): Verzögerung in Millisekunden
- **Hinweis:** OTHER funktioniert aktuell nicht (Server-Limitation)

### SPELL_CHANNEL_START / SPELL_CHANNEL_UPDATE
Feuert bei Channel-Start/-Update (nur für eigenen Spieler)
- **Parameter (START):**
  - `spellId` (number): Spell-ID
  - `targetGuid` (string): Target-GUID
  - `durationMs` (number): Channel-Dauer in Millisekunden
- **Parameter (UPDATE):**
  - `spellId` (number): Spell-ID
  - `targetGuid` (string): Target-GUID
  - `remainingMs` (number): Verbleibende Zeit in Millisekunden

### SPELL_DAMAGE_EVENT_SELF / SPELL_DAMAGE_EVENT_OTHER
Feuert bei Spell-Schaden
- **Parameter:**
  - `targetGuid` (string): Ziel-GUID
  - `casterGuid` (string): Caster-GUID
  - `spellId` (number): Spell-ID
  - `amount` (number): Schaden
  - `mitigationStr` (string): "absorb,block,resist" (komma-separiert)
  - `hitInfo` (number): Hit-Info-Flags (2 = Crit)
  - `spellSchool` (number): Schaden-Schule
  - `effectAuraStr` (string): "effect1,effect2,effect3,auraType"

### BUFF_ADDED_SELF / BUFF_REMOVED_SELF / etc.
Feuert bei Buff/Debuff-Änderungen
- **Events:**
  - BUFF_ADDED_SELF, BUFF_REMOVED_SELF
  - BUFF_ADDED_OTHER, BUFF_REMOVED_OTHER
  - DEBUFF_ADDED_SELF, DEBUFF_REMOVED_SELF
  - DEBUFF_ADDED_OTHER, DEBUFF_REMOVED_OTHER
- **Parameter:**
  - `guid` (string): Unit-GUID
  - `slot` (number): 1-indexed Buff/Debuff-Slot
  - `spellId` (number): Spell-ID
  - `stackCount` (number): Stack-Anzahl (0 wenn entfernt)
  - `auraLevel` (number): Caster-Level

### AURA_CAST_ON_SELF / AURA_CAST_ON_OTHER
Feuert wenn Spell Aura anwendet
- **CVar:** `NP_EnableAuraCastEvents` (Default: 0)
- **Parameter:**
  - `spellId` (number): Spell-ID
  - `casterGuid` (string): Caster-GUID
  - `targetGuid` (string): Target-GUID
  - `effect` (number): Effect-ID
  - `effectAuraName` (number): EffectApplyAuraName
  - `effectAmplitude` (number): EffectAmplitude
  - `effectMiscValue` (number): EffectMiscValue
  - `durationMs` (number): Dauer in Millisekunden
  - `auraCapStatus` (number): 1=Buff-Bar voll, 2=Debuff-Bar voll, 3=beide

### AUTO_ATTACK_SELF / AUTO_ATTACK_OTHER
Feuert bei Auto-Attack-Schaden
- **CVar:** `NP_EnableAutoAttackEvents` (Default: 0)
- **Parameter:**
  - `attackerGuid` (string): Angreifer-GUID
  - `targetGuid` (string): Ziel-GUID
  - `totalDamage` (number): Gesamt-Schaden
  - `hitInfo` (number): Hit-Flags (128=Crit, 16384=Glancing, 32768=Crushing)
  - `victimState` (number): Opfer-Status (2=Dodge, 3=Parry, 5=Block)
  - `subDamageCount` (number): Anzahl Sub-Schäden
  - `blockedAmount` (number): Blockierter Schaden
  - `totalAbsorb` (number): Absorbierter Schaden
  - `totalResist` (number): Resistierter Schaden

### SPELL_HEAL_BY_SELF / SPELL_HEAL_BY_OTHER / SPELL_HEAL_ON_SELF
Feuert bei Spell-Heilung
- **CVar:** `NP_EnableSpellHealEvents` (Default: 0)
- **Parameter:**
  - `targetGuid` (string): Ziel-GUID
  - `casterGuid` (string): Caster-GUID
  - `spellId` (number): Spell-ID
  - `amount` (number): Heilmenge
  - `critical` (number): 1 wenn Crit, 0 sonst
  - `periodic` (number): 1 wenn periodisch (HoT), 0 sonst

### SPELL_ENERGIZE_BY_SELF / SPELL_ENERGIZE_BY_OTHER / SPELL_ENERGIZE_ON_SELF
Feuert bei Power-Wiederherstellung (Mana, Rage, etc.)
- **CVar:** `NP_EnableSpellEnergizeEvents` (Default: 0)
- **Parameter:**
  - `targetGuid` (string): Ziel-GUID
  - `casterGuid` (string): Caster-GUID
  - `spellId` (number): Spell-ID
  - `powerType` (number): Power-Typ (0=Mana, 1=Rage, 2=Focus, 3=Energy, 4=Happiness)
  - `amount` (number): Wiederhergestellte Menge
  - `periodic` (number): 1 wenn periodisch, 0 sonst

### UNIT_DIED
Feuert wenn Unit stirbt
- **Parameter:**
  - `guid` (string): GUID der gestorbenen Unit

---

## CVars

### Spell Queuing

#### NP_QueueCastTimeSpells
- **Default:** "1"
- **Beschreibung:** Queue für Spells mit Cast-Zeit aktivieren

#### NP_QueueInstantSpells
- **Default:** "1"
- **Beschreibung:** Queue für Instant-Cast Spells aktivieren

#### NP_QueueChannelingSpells
- **Default:** "1"
- **Beschreibung:** Queue für Channel-Spells aktivieren

#### NP_QueueTargetingSpells
- **Default:** "1"
- **Beschreibung:** Queue für Terrain-Targeting-Spells aktivieren

#### NP_QueueOnSwingSpells
- **Default:** "0"
- **Beschreibung:** Queue für On-Swing-Spells aktivieren

#### NP_QueueSpellsOnCooldown
- **Default:** "1"
- **Beschreibung:** Queue für Spells auf Cooldown aktivieren

### Queue Windows (in Millisekunden)

#### NP_SpellQueueWindowMs
- **Default:** "500"
- **Beschreibung:** Queue-Fenster vor Cast-Ende

#### NP_ChannelQueueWindowMs
- **Default:** "1500"
- **Beschreibung:** Queue-Fenster vor Channel-Ende

#### NP_TargetingQueueWindowMs
- **Default:** "500"
- **Beschreibung:** Queue-Fenster für Terrain-Targeting

#### NP_CooldownQueueWindowMs
- **Default:** "250"
- **Beschreibung:** Queue-Fenster für Cooldown-Spells

### Buffer & Timing

#### NP_MinBufferTimeMs
- **Default:** "55"
- **Beschreibung:** Minimale Buffer-Zeit nach jedem Cast

#### NP_NonGcdBufferTimeMs
- **Default:** "100"
- **Beschreibung:** Buffer-Zeit nach Non-GCD-Spells

#### NP_MaxBufferIncreaseMs
- **Default:** "30"
- **Beschreibung:** Maximale Buffer-Erhöhung bei Server-Rejection

#### NP_OnSwingBufferCooldownMs
- **Default:** "500"
- **Beschreibung:** Cooldown nach On-Swing-Spell

### Behavior

#### NP_RetryServerRejectedSpells
- **Default:** "1"
- **Beschreibung:** Automatischer Retry bei Server-Rejection

#### NP_QuickcastTargetingSpells
- **Default:** "0"
- **Beschreibung:** Instant-Cast für alle Terrain-Targeting-Spells

#### NP_QuickcastOnDoubleCast
- **Default:** "0"
- **Beschreibung:** Quickcast durch doppelten Cast-Versuch

#### NP_ReplaceMatchingNonGcdCategory
- **Default:** "0"
- **Beschreibung:** Non-GCD-Spells mit gleicher Kategorie ersetzen

#### NP_OptimizeBufferUsingPacketTimings
- **Default:** "0"
- **Beschreibung:** Buffer mit Latenz und Packet-Timings optimieren

#### NP_InterruptChannelsOutsideQueueWindow
- **Default:** "0"
- **Beschreibung:** Channels außerhalb Queue-Fenster unterbrechen

#### NP_DoubleCastToEndChannelEarly
- **Default:** "0"
- **Beschreibung:** Channel durch Doppel-Cast früher beenden

#### NP_SpamProtectionEnabled
- **Default:** "1"
- **Beschreibung:** Spam-Protection während Server-Antwort

#### NP_PreventMountingWhenBuffCapped
- **Default:** "1"
- **Beschreibung:** Mounting bei 32 Buffs verhindern

#### NP_PreventRightClickTargetChange
- **Default:** "0"
- **Beschreibung:** Rechtsklick-Target-Wechsel im Kampf verhindern

#### NP_PreventRightClickPvPAttack
- **Default:** "0"
- **Beschreibung:** Rechtsklick-PvP-Angriff verhindern

### Events

#### NP_EnableAuraCastEvents
- **Default:** "0"
- **Beschreibung:** AURA_CAST_ON_SELF/OTHER Events aktivieren

#### NP_EnableAutoAttackEvents
- **Default:** "0"
- **Beschreibung:** AUTO_ATTACK_SELF/OTHER Events aktivieren

#### NP_EnableSpellStartEvents
- **Default:** "0"
- **Beschreibung:** SPELL_START_SELF/OTHER Events aktivieren

#### NP_EnableSpellGoEvents
- **Default:** "0"
- **Beschreibung:** SPELL_GO_SELF/OTHER Events aktivieren

#### NP_EnableSpellHealEvents
- **Default:** "0"
- **Beschreibung:** SPELL_HEAL Events aktivieren

#### NP_EnableSpellEnergizeEvents
- **Default:** "0"
- **Beschreibung:** SPELL_ENERGIZE Events aktivieren

### Channel & Latency

#### NP_ChannelLatencyReductionPercentage
- **Default:** "75"
- **Beschreibung:** Prozent der Latenz von Channel-Ende subtrahieren

### Nameplate

#### NP_NameplateDistance
- **Beschreibung:** Nameplate-Sichtweite in Yards (Default: Game-Setting)

---

## Spellbook Lua Improvements

Diese Standard-Funktionen akzeptieren jetzt:
1. Spell-Slot (Original)
2. Spell-Name (String)
3. `"spellId:number"` (String mit Spell-ID)

**Funktionen:**
- `GetSpellIconTexture`, `GetSpellName`, `GetSpellCooldown`
- `GetSpellAutocast`, `ToggleSpellAutocast`
- `PickupSpell`, `CastSpell`
- `IsCurrentCast`, `IsSpellPassive`

**Beispiele:**
```lua
print(GetSpellIconTexture(1, "spell")) -- slot, booktype required
print(GetSpellIconTexture("spellId:25978")) -- defaults to BOOKTYPE_SPELL
print(GetSpellIconTexture("spellId:6268", "pet")) -- pet spells need "pet"
print(GetSpellIconTexture("Fireball")) -- name search
```

---

## Entwickler-Hinweise

### Performance
- Verwende Copy-Parameter (`1`) nur wenn nötig
- Extrahiere Werte sofort aus wiederverwendbaren Tables
- Cache Spell/Item-IDs statt Namen wo möglich

### Queue-System
- Max 1 GCD-Spell in Queue
- Max 6 Non-GCD-Spells in Queue
- Max 1 On-Swing-Spell in Queue
- Non-GCD-Queue hat Priorität

### Zeit-Formate
- Felder mit `S` sind in Sekunden (GetTime()-kompatibel)
- Felder mit `Ms` sind in Millisekunden

### GUID-Format
GUIDs sind Hex-Strings: `"0xF5300000000000A5"`

### Spell-Queuing Best Practices
1. Standard-Buffer (55ms) reicht für die meisten Server
2. Non-GCD-Buffer (100ms) wichtig für Item-Combos
3. Channel-Latency-Reduction mit Vorsicht erhöhen
4. Teste mit verschiedenen Latenz-Werten

### Kompatibilität
- Benötigt SuperWoW oder compatibles System
- GUIDs erfordern SuperWoW/Nampower
- Einige Events sind opt-in (CVars auf 1 setzen)
