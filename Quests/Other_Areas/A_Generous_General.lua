-----------------------------------
-- A Generous General
-- Oldton south eastern zone line !zone north gusta !pos 566 -12 685
-- Faulpie !pos -179.88 -1.0 10.16
-- iron box !pos -140.95 7.51 157.20
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, A_GENEROUS_GENERAL)

quest.reward = {
    item = dsp.items.CHOPLIXS_COIF,
    title = dsp.title.MOBLIN_KINSMAN,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return (player:getQuestStatus(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, A_MORAL_MANIFEST) ~= QUEST_ACCEPTED)
            and status ~= QUEST_ACCEPTED and os.time() > player:getVar("BstHeadGearQuest_Conquest") and not player:hasItem(dsp.items.CHOPLIXS_COIF) and player:getMainLvl() >= 60
        -- this and other bstmn hat quests, are repeatable every conquest tally (i.e. 1 per tally). this will be a permanent var that gets reset every time the quest is redone.             
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            onZoneIn = {
                function(player, prevZone)
                    local xPos = player:getXPos()
                    local yPos = player:getYPos()
                    local zPos = player:getZPos()
                    if xPos >= -323.0 and yPos >= 6.0 and zPos >= -261.0 and 
                    xPos <= -321.0 and yPos <= 9.0 and zPos <= -258.0 and quest:getVar(player, 'Prog') == 0 then
                        return 60
                    end
                end,
            },

            onEventFinish = {
                [60] = function(player, csid, option, npc)
                    if option == 0 then
                        if player:getQuestStatus(OTHER_AREAS_LOG, A_GENEROUS_GENERAL) == QUEST_COMPLETED then
                            player:delQuest(OTHER_AREAS_LOG, A_GENEROUS_GENERAL)
                        end
                        quest:begin(player)
                        player:setVar("BstHeadgearQuest", 1)
                    elseif option == 1 then
                        player:setVar("BstHeadGearQuest_Conquest", getConquestTally()) -- if you decline, you can't start until next tally
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
                        return quest:progressCutscene(770)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(771)
                    elseif quest:getVar(player, 'Prog') == 2 then 
                        if os.time() > quest:getVar(player, 'Option') then
                            return quest:progressCutscene(775)
                        else
                            return quest:cutscene(773)    
                        end
                    elseif quest:getVar(player, 'Prog') == 3 and not player:hasItem(dsp.items.GOBLIN_COIF_CUTTING) then
                        return quest:progressCutscene(774)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.BUFFALO_HIDE, dsp.items.SQUARE_OF_SHEEP_LEATHER, {"gil", 10000}}) then
                        return quest:progressEvent(772)
                    end
                end,
            },

            onEventFinish = {
                [770] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
                [771] = function(player, csid, option, npc)
                    if option == 100 then
                        -- note: you are able to reobtain the quest after cancelling, without a conquest wait
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)
                        player:delQuest(OTHER_AREAS_LOG, A_GENEROUS_GENERAL)
                    end
                end,
                [772] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player, 'Prog', 2)
                    quest:setVar(player, 'Option', getVanaMidnight())
                end,
                [775] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    npcUtil.giveItem(player, dsp.items.GOBLIN_COIF_CUTTING)
                end,
                [774] = function(player, csid, option, npc)
                    if option == 0 and player:getGil() >= 100000 then 
                        player:delGil(100000)
                        quest:setVar(player, 'Prog', 2)
                        quest:setVar(player, 'Option', getVanaMidnight())
                    elseif option == 100 then
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)
                        player:setVar("BstHeadGearQuest_Conquest", 0)
                        player:delQuest(OTHER_AREAS_LOG, A_GENEROUS_GENERAL)
                    end
                end,                        
            },
        },

        [dsp.zone.OLDTON_MOVALPOLOS] = {
            ['Iron_Box'] = {
                onTrigger = function(player, npc, trade)
                    local headEquip = player:getEquipID(dsp.slot.HEAD)
                    if headEquip == dsp.items.GOBLIN_COIF and player:hasKeyItem(dsp.ki.GOBLIN_RECOMMENDATION_LETTER) then
                        player:messageSpecial(zones[player:getZoneID()].text.RECOMMENDATION_LETTER)
                        return quest:progressCutscene(62)
                    elseif quest:getVar(player,'Prog') == 5 and headEquip == dsp.items.GOBLIN_COIF then
                        return quest:progressCutscene(63)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.GOBLIN_COIF}) and quest:getVar(player, 'Prog') == 6 then
                        return quest:progressEvent(64)
                    end
                end,                
            },

            onEventFinish = {
                [61] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.GOBLIN_RECOMMENDATION_LETTER)
                    quest:setVar(player, 'Prog', 4)
                end,
                [62] = function(player, csid, option, npc)
                    local zone = zones[player:getZoneID()]
                    npcUtil.popFromQM(player, npc, {zone.mob.PRECEPTOR_OFFSET, zone.mob.PRECEPTOR_OFFSET + 1, zone.mob.PRECEPTOR_OFFSET +2,
                    zone.mob.PRECEPTOR_OFFSET + 3, zone.mob.PRECEPTOR_OFFSET + 4, zone.mob.PRECEPTOR_OFFSET + 5, zone.mob.PRECEPTOR_OFFSET + 6},{hide = 0})
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

            ['Goblin_Preceptor'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    for i = 1,6 do
                        if GetMobByID(mob:getID() + i):isAlive() then
                            DespawnMob(mob:getID() + i)
                        end
                    end
                    if quest:getVar(player, 'Prog') == 4 then
                        quest:setVar(player, 'Prog', 5)
                        player:delKeyItem(dsp.ki.GOBLIN_RECOMMENDATION_LETTER)
                    end
                end,
            }
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.OLDTON_MOVALPOLOS] = {
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
