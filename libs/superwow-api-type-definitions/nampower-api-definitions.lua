---@meta
--- Nampower API Type Definitions for Autocomplete
--- Version: 2.29.0
--- Repository: https://gitea.com/avitasia/nampower

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return

-----------------------------------------------------------------------------
-- Spell/Item/Unit Information
-----------------------------------------------------------------------------

--- Get complete item statistics from DBC.
--- Returns a reusable table reference unless copy=1.
---@param itemId integer Item ID
---@param copy? integer Pass 1 to get independent table copy
---@return table|nil itemStats Table with all ItemStats fields (displayName, itemLevel, quality, delay, bonusStat, bonusAmount, etc.)
---@nodiscard
function GetItemStats(itemId, copy) end

--- Get single field from item statistics (faster than GetItemStats).
--- For array fields, returns reusable table unless copy=1.
---@param itemId integer Item ID
---@param fieldName string Field name (e.g., "displayName", "itemLevel", "quality", "delay")
---@param copy? integer Pass 1 for independent copy of array fields
---@return any value Field value
---@nodiscard
function GetItemStatsField(itemId, fieldName, copy) end

--- Find an item in player inventory.
---@param itemIdOrName integer|string Item ID or name (case-insensitive)
---@return integer|nil bagIndex nil=equipped, 0=backpack, 1-4=bags, -1=bank, 5-10=bank bags, -2=keyring
---@return integer slotIndex 1-indexed slot number (0-18 for equipped items)
---@nodiscard
function FindPlayerItemSlot(itemIdOrName) end

--- Use an item from player inventory.
---@param itemIdOrName integer|string Item ID or name
---@param target? string|integer Unit token or GUID (default: LockedTargetGuid or player GUID)
---@return integer success 1 if successful, 0 if failed
function UseItemIdOrName(itemIdOrName, target) end

--- Get all equipped items for a unit.
--- Returns reusable table reference.
---@param unitToken string Unit token or GUID
---@return table|nil items Table with slots 0-18 as keys, item info as values
---@nodiscard
function GetEquippedItems(unitToken) end

--- Get equipped item in specific slot.
--- Returns reusable table reference.
---@param unitToken string Unit token or GUID
---@param slot integer Equipment slot 0-18 (1=head, 16=mainhand, etc.)
---@return table|nil itemInfo Table with itemId, stackCount, durability, enchants, etc.
---@nodiscard
function GetEquippedItem(unitToken, slot) end

--- Get items in bags.
--- Returns reusable table reference.
---@param bagIndex? integer Optional: specific bag (0, 1-4, -1, 5-10, -2). Omit for all bags.
---@return table items Nested table: [bagIndex][slotIndex] = itemInfo
---@nodiscard
function GetBagItems(bagIndex) end

--- Get item in specific bag slot.
--- Returns reusable table reference.
---@param bagIndex integer Bag index (0=backpack, 1-4=bags, -1=bank, 5-10=bank bags, -2=keyring)
---@param slot integer 1-indexed slot number
---@return table|nil itemInfo Table with itemId, stackCount, durability, etc.
---@nodiscard
function GetBagItem(bagIndex, slot) end

--- Get equipped ammo information.
---@return integer|nil ammoId Item ID of equipped ammo
---@return integer count Total count in backpack and bags 1-4
---@nodiscard
function GetAmmo() end

--- Get complete spell record from DBC.
--- Returns reusable table reference unless copy=1.
---@param spellId integer Spell ID
---@param copy? integer Pass 1 to get independent table copy
---@return table|nil spellRec Table with all SpellRec fields (name, rank, castTime, manaCost, school, range, etc.)
---@nodiscard
function GetSpellRec(spellId, copy) end

--- Get single field from spell record (faster than GetSpellRec).
--- For array fields, returns reusable table unless copy=1.
---@param spellId integer Spell ID
---@param fieldName string Field name (e.g., "name", "rank", "castTime", "manaCost", "school")
---@param copy? integer Pass 1 for independent copy of array fields
---@return any value Field value
---@nodiscard
function GetSpellRecField(spellId, fieldName, copy) end

--- Get current spell modifiers from buffs/talents.
---@param spellId integer Spell ID
---@param modifierType integer 0=DAMAGE, 1=DURATION, 2=THREAT, 7=CRIT_CHANCE, 10=CAST_TIME, 11=COOLDOWN, 14=COST, etc.
---@return number flatMod Flat modification value (e.g., +50 damage)
---@return number percentMod Percent modification (e.g., 10 for +10%)
---@return integer hasModifier Whether any modifier exists
---@nodiscard
function GetSpellModifiers(spellId, modifierType) end

