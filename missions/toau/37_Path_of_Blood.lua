-----------------------------------
-- Path of Blood
-- Aht Uhrgan Mission 37
-----------------------------------
-- !addmission 4 36
-- Salaheem's Sentinels : !pos 24.000 -7.298 -60.600 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PATH_OF_BLOOD)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.STIRRINGS_OF_WAR },
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
                    -- Event 3131 will automatically move the player to the end point
                    player:startEvent(3131)
                    return mission:progressEvent(3220)
                end,
            },

            onEventFinish =
            {
                [3220] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:needToZone(true)
                        player:setVar("M[4][37]Wait", getMidnight())
                    end
                end,
            },
        },
    },
}

return mission
