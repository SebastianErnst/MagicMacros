---@meta
--- SuperWoW API Type Definitions for Autocomplete
--- Version: 2.0
--- Repository: https://github.com/balakethelock/SuperWoW/

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return

-----------------------------------------------------------------------------
-- Global Variables
-----------------------------------------------------------------------------

--- SuperWoW version information string
---@type string
SUPERWOW_STRING = ""

--- SuperWoW numeric version
---@type string
SUPERWOW_VERSION = ""

-----------------------------------------------------------------------------
-- Enhanced Standard Functions
-----------------------------------------------------------------------------

--- Cast spell by name with enhanced targeting options.
--- - Second parameter can now accept unit tokens ("player", "target", "mouseover", etc.)
--- - Special value "CLICK" instantly casts reticle spells at mouse position
---@param spellName string The name of the spell to cast
---@param target? string|boolean Unit token, GUID, "CLICK" for instant reticle cast, or true/false for OnSelf
---@return nil
function CastSpellByName(spellName, target) end

--- Check if a unit exists. Enhanced to return GUID.
---@param unit UnitId Unit token or GUID string
---@return boolean exists Whether the unit exists
---@return string guid The GUID of the unit (format: "0xF5300000000000A5")
---@nodiscard
function UnitExists(unit) end

--- Returns information about a buff on the unit. Enhanced to include spell ID.
---@param unit UnitId
---@param index integer 1-based buff index
---@return string name The name of the buff
---@return integer rank The rank of the buff
---@return string texture The texture path
---@return integer count Stack count
---@return string type Buff type
---@return integer duration Duration in seconds
---@return integer timeLeft Time remaining in seconds
---@return integer spellId The spell ID of the buff (SuperWoW enhancement)
---@nodiscard
function UnitBuff(unit, index) end

--- Returns information about a debuff on the unit. Enhanced to include spell ID.
---@param unit UnitId
---@param index integer 1-based debuff index
---@return string name The name of the debuff
---@return integer rank The rank of the debuff
---@return string texture The texture path
---@return integer count Stack count
---@return string type Debuff type
---@return integer duration Duration in seconds
---@return integer timeLeft Time remaining in seconds
---@return integer spellId The spell ID of the debuff (SuperWoW enhancement)
---@nodiscard
function UnitDebuff(unit, index) end

--- Returns current mana/power. Enhanced for Druids to return both form power and caster mana.
---@param unit UnitId
---@return integer currentPower Current power amount
---@return integer? casterMana For Druids: caster form mana amount
---@nodiscard
function UnitMana(unit) end

--- Set raid target marker with optional local-only flag.
---@param unit UnitId
---@param marker integer Marker index 1-8 (1=star, 8=skull)
---@param isLocal? boolean If true, marker is only visible to local client (works solo)
---@return nil
function SetRaidTarget(unit, marker, isLocal) end

--- Loot a slot with optional force flag.
---@param slotId integer The slot to loot
---@param forceLoot? integer Pass 1 to force loot the slot
---@return nil
function LootSlot(slotId, forceLoot) end

--- Get container item info. Enhanced to return charges for chargeable items.
---@param bag integer Bag index
---@param slot integer Slot index
---@return string texture
---@return integer count Stack count, or negative number for charges if item has charges
---@return boolean locked
---@return integer quality
---@return boolean readable
---@nodiscard
function GetContainerItemInfo(bag, slot) end

--- Get temporary weapon enchant info. Enhanced to work on friendly players.
---@param unit? UnitId If provided, returns enchant names for that player's weapons
---@return boolean hasMainHandEnchant
---@return integer mainHandExpiration Seconds until expiration
---@return integer mainHandCharges
---@return boolean hasOffHandEnchant
---@return integer offHandExpiration
---@return integer offHandCharges
---@return string? mainHandEnchantName Name if querying another player
---@return string? offHandEnchantName Name if querying another player
---@nodiscard
function GetWeaponEnchantInfo(unit) end

--- Returns action info with enhanced type detection for macros.
---@param actionSlot integer
---@return string text The macro/action text
---@return string actionType "MACRO", "ITEM", or "SPELL"
---@return integer|nil id The ID (item/spell ID, or macro index)
---@nodiscard
function GetActionText(actionSlot) end

