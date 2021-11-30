-----------------------------------
-- Such Sweet Sorrow
-- Dabhuh !pos 97.939 0 -91.530 50
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/zone")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, SUCH_SWEET_SORROW)

quest.reward = {
    item = dsp.items.MERROW_NO_17_LOCKET,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Dabhuh'] =
            {
                onTrigger = function(player, npc)
                    return quest:progressEvent(582, {text_table = 0})
                end,
            },

            onRegionEnter =
            {
                [8] = function(player, region)
                    if quest:getVar(player, 'Prog') == 2 then
                        return quest:progressEvent(956, {text_table = 0})
                    end
                end
            },

            onEventFinish =
            {
                [582] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    player:setPos(43.493, 5.325, -699.828, 90, dsp.zone.CAEDARVA_MIRE)
                end,

                [956] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    quest:begin(player)
                end,
            },
        },
        [dsp.zone.CAEDARVA_MIRE] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    if quest:getVar(player, 'Prog') == 1 then
                        return 29
                    end
                end
            },

            onEventFinish =
            {
                [29] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:setPos(100.023, 0, -91.762, 125, dsp.zone.AHT_URHGAN_WHITEGATE)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Dabhuh'] =
            {
                onTrigger = function(player, npc)
                    return quest:event(584, {text_table = 0})
                end,

                onTrade = function(player, npc, trade)
                    if player:getFreeSlotsCount() == 0 then
                        local ID = require("scripts/zones/Aht_Urhgan_Whitegate/IDs")
                        return quest:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, dsp.items.MERROW_NO_17_LOCKET)
                    elseif npcUtil.tradeHasExactly(trade, {dsp.items.MERROW_SCALE}) then
                        return quest:progressEvent(583, {text_table = 0})
                    end
                end,
            },

            onEventFinish =
            {
                [583] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:complete(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Dabhuh'] =
            {
                onTrigger = function(player, npc)
                    return quest:event(584)
                end,
            },
        },
    },
}


return quest
