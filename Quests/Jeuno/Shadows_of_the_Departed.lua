-----------------------------------
-- Shadows of the Departed
-- _0id Dem !pos 220 0 340 18
-- _0k0 Mea !pos 259 0 179 20
-- _0gc Holla !pos 99 -1 -140 16
-----------------------------------
require('scripts/globals/common')
require('scripts/globals/items')
require("scripts/globals/pets/fellow")
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------


local quest = Quest:new(JEUNO, SHADOWS_OF_THE_DEPARTED)

quest.reward = {}

quest.sections = {

     {
        check = function(player, status, vars)
            return player:getQuestStatus(JEUNO, STORMS_OF_FATE) == QUEST_COMPLETED
            and player:getCurrentMission(ZILART) == AWAKENING
            and player:getVar("ZilartStatus") >= 3
            and status == QUEST_AVAILABLE
            and player:getVar("Quest[3][86]Stage") < os.time()
        end,

        [dsp.zone.RULUDE_GARDENS] = {
            onRegionEnter = {
                [1] = function(player, region)
                    return quest:progressEvent(161)
                end,
            },

            onEventFinish = {
                [161] = function(player, csid, option, npc)
                    player:setVar("Quest[3][86]Stage", 0)
                    quest:begin(player)
                    npcUtil.giveKeyItem(player, dsp.ki.NOTE_WRITTEN_BY_ESHANTARL)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.PROMYVION_DEM] = {
            ['_0id'] = {
                onTrigger = function(player, npc)
                    if not player:hasKeyItem(dsp.ki.PROMYVION_DEM_SLIVER) then
                        return npcUtil.giveKeyItem(player, dsp.ki.PROMYVION_DEM_SLIVER)
                    end
                end,
            },
        },

        [dsp.zone.PROMYVION_MEA] = {
            ['_0k0'] = {
                onTrigger = function(player, npc)
                    if not player:hasKeyItem(dsp.ki.PROMYVION_MEA_SLIVER) then
                        return npcUtil.giveKeyItem(player, dsp.ki.PROMYVION_MEA_SLIVER)
                    end
                end,
            },
        },

        [dsp.zone.PROMYVION_HOLLA] = {
            ['_0gc'] = {
                onTrigger = function(player, npc)
                    if not player:hasKeyItem(dsp.ki.PROMYVION_HOLLA_SLIVER) then
                        return npcUtil.giveKeyItem(player, dsp.ki.PROMYVION_HOLLA_SLIVER)
                    end
                end,
            },
        },

        [dsp.zone.RULUDE_GARDENS] = {
            onRegionEnter = {
                [1] = function(player, region)
                    if player:hasKeyItem(dsp.ki.PROMYVION_HOLLA_SLIVER) and player:hasKeyItem(dsp.ki.PROMYVION_DEM_SLIVER) and player:hasKeyItem(dsp.ki.PROMYVION_MEA_SLIVER) then
                        return quest:progressEvent(162)
                    end
                end,
            },

            onEventFinish = {
                [162] = function(player, csid, option, npc)
                    quest:complete(player)
                    quest:setVar(player, 'Stage', getMidnight())
                    player:delKeyItem(dsp.ki.PROMYVION_HOLLA_SLIVER)
                    player:delKeyItem(dsp.ki.PROMYVION_DEM_SLIVER)
                    player:delKeyItem(dsp.ki.PROMYVION_MEA_SLIVER)
                    player:messageSpecial(zones[player:getZoneID()].text.YOU_HAND_THE_THREE_SLIVERS)
                end,
            },
        },
    },
}

return quest
