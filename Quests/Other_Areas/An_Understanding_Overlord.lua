-----------------------------------
-- An Understanding Overlord
-- Monastic Cavern 
-- Peshi Yohnts !pos -179.88 -1.0 10.16
-- stone lid 
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD)

quest.reward = {
    item = dsp.items.GADZRADDS_HELM,
    title = dsp.title.ORCISH_SERJEANT,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return (player:getQuestStatus(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, A_MORAL_MANIFEST) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, A_GENEROUS_GENERAL) ~= QUEST_ACCEPTED)
         -- this, along with the other hat quests, are repeatable every conquest tally (i.e. 1 per tally). this will be a permanent var that gets reset every time the quest is redone.            
            and status ~= QUEST_ACCEPTED and os.time() > player:getVar("BstHeadGearQuest_Conquest") and not player:hasItem(dsp.items.GADZRADDS_HELM) and player:getMainLvl() >= 60
        end,

        [dsp.zone.MONASTIC_CAVERN] = {
            onZoneIn = {
                function(player, prevZone)
                    local xPos = player:getXPos()
                    local yPos = player:getYPos()
                    local zPos = player:getZPos()
                    if xPos >= -60.0 and yPos >= -19.0 and zPos >= -102.0 and
                    xPos <= -43.0 and yPos <= -15.0 and zPos <= -94.0 and quest:getVar(player, 'Prog') == 0 then
                        return 5
                    end
                end,
            },

            onEventFinish = {
                [5] = function(player, csid, option, npc)
                    if option == 0 then
                        if player:getQuestStatus(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORDT) == QUEST_COMPLETED then
                            player:delQuest(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD)
                        end
                        player:setVar("BstHeadgearQuest", 0)
                        quest:begin(player)
                    elseif option == 1 then -- if you decline, you cant start until next tally
                        player:setVar("BstHeadGearQuest_Conquest", getConquestTally())
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.SOUTHERN_SAN_DORIA] = {
            ['Faulpie'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressCutscene(760)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(761)
                    elseif quest:getVar(player, 'Prog') == 2 then 
                        if os.time() > quest:getVar(player, 'Option') then
                            return quest:progressCutscene(765)
                        else
                            return quest:cutscene(763)    
                        end
                    elseif quest:getVar(player, 'Prog') == 3 and not player:hasItem(dsp.items.ORC_HELM_CUTTING) then
                        return quest:progressCutscene(764)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.BUFFALO_HIDE, dsp.items.SQUARE_OF_RAM_LEATHER, {"gil", 10000}}) then
                        return quest:progressCutscene(762)
                    end
                end,
            },

            onEventFinish = {
                [760] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
                [761] = function(player, csid, option, npc)
                    if option == 100 then
                        -- note: you are able to reobtain the quest after cancelling, without a conquest wait
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)
                        player:setVar('BstHeadGearQuest_Conquest', 0) 
                        player:delQuest(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD)
                    end
                end,
                [762] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player, 'Prog', 2)
                    quest:setVar(player, 'Option', getVanaMidnight())
                end,
                [765] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    npcUtil.giveItem(player, dsp.items.ORC_HELM_CUTTING)
                end,
                [764] = function(player, csid, option, npc)
                    if option == 0 and player:getGil() >= 100000 then 
                        player:delGil(100000)
                        quest:setVar(player, 'Prog', 2)
                        quest:setVar(player, 'Option', getVanaMidnight())
                    elseif option == 100 then
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)
                        player:setVar('BstHeadGearQuest_Conquest', 0) 
                        player:delQuest(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD)
                    end
                end,                        
            },
        },

        [dsp.zone.MONASTIC_CAVERN] = {
            ['Cryptexphere'] = {
                onTrigger = function(player, npc, trade)
                    local headEquip = player:getEquipID(dsp.slot.HEAD)
                    if headEquip == dsp.items.ORC_HELM and player:hasKeyItem(dsp.ki.COMMUNICATION_FROM_TZEE_XICU) then
                        player:messageSpecial(zones[player:getZoneID()].text.PLACE_WITHIN)
                        return quest:progressCutscene(7)
                    elseif quest:getVar(player,'Prog') == 5 and headEquip == dsp.items.ORC_HELM then
                        return quest:progressCutscene(8)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.ORC_HELM}) and quest:getVar(player,'Prog') == 6 then
                        return quest:progressCutscene(9)
                    end
                end,                
            },


            onEventFinish = {
                [6] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.COMMUNICATION_FROM_TZEE_XICU)
                    quest:setVar(player, 'Prog', 4)
                end,
                [7] = function(player, csid, option, npc)
                    local zone = zones[player:getZoneID()]
                    npcUtil.popFromQM(player, npc, {zone.mob.UNDERSTANDING_OVERLORD_OFFSET, zone.mob.UNDERSTANDING_OVERLORD_OFFSET + 1, zone.mob.UNDERSTANDING_OVERLORD_OFFSET + 2,
                    zone.mob.UNDERSTANDING_OVERLORD_OFFSET + 3, zone.mob.UNDERSTANDING_OVERLORD_OFFSET + 4, zone.mob.UNDERSTANDING_OVERLORD_OFFSET + 5, zone.mob.UNDERSTANDING_OVERLORD_OFFSET + 6},{hide = 0})
                end,
                [8] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 6)
                end,
                [9] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:complete(player)
                    player:setVar("BstHeadGearQuest_Conquest", getConquestTally())
                end,
            },

            ['Orcish_Overlord'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    for i = 1,6 do
                        if GetMobByID(mob:getID() + i):isAlive() then
                            DespawnMob(mob:getID() + i)
                        end
                    end
                    if quest:getVar(player, 'Prog') == 4 then
                        quest:setVar(player, 'Prog', 5)
                        player:delKeyItem(dsp.ki.COMMUNICATION_FROM_TZEE_XICU)
                    end
                end,
            }
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.MONASTIC_CAVERN] = {
            onEventFinish = {
                [10] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.GOLD_BEASTCOIN) then
                        player:setVar("BstHeadgearQuest", 1)
                    end
                end,
            },
        },
    },
}

return quest
