-----------------------------------
-- Puppet in Peril
-- Aht Uhrgan Mission 29
-----------------------------------
-- !addmission 4 28
-- Naja Salaheem   : !pos 22.700 -7.805 -45.591 50
-- Ornamental Door : !pos 299.000 0.000 -199.000 67
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PUPPET_IN_PERIL)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.PREVALENCE_OF_PIRATES },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3117, { text_table = 0 }),
        },

        [xi.zone.JADE_SEPULCHER] =
        {
            ['_1v0'] =
            {
                onTrigger = function(player, npc)
                    if mission:getVar(player, 'Prog') == 0 then
                        return mission:progressEvent(4)
                    end
                end,
            },

            ['Lancelord_Gaheel_Ja'] =
            {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    if mission:getVar(player, 'Prog') == 1 then
                        mission:setLocalVar(player, 'Prog', 1)
                    end
                end,
            },

            onEventFinish =
            {
                [4] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 1)
                end,

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
