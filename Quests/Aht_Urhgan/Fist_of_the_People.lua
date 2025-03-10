-----------------------------------
-- Fist of the People
-- Talhaal  : !pos -36 -6 107 48
-- Fari-Wari: !pos 80 -6 -137 50
-- Leypoint : !pos -200 -10 80 51
-----------------------------------
local ID = require("scripts/zones/Wajaom_Woodlands/IDs")
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/titles")
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.FIST_OF_THE_PEOPLE)

quest.reward =
{
    title = dsp.title.STONESERPENT_SHOCKTROOPER,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.ODE_TO_THE_SERPENTS) == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.AL_ZAHBI] =
        {
            ['Talhaal'] = quest:progressEvent(282),

            onEventFinish =
            {
                [282] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 0
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(884),

            onEventFinish =
            {
                [884] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 1
        end,

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            ['Leypoint'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.RUSTY_MEDAL) then
                        return quest:progressEvent(511)
                    end
                end,    
            },

            onEventFinish =
            {
                [511] = function(player, csid, option, npc)
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