--- Get action cooldown. Enhanced to work with linked macros.
---@param actionSlot integer
---@return number start
---@return number duration
---@return number enabled
---@nodiscard
function GetActionCooldown(actionSlot) end

--- Get action count. Enhanced to work with linked macros.
---@param actionSlot integer
---@return integer count
---@nodiscard
function GetActionCount(actionSlot) end

--- Check if action is consumable. Enhanced to work with linked macros.
---@param actionSlot integer
---@return 1|nil isConsumable
---@nodiscard
function ActionIsConsumable(actionSlot) end

-----------------------------------------------------------------------------
-- New SuperWoW Functions
-----------------------------------------------------------------------------

--- Get comprehensive spell information by spell ID.
---@param spellId integer The spell ID
---@return string name Spell name
---@return string rank Spell rank (e.g., "Rank 1")
---@return string texture Texture path
---@return number minRange Minimum range in yards
---@return number maxRange Maximum range in yards
---@nodiscard
function SpellInfo(spellId) end

--- Get the spell ID of a buff the player has.
---@param buffIndex integer 0-based buff index
---@return integer spellId The spell ID of the buff at this index
---@nodiscard
function GetPlayerBuffID(buffIndex) end

--- Add a tracked unit to the minimap.
---@param unitId UnitId Unit to track
---@return nil
function TrackUnit(unitId) end

--- Remove a tracked unit from the minimap.
---@param unitId UnitId|"all" Unit to untrack, or "all" to remove all
---@return nil
function UntrackUnit(unitId) end

--- Get the world position of a friendly unit.
---@param unitId UnitId
---@return number x X coordinate
---@return number y Y coordinate
---@return number z Z coordinate
---@nodiscard
function UnitPosition(unitId) end

--- Set the current mouseover unit for other functions to use.
---@param unitId? UnitId Unit to set as mouseover, or nil to clear
---@return nil
function SetMouseoverUnit(unitId) end

--- Toggle clickthrough mode for corpses.
---@param enabled? integer 0 to disable, 1 to enable. If omitted, returns current state.
---@return boolean state Current clickthrough state
function Clickthrough(enabled) end

--- Set autoloot state.
---@param enabled? integer 0 to disable, 1 to enable. If omitted, returns current state.
---@return boolean state Current autoloot state
function SetAutoloot(enabled) end

--- Import text file contents from game directory.
---@param filename string Name of file in gamedirectory\imports folder
---@return string contents The file contents
---@nodiscard
function ImportFile(filename) end

--- Export text to a file in game directory.
---@param filename string Name of file to create in gamedirectory\imports folder
---@param text string Text to write to the file
---@return nil
function ExportFile(filename, text) end

--- Add a message directly to the combat log file.
---@param text string Message to add
---@param addToRawLog? integer Pass 1 to add to raw combat log instead
---@return nil
function CombatLogAdd(text, addToRawLog) end

--- Get the nameplate frame for a unit.
---@param unit UnitId
---@return table frame The nameplate frame
---@nodiscard
function UnitNameplate(unit) end

--- Check if a unit has loot available.
---@param unit UnitId
---@return boolean hasLoot
---@nodiscard
function CanLootUnit(unit) end

--- Get world coordinates of mouse cursor position.
---@return number x X coordinate
---@return number y Y coordinate
---@return number z Z coordinate
---@nodiscard
function CursorPosition() end

--- Convert world coordinates to map coordinates.
---@param continent integer Continent index
---@param x number World X coordinate
---@param y number World Y coordinate
---@return number mapX Map X coordinate (0-1)
---@return number mapY Map Y coordinate (0-1)
---@nodiscard
function GetWorldLocMapPosition(continent, x, y) end

--- Convert map coordinates to world coordinates.
---@param continentIndex integer Continent index
---@param zoneIndex integer Zone index
---@param mapX number Map X coordinate (0-1)
---@param mapY number Map Y coordinate (0-1)
---@return number x World X coordinate
---@return number y World Y coordinate
---@return number z World Z coordinate
---@nodiscard
function GetMapPositionWorldLoc(continentIndex, zoneIndex, mapX, mapY) end

