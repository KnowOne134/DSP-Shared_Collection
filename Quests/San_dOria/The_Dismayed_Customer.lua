-----------------------------------
-- The Dismayed Customer
-----------------------------------
-- Log ID: 0, Quest ID: 6
-- Gulemont : !pos -69 -5 -38 232
-- qm1      : !pos -453 -20 -230 100
-- qm2      : !pos -550 -0 -542 100
-- qm3      : !pos -399 -10 -438 100
-----------------------------------
require("scripts/globals/keyitems")
require("scripts/globals/npc_util")
require("scripts/globals/quests")
require("scripts/globals/titles")
require("scripts/globals/zone")
require("scripts/globals/interaction/quest")
-----------------------------------
local westRonfaureID = require("scripts/zones/West_Ronfaure/IDs")
-----------------------------------

local quest = Quest:new(SANDORIA, THE_DISMAYED_CUSTOMER)

quest.reward =
{
    fame = 30,
    gil = 560,
    title = dsp.title.LOST_AND_FOUND_OFFICER,
}

local function handleQm(player, qmNumber)
    if quest:getVar(player, 'Stage') == qmNumber then
        quest:setVar(player, 'Stage', 0)
        return quest:keyItem(dsp.ki.GULEMONTS_DOCUMENT)
    end
end

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
                player:hasCompletedQuest(SANDORIA, A_TASTE_FOR_MEAT)
        end,

        [dsp.zone.PORT_SAN_DORIA] =
        {
            ['Gulemont'] =
            {
                onTrigger = function(player, npc)
                    return quest:progressEvent(605)
                end,
            },

            onEventFinish =
            {
                [605] = function(player, csid, option, npc)
                    if option == 0 then
                        quest:begin(player)
                        quest:setVar(player, 'Stage', math.random(1, 3))
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.PORT_SAN_DORIA] =
        {
            ['Gulemont'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(dsp.ki.GULEMONTS_DOCUMENT) then
                        return quest:progressEvent(607)
                    else
                        return quest:progressEvent(606)
                    end
                end,
            },

            onEventFinish =
            {
                [607] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.GULEMONTS_DOCUMENT)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.WEST_RONFAURE] =
        {
            ['qm1'] =
            {
                onTrigger = function(player, npc)
                    return handleQm(player, 1)
                end,
            },

            ['qm2'] =
            {
                onTrigger = function(player, npc)
                    return handleQm(player, 2)
                end,
            },

            ['qm3'] =
            {
                onTrigger = function(player, npc)
                    return handleQm(player, 3)
                end,
            },
        },
    },
}

return quest
