-----------------------------------
-- Breaking the Bonds of Fate
-- Corsair Limit Break Quest (70)
-----------------------------------
-- Log ID: 6, Quest ID: 41
-- qm6  : !pos 468.767 -12.292 111.817 54
-- _110 : !pos -99 -7 -91 57
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/status")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, BREAKING_THE_BONDS_OF_FATE)

quest.reward =
{
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:getQuestStatus(AHT_URHGAN, AGAINST_ALL_ODDS) == QUEST_COMPLETED and
                player:getMainJob() == dsp.job.COR and
                player:getMainLvl() >= 66
        end,

        [dsp.zone.ARRAPAGO_REEF] =
        {
            ['qm6'] = {
                onTrigger = function(player, npc)
                    return quest:progressCutscene(234)
                end,
            },

            onEventFinish =
            {
                [234] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.ARRAPAGO_REEF] =
        {
            ['qm6'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, {dsp.items.CORSAIRS_TESTIMONY}) then
                        return quest:progressCutscene(235)
                    end
                end,
            },

            onEventFinish =
            {
                [235] = function(player, csid, option, npc)
                    player:setPos(-90, -7, -104, 200, 57)
                end,
            },
        },
    },
}

return quest
