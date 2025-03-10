-----------------------------------
-- Old Wounds
-- Curilla !pos 27 0.1 0.1 233
-- qm3 !pos -145 2 446 208
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/weaponskillids")
-----------------------------------

local quest = Quest:new(SANDORIA, OLD_WOUNDS)

quest.reward = {
    fame = 30,
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:canEquipItem(dsp.items.SAPARA_OF_TRIALS, true) and
                player:getCharSkillLevel(dsp.skill.SWORD) / 10 >= 240 and
                not player:hasKeyItem(dsp.keyItem.WEAPON_TRAINING_GUIDE)
        end,

        [dsp.zone.CHATEAU_DORAGUILLE] = {
            ['Curilla'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(43) -- start
                end,
            },

            onEventFinish = {
                [43] = function(player, csid, option, npc)
                    if option == 1 then
                        if npcUtil.giveItem(player, dsp.items.SAPARA_OF_TRIALS) then
                            npcUtil.giveKeyItem(player, dsp.keyItem.WEAPON_TRAINING_GUIDE)
                            quest:begin(player)
                        end
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.CHATEAU_DORAGUILLE] = {
            ['Curilla'] = {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(dsp.ki.ANNALS_OF_TRUTH) then
                        return quest:progressEvent(48) -- complete
                    elseif player:hasKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH) then
                        return quest:event(47) -- cont 2
                    else
                        return quest:event(46) -- cont 1
                    end
                end,

                onTrade = function(player, npc, trade)
                    local wsPoints = (trade:getItem(0):getWeaponskillPoints())
                    if npcUtil.tradeHasExactly(trade, dsp.items.SAPARA_OF_TRIALS) then
                        if wsPoints < 300 then
                            return quest:event(45) -- unfinished weapon
                        else
                            return quest:progressEvent(44) -- finished weapon
                        end
                    end
                end,
            },

            onEventFinish = {
                [46] = function(player, csid, option, npc)
                    if option == 1 then
                        npcUtil.giveItem(player, dsp.items.SAPARA_OF_TRIALS)
                    elseif option == 2 then
                        player:delQuest(SANDORIA, OLD_WOUNDS)
                        player:delKeyItem(dsp.ki.WEAPON_TRAINING_GUIDE)
                        player:delKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                    end
                end,
                [44] = function(player, csid, option, npc)
                    player:confirmTrade()
                    npcUtil.giveKeyItem(player, dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                end,
                [48] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                    player:delKeyItem(dsp.ki.ANNALS_OF_TRUTH)
                    player:delKeyItem(dsp.ki.WEAPON_TRAINING_GUIDE)
                    player:addLearnedWeaponskill(dsp.ws_unlock.SAVAGE_BLADE)
                    player:messageSpecial(zones[player:getZoneID()].text.SAVAGE_BLADE_LEARNED)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.QUICKSAND_CAVES] = {
            ['qm3'] = {
                onTrigger = function(player, npc)
                    if player:getLocalVar('killed_wsnm') == 1 then
                        player:setLocalVar('killed_wsnm', 0)
                        player:addKeyItem(dsp.ki.ANNALS_OF_TRUTH)
                        return quest:messageSpecial(zones[player:getZoneID()].text.KEYITEM_OBTAINED, dsp.ki.ANNALS_OF_TRUTH)
                    elseif player:hasKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH) and not player:hasKeyItem(dsp.keyItem.ANNALS_OF_TRUTH) and npcUtil.popFromQM(player, npc, zones[player:getZoneID()].mob.GIRTABLULU, {hide = 0}) then
                        return quest:messageSpecial(zones[player:getZoneID()].text.SENSE_OMINOUS_PRESENCE)
                    end
                end,
            },
            ['Girtablulu'] = {
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

        [dsp.zone.QUICKSAND_CAVES] = {
            ['qm3'] = {
                onTrigger = function(player, npc)
                    return quest:messageSpecial(zones[player:getZoneID()].text.NOTHING_OUT_OF_ORDINARY)
                end,
            },
        },
    },
}


return quest
