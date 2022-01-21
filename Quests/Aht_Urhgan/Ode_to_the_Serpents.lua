-----------------------------------
-- Ode to the Serpents
-- Fari-Wari: !pos 80 -6 -137 50
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.ODE_TO_THE_SERPENTS)

quest.reward =
{
    item = dsp.items.IMPERIAL_GOLD_PIECE,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and
            player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.SAGA_OF_THE_SKYSERPENT) == xi.quest.status.COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(882),

            onEventFinish =
            {
                [882] = function(player, csid, option, npc)
                    quest:begin(player)
                    npcUtil.giveKeyItem(player, dsp.ki.BIYAADAS_LETTER)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] =
            {
                onTrigger = function(player, npc)
                    if player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.WHEN_THE_BOW_BREAKS) == xi.quest.status.COMPLETED and
                    player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.FIST_OF_THE_PEOPLE) == xi.quest.status.COMPLETED then
                        return quest:progressEvent(883)
                    else
                        return quest:event(891)
                    end
                end,
            },

            onEventFinish =
            {
                [883] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(dsp.ki.BIYAADAS_LETTER)
                    end
                end,
            },
        },
    },
}


return quest
