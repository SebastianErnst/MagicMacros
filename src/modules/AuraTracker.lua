AuraTracker                        = {}
AuraTracker.__index                = AuraTracker

-- SELF
local PATTERN_BUFF_GAIN_SELF = "You gain ([^%(%.]+)%s*%(?(%d*)%)?%."
local PATTERN_AURA_FADE_SELF = "^(.+) fades from you%.$"
local PATTERN_DEBUFF_GAIN_SELF = "^You are afflicted by (.+)%.$"

function AuraTracker:new()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
    frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
    --frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")

    frame:SetScript("OnEvent", function()
        local event = event
        local combatLogText = arg1

        if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or event == "CHAT_MSG_SPELL_SELF_BUFF" then
            handleBuffGained(combatLogText)
        end

        if event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
            handleBuffLost(combatLogText)
        end
    end)

    function handleBuffGained(combatLogText)
        local _, _, buffName, stacks = string.find(combatLogText, PATTERN_BUFF_GAIN_SELF)
        local stacks = tonumber(stacks) or 1

    end

    function handleBuffLost(combatLogText)
        local _, _, buffName = string.find(combatLogText, PATTERN_AURA_FADE_SELF)
    end

    local public = {}
end

AuraTracker:new()

SetPlayer
