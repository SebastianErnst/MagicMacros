# SuperWoW API Dokumentation

## Übersicht
SuperWoW ist ein Launcher/Mod für World of Warcraft 1.12.1, der Client-Bugs behebt und die Lua-basierte API für UI-Addons erweitert.

**Version:** 2.0  
**Repository:** https://github.com/balakethelock/SuperWoW/

---

## Globale Variablen

### SUPERWOW_STRING
- **Typ:** `string`
- **Beschreibung:** Gibt Versionsinformationen über SuperWoW als String zurück

### SUPERWOW_VERSION
- **Typ:** `string` 
- **Beschreibung:** Gibt die SuperWoW-Version zurück

---

## Neue/Geänderte Funktionen

### CastSpellByName(spellName, target)
- **Parameter:**
  - `spellName` (string): Name des Zaubers
  - `target` (string|boolean): Unit-Token ("player", "target", etc.) oder true/false für OnSelf
    - Spezialwert: `"CLICK"` - Castet Reticle-Zauber sofort an Mausposition
- **Beschreibung:** Erweiterte Version der Standard-Funktion mit Unit-Targeting
- **Beispiel:** 
  ```lua
  CastSpellByName("Fireball", "target")
  CastSpellByName("Blizzard", "CLICK") -- Instant cast at mouse
  ```

### UnitExists(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** 
  - `boolean`: Ob die Unit existiert
  - `string`: GUID der Unit
- **Beschreibung:** Gibt zusätzlich zur Existenz auch die GUID zurück

### UnitDebuff(unit, index)
### UnitBuff(unit, index)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `index` (number): Buff/Debuff-Index
- **Rückgabe:** Standard-Werte + `spellId` (number)
- **Beschreibung:** Gibt zusätzlich die Zauber-ID des Buffs/Debuffs zurück

### UnitMana(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** 
  - Für Druiden: Gibt sowohl aktuelles Form-Mana als auch Caster-Form-Mana zurück
- **Beschreibung:** Spezielle Behandlung für Druiden-Gestalten

### GetPlayerBuffID(buffIndex)
- **Parameter:** `buffIndex` (number): Index des Buffs
- **Rückgabe:** `spellId` (number)
- **Beschreibung:** Gibt die ID des Buffs am angegebenen Index zurück

### frame:GetName(returnGuid)
- **Parameter:** `returnGuid` (number): Optional, 1 für GUID-Rückgabe
- **Rückgabe:** 
  - Ohne Parameter: Frame-Name (string)
  - Mit `1`: GUID der Unit (string) bei Nameplate-Frames
- **Beschreibung:** Erweitert für Nameplate-Frames, um GUID zu erhalten
- **Beispiel:**
  ```lua
  local guid = nameplate:GetName(1)
  ```

### SetRaidTarget(unit, marker, local)
- **Parameter:**
  - `unit` (string): Unit-Token
  - `marker` (number): Marker-ID (1-8)
  - `local` (boolean): Optional, lokaler Marker nur für eigenen Client
- **Beschreibung:** Kann jetzt auch Solo-Marker setzen mit lokalem Flag

### LootSlot(slotId, forceLoot)
- **Parameter:**
  - `slotId` (number): Slot-ID
  - `forceLoot` (number): Optional, 1 zum direkten Looten
- **Beschreibung:** Kann nun direkt Loot aufnehmen mit zweitem Parameter

### GetContainerItemInfo(bag, slot)
- **Rückgabe:** Gibt Charges als negative Zahl zurück wenn Item nicht stackbar ist
- **Beschreibung:** Unterscheidet zwischen Stacks und Charges

### GetWeaponEnchantInfo(unit)
- **Parameter:** `unit` (string): Optional, Unit-Token für freundliche Spieler
- **Rückgabe:** 
  - Ohne Parameter: Eigene Enchant-Dauer & Stacks
  - Mit Parameter: Namen der temporären Enchants von MH/OH des Ziels
- **Beschreibung:** Kann jetzt auch Enchants anderer Spieler abfragen

### GetActionCount(actionSlot)
### GetActionCooldown(actionSlot)  
### ActionIsConsumable(actionSlot)
- **Parameter:** `actionSlot` (number): Aktions-Slot
- **Beschreibung:** Funktionieren jetzt auch für Makros, wenn diese mit `/tooltip` verlinkt sind

