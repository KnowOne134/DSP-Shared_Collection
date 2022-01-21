-----------------------------------
-- Rat Race
-- Kakkaroon : !pos 13 0 -25 53
-- Nadee Periyaha : !pos -11 0 -1 50
-- Cacaroon : !pos -72 0 -82 50
-- Ququroon : !pos -2 -1 66 53
-- Kyokyoroon : !pos 18 -6 10 53
-- var ratraceCS to Progress
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.RAT_RACE)

quest.reward =
{
    item = {{dsp.items.IMPERIAL_SILVER_PIECE, 3}, {dsp.items.IMPERIAL_MYTHRIL_PIECE, 2}, {dsp.items.IMPERIAL_GOLD_PIECE, 2}},
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE
        end,

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(308),

            onEventFinish =
            {
                [308] = function(player, csid, option, npc)
                    quest:begin(player)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 1
        end,

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(313),
            ['Kyokyoroon'] = quest:progressEvent(263),
        },
        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadee_Periyaha'] = quest:progressEvent(849),

            onEventFinish =
            {
                [849] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 2
        end,

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(313),
            ['Kyokyoroon'] = quest:progressEvent(263),
        },

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadee_Periyaha'] = quest:progressEvent(251),
            ['Cacaroon'] =
            {
                onTrigger = function(player, npc)
                    return quest:progressEvent(853)
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.IMPERIAL_BRONZE_PIECE) then
                        return quest:progressEvent(850)
                    end
                end,
            },

            onEventFinish =
            {
                [850] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:setVar(player, 'Prog', 3)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 3
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadee_Periyaha'] = quest:progressEvent(852),
            ['Cacaroon'] = quest:progressEvent(854),
        },

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(313),
            ['Kyokyoroon'] = quest:progressEvent(263),
            ['Ququroon'] = quest:progressEvent(309),

            onEventFinish =
            {
                [309] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 4
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadee_Periyaha'] = quest:progressEvent(852),
            ['Cacaroon'] = quest:progressEvent(854),
        },

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(313),
            ['Kyokyoroon'] = quest:progressEvent(263),
            ['Ququroon'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade,
                    {
                        dsp.items.AHTAPOT, dsp.items.ISTAKOZ, dsp.items.ISTAVRIT, dsp.items.ISTIRIDYE, dsp.items.MERCANBALIGI
                    }) then
                        return quest:progressEvent(310)
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:progressEvent(242)
                end,
            },

            onEventFinish =
            {
                [310] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:setVar(player, 'Prog', 5)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 5
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadee_Periyaha'] = quest:progressEvent(852),
            ['Cacaroon'] = quest:progressEvent(854),
        },

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(313),
            ['Ququroon'] = quest:progressEvent(315),
            ['Kyokyoroon'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.BOWL_OF_NASHMAU_STEW) then
                        return quest:progressEvent(311)
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:progressEvent(263)
                end,
            },

            onEventFinish =
            {
                [311] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:setVar(player, 'Prog', 6)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 6
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadee_Periyaha'] = quest:progressEvent(852),
            ['Cacaroon'] = quest:progressEvent(854),
        },

        [dsp.zone.NASHMAU] =
        {
            ['Kakkaroon'] = quest:progressEvent(312),
            ['Ququroon'] = quest:progressEvent(315),
            ['Kyokyoroon'] = quest:progressEvent(316),

            onEventFinish =
            {
                [312] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
}


return quest
