-----------------------------------
-- Stirrings of War
-- Aht Uhrgan Mission 38
-----------------------------------
-- !addmission 4 37
-- Naja Salaheem     : !pos 22.700 -8.804 -45.591 50
-- Shaharat Teahouse : !pos 73.000 -7.000 -137.000 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.STIRRINGS_OF_WAR)

mission.reward =
{
    keyItem     = xi.ki.ALLIED_COUNCIL_SUMMONS,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.ALLIED_RUMBLINGS },
}

mission.sections =
{
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3134, { text_table = 0 }),

            onRegionEnter =
            {
                [5] = function(player, region)
                    if not player:needToZone() and os.time() >= mission:getVar(player, 'Wait') then
                        return mission:progressEvent(3136, { text_table = 0 })
                    end
                end,
            },

            onEventFinish =
            {
                [3136] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
