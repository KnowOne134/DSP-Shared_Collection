-----------------------------------
-- A Moral Manifest
-- entrance to Altar Room !pos -34.84 24.03 59.77
-- Ponono !search ponono
-- stone lid !search stone_lid
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, A_MORAL_MANIFEST)

quest.reward = {
    item = dsp.items.TSOO_HAJAS_HEADGEAR,
    title = dsp.title.YAGUDO_INITIATE,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return (player:getQuestStatus(OTHER_AREAS_LOG, AN_AFFABLE_ADAMANTKING) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, AN_UNDERSTANDING_OVERLORD) ~= QUEST_ACCEPTED
            and player:getQuestStatus(OTHER_AREAS_LOG, A_GENEROUS_GENERAL) ~= QUEST_ACCEPTED)
         -- this, along with the other hat quests, are repeatable every conquest tally (i.e. 1 per tally). this will be a permanent var that gets reset every time the quest is redone.            
            and status ~= QUEST_ACCEPTED and os.time() > player:getVar("BstHeadGearQuest_Conquest") and not player:hasItem(dsp.items.TSOO_HAJAS_HEADGEAR) and player:getMainLvl() >= 60
        end,

        [dsp.zone.ALTAR_ROOM] = {
            onZoneIn = {
                function(player, prevZone)
                    local xPos = player:getXPos()
                    local yPos = player:getYPos()
                    local zPos = player:getZPos()
                    if xPos >= -267 and yPos >= 11 and zPos >= -103 and
                    xPos <= -247 and yPos <= 16 and zPos <= -94 and quest:getVar(player, 'Prog') == 0 then
                        return 46
                    end
                end,
            },

            onEventFinish = {
                [46] = function(player, csid, option, npc)
                    if option == 0 then
                        if player:getQuestStatus(OTHER_AREAS_LOG, A_MORAL_MANIFEST) == QUEST_COMPLETED then
                            player:delQuest(OTHER_AREAS_LOG, A_MORAL_MANIFEST)
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

        [dsp.zone.WINDURST_WOODS] = {
            ['Ponono'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressCutscene(700)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(701)
                    elseif quest:getVar(player, 'Prog') == 2 then 
                        if os.time() > quest:getVar(player, 'Option') then
                            return quest:progressCutscene(705)
                        else
                            return quest:cutscene(703)    
                        end
                    elseif quest:getVar(player, 'Prog') == 3 and not player:hasItem(dsp.items.YAGUDO_HEADDRESS_CUTTING) then
                        return quest:progressCutscene(704)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.SQUARE_OF_RAINBOW_CLOTH, dsp.items.SQUARE_OF_VELVET_CLOTH, {"gil", 10000}}) then
                        return quest:progressCutscene(702)
                    end
                end,
            },

            onEventFinish = {
                [700] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
                [701] = function(player, csid, option, npc)
                    if option == 100 then
                        -- note: you are able to reobtain the quest after cancelling, without a conquest wait
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)                        
                        player:delQuest(OTHER_AREAS_LOG, A_MORAL_MANIFEST)
                    end
                end,
                [702] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player, 'Prog', 2)
                    quest:setVar(player, 'Option', getVanaMidnight())
                end,
                [705] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    npcUtil.giveItem(player, dsp.items.YAGUDO_HEADDRESS_CUTTING)
                end,
                [704] = function(player, csid, option, npc)
                    if option == 0 and player:getGil() >= 100000 then 
                        player:delGil(100000)
                        quest:setVar(player, 'Prog', 2)
                        quest:setVar(player, 'Option', getVanaMidnight())
                    elseif option == 100 then
                        player:messageSpecial(zones[player:getZoneID()].text.QUEST_CANCELLED)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Option', 0)
                        player:setVar("BstHeadGearQuest_Conquest", 0) -- can cancel and still re-get quests, or acquire a new one
                        player:delQuest(OTHER_AREAS_LOG, A_MORAL_MANIFEST)
                    end
                end,                        
            },
        },

        [dsp.zone.ALTAR_ROOM] = {
            ['Stone_Lid'] = {
                onTrigger = function(player, npc, trade)
                    local headEquip = player:getEquipID(dsp.slot.HEAD)
                    if headEquip == dsp.items.YAGUDO_HEADGEAR and player:hasKeyItem(dsp.ki.VAULT_QUIPUS) then
                        player:messageSpecial(zones[player:getZoneID()].text.QUIPUS_PLACE)
                        return quest:progressCutscene(48)
                    elseif quest:getVar(player,'Prog') == 5 and headEquip == dsp.items.YAGUDO_HEADGEAR then
                        return quest:progressCutscene(49)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.YAGUDO_HEADGEAR}) and quest:getVar(player,'Prog') == 6 then
                        return quest:progressCutscene(50)
                    end
                end,                
            },


            onEventFinish = {
                [47] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.VAULT_QUIPUS)
                    quest:setVar(player, 'Prog', 4)
                end,
                [48] = function(player, csid, option, npc)
                    local zone = zones[player:getZoneID()]
                    npcUtil.popFromQM(player, npc, {zone.mob.YAGUDO_AVATAR_OFFSET, zone.mob.YAGUDO_AVATAR_OFFSET + 3, zone.mob.YAGUDO_AVATAR_OFFSET + 4,
                    zone.mob.YAGUDO_AVATAR_OFFSET + 5, zone.mob.YAGUDO_AVATAR_OFFSET + 6, zone.mob.YAGUDO_AVATAR_OFFSET + 7, zone.mob.YAGUDO_AVATAR_OFFSET + 8},{hide = 0})
                end,
                [49] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 6)
                end,                
                [50] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:complete(player)
                    player:setVar("BstHeadGearQuest_Conquest", getConquestTally())
                end,
            },

            ['Yagudo_Avatar'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    for i = 3,8 do
                        if GetMobByID(mob:getID() + i):isAlive() then
                            DespawnMob(mob:getID() + i)
                        end
                    end
                    if quest:getVar(player, 'Prog') == 4 then
                        quest:setVar(player, 'Prog', 5)
                        player:delKeyItem(dsp.ki.VAULT_QUIPUS)
                    end
                end,
            }
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.ALTAR_ROOM] = {
            onEventFinish = {
                [51] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.GOLD_BEASTCOIN) then
                        player:setVar("BstHeadgearQuest", 1)
                    end
                end,
            },
        },
    },
}

return quest
