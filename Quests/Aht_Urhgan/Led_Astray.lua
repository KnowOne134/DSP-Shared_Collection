-----------------------------------
-- Led Astry
-- Log: 6, Quest: 65
-- Mhasbaf:         !pos 54.701 -6.999 11.387 50
-- Whitegate Region !pos 71 0 9.299 50
-- Tohka Telposkha: !pos 22.1 0 22.759 50
-- Rubahah:         !pos -96.746 0 -14.701 50
-- Cacaroon:        !pos -72.026 0.000 -82.337 50
-- Whitegate Region !pos 12.5 -94 2 50
-- Tataroon:        !pos -25.189 0 -39.022 53
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
require("scripts/globals/titles")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, LED_ASTRAY)

quest.reward =
{
    item = dsp.items.IMPERIAL_SILVER_PIECE,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Mhasbaf'] = quest:progressEvent(808),

            onEventFinish =
            {
                [808] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 0
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Mhasbaf'] = {
                onTrigger = function(player, npc)
                    if player:getLocalVar('Quest[6][65]Prog') == 0 then
                        return quest:progressEvent(834)
                    end
                end,
            },

            onRegionEnter =
            {
                [9] = function(player, region)
                    return quest:progressEvent(809)
                end,
            },

            onEventFinish =
            {
                [809] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,

                [834] = function(player, csid, option, npc)
                    player:setLocalVar('Quest[6][65]Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 1
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Mhasbaf'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar('Quest[6][65]Prog') == 0 then
                        return quest:progressEvent(834)
                    end
                end,
            },

            ['Tohka_Telposkha'] = quest:progressEvent(810),

            onEventFinish =
            {
                [810] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,

                [834] = function(player, csid, option, npc)
                    player:setLocalVar('Quest[6][65]Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 2
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Mhasbaf'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar('Quest[6][65]Prog') == 0 then
                        return quest:progressEvent(834)
                    end
                end,
            },

            ['Rubahah'] =
            {
                onTrigger = function(player, npc)
                    if not quest:isVarBitsSet(player, 'Stage', 1) then
                        return quest:progressEvent(811)
                    end
                end,
            },
            ['Cacaroon'] =
            {
                onTrigger = function(player, npc)
                    if not quest:isVarBitsSet(player, 'Stage', 2) then
                        return quest:progressEvent(812)
                    end
                end,
            },

            onEventFinish =
            {
                [811] = function(player, csid, option, npc)
                    if quest:isVarBitsSet(player, 'Stage', 2) then
                        quest:setVar(player, 'Prog', 3)
                    else
                        quest:setVarBit(player, 'Stage', 1)
                    end
                end,

                 [812] = function(player, csid, option, npc)
                    if quest:isVarBitsSet(player, 'Stage', 1) then
                        quest:setVar(player, 'Prog', 3)
                    else
                        quest:setVarBit(player, 'Stage', 2)
                    end
                end,

                [834] = function(player, csid, option, npc)
                    player:setLocalVar('Quest[6][65]Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 3
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Mhasbaf'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar('Quest[6][65]Prog') == 0 then
                        return quest:progressEvent(834)
                    end
                end,
            },

            onRegionEnter =
            {
                [10] = function(player, region)
                    return quest:progressEvent(813)
                end,
            },

            onEventFinish =
            {
                [813] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.LETTER_FROM_BERNAHN)
                    quest:setVar(player, 'Prog', 4)
                end,

                [834] = function(player, csid, option, npc)
                    player:setLocalVar('Quest[6][65]Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 4
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Mhasbaf'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar('Quest[6][65]Prog') == 0 then
                        return quest:progressEvent(834)
                    end
                end,
            },

            onEventFinish =
            {
                [834] = function(player, csid, option, npc)
                    player:setLocalVar('Quest[6][65]Prog', 1)
                end,
            },
        },

        [dsp.zone.NASHMAU] =
        {
            ['Tataroon'] = quest:progressEvent(305),

            onEventFinish =
            {
                [305] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(dsp.ki.LETTER_FROM_BERNAHN)
                    end
                end,
            },
        },
    },
}


return quest
