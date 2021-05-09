-----------------------------------
-- Growing Flowers
-- Kuu Mohzolhi !pos -123 0 80 231
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require('scripts/globals/interaction/quest')
require("scripts/globals/npc_util")
-----------------------------------

local quest = Quest:new(SANDORIA, GROWING_FLOWERS)

quest.reward = {
    fame = 120,
}

local otherFlowers =
{
    636, 835, 938, 941, 948, 949, 950, 951, 956, 957, 959, 1120, 1410, 1411, 1412, 1413, 1725, 2507, 2554, 2960
}

quest.otherFlowers = function(player, trade)
    for _, item in pairs(otherFlowers) do
        if trade:getItemId() == item then
            return item
        end
    end
    return false
end

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.NORTHERN_SAN_DORIA] = {
            ['Kuu_Mohzolhi'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.MARGUERITE) then
                        return quest:progressEvent(605, {[1] = 231,[2] = 2})
                    elseif npcUtil.tradeHasExactly(trade, quest.otherFlowers(player, trade)) then
                        return quest:progressEvent(605, {[1] = 231,[2] = 1})
                    else
                        return quest:progressEvent(605, {[1] = 231,[2] = 0})
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:progressEvent(605, {[1] = 231, [2] = 10})
                end,
            },

            onEventFinish = {
                [605] = function(player, csid, option, npc)
                    if option == 1 then
                        player:confirmTrade()
                        quest:begin(player)
                    elseif option == 1002 then
                        player:confirmTrade()
                        player:moghouseFlag(1)
                        player:messageSpecial(zones[player:getZoneID()].text.MOGHOUSE_EXIT)
                        quest:complete(player)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.NORTHERN_SAN_DORIA] = {
            ['Kuu_Mohzolhi'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.MARGUERITE) then
                        return quest:progressEvent(605, {[1] = 231,[2] = 2})
                    elseif npcUtil.tradeHasExactly(trade, quest.otherFlowers(player, trade)) then
                        return quest:progressEvent(605, {[1] = 231,[2] = 3})
                    else
                        return quest:progressEvent(605, {[1] = 231,[2] = 0})
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:progressEvent(605, {[1] = 231, [2] = 10})
                end,
            },

            onEventFinish = {
                [605] = function(player, csid, option, npc)
                    if option == 1002 then
                        player:confirmTrade()
                        player:moghouseFlag(1)
                        player:messageSpecial(zones[player:getZoneID()].text.MOGHOUSE_EXIT)
                        quest:complete(player)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.NORTHERN_SAN_DORIA] = {
            ['Kuu_Mohzolhi'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.MARGUERITE) then
                        return quest:progressEvent(605, {[1] = 231,[2] = 3})
                    elseif npcUtil.tradeHasExactly(trade, quest.otherFlowers(player, trade)) then
                        return quest:progressEvent(605, {[1] = 231,[2] = 1})
                    else
                        return quest:progressEvent(605, {[1] = 231,[2] = 0})
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:progressEvent(605, {[1] = 231, [2] = 10})
                end,
            },
        },
    },
}

return quest