--- Get all unit fields from memory.
--- Returns reusable table reference unless copy=1.
---@param unitToken string Unit token or GUID
---@param copy? integer Pass 1 to get independent table copy
---@return table|nil unitData Table with all unit fields (health, maxHealth, level, displayId, power, aura, resistances, etc.)
---@nodiscard
function GetUnitData(unitToken, copy) end

--- Get single unit field from memory (faster than GetUnitData).
--- For array fields, returns reusable table unless copy=1.
---@param unitToken string Unit token or GUID
---@param fieldName string Field name (e.g., "health", "maxHealth", "level", "aura", "resistances")
---@param copy? integer Pass 1 for independent copy of array fields
---@return any value Field value or table for array fields
---@nodiscard
function GetUnitField(unitToken, fieldName, copy) end

--- Get spell ID from spell name.
---@param spellName string Spell name (with or without rank)
---@return integer spellId Max rank spell ID from spellbook, or 0 if not found
---@nodiscard
function GetSpellIdForName(spellName) end

--- Get spell name and rank from spell ID.
---@param spellId integer Spell ID
---@return string name Spell name
---@return string rank Spell rank (e.g., "Rank 1")
---@nodiscard
function GetSpellNameAndRankForId(spellId) end

--- Get spellbook slot, book type, and spell ID from name.
---@param spellName string Spell name
---@return integer slot 1-indexed spellbook slot, or 0 if not found
---@return string bookType "spell", "pet", or "unknown"
---@return integer spellId Spell ID, or 0 if not found
---@nodiscard
function GetSpellSlotTypeIdForName(spellName) end

--- Get Nampower version.
---@return integer major Major version number
---@return integer minor Minor version number
---@return integer patch Patch version number
---@nodiscard
function GetNampowerVersion() end

--- Get item level.
---@param itemId integer Item ID
---@return integer itemLevel Item level
---@nodiscard
function GetItemLevel(itemId) end

--- Get item icon texture path.
---@param displayInfoId integer Display info ID from GetItemStatsField(itemId, "displayInfoID")
---@return string|nil texture Texture path (e.g., "Interface\\Icons\\INV_Sword_04")
---@nodiscard
function GetItemIconTexture(displayInfoId) end

--- Get spell icon texture path.
---@param spellIconId integer Spell icon ID from GetSpellRecField(spellId, "spellIconID")
---@return string|nil texture Texture path with Interface\\Icons\\ prefix
---@nodiscard
function GetSpellIconTexture(spellIconId) end

-----------------------------------------------------------------------------
-- Spell Casting & Queuing
-----------------------------------------------------------------------------

--- Force queue a spell regardless of queue window.
--- Max 1 GCD spell and 6 non-GCD spells can be queued.
---@param spellName string Spell name
---@return nil
function QueueSpellByName(spellName) end

--- Cast spell without queuing even if settings would normally queue.
---@param spellName string Spell name
---@return nil
function CastSpellByNameNoQueue(spellName) end

--- Queue arbitrary script with spell queue logic.
---@param script string Lua script as string
---@param priority? integer 1=before all spells, 2=after non-GCD, 3=after all spells (default: 1)
---@return nil
function QueueScript(script, priority) end

--- Check if spell is in range of target.
---@param spellNameOrId string|integer Spell name from spellbook or any spell ID
---@param target? string Unit token or GUID (default: current target)
---@return integer inRange 1=in range, 0=out of range, -1=not single-target spell
---@nodiscard
function IsSpellInRange(spellNameOrId, target) end

--- Check if spell is usable (e.g., reactive spells).
--- Note: "usable" does not mean "castable".
---@param spellNameOrId string|integer Spell name from spellbook or any spell ID
---@return integer usable 1 if usable, 0 if not
---@return integer noMana 1 if unusable due to mana, 0 otherwise
---@nodiscard
function IsSpellUsable(spellNameOrId) end

--- Stop channeling early on next tick if queue channeling is enabled.
---@return nil
function ChannelStopCastingNextTick() end

-----------------------------------------------------------------------------
-- Cast Information
-----------------------------------------------------------------------------

--- Get basic cast information (legacy).
---@return integer castingSpellId Casting spell ID or 0
---@return integer visualSpellId Visual spell ID or 0
---@return integer autoRepeatSpellId Auto-repeat spell ID or 0
---@return integer isCasting 1 if casting spell with cast time, 0 otherwise
---@return integer isChanneling 1 if channeling, 0 otherwise
---@return integer isOnSwingPending 1 if on-swing spell pending, 0 otherwise
---@return integer isAutoAttacking 1 if auto-attacking, 0 otherwise
---@nodiscard
function GetCurrentCastingInfo() end

