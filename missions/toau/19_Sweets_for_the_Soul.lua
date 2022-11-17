-----------------------------------
-- Sweets for the Soul
-- Aht Uhrgan Mission 19
-----------------------------------
-- !addmission 4 18
-- Shaharat Teahouse : !pos 73.000 -7.000 -137.000 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.SWEETS_FOR_THE_SOUL)

mission.reward =
{
    title       = xi.title.KARABABAS_TOUR_GUIDE,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.TEAHOUSE_TUMULT },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            onRegionEnter =
            {
                [5] = function(player, region)
                    return mission:progressEvent(3092)
                end,
            },

            onEventFinish =
            {
                [3092] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
