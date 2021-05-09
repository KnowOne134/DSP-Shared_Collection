-----------------------------------
-- Saga of the Skyserpent
-- Quest[6][43]
-- Fari-Wari !pos 80 -6 -137 50
-- qm7 !pos -11 8 -185 62
-- Biyaada !pos -65.802 -6.999 69.273 48
-----------------------------------
require("scripts/globals/common")
require("scripts/globals/items")
require("scripts/globals/quests")
require('scripts/globals/interaction/quest')
require("scripts/globals/npc_util")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, SAGA_OF_THE_SKYSERPENT)

quest.reward = {
    item = dsp.items.IMPERIAL_GOLD_PIECE,
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Fari-Wari'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(823,0,0,0,0,0,0,0,0,0)
                end,
            },

            onEventFinish = {
                [823] = function(player, csid, option, npc)
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

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Fari-Wari'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:event(829)
                    elseif quest:getVar(player, 'Prog') == 2 and player:hasKeyItem(dsp.ki.LILAC_RIBBON) then
                        return quest:progressEvent(953,0,0,0,0,0,0,0,0,0)
                    elseif quest:getVar(player, 'Prog') == 3 then
                        if quest:getVar(player, 'Stage') < vanaDay() then
                            return quest:progressEvent(825,0,0,0,0,0,0,0,0,0)
                        else
                            return quest:event(833)
                        end
                    end
                end,
            },

            onEventFinish = {
                [825] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:addCurrency("imperial_standing", 1000)
                        player:messageSpecial(zones[player:getZoneID()].text.BESIEGED_OFFSET)
                    end
                end,
                [953] = function(player, csid, option, npc)
                    player:setPos(0, 0, 0, 0, 51)
                end,
            },
        },
        [dsp.zone.AL_ZAHBI] = {
            ['Biyaada'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:event(279,0,0,0,0,0,0,0,0)
                    else
                        return quest:event(278,0,0,0,0,0,0,0,0)
                    end
                end,
            },
        },

        [dsp.zone.HALVUNG] = {
            ['qm7'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        quest:setVar(player, 'Prog', 2)
                        return npcUtil.giveKeyItem(player, dsp.ki.LILAC_RIBBON)
                    end
                end,
            },
        },

        [dsp.zone.WAJAOM_WOODLANDS] = {
            onZoneIn = {
                function(player, prevZone)
                    if quest:getVar(player, 'Prog') == 2 then
                        return 12
                    end
                end
            },

            onEventFinish = {
                [12] = function(player, csid, option, npc)
                    player:startEvent(13)
                end,
                [13] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    quest:setVar(player, 'Stage', vanaDay())
                    player:delKeyItem(dsp.keyItem.LILAC_RIBBON)
                    player:setPos(80, -6, -123, 65, 50)
                end,
            },
        },
    },
}

return quest