--- Get detailed cast information.
--- Returns reusable table reference, or nil if no active cast/channel.
---@return table|nil castInfo Table with castId, spellId, guid, castType, castStartS, castEndS, castRemainingMs, castDurationMs, gcdEndS, gcdRemainingMs
---@nodiscard
function GetCastInfo() end

-----------------------------------------------------------------------------
-- Cooldown Information
-----------------------------------------------------------------------------

--- Get detailed spell cooldown information.
--- Returns reusable table reference.
---@param spellId integer Spell ID
---@return table cooldown Table with isOnCooldown, cooldownRemainingMs, itemId, individual/category/GCD cooldown details
---@nodiscard
function GetSpellIdCooldown(spellId) end

--- Get detailed item cooldown information.
--- Returns reusable table reference.
---@param itemId integer Item ID
---@return table cooldown Table with same structure as GetSpellIdCooldown
---@nodiscard
function GetItemIdCooldown(itemId) end

--- Get list of equipped and carried trinkets.
--- Returns reusable table reference unless copy=1.
---@param copy? integer|boolean Pass 1 or true to get independent copy
---@return table trinkets Array of tables with itemId, trinketName, texture, itemLevel, bagIndex, slotIndex
---@nodiscard
function GetTrinkets(copy) end

--- Get cooldown for equipped trinket.
---@param slotOrItemIdOrName integer|string 1/13=first slot, 2/14=second slot, number=item ID, string=item name
---@return table|integer cooldown Cooldown table or -1 if not found
---@nodiscard
function GetTrinketCooldown(slotOrItemIdOrName) end

--- Use equipped trinket.
---@param slotOrItemIdOrName integer|string 1/13=first slot, 2/14=second slot, number=item ID, string=item name
---@param target? string|integer Unit token or GUID
---@return integer result 1=success, 0=found but failed, -1=not found
function UseTrinket(slotOrItemIdOrName, target) end

-----------------------------------------------------------------------------
-- Utility Functions
-----------------------------------------------------------------------------

--- Automatically disenchant all matching items in bags.
--- ⚠️ WARNING: Disenchants without confirmation! Only searches backpack and bags 1-4.
--- Quest items always protected. Soulbound items protected by default.
---@param itemIdOrNameOrQuality integer|string Item ID, item name, "greens", "blues", "purples", or combinations like "greens|blues"
---@param includeSoulbound? integer Pass 1 to include soulbound items (default: 0)
---@return integer success 1 if started disenchanting, 0 if failed
function DisenchantAll(itemIdOrNameOrQuality, includeSoulbound) end

-----------------------------------------------------------------------------
-- Enhanced Spellbook Functions
-----------------------------------------------------------------------------

-- These standard functions now accept:
-- 1. Spell slot (original)
-- 2. Spell name (string)
-- 3. "spellId:number" format
-- Enhanced functions:
-- GetSpellIconTexture, GetSpellName, GetSpellCooldown, GetSpellAutocast,
-- ToggleSpellAutocast, PickupSpell, CastSpell, IsCurrentCast, IsSpellPassive

-----------------------------------------------------------------------------
-- Events
-----------------------------------------------------------------------------

--- SPELL_QUEUE_EVENT fires when spells are queued/dequeued
--- arg1: eventCode (integer) - 0=ON_SWING_QUEUED, 1=ON_SWING_POPPED, 2=NORMAL_QUEUED, 3=NORMAL_POPPED, 4=NON_GCD_QUEUED, 5=NON_GCD_POPPED
--- arg2: spellId (integer)

--- SPELL_CAST_EVENT fires when you cast a spell (client-side, before server send)
--- arg1: success (integer) - 1=success, 0=failed
--- arg2: spellId (integer)
--- arg3: castType (integer) - 1=NORMAL, 2=NON_GCD, 3=ON_SWING, 4=CHANNEL, 5=TARGETING, 6=TARGETING_NON_GCD
--- arg4: targetGuid (string) - e.g., "0xF5300000000000A5"
--- arg5: itemId (integer) - Item that triggered spell, or 0

--- SPELL_START_SELF / SPELL_START_OTHER fires on spell start packet from server
--- Requires: SetCVar("NP_EnableSpellStartEvents", "1")
--- arg1: itemId (integer), arg2: spellId (integer), arg3: casterGuid (string)
--- arg4: targetGuid (string), arg5: castFlags (integer), arg6: castTime (integer)

