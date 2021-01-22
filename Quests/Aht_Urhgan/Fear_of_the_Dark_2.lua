-----------------------------------
-- Fear of the Dark 2
-- Suldiran !pos 42 -7 -43 48
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/npc/quest')
require("scripts/globals/titles")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, FEAR_OF_THE_DARK_II)

quest.reward = {
    gil = 200,
    title = dsp.title.DARK_RESISTANT,
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AL_ZAHBI] = {
            ['Suldiran'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(14)
                end,
            },

            onEventFinish = {
                [14] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.AL_ZAHBI] = {
            ['Suldiran'] = {
                onTrigger = function(player, npc)
                    return quest:event(15)
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {{dsp.items.IMP_WING, 2}}) then
                        return quest:progressEvent(16)
                    end
                end,
            },

            onEventFinish = {
                [16] = function(player, csid, option, npc)
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

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Suldiran'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {{dsp.items.IMP_WING, 2}}) then
                        return quest:progressEvent(16)
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:event(15)
                end,
            },

            onEventUpdate = {
                [16] = function(player, csid, option, npc)
                    npcUtil.giveGil(player, 200) then
                    player:confirmTrade()
                end,
            },
        },
    },
}


return quest