### GetActionText(actionSlot)
- **Parameter:** `actionSlot` (number): Aktions-Slot
- **Rückgabe:**
  - `text` (string): Aktions-Text
  - `actionType` (string): "MACRO", "ITEM" oder "SPELL"
  - `id` (number): ID oder Makro-Index
- **Beschreibung:** Gibt zusätzliche Typ-Informationen zurück

---

## Neue Funktionen

### SpellInfo(spellId)
- **Parameter:** `spellId` (number): Zauber-ID
- **Rückgabe:**
  - `name` (string): Zauber-Name
  - `rank` (string): Rang
  - `texture` (string): Textur-Pfad
  - `minRange` (number): Minimale Reichweite
  - `maxRange` (number): Maximale Reichweite
- **Beschreibung:** Gibt vollständige Informationen über einen Zauber
- **Beispiel:**
  ```lua
  local name, rank, tex, minR, maxR = SpellInfo(133) -- Fireball
  ```

### TrackUnit(unitId)
- **Parameter:** `unitId` (string): Unit-Token
- **Beschreibung:** Fügt eine freundliche Unit zur Minimap hinzu

### UntrackUnit(unitId)
- **Parameter:** `unitId` (string|"all"): Unit-Token oder "all" für alle
- **Beschreibung:** Entfernt Unit-Tracking von der Minimap

### UnitPosition(unitId)
- **Parameter:** `unitId` (string): Unit-Token
- **Rückgabe:** 
  - `x` (number): X-Koordinate
  - `y` (number): Y-Koordinate
  - `z` (number): Z-Koordinate
- **Beschreibung:** Gibt Weltkoordinaten einer freundlichen Unit zurück

### SetMouseoverUnit(unitId)
- **Parameter:** `unitId` (string): Unit-Token oder nil zum Zurücksetzen
- **Beschreibung:** Setzt die aktuelle Mouseover-Unit für andere Funktionen
- **Verwendung:** Für UnitFrame-Addons bei OnEnter/OnLeave

### Clickthrough(enabled)
- **Parameter:** `enabled` (number): Optional, 0/1 zum Setzen
- **Rückgabe:** `boolean`: Aktueller Status
- **Beschreibung:** Aktiviert/deaktiviert Clickthrough für lootlose Leichen

### SetAutoloot(enabled)
- **Parameter:** `enabled` (number): Optional, 0/1 zum Setzen
- **Rückgabe:** `boolean`: Aktueller Status
- **Beschreibung:** Steuert Autoloot (Shift-Taste funktioniert nicht mehr)

### ImportFile(filename)
- **Parameter:** `filename` (string): Dateiname
- **Rückgabe:** `string`: Dateiinhalt
- **Beschreibung:** Liest Textdatei aus `gamedirectory\imports` Ordner

### ExportFile(filename, text)
- **Parameter:**
  - `filename` (string): Dateiname
  - `text` (string): Zu schreibender Text
- **Beschreibung:** Erstellt Textdatei in `gamedirectory\imports` Ordner

### CombatLogAdd(text, addToRawLog)
- **Parameter:**
  - `text` (string): Nachricht
  - `addToRawLog` (number): Optional, 1 für Raw-Log
- **Beschreibung:** Fügt Nachricht direkt zum Combat-Log hinzu

### UnitNameplate(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `frame`: Nameplate-Frame der Unit
- **Beschreibung:** Gibt das Nameplate-Frame einer Unit zurück

### CanLootUnit(unit)
- **Parameter:** `unit` (string): Unit-Token
- **Rückgabe:** `boolean`: Ob Unit Loot enthält
- **Beschreibung:** Prüft ob eine Unit gelootet werden kann

### CursorPosition()
- **Rückgabe:**
  - `x` (number): X-Koordinate
  - `y` (number): Y-Koordinate
  - `z` (number): Z-Koordinate
- **Beschreibung:** Gibt Welt-XYZ-Koordinaten der Mausposition zurück

### GetWorldLocMapPosition(continent, x, y)
- **Parameter:**
  - `continent` (number): Kontinent-Index
  - `x` (number): Welt-X-Koordinate
  - `y` (number): Welt-Y-Koordinate
