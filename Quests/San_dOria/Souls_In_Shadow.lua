-----------------------------------
-- Souls In Shadow
-- Novalmauge !pos 70 -24 21 167
-- qm2 !pos 118 36 -281 160
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/weaponskillids")
-----------------------------------

local quest = Quest:new(SANDORIA, SOULS_IN_SHADOW)

quest.reward = {
    fame = 30,
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:canEquipItem(dsp.items.SCYTHE_OF_TRIALS, true) and
                player:getCharSkillLevel(dsp.skill.SCYTHE) / 10 >= 240 and
                not player:hasKeyItem(dsp.keyItem.WEAPON_TRAINING_GUIDE)
        end,

        [dsp.zone.BOSTAUNIEUX_OUBLIETTE] = {
            ['Novalmauge'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(0) -- start
                end,
            },

            onEventFinish = {
                [0] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.SCYTHE_OF_TRIALS) and option == 1 then
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

        [dsp.zone.BOSTAUNIEUX_OUBLIETTE] = {
            ['Novalmauge'] = {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(dsp.ki.ANNALS_OF_TRUTH) then
                        return quest:progressEvent(5) -- complete
                    elseif player:hasKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH) then
                        return quest:event(4) -- cont 2
                    else
                        return quest:event(3) -- cont 1
                    end
                end,

                onTrade = function(player, npc, trade)
                    local wsPoints = (trade:getItem(0):getWeaponskillPoints())
                    if npcUtil.tradeHasExactly(trade, dsp.items.SCYTHE_OF_TRIALS) then
                        if wsPoints < 300 then
                            return quest:event(2) -- unfinished weapon
                        else
                            return quest:progressEvent(1) -- finished weapon
                        end
                    end
                end,
            },

            onEventFinish = {
                [3] = function(player, csid, option, npc)
                    if option == 1 then
                        npcUtil.giveItem(player, dsp.items.SCYTHE_OF_TRIALS)
                    elseif option == 2 then
                        player:delQuest(SANDORIA, SOULS_IN_SHADOW)
                        player:delKeyItem(dsp.ki.WEAPON_TRAINING_GUIDE)
                        player:delKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                    end
                end,
                [1] = function(player, csid, option, npc)
                    player:confirmTrade()
                    npcUtil.giveKeyItem(player, dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                end,
                [5] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH)
                    player:delKeyItem(dsp.ki.ANNALS_OF_TRUTH)
                    player:delKeyItem(dsp.ki.WEAPON_TRAINING_GUIDE)
                    player:addLearnedWeaponskill(dsp.ws_unlock.SPIRAL_HELL)
                    player:messageSpecial(zones[player:getZoneID()].text.SPIRAL_HELL_LEARNED)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.DEN_OF_RANCOR] = {
            ['qm2'] = {
                onTrigger = function(player, npc)
                    if player:getLocalVar('killed_wsnm') == 1 then
                        player:setLocalVar('killed_wsnm', 0)
                        player:addKeyItem(dsp.ki.ANNALS_OF_TRUTH)
                        return quest:messageSpecial(zones[player:getZoneID()].text.KEYITEM_OBTAINED, dsp.ki.ANNALS_OF_TRUTH)
                    elseif player:hasKeyItem(dsp.ki.MAP_TO_THE_ANNALS_OF_TRUTH) and not player:hasKeyItem(dsp.keyItem.ANNALS_OF_TRUTH) and npcUtil.popFromQM(player, npc, zones[player:getZoneID()].mob.MOKUMOKUREN, {hide = 0}) then
                        return quest:messageSpecial(zones[player:getZoneID()].text.SENSE_OMINOUS_PRESENCE)
                    end
                end,
            },
            ['Mokumokuren'] = {
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

        [dsp.zone.DEN_OF_RANCOR] = {
            ['qm2'] = {
                onTrigger = function(player, npc)
                    return quest:messageSpecial(zones[player:getZoneID()].text.NOTHING_OUT_OF_ORDINARY)
                end,
            },
        },
    },
}


return quest
