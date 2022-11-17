-----------------------------------
-- Westerly Winds
-- Aht Uhrgan Mission 7
-----------------------------------
-- !addmission 4 6
-- Region 5 : !pos 73.000 -7.000 -137.000 50
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------
require('scripts/globals/common')
require('scripts/globals/interaction/mission')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.WESTERLY_WINDS)

mission.reward =
{
    title       = xi.title.AGENT_OF_THE_ALLIED_FORCES,
    item        = xi.items.IMPERIAL_SILVER_PIECE,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.A_MERCENARY_LIFE },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 0
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {

            onRegionEnter =
            {
                [5] = function(player, region)
                    return mission:progressEvent(3027, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3027] = function(player, csid, option, npc)
                    -- Don't change order. In retail, Keyitem is gotten before item.
                    if player:getFreeSlotsCount() >= 1 then
                        npcUtil.giveKeyItem(player, xi.ki.RAILLEFALS_NOTE)
                        npcUtil.giveItem(player, xi.items.IMPERIAL_SILVER_PIECE)
                        player:setTitle(xi.title.AGENT_OF_THE_ALLIED_FORCES)
                        mission:setVar(player, 'Prog', 1)
                    end
                end,
            },
        },
    },
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 1
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3028, { text_table = 0 }),

            onEventFinish =
            {
                [3028] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:delKeyItem(xi.ki.RAILLEFALS_NOTE)
                        player:needToZone(true)
                        player:setVar("M[4][7]Wait", getMidnight())
                    end
                end,
            },
        },
    },
}

return mission
