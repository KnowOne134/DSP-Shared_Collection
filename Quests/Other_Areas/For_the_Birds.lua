-----------------------------------
-- For the Birds
-- Koblakiq !pos -64.851 21.834 -117.521 11
-- daa bola the seer !pos -157.978 -18.179 193.458
-- ge fhu yagudoeye !pos -91.354 -4.251 -127.831
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, FOR_THE_BIRDS)

quest.reward = {
    item = dsp.items.JAGUAR_MANTLE,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return player:getQuestStatus(OTHER_AREAS_LOG, MISSIONARY_MOBLIN) == QUEST_COMPLETED
            and player:needToZone() == false
            and status == QUEST_AVAILABLE
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            ['Koblakiq'] = {
                onTrigger = function(player, npc)
                    return quest:progressCutscene(14, {[1] = dsp.items.ARNICA_ROOT})
                end,
            },

            onEventFinish = {
                [14] = function(player, csid, option, npc)
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
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressCutscene(15, {[1] = dsp.items.ARNICA_ROOT, [2] = dsp.items.ARNICA_ROOT})
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(16, {[1] = dsp.keyItem.GLITTERING_FRAGMENT})
                    elseif quest:getVar(player, 'Prog') == 2 then
                        return quest:progressCutscene(17)
                    elseif quest:getVar(player, 'Prog') == 3 then
                        return quest:progressCutscene(18)
                    end
                end,
            },

            onEventFinish = {
                [16] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    npcUtil.giveKeyItem(player, dsp.keyItem.GLITTERING_FRAGMENT)
                end,
                [18] = function(player, csid, option, npc)
                    quest:complete(player)
                    player:needToZone(true)
                end,
            },
        },

        [dsp.zone.CASTLE_OZTROJA] = {
            ['Daa_Bola_the_Seer'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.ARNICA_ROOT) then
                        return quest:progressCutscene(87, {[1] = dsp.items.ARNICA_ROOT})
                    end
                end,

                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:cutscene(86)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:message(zones[player:getZoneID()].text.DAA_BOLA_TALK)
                    end
                end,
            },
                onEventFinish = {
                [87] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    player:confirmTrade()
                end,
            },
        },

        [dsp.zone.BEADEAUX] = {
            ['Ge_Fhu_Yagudoeye'] = {
                onTrigger = function(player, npc)
                    local mobid = zones[player:getZoneID()].mob.FOR_THE_BIRDS_OFFSET
                    if quest:getVar(player, 'Prog') == 2 and quest:getVar(player, 'Option') >= 4 and GetMobByID(mobid):isDead() and GetMobByID(mobid +1):isDead()
                    and GetMobByID(mobid+2):isDead() and GetMobByID(mobid+3):isDead() then
                        return quest:progressEvent(124)
                    elseif quest:getVar(player, 'Prog') == 2 and npc:getLocalVar("Cue") <= os.time() then
                        local mobid = zones[player:getZoneID()].mob.FOR_THE_BIRDS_OFFSET
                        player:messageSpecial(zones[player:getZoneID()].text.GE_FHU_TALK, 0, dsp.keyItem.GLITTERING_FRAGMENT)
                        SpawnMob(mobid):updateClaim(player)
                        SpawnMob(mobid +1):updateClaim(player)
                        SpawnMob(mobid +2):updateClaim(player)
                        SpawnMob(mobid +3):updateClaim(player)
                        quest:setVar(player, 'Stage', 1)
                        npc:setLocalVar("Cue", os.time() + 300)
                        return quest:messageSpecial(zones[player:getZoneID()].text.GE_FHU_TALK + 1)
                    end
                end,
            },
                onEventFinish = {
                [124] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    quest:setVar(player, 'Stage', 0)
                    quest:setVar(player, 'Option', 0)
                    player:delKeyItem(dsp.keyItem.GLITTERING_FRAGMENT)
                end,
            },

            ['Magnes_Quadav'] = {
                onMobDeath = function(mob, player, isKiller)
                    if quest:getVar(player, 'Stage') == 1 then
                        quest:setVar(player, 'Option', quest:getVar(player, 'Option') + 1)
                    end
                end,
            },
            ['Nickel_Quadav'] = {
                onMobDeath = function(mob, player, isKiller)
                    if quest:getVar(player, 'Stage') == 1 then
                        quest:setVar(player, 'Option', quest:getVar(player, 'Option') + 1)
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
                    return quest:event(19):importantOnce()
                end,
            },
        },
    },
}

return quest
