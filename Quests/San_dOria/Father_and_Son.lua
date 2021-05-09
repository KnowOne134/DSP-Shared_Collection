-----------------------------------
-- Father and Son
-- Ailbeche Northern San d'Oria !pos 4 -1 24 231
-- Exoroche Southern San d'Oria !pos 72 -1 60 230
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/quests')
require('scripts/globals/titles')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------

local quest = Quest:new(SANDORIA, FATHER_AND_SON)

quest.reward = {
    fame = 30,
    item = dsp.items.WILLOW_FISHING_ROD,
    title = dsp.title.LOST_CHILD_OFFICER,
}

quest.sections = {
    -- Section: Begin quest
    {
        check = function(player, status)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.NORTHERN_SAN_DORIA] = {
            ['Ailbeche'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(508)
                end,
            },

            onEventFinish = {
                [508] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.SOUTHERN_SAN_DORIA] = {
            ['Exoroche'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(542)
                    end
                end,
            },
            onEventFinish = {
                [542] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },

        [dsp.zone.NORTHERN_SAN_DORIA] = {
            ['Ailbeche'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(509)
                    end
                end,
            },
            onEventFinish = {
                [509] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
    {
        check = function(player, status)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.NORTHERN_SAN_DORIA] ={
            ['Ailbeche'] = {
                onTrade = function(player, npc, trade)
                    if not player:hasTitle(dsp.title.FAMILY_COUNSELOR) and npcUtil.tradeHasExactly(trade, dsp.items.WILLOW_FISHING_ROD) then
                        return quest:progressEvent(61)
                    end
                end,
            },
            onEventFinish = {
                [61] = function(player, csid, option, npc)
                    player:addTitle(dsp.title.FAMILY_COUNSELOR)
                    player:confirmTrade()
                end,
            },
        },
    },
}

return quest
