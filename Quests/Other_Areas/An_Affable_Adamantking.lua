-----------------------------------
-- An Affable Adamantking
-- entrance to Qulun Dome !pos -34.84 24.03 59.77
-- Peshi Yohnts 17764402
-- beastmen banner zone in to qulun
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING)

quest.reward = {
    item = dsp.items.DAVHUS_BARBUT,
    title = dsp.title.BRONZE_QUADAV,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return (player:getQuestStatus(OTHER_AREAS_LOG, A_GENEROUS_GENERAL) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, A_MORAL_MANIFEST) ~= QUEST_ACCEPTED)
         -- this, along with the other hat quests, are repeatable every conquest tally (i.e. 1 per tally). this will be a permanent var that gets reset every time the quest is redone.            
            and status ~= QUEST_ACCEPTED and os.time() > player:getVar("BstHeadGearQuest_Conquest")
            and not player:hasItem(dsp.items.DAVHUS_BARBUT) and player:getMainLvl() >= 60
        end,

        [dsp.zone.QULUN_DOME] = {
            onZoneIn = {
                function(player, prevZone)
                    local xPos = player:getXPos()
                    local yPos = player:getYPos()
                    local zPos = player:getZPos()
                    if xPos >= 2.0 and yPos >= 22.0 and zPos >= 56.0 and 
                    xPos <= 24.0 and yPos <= 24.0 and zPos <= 63.0 and quest:getVar(player, 'Prog') == 0 then
                        return 60
                    end
                end,
            },

            onEventFinish = {
                [60] = function(player, csid, option, npc)
                    if option == 0 then
                        if player:getQuestStatus(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING) == QUEST_COMPLETED then
                            player:delQuest(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING)
                        end
                        quest:begin(player)
                        player:setVar("BstHeadgearQuest", 0)
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

        [dsp.zone.WINDURST_WOODS] = {
            ['Peshi_Yohnts'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressCutscene(710)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(711)
                    elseif quest:getVar(player, 'Prog') == 2 then 
                        if os.time() > quest:getVar(player, 'Option') then
                            return quest:progressCutscene(715)
                        else
                            return quest:cutscene(713)    
                        end
                    elseif quest:getVar(player, 'Prog') == 3 and not player:hasItem(dsp.items.SET_OF_QUADAV_BARBUT_PARTS) then
                        return quest:progressCutscene(714)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.SQUARE_OF_BUGARD_LEATHER, dsp.items.TURTLE_SHELL, {"gil", 10000}}) then
                        return quest:progressCutscene(712)
                    end
                end,
            },

            onEventFinish = {
                [710] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
                [711] = function(player, csid, option, npc)
                    if option == 100 then
                        -- note: you are able to reobtain the quest after cancelling, without a conquest wait
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)                        
                        player:delQuest(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING)
                    end
                end,
                [712] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player, 'Prog', 2)
                    quest:setVar(player, 'Option', getVanaMidnight())
                end,
                [715] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    npcUtil.giveItem(player, dsp.items.SET_OF_QUADAV_BARBUT_PARTS)
                end,
                [714] = function(player, csid, option, npc)
                    if option == 0 and player:getGil() >= 100000 then 
                        player:delGil(100000)
                        quest:setVar(player, 'Prog', 2)
                        quest:setVar(player, 'Option', getVanaMidnight())
                    elseif option == 100 then
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)
                        player:setVar("BstHeadGearQuest_Conquest", 0) -- can immediately get another of these if you cancel
                        player:delQuest(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING)
                    end
                end,                        
            },
        },

        [dsp.zone.QULUN_DOME] = {
            ['Beastmen_s_Banner'] = {
                onTrigger = function(player, npc, trade)
                    local headEquip = player:getEquipID(dsp.slot.HEAD)
                    if headEquip == dsp.items.QUADAV_BARBUT and player:hasKeyItem(dsp.ki.ORCISH_SEEKER_BATS) then
                        player:messageSpecial(zones[player:getZoneID()].text.ORCISH_SEEKER_BATS, dsp.ki.ORCISH_SEEKER_BATS) -- this still leaves a blank, have tried adding more params and no luck
                        return quest:progressCutscene(62)
                    elseif quest:getVar(player,'Prog') == 5 and headEquip == dsp.items.QUADAV_BARBUT then
                        return quest:progressCutscene(63)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.QUADAV_BARBUT}) and quest:getVar(player,'Prog') == 5 then
                        return quest:progressCutscene(64)
                    end
                end,                
            },


            onEventFinish = {
                [61] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.ORCISH_SEEKER_BATS)
                    quest:setVar(player, 'Prog', 4)
                end,
                [62] = function(player, csid, option, npc)
                    local zone = zones[player:getZoneID()]
                    npcUtil.popFromQM(player, npc, {zone.mob.AFFABLE_ADAMANTKING_OFFSET, zone.mob.AFFABLE_ADAMANTKING_OFFSET + 1, zone.mob.AFFABLE_ADAMANTKING_OFFSET +2,
                    zone.mob.AFFABLE_ADAMANTKING_OFFSET + 3, zone.mob.AFFABLE_ADAMANTKING_OFFSET + 4, zone.mob.AFFABLE_ADAMANTKING_OFFSET + 5, zone.mob.AFFABLE_ADAMANTKING_OFFSET + 6},{hide = 0})
                end,
                [63] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 6)
                end,                
                [64] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:complete(player)
                    player:setVar("BstHeadGearQuest_Conquest", getConquestTally())
                end,
            },

            ['Diamond_Quadav'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    for i = 1,6 do
                        if GetMobByID(mob:getID() + i):isAlive() then
                            DespawnMob(mob:getID() + i)
                        end
                    end
                    if quest:getVar(player, 'Prog') == 4 then
                        quest:setVar(player, 'Prog', 5)
                        player:delKeyItem(dsp.ki.ORCISH_SEEKER_BATS)
                    end
                end,
            }
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.QULUN_DOME] = {
            onEventFinish = {
                [65] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.GOLD_BEASTCOIN) then
                        player:setVar("BstHeadgearQuest", 1)
                    end
                end,
            },
        },
    },
}

return quest
