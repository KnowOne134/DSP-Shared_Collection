-----------------------------------
-- When the Bow Breaks
-- Gaweesh: !pos -64 -7 38 48
-- Giwahb Watchtower: !pos -339 -37 654 51
-----------------------------------
local ID = require("scripts/zones/Wajaom_Woodlands/IDs")
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/titles")
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.WHEN_THE_BOW_BREAKS)

quest.reward =
{
    title = dsp.title.GALESERPENT_GUARDIAN,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.ODE_TO_THE_SERPENTS) == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.AL_ZAHBI] =
        {
            ['Gaweesh'] = quest:progressEvent(280),

            onEventFinish =
            {
                [280] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            ['Giwahb_Watchtower'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.FRAYED_ARROW) then
                        return quest:progressEvent(512)
                    end
                end,
            },

            onEventFinish =
            {
                [512] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:confirmTrade()
                        player:messageSpecial(ID.text.INCREASED_STANDING)
                        player:addCurrency("imperial_standing", 500)
                    end
                end,
            },
        },
    },
}


return quest
