-----------------------------------
-- Rock Bottom
-- !pos 838.243 -14.475 231.871 61
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, ROCK_BOTTOM)

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.MOUNT_ZHAYOLM] = {
            ['11'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(7)
                end,
            },

            onEventFinish = {
                [7] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.MOUNT_ZHAYOLM] = {
            ['11'] = {
                onTrade = function(player, npc, trade)
                    if quest:getVar(player, 'Prog') == 1 and npcUtil.tradeHasExactly(trade, dsp.items.PICKAXE) then
                        return quest:progressEvent(8)
                    elseif not player:needToZone() and quest:getVar(player, 'Prog') == 2 and npcUtil.tradeHas(trade, {dsp.items.MYTHRIL_PICK, dsp.items.MYTHRIL_PICK_HQ}, true, true) then
                        return quest:progressEvent(9, {[0] = trade:getItemId()})
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:messageSpecial(zones[player:getZoneID()].text.NOTHING_HAPPENS)
                end,
            },

            onEventFinish = {
                [8] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:needToZone(true)
                end,
                [9] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:complete(player)
                    npcUtil.giveKeyItem(player, dsp.ki.MAP_OF_MOUNT_ZHAYOLM)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.MOUNT_ZHAYOLM] = {
            ['11'] = {
                onTrigger = function(player, npc)
                    return quest:messageSpecial(zones[player:getZoneID()].text.NOTHING_HAPPENS)
                end,
            },
        },
    },
}


return quest
