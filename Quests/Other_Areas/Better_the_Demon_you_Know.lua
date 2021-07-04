-----------------------------------
-- Better the Demon You Know
-- Koblakiq !pos -64.851 21.834 -117.521 11
-- qm2 !pos 19.400,-24.141,19.185
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, BETTER_THE_DEMON_YOU_KNOW)

quest.reward = {
    item = dsp.items.GOBLIN_GRENADE,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return player:getQuestStatus(OTHER_AREAS_LOG, FOR_THE_BIRDS) == QUEST_COMPLETED
            and player:needToZone() == false
            and status == QUEST_AVAILABLE
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            ['Koblakiq'] = {
                onTrigger = function(player, npc)
                    return quest:progressCutscene(20, {[1] = dsp.items.DEMON_PEN, [2] = dsp.items.DEMON_PEN})
                end,
            },

            onEventFinish = {
                [20] = function(player, csid, option, npc)
                    quest:begin(player)
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
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.DEMON_PEN) then
                        return quest:progressCutscene(22)
                    end
                end,
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressCutscene(21, {[1] = dsp.items.DEMON_PEN})
                    elseif quest:getVar(player, 'Prog') == 1 and os.time() > quest:getVar(player, 'Stage') then
                        return quest:progressCutscene(24)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(23)                        
                    elseif quest:getVar(player, 'Prog') == 2 then
                        return quest:progressCutscene(25)
                    elseif quest:getVar(player, 'Prog') == 3 then
                        return quest:progressCutscene(26)
                    end
                end,
            },

            onEventFinish = {
                [22] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    quest:setVar(player, 'Stage', getMidnight())
                    player:tradeComplete()
                end,
                [24] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,                
                [26] = function(player, csid, option, npc)
                    quest:complete(player)
                    player:delKeyItem(dsp.keyItem.ZEELOZOKS_EARPLUG)
                end,
            },
        },

        [dsp.zone.CASTLE_ZVAHL_BAILEYS] = {
            ['qm2'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 and not player:hasKeyItem(dsp.ki.ZEELOZOKS_EARPLUG)then
                        if quest:getVar(player, 'Option') == 1 then
                            quest:setVar(player, 'Option', 0)
                            quest:setVar(player, 'Prog', 3)                                
                            return npcUtil.giveKeyItem(player, dsp.ki.ZEELOZOKS_EARPLUG)
                        elseif npcUtil.popFromQM(player, npc, {zones[player:getZoneID()].mob.MARQUIS_OFFSET, zones[player:getZoneID()].mob.MARQUIS_OFFSET + 1, zones[player:getZoneID()].mob.MARQUIS_OFFSET + 2,
                        zones[player:getZoneID()].mob.MARQUIS_OFFSET+3,zones[player:getZoneID()].mob.MARQUIS_OFFSET+4}, {hide = 0}) then
                            player:messageSpecial(zones[player:getZoneID()].text.MOBLIN_EARPLUG)
                            return quest:messageSpecial(zones[player:getZoneID()].text.MOBLIN_EARPLUG+1)
                        end
                    elseif player:hasKeyItem(dsp.ki.ZEELOZOKS_EARPLUG) then
                        return quest:messageSpecial(zones[player:getZoneID()].text.MOBLIN_EARPLUG+2)
                    end
                end,
            },
            ['Marquis_Andrealphus'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    for i = 1,4 do
                        if GetMobByID(mob:getID() + i):isAlive() then
                            DespawnMob(mob:getID() + i)
                        end
                    end
                    if quest:getVar(player, 'Prog') == 2 then
                       quest:setVar(player, 'Option', 1)
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
                    return quest:event(27):importantOnce()
                end,
            },
        },
    },
}

return quest