--- SPELL_GO_SELF / SPELL_GO_OTHER fires when spell cast completes (server)
--- Requires: SetCVar("NP_EnableSpellGoEvents", "1")
--- arg1: itemId (integer), arg2: spellId (integer), arg3: casterGuid (string)
--- arg4: targetGuid (string), arg5: castFlags (integer)
--- arg6: numTargetsHit (integer), arg7: numTargetsMissed (integer)

--- SPELL_FAILED_SELF / SPELL_FAILED_OTHER fires on spell failure
--- SELF args: spellId, spellResult, failedByServer
--- OTHER args: casterGuid, spellId

--- SPELL_DELAYED_SELF / SPELL_DELAYED_OTHER fires when spell is delayed
--- arg1: casterGuid (string), arg2: delayMs (integer)

--- SPELL_CHANNEL_START fires when player starts channeling
--- arg1: spellId (integer), arg2: targetGuid (string), arg3: durationMs (integer)

--- SPELL_CHANNEL_UPDATE fires when channel updates
--- arg1: spellId (integer), arg2: targetGuid (string), arg3: remainingMs (integer)

--- SPELL_DAMAGE_EVENT_SELF / SPELL_DAMAGE_EVENT_OTHER fires on spell damage
--- arg1: targetGuid (string), arg2: casterGuid (string), arg3: spellId (integer)
--- arg4: amount (integer), arg5: mitigationStr (string) "absorb,block,resist"
--- arg6: hitInfo (integer), arg7: spellSchool (integer), arg8: effectAuraStr (string)

--- BUFF_ADDED_SELF, BUFF_REMOVED_SELF, BUFF_ADDED_OTHER, BUFF_REMOVED_OTHER
--- DEBUFF_ADDED_SELF, DEBUFF_REMOVED_SELF, DEBUFF_ADDED_OTHER, DEBUFF_REMOVED_OTHER
--- arg1: guid (string), arg2: slot (integer), arg3: spellId (integer)
--- arg4: stackCount (integer), arg5: auraLevel (integer)

--- AURA_CAST_ON_SELF / AURA_CAST_ON_OTHER fires when spell applies aura
--- Requires: SetCVar("NP_EnableAuraCastEvents", "1")
--- arg1: spellId (integer), arg2: casterGuid (string), arg3: targetGuid (string)
--- arg4: effect (integer), arg5: effectAuraName (integer), arg6: effectAmplitude (integer)
--- arg7: effectMiscValue (integer), arg8: durationMs (integer), arg9: auraCapStatus (integer)

--- AUTO_ATTACK_SELF / AUTO_ATTACK_OTHER fires on auto-attack damage
--- Requires: SetCVar("NP_EnableAutoAttackEvents", "1")
--- arg1: attackerGuid (string), arg2: targetGuid (string), arg3: totalDamage (integer)
--- arg4: hitInfo (integer), arg5: victimState (integer), arg6: subDamageCount (integer)
--- arg7: blockedAmount (integer), arg8: totalAbsorb (integer), arg9: totalResist (integer)

--- SPELL_HEAL_BY_SELF fires when you heal someone
--- SPELL_HEAL_BY_OTHER fires when someone else heals
--- SPELL_HEAL_ON_SELF fires when you receive healing
--- Requires: SetCVar("NP_EnableSpellHealEvents", "1")
--- arg1: targetGuid (string), arg2: casterGuid (string), arg3: spellId (integer)
--- arg4: amount (integer), arg5: critical (integer), arg6: periodic (integer)

--- SPELL_ENERGIZE_BY_SELF fires when you restore power to someone
--- SPELL_ENERGIZE_BY_OTHER fires when someone else restores power
--- SPELL_ENERGIZE_ON_SELF fires when you receive power
--- Requires: SetCVar("NP_EnableSpellEnergizeEvents", "1")
--- arg1: targetGuid (string), arg2: casterGuid (string), arg3: spellId (integer)
--- arg4: powerType (integer) - 0=Mana, 1=Rage, 2=Focus, 3=Energy, 4=Happiness
--- arg5: amount (integer), arg6: periodic (integer)

--- UNIT_DIED fires when a unit dies
--- arg1: guid (string)

-----------------------------------------------------------------------------
-- CVars (Spell Queuing)
-----------------------------------------------------------------------------

--- Enable queue for cast-time spells
--- Default: "1"
--- SetCVar("NP_QueueCastTimeSpells", "1")

--- Enable queue for instant spells
--- Default: "1"
--- SetCVar("NP_QueueInstantSpells", "1")

--- Enable queue for channeling spells
--- Default: "1"
--- SetCVar("NP_QueueChannelingSpells", "1")

--- Enable queue for terrain targeting spells
--- Default: "1"
--- SetCVar("NP_QueueTargetingSpells", "1")

