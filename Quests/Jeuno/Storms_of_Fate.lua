-----------------------------------
-- Storms of Fate
-- [3][86]
-- Dilapidated Gate !pos -260 -32 280 25
-- Unstable Displacement !pos -612 1.75 693 29
-----------------------------------
require('scripts/globals/common')
require('scripts/globals/interaction/quest')
require('scripts/globals/items')
require('scripts/globals/quests')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
-----------------------------------


local quest = Quest:new(JEUNO, STORMS_OF_FATE)

quest.reward = {}

quest.sections = {
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
                and player:getCurrentMission(COP) == DAWN
                and player:getVar("PromathiaStatus") == 7
        end,

        [dsp.zone.RULUDE_GARDENS] = {
            onRegionEnter = {
                [1] = function(player, region)
                    return quest:progressEvent(142)
                end,
            },

            onEventFinish = {
                [142] = function(player, csid, option, npc)
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

        [dsp.zone.MISAREAUX_COAST] = {
            ['_0p2'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(559)
                    end
                end,
            },

            onEventFinish = {
                [559] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },

        [dsp.zone.RIVERNE_SITE_B01] = {
            ['Unstable_Displacement'] = {
                onTrigger = function(player, npc)
                    if npc:getID() - 5 == zones[player:getZoneID()].npc.DISPLACEMENT_OFFSET and quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(1)
                    end
                end,
            },

            onEventFinish = {
                [1] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,

                [32001] = function(player, csid, option, npc)
                    if quest:getVar(player, 'Prog') == 2 then
                        quest:setVar(player, 'Prog', 3)
                        player:addTitle(dsp.title.CONQUEROR_OF_FATE)
                        player:addStatusEffect(dsp.effect.LEVEL_RESTRICTION, 50, 0, 0)
                        npcUtil.giveKeyItem(player, dsp.ki.WHISPER_OF_THE_WYRMKING)
                    end
                end,
            },
        },

        [dsp.zone.RULUDE_GARDENS] = {
            onRegionEnter = {
                [1] = function(player, region)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(143)
                    end
                end,
            },
            onEventFinish = {
                [143] = function(player, csid, option, npc)
                    quest:complete(player)
                    quest:setVar(player, 'Stage', getConquestTally())
                end,
            },
        },
    },
}

return quest
