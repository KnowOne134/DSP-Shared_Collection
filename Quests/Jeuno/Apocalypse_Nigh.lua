-----------------------------------
-- Apocalypse Nigh
-- RuLude Gardens (Region 1)
-- Sealions Den (Zone in)
-- Gate of the gods !pos -20 -2.25 -280 34
-- Empyreal Paradox !pos 540 -1 -597 36
-- Aldo !pos 21 4 -61 245
-- Gilgamesh !pos
-- qm1 !pos 533 -1 -592 36
-----------------------------------
require('scripts/globals/common')
require('scripts/globals/interaction/quest')
require('scripts/globals/items')
require('scripts/globals/quests')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
-----------------------------------


local quest = Quest:new(JEUNO, APOCALYPSE_NIGH)

quest.reward = {
    title = dsp.title.BREAKER_OF_THE_CHAINS,
}

quest.sections = {
    {
        check = function(player, status, vars)
            return player:getQuestStatus(JEUNO, SHADOWS_OF_THE_DEPARTED) == QUEST_COMPLETED
                and status == QUEST_AVAILABLE
                and not player:needToZone() and player:getVar("Quest[3][88]Stage") < os.time()
        end,

        [dsp.zone.RULUDE_GARDENS] = {
            onRegionEnter = {
                [1] = function(player, region)
                    return quest:progressEvent(123)
                end,
            },

            onEventFinish = {
                [123] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.SEALIONS_DEN] = {
            onZoneIn = {
                function(player, prevZone)
                    if quest:getVar(player, 'Prog') == 0 then
                        return 29
                    end
                end,
            },

            onEventFinish = {
                [29] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },

        [dsp.zone.GRAND_PALACE_OF_HUXZOI] = {
            ['_iya'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(4)
                    end
                end,
            },

            onEventFinish = {
                [4] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:setPos(-419.995, 0, 248.483, 191, 35)
                end,
            },
        },

        [dsp.zone.EMPYREAL_PARADOX] = {
            ['Transcendental'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 then
                        return quest:progressEvent(4)
                    end
                end,
            },

            onEventFinish = {
                [4] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,

                [32001] = function(player, csid, option, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        quest:setVar(player, 'Prog', 4)
                        player:startEvent(7)
                    end
                end,

                [7] = function(player, csid, option, npc)
                    player:setPos(-0.075, -10, -465.1132, 63, 33)
                end,
            },
        },

        [dsp.zone.LOWER_JEUNO] = {
            ['Aldo'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 4 and player:getRank() >= 5 then
                        return quest:progressEvent(10057)
                    elseif quest:getVar(player, 'Prog') == 5 then
                        return quest:event(10058)
                    end
                end,
            },
            ['Sattal-Mansal'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 5 then
                        return quest:progressEvent(10061)
                    end
                end,
            },            
            ['Yin_Pocanakhu'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 5 then
                        return quest:progressEvent(10060)
                    end
                end,
            },    
            onEventFinish = {
                [10057] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 5)
                    quest:setVar(player, 'Stage', getMidnight())
                end,
            },
        },

        [dsp.zone.NORG] = {

            ['Gilgamesh'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 5 and quest:getVar(player, 'Stage') < os.time() then
                        return quest:progressEvent(232, {[1] = dsp.items.STATIC_EARRING, [2] = dsp.items.MAGNETIC_EARRING, [3] = dsp.items.HOLLOW_EARRING, [4] = dsp.items.ETHEREAL_EARRING})
                    elseif quest:getVar(player, 'Prog') == 6 then
                        return quest:progressEvent(234, {[1] = dsp.items.STATIC_EARRING, [2] = dsp.items.MAGNETIC_EARRING, [3] = dsp.items.HOLLOW_EARRING, [4] = dsp.items.ETHEREAL_EARRING})
                    end
                end,
            },

            ['_700'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 5 and quest:getVar(player, 'Stage') > os.time() then
                        return quest:event(235)
                    end
                end,
            },
            onEventFinish = {
                [232] = function(player, csid, option, npc)
                    if option == 0 then
                        quest:setVar(player, 'Prog', 6)
                    elseif option > 0 then
                        npcUtil.giveItem(player, dsp.items.MUSICAL_EARRING + option)
                        quest:complete(player)
                        player:completeMission(COP, DAWN)
                        player:addMission(COP, THE_LAST_VERSE)
                        player:setVar("PromathiaStatus", 0)
                        player:completeMission(ZILART, AWAKENING)
                        player:addMission(ZILART, THE_LAST_VERSE)
                        player:setVar("ZilartStatus", 0)
                    end
                end,
                [234] = function(player, csid, option, npc)
                    if option > 0 then
                        npcUtil.giveItem(player, dsp.items.MUSICAL_EARRING + option)
                        quest:complete(player)
                        player:completeMission(COP, DAWN)
                        player:addMission(COP, THE_LAST_VERSE)
                        player:setVar("PromathiaStatus", 0)
                        player:completeMission(ZILART, AWAKENING)
                        player:addMission(ZILART, THE_LAST_VERSE)
                        player:setVar("ZilartStatus", 0)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.NORG] = {
            ['Gilgamesh'] = {
                onTrigger = function(player, npc)
                    quest:event(233)
                end,
            },
        },

        [dsp.zone.EMPYREAL_PARADOX] = {
            ['qm1'] = {
                onTrigger = function(player, npc)
                    local earRings = {
                        dsp.items.STATIC_EARRING, dsp.items.MAGNETIC_EARRING, dsp.items.HOLLOW_EARRING, dsp.items.ETHEREAL_EARRING
                    }

                    for _, earRing in pairs(earRings) do
                        if player:hasItem(earRing) then
                            return quest:messageSpecial(zones[player:getZoneID()].text.QM_TEXT)
                        end
                        return quest:progressEvent(5)
                    end
                end,
            },

            onEventFinish = {
                [5] = function(player, csid, option, npc)
                    if option == 1 then
                        player:delMission(COP, THE_LAST_VERSE)
                        player:delMission(ZILART, THE_LAST_VERSE)
                        player:addMission(COP, DAWN)
                        player:addMission(ZILART, AWAKENING)
                        player:setVar("ZilartStatus", 3)
                        player:setVar("PromathiaStatus", 7)
                        player:delQuest(JEUNO, SHADOWS_OF_THE_DEPARTED)
                        player:delQuest(JEUNO, APOCALYPSE_NIGH)
                    end
                end,
            },
        },
    },
}

return quest
