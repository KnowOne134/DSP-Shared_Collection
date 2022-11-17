-----------------------------------
-- Ragnarok
-- Aht Uhrgan Mission 45
-----------------------------------
-- !addmission 4 44
-- Salaheem's Sentinels : !pos 24.000 -7.298 -60.600 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.RAGNAROK)

mission.reward =
{
    title       = xi.title.NASHMEIRAS_LOYALIST,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.IMPERIAL_CORONATION },
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
                [3] = function(player, region)
                    return mission:progressEvent(3139, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3139] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