- **Rückgabe:**
  - `mapX` (number): Karten-X-Position
  - `mapY` (number): Karten-Y-Position
- **Beschreibung:** Konvertiert Weltkoordinaten zu Kartenkoordinaten

### GetMapPositionWorldLoc(continentIndex, zoneIndex, mapX, mapY)
- **Parameter:**
  - `continentIndex` (number): Kontinent-Index
  - `zoneIndex` (number): Zonen-Index
  - `mapX` (number): Karten-X-Position
  - `mapY` (number): Karten-Y-Position
- **Rückgabe:**
  - `x` (number): Welt-X-Koordinate
  - `y` (number): Welt-Y-Koordinate
  - `z` (number): Welt-Z-Koordinate
- **Beschreibung:** Konvertiert Kartenkoordinaten zu Weltkoordinaten

### GetMapBoundaries(continentIndex, zoneIndex)
- **Parameter:**
  - `continentIndex` (number): Kontinent-Index
  - `zoneIndex` (number): Zonen-Index
- **Rückgabe:**
  - `left` (number): Linke Grenze
  - `right` (number): Rechte Grenze
  - `top` (number): Obere Grenze
  - `bottom` (number): Untere Grenze
- **Beschreibung:** Gibt Kartengrenzen zurück

### IsSwimming()
- **Rückgabe:** `boolean`: Ob Spieler schwimmt
- **Beschreibung:** Gibt Schwimm-Status zurück

### IsMounted()
- **Rückgabe:** `boolean`: Ob Spieler mounted ist
- **Beschreibung:** Gibt Mount-Status zurück

### isIndoors()
- **Rückgabe:** `boolean`: Ob Spieler drinnen ist
- **Beschreibung:** Gibt Indoor-Status zurück

### GetSpeed()
- **Rückgabe:**
  - `runSpeed` (number): Laufgeschwindigkeit in Yards/Sekunde
  - `swimSpeed` (number): Schwimmgeschwindigkeit in Yards/Sekunde
- **Beschreibung:** Gibt Bewegungsgeschwindigkeiten zurück (7 yards = 100%)

---

## Erweiterte Unit-Token

### Unit-Suffixe
Alle Unit-Funktionen unterstützen jetzt den Suffix `"owner"`:
- **Beispiel:** `UnitName("targetowner")` - Gibt Owner des Targets zurück (z.B. Shaman bei Totem)

### Marker-Units
Units können über Marker-IDs angesprochen werden:
- **Tokens:** `"mark1"` bis `"mark8"`
- **Beschreibung:** Gibt die Unit mit dem entsprechenden Marker zurück
- **Beispiel:** `UnitName("mark8")` - Gibt Namen der mit Skull markierten Unit zurück

### GUID als Unit-Token
Alle Unit-Funktionen akzeptieren jetzt GUIDs als String:
- **Format:** `"0xF5300000000000A5"`
- **Beschreibung:** GUID kann direkt als Unit-Token verwendet werden
- **Beispiel:** `UnitHealth("0xF5300000000000A5")`

---

## Events

### UNIT_CASTEVENT
Trackt Cast-Status von Units
- **Parameter:**
  - `arg1` (string): Caster-GUID
  - `arg2` (string): Target-GUID
  - `arg3` (string): Event-Typ: "START", "CAST", "FAIL", "CHANNEL", "MAINHAND", "OFFHAND"
  - `arg4` (number): Spell-ID
  - `arg5` (number): Cast-Dauer
- **Beschreibung:** Feuert bei Cast-Start, Finish, Interrupt, Channel und Swings

### RAW_COMBATLOG
Rohe Combat-Log-Events mit GUIDs
- **Parameter:**
  - `arg1` (string): Original Event-Name
  - `arg2` (string): Event-Text mit GUIDs
- **Beschreibung:** Gibt Raw-Version aller Combat-Log-Events mit GUIDs
- **Log-Datei:** WoWRawCombatLog.txt

### CREATE_CHATBUBBLE
Feuert wenn eine Chat-Bubble erstellt wird
- **Parameter:**
  - `arg1` (frame): ChatBubble-Frame
  - `arg2` (string): Unit-GUID
