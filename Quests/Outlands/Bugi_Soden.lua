-----------------------------------
-- Bugi Soden
-- Ryoma !pos -23 0 -9 252
-- qm1 !pos 110 15 162 213
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/weaponskillids")
-----------------------------------

local quest = Quest:new(OUTLANDS, BUGI_SODEN)

quest.reward = {
    fame = 30,
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:canEquipItem(dsp.items.KODACHI_OF_TRIALS, true) and
                player:getCharSkillLevel(dsp.skill.KATANA) / 10 >= 250 and
                not player:hasKeyItem(dsp.keyItem.WEAPON_TRAINING_GUIDE)
        end,

        [dsp.zone.NORG] = {
            ['Ryoma'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(184) -- start
                end,
            },

            onEventFinish = {
                [184] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.KODACHI_OF_TRIALS)and option == 1 then
                        npcUtil.giveKeyItem(player, dsp.keyItem.WEAPON_TRAINING_GUIDE)
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

        [dsp.zone.NORG] = {
            ['Ryoma'] = {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(dsp.ki.ANNALS_OF_TRUTH) then
                        return quest:progressEvent(189) -- complete
                    elseif player:hasKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH) then
                        return quest:event(188) -- cont 2
                    else
                        return quest:event(185) -- cont 1
                    end
                end,

                onTrade = function(player, npc, trade)
                    local wsPoints = (trade:getItem(0):getWeaponskillPoints())
                    if npcUtil.tradeHasExactly(trade, dsp.items.KODACHI_OF_TRIALS) then
                        if wsPoints < 300 then
                            return quest:event(186) -- unfinished weapon
                        else
                            return quest:progressEvent(187) -- finished weapon
                        end
                    end
                end,
            },

            onEventFinish = {
                [185] = function(player, csid, option, npc)
                    if option == 2 then
                        player:delQuest(OUTLANDS, BUGI_SODEN)
                        player:delKeyItem(dsp.ki.WEAPON_TRAINING_GUIDE)
                        player:delKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                    elseif not player:hasItem(dsp.items.KODACHI_OF_TRIALS) then
                        npcUtil.giveItem(player, dsp.items.KODACHI_OF_TRIALS)
                    end
                end,
                [187] = function(player, csid, option, npc)
                    player:confirmTrade()
                    npcUtil.giveKeyItem(player, dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                end,
                [189] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                    player:delKeyItem(dsp.ki.ANNALS_OF_TRUTH)
                    player:delKeyItem(dsp.ki.WEAPON_TRAINING_GUIDE)
                    player:addLearnedWeaponskill(dsp.ws_unlock.BLADE_KU)
                    player:messageSpecial(zones[player:getZoneID()].text.BLADE_KU_LEARNED)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.LABYRINTH_OF_ONZOZO] = {
            ['qm1'] = {
                onTrigger = function(player, npc)
                    if player:getLocalVar('killed_wsnm') == 1 then
                        player:setLocalVar('killed_wsnm', 0)
                        player:addKeyItem(dsp.ki.ANNALS_OF_TRUTH)
                        return quest:messageSpecial(zones[player:getZoneID()].text.KEYITEM_OBTAINED, dsp.ki.ANNALS_OF_TRUTH)
                    elseif player:hasKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH) and not player:hasKeyItem(dsp.keyItem.ANNALS_OF_TRUTH) and npcUtil.popFromQM(player, npc, zones[player:getZoneID()].mob.MEGAPOD_MEGALOPS, {hide = 0}) then
                        return quest:messageSpecial(zones[player:getZoneID()].text.SENSE_OMINOUS_PRESENCE)
                    end
                end,
            },
            ['Megapod_Megalops'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    player:setLocalVar('killed_wsnm', 1)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status >= QUEST_AVAILABLE
        end,

        [dsp.zone.LABYRINTH_OF_ONZOZO] = {
            ['qm1'] = {
                onTrigger = function(player, npc)
                    return quest:messageSpecial(zones[player:getZoneID()].text.NOTHING_OUT_OF_ORDINARY)
                end,
            },
        },
    },
}


return quest
