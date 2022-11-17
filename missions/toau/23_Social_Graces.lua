-----------------------------------
-- Social Graces
-- Aht Uhrgan Mission 23
-----------------------------------
-- !addmission 4 22
-- Salaheem's Sentinels : !pos 36.000 -6.600 -51.900 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.SOCIAL_GRACES)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.FOILED_AMBITION },
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
                    return mission:progressEvent(3095)
                end,
            },

            onEventFinish =
            {
                [3095] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:needToZone(true)
                        player:setVar("M[4][23]Wait", vanaDay())
                    end
                end,
            },
        },
    },
}

return mission
