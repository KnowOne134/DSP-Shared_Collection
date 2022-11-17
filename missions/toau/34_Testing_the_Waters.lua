-----------------------------------
-- Testing the Waters
-- Aht Uhrgan Mission 34
-----------------------------------
-- !addmission 4 33
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Cutter Region : !pos -435.000 -4.000 -414.000 54
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.TESTING_THE_WATERS)

mission.reward =
{
    keyItem     = xi.ki.PERCIPIENT_EYE,
    title       = xi.title.TREASURE_TROVE_TENDER,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.LEGACY_OF_THE_LOST },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3132, { text_table = 0 }),
        },

        [xi.zone.ARRAPAGO_REEF] =
        {
            onRegionEnter =
            {
                [1] = function(player, region)
                    if player:hasKeyItem(xi.ki.EPHRAMADIAN_GOLD_COIN) and not player:needToZone() then
                        return mission:progressEvent(15)
                    else
                        return mission:progressEvent(16)
                    end
                end,
            },

            onEventFinish =
            {
                [15] = function(player, csid, option, npc)
                    if option == 1 then
                        mission:setVar(player, 'Prog', 1)
                        player:setPos(-88.879, -7.318, -109.233, 173, xi.zone.TALACCA_COVE)
                    else
                        player:needToZone(true)
                    end
                end,
            },
        },

        [xi.zone.TALACCA_COVE] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    if mission:getVar(player, 'Prog') == 1 then
                        player:setPos(-88.879, -7.318, -109.233, 173)
                        return 106
                    end
                end,
            },

            onEventFinish =
            {
                [106] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:delKeyItem(xi.ki.EPHRAMADIAN_GOLD_COIN)
                    end
                end,
            },
        },
    },
}

return mission
