-----------------------------------
-- Luck of the Draw
-- Corsair Job Flag Quest
-----------------------------------
-- Log ID: 6, Quest ID: 6
-- Ratihb           : !pos 75.225 -6.000 -137.203 50
-- Mafwahb          : !pos 149.11 -2.000 -2.7127 50
-- qm6 (H-10 / Boat): !pos 468.767 -12.292 111.817 54
-- qm1              : !pos -62.239 -7.9619 -137.12 57
-- _1l0 (Rock Slab) : !pos -99 -7 -91 57
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/titles")
require('scripts/globals/interaction/quest')
-----------------------------------
local talaccaCoveID = require("scripts/zones/Talacca_Cove/IDs")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, LUCK_OF_THE_DRAW)

quest.reward =
{
    item  = dsp.items.CORSAIR_DIE,
    title = dsp.title.SEAGULL_PHRATRIE_CREW_MEMBER,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and player:getMainLvl() >= 30
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ratihb'] =
            {
                onTrigger = function(player, npc)
                    return quest:progressEvent(547)
                end,
            },

            onEventFinish =
            {
                [547] = function(player, csid, option, npc)
                    quest:begin(player)
                    quest:setVar(player, 'Prog', 1)
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
            ['Mafwahb'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(548)
                    end
                end,
            },

            onEventFinish =
            {
                [548] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },

        [dsp.zone.ARRAPAGO_REEF] =
        {
            ['qm6'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 then
                        return quest:progressCutscene(211)
                    end
                end,
            },

            onEventFinish =
            {
                [211] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,
            },
        },

        [dsp.zone.TALACCA_COVE] =
        {
            ['qm1'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(2)
                    end
                end,
            },

            ['_1l0'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 4 then
                        return quest:progressEvent(3)
                    end
                end,
            },

            onEventFinish =
            {
                [2] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    npcUtil.giveKeyItem(player, dsp.ki.FORGOTTEN_HEXAGUN)
                end,

                [3] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(dsp.ki.FORGOTTEN_HEXAGUN)
                        player:unlockJob(dsp.job.COR)
                        player:messageSpecial(talaccaCoveID.text.YOU_CAN_NOW_BECOME_A_CORSAIR)
                    end
                end,
            },
        }
    },

    {
        check = function(player, status, vars)
            -- Event 552 is a once event that can occur after completing "Luck of the Draw"
            -- but before finishing Equipped for all Occasions.  This charvar is cleaned up
            -- on complete of Equipped for all Occasions when quest:complete() is called.
            return status == QUEST_COMPLETED and
                player:getVar("Quest[6][24]Stage") == 0 and
                not player:hasCompletedQuest(AHT_URHGAN, EQUIPPED_FOR_ALL_OCCASIONS)
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Ratihb'] =
            {
                onTrigger = function(player, npc)
                    return quest:progressEvent(552)
                end,
            },

            onEventFinish =
            {
                [552] = function(player, csid, option, npc)
                    player:setVar("Quest[6][24]Stage", 1)
                end,
            },
        },
    },
}

return quest
