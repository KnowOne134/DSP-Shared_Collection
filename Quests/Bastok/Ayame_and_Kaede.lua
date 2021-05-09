-----------------------------------
-- Ayame and Kaede
-- Kaede !pos 48 -6 67 236
-- Kagetora !pos -96 -2 29 236
-- qm2 !pos -208 -9 176 173
-- Ensetsu !pos 33 -6 67 236
-- Ryoma !pos -23 0 -9 252
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/settings")
-----------------------------------

local quest = Quest:new(BASTOK, AYAME_AND_KAEDE)

quest.reward = {
    title = dsp.title.SHADOW_WALKER,
    fame = 30,
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and player:getMainLvl() >= 30
        end,

        [dsp.zone.PORT_BASTOK] = {
            ['Kaede'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(240)
                end,
            },

            onEventFinish = {
                [240] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.PORT_BASTOK] = {
            ['Kagetora'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(241)
                    elseif quest:getVar(player, 'Prog') > 2 then
                        return quest:event(244)
                    end
                end,
            },
            ['Ensetsu'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') >= 1 and quest:getVar(player, 'Prog') <= 2 and not player:hasKeyItem(dsp.ki.STRANGELY_SHAPED_CORAL) then
                        return quest:event(242)
                    elseif quest:getVar(player, 'Prog') == 2 and player:hasKeyItem(dsp.ki.STRANGELY_SHAPED_CORAL) then
                        return quest:progressEvent(245)
                    elseif quest:getVar(player, 'Prog') == 3 then
                        return quest:event(243)
                    elseif player:hasKeyItem(dsp.ki.SEALED_DAGGER) then
                        return quest:progressEvent(246, {[0] = dsp.ki.SEALED_DAGGER})
                    end
                end,
            },

            onEventFinish = {
                [241] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
                [242] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
                [245] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,
                [246] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(dsp.ki.SEALED_DAGGER)
                        player:unlockJob(dsp.job.NIN)
                        player:messageSpecial(zones[player:getZoneID()].text.UNLOCK_NINJA)
                    end
                end,
            },
        },

        [dsp.zone.KORROLOKA_TUNNEL] = {
            ['qm2'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 and not player:hasKeyItem(dsp.ki.STRANGELY_SHAPED_CORAL) then
                        if (not GetMobByID(zones[player:getZoneID()].mob.KORROLOKA_LEECH_I):isSpawned() and not GetMobByID(zones[player:getZoneID()].mob.KORROLOKA_LEECH_II):isSpawned()
                        and not GetMobByID(zones[player:getZoneID()].mob.KORROLOKA_LEECH_III):isSpawned()) then
                            if quest:getVar(player, 'Stage') == 1 then
                                if quest:getVar(player, 'Option') == 1 then
                                    npc:hideNPC(FORCE_SPAWN_QM_RESET_TIME)
                                    quest:setVar(player, 'Option', 0)
                                end
                                quest:setVar(player, 'Stage', 0)
                                return npcUtil.giveKeyItem(player, dsp.ki.STRANGELY_SHAPED_CORAL)
                            elseif npcUtil.popFromQM(player, npc, {zones[player:getZoneID()].mob.KORROLOKA_LEECH_I, zones[player:getZoneID()].mob.KORROLOKA_LEECH_II, zones[player:getZoneID()].mob.KORROLOKA_LEECH_III}, {hide = 0, claim = false}) then
                                quest:setVar(player, 'Option', 1)
                                return quest:messageSpecial(zones[player:getZoneID()].text.SENSE_OF_BOREBODING)
                            end
                        end
                    end
                end,
            },
            ['Korroloka_Leech'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    if GetMobByID(zones[player:getZoneID()].mob.KORROLOKA_LEECH_I):isDead() and GetMobByID(zones[player:getZoneID()].mob.KORROLOKA_LEECH_II):isDead() and GetMobByID(zones[player:getZoneID()].mob.KORROLOKA_LEECH_III):isDead() then
                        if quest:getVar(player, 'Prog') == 2 then
                            quest:setVar(player, 'Stage', 1)
                        end
                    end
                end,
            },
        },

        [dsp.zone.NORG] = {
            ['Ryoma'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(95)
                    end
                end,
            },
            onEventFinish = {
                [95] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    npcUtil.giveKeyItem(player, dsp.ki.SEALED_DAGGER)
                    player:delKeyItem(dsp.ki.STRANGELY_SHAPED_CORAL)
                end,
            },
        },
    },
}


return quest
