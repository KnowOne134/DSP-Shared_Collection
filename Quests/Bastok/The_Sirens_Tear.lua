-----------------------------------
-- The Siren's Tear
-----------------------------------
-- Log ID: 1, Quest ID: 0
-- Wahid       : !pos 26.305 -1 -66.403 234
-- Otto        : !pos -145.929 -7.48 13.701 236
-- Carmelo     : !pos -146.476 -7.482 10.889 236
-- Echo Hawk   : !pos -0.965 5.999 -15.567 234
-- qm1 (moves) : !pos 309.6 2.6 324 106
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/npc_util")
require("scripts/globals/quests")
require("scripts/globals/status")
require("scripts/globals/titles")
require("scripts/globals/zone")
require("scripts/globals/interaction/quest")
-----------------------------------

local quest = Quest:new(xi.quest.log_id.BASTOK, xi.quest.id.bastok.THE_SIRENS_TEAR)

quest.reward =
{
    fame = 120,
    gil = 150,
    title = dsp.title.TEARJERKER,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE
        end,

        [dsp.zone.BASTOK_MINES] =
        {
            ['Wahid']     = quest:progressEvent(81),
            ['Echo_Hawk'] = quest:event(5),

            onEventFinish =
            {
                [81] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.PORT_BASTOK] =
        {
            ['Otto'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(5)
                    end
                end,
            },

            ['Carmelo'] = quest:progressEvent(6),

            onEventFinish =
            {
                [6] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.quest.status.COMPLETED
        end,

        [dsp.zone.PORT_BASTOK] =
        {
            ['Carmelo'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') < 2 and not player:hasItem(dsp.items.SIRENS_TEAR) then
                        return quest:progressEvent(19)
                    end
                end,
            },

            onEventFinish =
            {
                [19] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status ~= xi.quest.status.AVAILABLE
        end,

        [dsp.zone.BASTOK_MINES] =
        {
            ['Wahid'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.SIRENS_TEAR) then
                        return quest:progressEvent(82)
                    end
                end,
            },

            onEventFinish =
            {
                [82] = function(player, csid, option, npc)
                    -- This is called even after the initial complete to handle quest var cleanup
                    -- CLuaBaseEntity::completeQuest() will only actually complete the quest the
                    -- first time the player finishes this.
                    if quest:complete(player) then
                        player:confirmTrade()
                    end
                end,
            },
        },
    },
}

return quest
