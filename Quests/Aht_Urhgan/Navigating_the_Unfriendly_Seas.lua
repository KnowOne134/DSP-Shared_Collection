-----------------------------------
-- Navigating the Unfriendly Seas
-- Corsair AF Legs Quest
-----------------------------------
-- Log ID: 6, Quest ID: 25
-- qm6 (H-10 / Boat): !pos 468.767 -12.292 111.817 54
-- Leleroon         : !pos -14.687 0.000 25.114 53
-- Leypoint         : !pos -200.027 -8.500 80.058 51
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/status")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, NAVIGATING_THE_UNFRIENDLY_SEAS)

quest.reward =
{
    item  = dsp.items.CORSAIRS_CULOTTES,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:getQuestStatus(AHT_URHGAN, EQUIPPED_FOR_ALL_OCCASIONS) == QUEST_COMPLETED and
                player:getMainJob() == dsp.job.COR and
                player:getMainLvl() >= 50
        end,

        [dsp.zone.ARRAPAGO_REEF] =
        {
            ['qm6'] =
            {
                onTrigger = function(player, npc)
                    return quest:progressCutscene(232)
                end,
            },

            onEventFinish =
            {
                [232] = function(player, csid, option, npc)
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

        [dsp.zone.NASHMAU] =
        {
            ['Leleroon'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.HYDROGAUGE}) and quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(283)
                    end
                end,
            },

            onEventFinish =
            {
                [283] = function(player, csid, option, npc)
                    quest:begin(player)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            ['Leypoint'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.HYDROGAUGE}) and quest:getVar(player, 'Prog') == 2 then
                        player:confirmTrade()
                        quest:setVar(player, 'Prog', 3)
                        quest:setVar(player, 'Stage', getMidnight())
                        return quest:messageSpecial(zones[player:getZoneID()].text.PLACE_HYDROGAUGE, dsp.items.HYDROGAUGE)
                    end
                end,

                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        if quest:getVar(player, 'Stage') >= os.time() then
                            return quest:messageSpecial(zones[player:getZoneID()].text.ENIGMATIC_LIGHT, dsp.items.HYDROGAUGE)
                        else
                            return quest:progressCutscene(508)
                        end
                    end
                end,
            },

            onEventFinish =
            {
                [508] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    quest:setVar(player, 'Stage', 0)
                end,
            },
        },

        [dsp.zone.ARRAPAGO_REEF] =
        {
            ['qm6'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 4 then
                        return quest:progressCutscene(233)
                    end
                end,
            },

            onEventFinish =
            {
                [233] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
}

return quest
