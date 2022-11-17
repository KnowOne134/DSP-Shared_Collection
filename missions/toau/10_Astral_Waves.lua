-----------------------------------
-- Astral Waves
-- Aht Uhrgan Mission 10
-----------------------------------
-- !addmission 4 9
-- Region 3 : !pos 22.700 -8.804 -45.591 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/besieged')
require('scripts/globals/common')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.ASTRAL_WAVES)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.IMPERIAL_SCHEMES },
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
                    return mission:progressEvent(3052, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3052] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:setVar('M[4][10]Wait', vanaDay())
                        player:needToZone(true)
                    end
                end,
            },
        },
    },
}

return mission
