-----------------------------------
-- Missionary Moblin
-- Koblakiq !pos -64.851 21.834 -117.521 11
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------


local quest = Quest:new(OTHER_AREAS_LOG, MISSIONARY_MOBLIN)

quest.reward = {
    gil = 4000,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            ['Koblakiq'] = {
                onTrigger = function(player, npc)
                    return quest:progressCutscene(7)
                end,
            },

            onEventFinish = {
                [7] = function(player, csid, option, npc)
                    if option == 1 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            ['Koblakiq'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.SOILED_LETTER) then
                        return quest:progressCutscene(9)
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:event(8)
                end,
            },

            onEventFinish = {
                [9] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:confirmTrade()
                        player:needToZone(true)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            ['Koblakiq'] = {
                onTrigger = function(player, npc)
                    return quest:event(12)
                end,
            },
        },
    },
}

return quest
