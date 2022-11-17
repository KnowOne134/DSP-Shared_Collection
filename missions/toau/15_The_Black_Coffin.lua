-----------------------------------
-- The Black Coffin
-- Aht Uhrgan Mission 15
-----------------------------------
-- !addmission 4 14
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Cutter Region : !pos -435.000 -4.000 -414.000 54
-- Cutter        : !pos -464.526 -2.100 -394.478 54
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.THE_BLACK_COFFIN)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.GHOSTS_OF_THE_PAST },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3073, { text_table = 0 }),
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 0 and
            player:hasKeyItem(xi.ki.EPHRAMADIAN_GOLD_COIN)
        end,

        [xi.zone.ARRAPAGO_REEF] =
        {
            onRegionEnter =
            {
                [1] = function(player, region)
                    player:startEvent(8)
                    player:startEvent(34, 1, 1, 1, 1, 1, 1, 1, 1)
                    return mission:progressEvent(35)
                end,
            },

            onEventFinish =
            {
                [35] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 1)
                end,
            },
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 2
        end,

        [xi.zone.ARRAPAGO_REEF] =
        {

            onZoneIn =
            {
                function(player, prevZone)
                    if prevZone == xi.zone.THE_ASHU_TALIF then
                        player:setPos(-456, -3, -405, 64)
                        return 9
                    end
                end,
            },

            onEventFinish =
            {
                [9] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 3)
                    player:setPos(0, 0, 0, 0, xi.zone.NASHMAU)
                end,
            },
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 3
        end,

        [xi.zone.NASHMAU] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    if
                        prevZone == xi.zone.ARRAPAGO_REEF and
                        player:getXPos() == 0 and
                        player:getYPos() == 0 and
                        player:getZPos() == 0
                    then
                        player:setPos(-13, 2, -62, 194)
                        return 281
                    end
                end,
            },

            onEventFinish =
            {
                [281] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
