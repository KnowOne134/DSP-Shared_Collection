-----------------------------------
-- In the Blood
-- Aht Uhrgan Mission 32
-----------------------------------
-- !addmission 4 31
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/items')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.IN_THE_BLOOD)

mission.reward =
{
    item        = xi.items.IMPERIAL_GOLD_PIECE,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SENTINELS_HONOR },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3113, { text_table = 0 }),

            onEventFinish =
            {
                [3113] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:setVar('M[4][32]Wait', getMidnight())
                        player:needToZone(true)
                    end
                end,
            },
        },
    },
}

return mission
