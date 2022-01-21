-----------------------------------
-- Soothing Waters
-- Fari-Wari    : !pos 80 -6 -137 50
-- Eunheem      : !pos -56 0 -3 50
-- Nadeey       : !pos 80 0 55 50
-- Mihli Aliapoh: !pos -22.615 -7 78.907 48
-- qm10         : !pos 352 2 376 68
-- Logid 6 Questid 47
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.SOOTHING_WATERS)

quest.reward =
{
    item = dsp.items.IMPERIAL_GOLD_PIECE,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and
            player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.ODE_TO_THE_SERPENTS) == xi.quest.status.COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(894, {text_table = 0}),

            onEventFinish =
            {
                [894] = function(player, csid, option, npc)
                    if option == 0 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 0
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(906),
            ['Eunheem'] = quest:progressEvent(895, {text_table = 0}),

            onEventFinish =
            {
                [895] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 1
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(906),
            ['Eunheem'] = quest:progressEvent(907),
            ['Nadeey'] = quest:progressEvent(896, {text_table = 0}),

            onEventFinish =
            {
                [896] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 2
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(906),
            ['Eunheem'] = quest:progressEvent(907),
        },

        [dsp.zone.AL_ZAHBI] =
        {
            ['Mihli_Aliapoh'] = quest:progressEvent(289),

            onEventFinish =
            {
                [289] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 3
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(906),
            ['Eunheem'] = quest:progressEvent(907),
        },

        [dsp.zone.AYDEEWA_SUBTERRANE] =
        {
            ['qm10'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.TUFT_OF_COLORFUL_HAIR) then
                        return quest:progressCutscene(34)
                    end
                end,
            },
            onEventFinish =
            {
                [34] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    player:confirmTrade()
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 4
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(897, {text_table = 0}),
            ['Eunheem'] = quest:progressEvent(907),

            onEventFinish =
            {
                [897] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:addCurrency("imperial_standing", 500)
                        player:messageSpecial(zones[player:getZoneID()].text.BESIEGED_OFFSET)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Eunheem'] = quest:progressEvent(285),
        },

        [dsp.zone.AL_ZAHBI] =
        {
            ['Rughadjeen'] =
            {
                onTringger = function(player, npc)
                    return quest:progressEvent(284, {[0] = getMercenaryRank(player)})
                end,
            },
            ['Gadalar'] = quest:progressEvent(285),
            ['Mihli_Aliapoh'] = quest:progressEvent(286),
            ['Zazarg'] = quest:progressEvent(287),
            ['Najelith'] = quest:progressEvent(288),
        },
    },
}

return quest