--- Enable queue for on-swing spells
--- Default: "0"
--- SetCVar("NP_QueueOnSwingSpells", "0")

--- Enable queue for spells on cooldown
--- Default: "1"
--- SetCVar("NP_QueueSpellsOnCooldown", "1")

-----------------------------------------------------------------------------
-- CVars (Queue Windows in milliseconds)
-----------------------------------------------------------------------------

--- Queue window before cast finishes
--- Default: "500"
--- SetCVar("NP_SpellQueueWindowMs", "500")

--- Queue window before channel finishes
--- Default: "1500"
--- SetCVar("NP_ChannelQueueWindowMs", "1500")

--- Queue window for targeting spells
--- Default: "500"
--- SetCVar("NP_TargetingQueueWindowMs", "500")

--- Queue window for spells on cooldown
--- Default: "250"
--- SetCVar("NP_CooldownQueueWindowMs", "250")

-----------------------------------------------------------------------------
-- CVars (Buffer & Timing)
-----------------------------------------------------------------------------

--- Minimum buffer time after each cast
--- Default: "55"
--- SetCVar("NP_MinBufferTimeMs", "55")

--- Buffer time after non-GCD spells
--- Default: "100"
--- SetCVar("NP_NonGcdBufferTimeMs", "100")

--- Maximum buffer increase on server rejection
--- Default: "30"
--- SetCVar("NP_MaxBufferIncreaseMs", "30")

--- Cooldown after on-swing spells
--- Default: "500"
--- SetCVar("NP_OnSwingBufferCooldownMs", "500")

-----------------------------------------------------------------------------
-- CVars (Behavior)
-----------------------------------------------------------------------------

--- Automatically retry rejected spells
--- Default: "1"
--- SetCVar("NP_RetryServerRejectedSpells", "1")

--- Quickcast all terrain targeting spells
--- Default: "0"
--- SetCVar("NP_QuickcastTargetingSpells", "0")

--- Quickcast by double-casting targeting spells
--- Default: "0"
--- SetCVar("NP_QuickcastOnDoubleCast", "0")

--- Replace matching non-GCD category spells in queue
--- Default: "0"
--- SetCVar("NP_ReplaceMatchingNonGcdCategory", "0")

--- Optimize buffer using packet timings
--- Default: "0"
--- SetCVar("NP_OptimizeBufferUsingPacketTimings", "0")

--- Allow interrupting channels outside queue window
--- Default: "0"
--- SetCVar("NP_InterruptChannelsOutsideQueueWindow", "0")

--- Allow ending channel early by double-casting
--- Default: "0"
--- SetCVar("NP_DoubleCastToEndChannelEarly", "0")

--- Enable spam protection during server response
--- Default: "1"
--- SetCVar("NP_SpamProtectionEnabled", "1")

--- Prevent mounting when buff-capped (32 buffs)
--- Default: "1"
--- SetCVar("NP_PreventMountingWhenBuffCapped", "1")

--- Prevent right-click target change in combat
--- Default: "0"
--- SetCVar("NP_PreventRightClickTargetChange", "0")

--- Prevent right-click PvP attacks
--- Default: "0"
--- SetCVar("NP_PreventRightClickPvPAttack", "0")

-----------------------------------------------------------------------------
-- CVars (Events - All default to "0", set to "1" to enable)
-----------------------------------------------------------------------------

--- Enable AURA_CAST_ON_SELF and AURA_CAST_ON_OTHER events
--- SetCVar("NP_EnableAuraCastEvents", "1")

--- Enable AUTO_ATTACK_SELF and AUTO_ATTACK_OTHER events
--- SetCVar("NP_EnableAutoAttackEvents", "1")

--- Enable SPELL_START_SELF and SPELL_START_OTHER events
--- SetCVar("NP_EnableSpellStartEvents", "1")

--- Enable SPELL_GO_SELF and SPELL_GO_OTHER events
--- SetCVar("NP_EnableSpellGoEvents", "1")

--- Enable SPELL_HEAL events
--- SetCVar("NP_EnableSpellHealEvents", "1")

--- Enable SPELL_ENERGIZE events
--- SetCVar("NP_EnableSpellEnergizeEvents", "1")

-----------------------------------------------------------------------------
-- CVars (Channel & Latency)
-----------------------------------------------------------------------------

--- Percentage of latency to subtract from channel end
--- Default: "75" (75%)
--- SetCVar("NP_ChannelLatencyReductionPercentage", "75")

-----------------------------------------------------------------------------
-- CVars (Nameplate)
-----------------------------------------------------------------------------

--- Nameplate viewing distance in yards
--- SetCVar("NP_NameplateDistance", "40")
