-----------------------------------
-- Sentinels' Honor
-- Aht Uhrgan Mission 33
-----------------------------------
-- !addmission 4 32
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.SENTINELS_HONOR)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.TESTING_THE_WATERS },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    if
                        not player:needToZone() and
                        os.time() >= mission:getVar(player, 'Wait')
                    then
                        return mission:progressEvent(3130, { text_table = 0 })
                    else
                        local optionalVariable = mission:getLocalVar(player, 'Option') % 2 == 0 and 2 or 0
                        return mission:progressEvent(3120, { [7] = optionalVariable, text_table = 0 })
                    end
                end,
            },

            onEventFinish =
            {
                [3120] = function(player, csid, option, npc)
                    mission:setLocalVar(player, 'Option', mission:getLocalVar(player, 'Option') + 1)
                end,

                [3130] = function(player, csid, option, npc)
                    mission:complete(player)
                    player:setPos(15.32, -6, -61.162, 66)
                end,
            },
        },
    },
}

return mission
