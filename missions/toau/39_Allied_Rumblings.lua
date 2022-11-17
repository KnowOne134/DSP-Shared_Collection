-----------------------------------
-- Allied Rumblings
-- Aht Uhrgan Mission 39
-----------------------------------
-- !addmission 4 38
-- Naja Salaheem            : !pos 22.700 -8.804 -45.591 50
-- Ru Lude Gardens Region 1 : !pos 0.000 2.000 44.500 243
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.ALLIED_RUMBLINGS)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.UNRAVELING_REASON },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3148, { text_table = 0 }),
        },

        [xi.zone.RULUDE_GARDENS] =
        {
            onRegionEnter =
            {
                [1] = function(player, region)
                    return mission:progressEvent(10097)
                end,
            },

            onEventFinish =
            {
                [10097] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:setVar("M[4][39]Wait", vanaDay())
                    end
                end,
            },
        },
    },
}

return mission
