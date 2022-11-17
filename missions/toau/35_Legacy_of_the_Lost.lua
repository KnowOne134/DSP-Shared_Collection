-----------------------------------
-- Legacy of the Lost
-- Aht Uhrgan Mission 35
-----------------------------------
-- !addmission 4 34
-- Rock Slab : !pos -100.000 -9.399 -87.000 57
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.LEGACY_OF_THE_LOST)

mission.reward =
{
    title       = xi.title.GESSHOS_MERCY,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.GAZE_OF_THE_SABOTEUR },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.TALACCA_COVE] =
        {
            onEventFinish =
            {
                [32001] = function(player, csid, option, npc)
                    if mission:getLocalVar(player, 'Prog') == 1 then
                        mission:complete(player)
                    end
                end,
            },
        },
    },
}

return mission
