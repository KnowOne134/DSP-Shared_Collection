-----------------------------------
-- Passing Glory
-- Aht Uhrgan Mission 18
-----------------------------------
-- !addmission 4 17
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------
require('scripts/globals/interaction/mission')
require("scripts/globals/besieged")
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PASSING_GLORY)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SWEETS_FOR_THE_SOUL },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
                not player:needToZone() and
                os.time() >= vars.Wait
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            onRegionEnter =
            {
                [3] = function(player, region)
                    return mission:progressEvent(3090, { text_table = 0 })
                end,
            },

            onEventUpdate =
            {
                [3090] = function(player, csid, option)
                    player:updateEvent(getMercenaryRank(player),0,0,0,0,0,0,0)
                end,
            },

            onEventFinish =
            {
                [3090] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