--- Get map boundaries.
---@param continentIndex integer
---@param zoneIndex integer
---@return number left Left boundary
---@return number right Right boundary
---@return number top Top boundary
---@return number bottom Bottom boundary
---@nodiscard
function GetMapBoundaries(continentIndex, zoneIndex) end

--- Check if player is swimming.
---@return boolean isSwimming
---@nodiscard
function IsSwimming() end

--- Check if player is mounted.
---@return boolean isMounted
---@nodiscard
function IsMounted() end

--- Check if player is indoors.
---@return boolean isIndoors
---@nodiscard
function isIndoors() end

--- Get player movement speed.
---@return number runSpeed Run speed in yards per second (7 = 100%)
---@return number swimSpeed Swim speed in yards per second
---@nodiscard
function GetSpeed() end

-----------------------------------------------------------------------------
-- Frame Enhancements
-----------------------------------------------------------------------------

--- Get frame name, or GUID for nameplate frames.
--- Enhanced method for frames.
---@param self table The frame
---@param returnGuid? integer Pass 1 to get GUID for nameplate frames
---@return string name Frame name, or GUID if returnGuid=1 on nameplate
---@nodiscard
function GetName(self, returnGuid) end

-----------------------------------------------------------------------------
-- Unit Token Extensions
-----------------------------------------------------------------------------

-- Unit tokens now support:
-- - "owner" suffix: e.g., "targetowner" returns owner of target (shaman for totems)
-- - "mark1" to "mark8": Returns unit with corresponding raid marker (mark8 = skull)
-- - GUID strings: Can use GUID as unit token, e.g., "0xF5300000000000A5"

-----------------------------------------------------------------------------
-- Events
-----------------------------------------------------------------------------

--- UNIT_CASTEVENT fires when units cast, channel, or swing
--- arg1: casterGUID (string)
--- arg2: targetGUID (string)
--- arg3: eventType (string) - "START", "CAST", "FAIL", "CHANNEL", "MAINHAND", "OFFHAND"
--- arg4: spellId (integer)
--- arg5: castDuration (number)

--- RAW_COMBATLOG fires for all combat log events with GUIDs
--- arg1: originalEventName (string)
--- arg2: eventTextWithGUIDs (string)
--- Logged to WoWRawCombatLog.txt

--- CREATE_CHATBUBBLE fires when a chat bubble is created
--- arg1: chatBubbleFrame (table)
--- arg2: unitGUID (string)

-----------------------------------------------------------------------------
-- CVars
-----------------------------------------------------------------------------

--- Background sound while tabbed out
--- Default: "0", Values: "0" or "1"
--- SetCVar("BackgroundSound", "1")

--- Remove hardcoded sound channel limit
--- Default: "0", Values: "0" or "1"
--- SetCVar("UncapSounds", "1")

--- Camera field of view
--- Default: "1.57", Range: "0.1" to "3.14"
--- SetCVar("FoV", "2.0")

--- Selection circle style
--- Default: "1", Values: "1" (classic), "2" (full), "3" (pointed), "4" (facing)
--- SetCVar("SelectionCircleStyle", "2")

--- Show sparkles on lootable treasure
--- Default: "0", Values: "0" or "1"
--- SetCVar("LootSparkle", "1")

--- Chat bubble range in yards
--- Default: "60", Range: "10" to "200"
--- SetCVar("ChatBubbleRange", "100")

--- Chat bubbles in raids
--- Default: varies, Values: "0" or "1"
--- SetCVar("ChatBubblesRaid", "1")

--- Chat bubbles in battlegrounds
--- SetCVar("ChatBubblesBattleground", "1")

--- Chat bubbles for whispers
--- SetCVar("ChatBubblesWhisper", "1")

--- Chat bubbles for creatures
--- SetCVar("ChatBubblesCreatures", "1")

--- Nameplate range in yards
--- Range: "10" to "80"
--- SetCVar("NameplateRange", "60")

--- Nameplate motion behavior
--- Values: "0" (overlap), "1" (default spread), "2" (smart spread)
--- SetCVar("NameplateMotion", "2")

--- Toggle floating healing text
--- Values: "0" or "1"
--- SetCVar("HealingText", "1")
