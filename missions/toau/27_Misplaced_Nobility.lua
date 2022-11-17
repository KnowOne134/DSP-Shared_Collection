-----------------------------------
-- Misplaced Nobility
-- Aht Uhrgan Mission 27
-----------------------------------
-- !addmission 4 26
-- 16 : !pos -298.000 36.000 -38.000 68
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.MISPLACED_NOBILITY)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.BASTION_OF_KNOWLEDGE },
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
        },

        [xi.zone.AYDEEWA_SUBTERRANE] =
        {
            ['16'] = mission:progressCutscene(12),

            onEventFinish =
            {
                [12] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
