-----------------------------------
-- The Search for Goldmane
-- rabao:
-- riverne b01: displacement !pos 389.32 52.4 692.68
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.OUTLANDS, xi.quest.id.outlands.THE_SEARCH_FOR_GOLDMANE)

quest.reward = {
    gil = 3000,
}

quest.sections = {
     {
        check = function(player, status, vars)
            return player:getQuestStatus(xi.quest.log_id.OUTLANDS, xi.quest.id.outlands.CHASING_DREAMS) == xi.quest.status.COMPLETED
            and status == xi.quest.status.AVAILABLE
        end,

        [dsp.zone.RABAO] = {
            ['Zoriboh'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(123)
                end,
            },
            onEventFinish = {
                [123] = function(player, csid, option, npc)
                    if option == 1 then
                        npcUtil.giveKeyItem(player, dsp.ki.CARE_PACKAGE)
                        quest:begin(player)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.RABAO] = {
            ['Zoriboh'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 6 then
                        return quest:progressEvent(128)
                    else
                        return quest:progressEvent(124)
                    end
                end,
            },
            ['Rudolfo'] = {
                onTrigger = function(player, npc)
                    return quest:event(126)
                end,
            },
            onEventFinish = {
                [128] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Quelveuiat'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(396)
                    end
                end,
            },
            onEventFinish = {
                [396] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },

        [dsp.zone.RIVERNE_SITE_A01] = {
            ['Spatial_Displacement'] = {
                onTrigger = function(player, npc)
                end,
            },

            ['Trunk'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.COPPER_KEY) then
                        return quest:progressEvent(41)
                    end
                end,

                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 then
                        return quest:messageSpecial(zones[player:getZoneID()].text.CLOSELY_EXAMINING)
                    elseif quest:getVar(player, 'Prog') == 3 then
                        return quest:messageSpecial(zones[player:getZoneID()].text.AFTER_CHECKING_CHEST)
                    end
                end,
            },
            onEventFinish = {
                [40] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
                [41] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player, 'Prog', 3)
                end,
            },
        },

        [dsp.zone.METALWORKS] = {
            ['Vladinek'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(887)
                    else
                        return quest:progressEvent(888)
                    end
                end,
            },
            onEventFinish = {
                [887] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },

        [dsp.zone.BIBIKI_BAY] = {
            ['Weathered_Boat'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 4 then
                        return quest:progressEvent(40)
                    elseif quest:getVar(player, 'Prog') == 5 then
                        return quest:progressEvent(37)
                    end
                end,
            },
            onEventFinish = {
                [40] = function(player, csid, option, npc)
                    if npcUtil.popFromQM(player, npc, zones[player:getZoneID()].mob.ROHEMOLIPAUD,{hide = 0}) then
                        player:messageSpecial(zones[player:getZoneID()].text.FIGHTING_FOR_LIFE)
                    end
                end,
                [37] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.DELUXE_CARBINE) then
                        quest:setVar(player, 'Prog', 6)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.COMPLETED
        end,

        [dsp.zone.RABAO] = {
            ['Zoriboh'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(129)
                end,
            },
        },
    },
}

return quest
