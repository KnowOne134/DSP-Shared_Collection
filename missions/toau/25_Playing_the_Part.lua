-----------------------------------
-- Playing the Part
-- Aht Uhrgan Mission 25
-----------------------------------
-- !addmission 4 24
-- Abquhbah             : !pos 35.524 -6.60 -58.237 50
-- Naja Salaheem        : !pos 22.700 -7.805 -45.591 50
-- Salaheem's Sentinels : !pos 36.000 -6.600 -51.900 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PLAYING_THE_PART)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SEAL_OF_THE_SERPENT },
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
                    local optionalVariable = mission:getLocalVar(player, 'Option') % 2 == 0 and 1 or 2
                    mission:progressEvent(3098, { [7] = optionalVariable, text_table = 0 })
                end,
            },

            ['Abquhbah'] = mission:progressEvent(3109, { text_table = 0 }):oncePerZone(),

            onRegionEnter =
            {
                [3] = function(player, region)
                    if not player:needToZone() and vanaDay() > mission:getVar(player, 'Wait') then
                        return mission:progressEvent(3110)
                    end
                end,
            },

            onEventFinish =
            {
                [3098] = function(player, csid, option, npc)
                    mission:setLocalVar(player, 'Option', mission:getLocalVar(player, 'Option') + 1)
                end,

                [3110] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
