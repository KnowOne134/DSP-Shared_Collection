-----------------------------------
-- Bastion of Knowledge
-- Aht Uhrgan Mission 28
-----------------------------------
-- !addmission 4 27
-- : !pos 75.000 -3.000 25.000 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.BASTION_OF_KNOWLEDGE)

mission.reward =
{
    title       = xi.title.APHMAUS_MERCENARY,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.PUPPET_IN_PERIL },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3116, { text_table = 0 }),

            onRegionEnter =
            {
                [4] = function(player, region)
                    return mission:progressEvent(3112)
                end,
            },

            onEventFinish =
            {
                [3112] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
