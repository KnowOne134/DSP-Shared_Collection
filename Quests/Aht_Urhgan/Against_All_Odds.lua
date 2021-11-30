-----------------------------------
-- Against All Odds
-- Corsair AF Hat Quest
-----------------------------------
-- Log ID: 6, Quest ID: 26
-- Aht Urhgan Region 5   : !pos 73 -7 -137 50
-- Arrapago Reef Region 1: !pos -462 -4 -420 54
-- Arrapago Reef Zonein  : !zone 54
-- Ratihb                : !pos 75.225 -6.000 -137.203 50
-- Cutter                : !pos -462 -2 -394 54
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/status")
require("scripts/globals/titles")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, AGAINST_ALL_ODDS)

quest.reward =
{
    item  = dsp.items.CORSAIRS_TRICORNE,
    title = dsp.title.PARAGON_OF_CORSAIR_EXCELLENCE,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:getQuestStatus(AHT_URHGAN, NAVIGATING_THE_UNFRIENDLY_SEAS) == QUEST_COMPLETED and
                player:getMainJob() == dsp.job.COR and
                player:getMainLvl() >= 50
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            onRegionEnter = {
                [5] = function(player, region)
                    return quest:progressEvent(797)
                end,
            },

            onEventFinish =
            {
                [797] = function(player, csid, option, npc)
                    quest:begin(player)
                    quest:setVar(player, 'Prog', 1)
                    npcUtil.giveKeyItem(player, dsp.ki.LIFE_FLOAT)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ratihb'] = {
                onTrigger = function(player, npc)
                    if not player:hasKeyItem(dsp.ki.LIFE_FLOAT) then
                        return quest:progressEvent(604)
                    end
                end,
            },

            onEventFinish =
            {
                [604] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.LIFE_FLOAT)
                end,
            },
        },

        [dsp.zone.ARRAPAGO_REEF] =
        {
            ['Cutter'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(238)
                    end
                end,
            },
            onRegionEnter = {
                [1] = function(player, region)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(237)
                    end
                end,
            },

            onZoneIn = {
                function(player, prevZone)
                    if quest:getVar(player, 'Prog') == 3 then
                        return 238
                    end
                end,
            },

            onEventFinish =
            {
                [237] = function(player, csid, option, npc)
                    player:startEvent(240)
                end,
                [240] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
                [238] = function(player, csid, option, npc)
                    player:setPos(-456, -3, -405, 64)
                    quest:complete(player)
                end,
            },
        },
    },
}

return quest
