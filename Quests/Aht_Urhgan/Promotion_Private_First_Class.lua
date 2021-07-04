-----------------------------------
-- Promotion: Private First Class
-- Naja Salaheem !pos 26 -8 -45.5 50
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, PROMOTION_PRIVATE_FIRST_CLASS)

quest.reward = {
    keyItem = dsp.ki.PFC_WILDCAT_BADGE,
}

quest.sections = {
    -- Section: Begin quest
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and player:getVar("AssaultPromotion") >= 25
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Naja_Salaheem'] = quest:progressEvent(5000, { text_table = 0 }),

            onEventFinish = {
                [5000] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Naja_Salaheem'] = {
                onTrigger = function(player, npc)
                    return quest:event(5001, { text_table = 0 })
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.IMP_WING) then
                        return quest:progressEvent(5002, { text_table = 0 })
                    end
                end,
            },

            onEventFinish = {
                [5002] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:setVar("AssaultPromotion", 0)
                        player:confirmTrade()
                    end
                end,
            },
        },
    },
}

return quest