- **Beschreibung:** Ermöglicht Zugriff auf Chat-Bubbles

---

## CVars

### BackgroundSound
- **Typ:** `string` ("0" oder "1")
- **Default:** "0"
- **Beschreibung:** Aktiviert Sound wenn Spiel im Hintergrund ist

### UncapSounds
- **Typ:** `string` ("0" oder "1")
- **Default:** "0"
- **Beschreibung:** Entfernt Hardcoded-Limit für Sound-Channels

### FoV
- **Typ:** `string` (Zahl)
- **Default:** "1.57"
- **Bereich:** "0.1" bis "3.14"
- **Beschreibung:** Setzt Kamera Field of View

### SelectionCircleStyle
- **Typ:** `string` ("1", "2", "3", "4")
- **Default:** "1"
- **Werte:**
  - "1" = Classic Style
  - "2" = Full Circle Style
  - "3" = Pointed Circle Style
  - "4" = Facing Classic Style
- **Beschreibung:** Ändert Aussehen des Target-Kreises

### LootSparkle
- **Typ:** `string` ("0" oder "1")
- **Default:** "0"
- **Beschreibung:** Zeigt Glitzer-Effekt auf lootbaren Objekten

### ChatBubbleRange
- **Typ:** `string` (Zahl)
- **Bereich:** "10" bis "200"
- **Default:** "60"
- **Beschreibung:** Reichweite für Chat-Bubbles in Yards

### ChatBubblesRaid
### ChatBubblesBattleground
### ChatBubblesWhisper
### ChatBubblesCreatures
- **Typ:** `string` ("0" oder "1")
- **Beschreibung:** Aktiviert Chat-Bubbles für spezifische Kontexte

### NameplateRange
- **Typ:** `string` (Zahl)
- **Bereich:** "10" bis "80"
- **Beschreibung:** Reichweite für Nameplates in Yards

### NameplateMotion
- **Typ:** `string` ("0", "1", "2")
- **Werte:**
  - "0" = Overlap
  - "1" = Default Spread
  - "2" = Smart Spread
- **Beschreibung:** Steuert Nameplate-Bewegung

### HealingText
- **Typ:** `string` ("0" oder "1")
- **Beschreibung:** Zeigt schwebenden Heilungs-Text

---

## Makro-Erweiterungen

### Tooltip-Linking
Makros können als Items oder Spells behandelt werden:
```lua
/tooltip spell:spellid
/tooltip item:itemid
```
- **Beschreibung:** Lässt Makro wie Item/Spell für GetActionCount, GetActionCooldown, etc. erscheinen

### Zeichenlimit
- **Alt:** 255 Zeichen
- **Neu:** 510 Zeichen
- **Beschreibung:** Verdoppeltes Zeichenlimit für Makros

---

## Features

### Combat Log
- Vollständig absorbierter Schaden wird korrekt angezeigt
- Combat Log fügt Owner-Namen zu Pets/Totems hinzu
- Raw Combat Log mit GUIDs in separater Datei

### Chat
- Chat-Links für Spells & Crafting Recipes unterstützt
- Chat-Bubbles mit 60 Yard Reichweite statt 20
- Chat-Bubbles funktionieren mit aktivierten Nameplates
- Raid/BG/Whisper Chat-Bubbles

### Buffs/Auras
- Persönliche Buff-Bar zeigt alle Buffs inkl. iconlose
- UnitBuff/UnitDebuff geben Spell-ID zurück

### Looting
- Autoloot funktioniert für Enchanting & Pick Pocket

### Casting
- SPELLCAST_START feuert jetzt auch für Ranged-Abilities (Aimed Shot, etc.)
- Targeting-Circle-Spells zeigen keine "can't cast while moving" Fehler mehr

### Sonstiges
- Heilung erscheint im Floating Combat Text
- Keine Reichweiten-Limite für Equipped Items von Freunden
- Enchanting & Pick Pocket mit Autoloot kompatibel

---

## Entwickler-Hinweise

### GUID-Format
GUIDs werden als Hex-String zurückgegeben: `"0xF5300000000000A5"`

### Performance
Die meisten neuen Funktionen haben minimalen Performance-Impact

### Kompatibilität
SuperWoW benötigt kompatible Addons (SuperAPI) für volle Funktionalität
