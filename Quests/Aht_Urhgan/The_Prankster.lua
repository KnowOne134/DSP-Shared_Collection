-----------------------------------
-- The Prankster
-- Ahaadah !pos -70 -6 105 50
-- Aht Whitegate region 6
-- Aht Whitegate region 7
-- qm4 !pos 460.166 -14.920 256.214 52
-- Log: 6, Quest: 60
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/zone")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, THE_PRANKSTER)
local ID = require("scripts/zones/Bhaflau_Thickets/IDs")

quest.reward = {
    keyItem = dsp.ki.MAP_OF_CAEDARVA_MIRE,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ahaadah'] = quest:progressEvent(1),

            onEventFinish =
            {
                [1] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 1
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ahaadah'] = quest:event(15),
            onRegionEnter =
            {
                [6] = function(player, region)
                    return quest:progressEvent(2)
                end,
            },

            onEventFinish =
            {
                [2] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 2
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ahaadah'] = quest:event(16),

            onRegionEnter =
            {
                [7] = function(player, region)
                    return quest:progressEvent(3)
                end,
            },

            onEventFinish =
            {
                [3] = function(player, csid, option, npc)
                    return quest:setVar(player, 'Prog', 3)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 3
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ahaadah'] = quest:event(17),
        },

        [dsp.zone.BHAFLAU_THICKETS] =
        {
            ['qm4'] =
            {
                onTrigger = function(player, npc)
                    if not GetMobByID(ID.mob.PLAGUE_CHIGOE):isSpawned() then
                        return quest:progressCutscene(1)
                    end
                end,
            },

            ['Plague_Chigoe'] =
            {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    quest:setVar(player, 'Prog', 4)
                end,
            },

            onEventFinish =
            {
                [1] = function(player, csid, option, npc)
                    npcUtil.popFromQM(player, npc, ID.mob.PLAGUE_CHIGOE, {hide = 0})
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 4
        end,

        [dsp.zone.BHAFLAU_THICKETS] =
        {
            ['Ahaadah'] = quest:event(17),

            ['qm4'] = quest:progressCutscene(2),

            onEventFinish =
            {
                [2] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
}


return quest
