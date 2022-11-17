-----------------------------------
-- Fangs of the Lion
-- Aht Uhrgan Mission 43
-----------------------------------
-- !addmission 4 42
-- Salaheem's Sentinels : !pos 24.000 -7.298 -60.600 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.FANGS_OF_THE_LION)

mission.reward =
{
    keyItem     = xi.ki.MYTHRIL_MIRROR,
    title       = xi.title.NASHMEIRAS_LOYALIST,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.NASHMEIRAS_PLEA },
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
                    return mission:progressEvent(3138, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3138] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:setPos(23.978, -6, -64.624, 63)
                        player:setVar("M[4][43]Wait", getMidnight())
                    end
                end,
            },
        },
    },
}

return mission
