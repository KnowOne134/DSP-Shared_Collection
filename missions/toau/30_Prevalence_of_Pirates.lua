-----------------------------------
-- Prevalence of Pirates
-- Aht Uhrgan Mission 30
-----------------------------------
-- !addmission 4 29
-- Naja Salaheem : !pos 22.700 -7.805 -45.591 50
-- Cutter Region : !pos -435.000 -4.000 -414.000 54
-----------------------------------
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/interaction/mission')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PREVALENCE_OF_PIRATES)

mission.reward =
{
    keyItem     = xi.ki.PERIQIA_ASSAULT_AREA_ENTRY_PERMIT,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SHADES_OF_VENGEANCE },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3118, { text_table = 0 }),
        },

        [xi.zone.ARRAPAGO_REEF] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    if
                        prevZone == xi.zone.CAEDARVA_MIRE and
                        mission:getVar(player, 'Prog') == 0
                    then
                        return 13
                    end
                end,
            },

            onRegionEnter =
            {
                [1] = function(player, region)
                    if mission:getVar(player, 'Prog') == 1 then
                        return mission:progressEvent(14)
                    end
                end,
            },

            onEventFinish =
            {
                [13] = function(player, csid, option, npc)
                    player:setPos(-180.028, -10.335, -559.987, 182)
                    mission:setVar(player, 'Prog', 1)
                end,

                [14] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
