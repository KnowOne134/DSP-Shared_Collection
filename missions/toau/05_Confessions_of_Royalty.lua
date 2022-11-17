-----------------------------------
-- Confessions of Royalty
-- Aht Uhrgan Mission 5
-----------------------------------
-- !addmission 4 4
-- Halver : !pos 2 0.1 0.1 233
-----------------------------------
require('scripts/globals/common')
require('scripts/globals/interaction/mission')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.CONFESSIONS_OF_ROYALTY)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.EASTERLY_WINDS },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and player:hasKeyItem(xi.ki.RAILLEFALS_LETTER)
        end,

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Halver'] = mission:progressEvent(564),

            onEventFinish =
            {
                [564] = function(player, csid, option, npc)
                    if option == 1 then
                        if mission:complete(player) then
                            player:delKeyItem(xi.ki.RAILLEFALS_LETTER)
                            player:setVar('M[4][5]Wait', getMidnight())
                        end
                    end
                end,
            },
        },
    },
}

return mission
