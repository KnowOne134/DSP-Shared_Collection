-----------------------------------
-- Knight of Gold
-- Aht Uhrgan Mission 4
-----------------------------------
-- !addmission 4 3
-- Cacaroon : !pos -72.026 0.000 -82.337 50
-- Region 4 : !pos 75.000 -3.000 25.000 50
-- Nadeey   : !pos 80.027 -0.325 55.072 50
-- Region 5 : !pos 73.000 -7.000 -137.000 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.KNIGHT_OF_GOLD)

mission.reward =
{
    keyItem     = xi.ki.RAILLEFALS_LETTER,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.CONFESSIONS_OF_ROYALTY },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 0
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Cacaroon'] = mission:progressEvent(3035, { text_table = 0 }),
            ['Naja_Salaheem'] = mission:progressEvent(3021, { text_table = 0 }),

            onEventFinish =
            {
                [3035] = function(player, csid, option, npc)
                    if option == 1 then
                        mission:setVar(player, 'Prog', 1)
                    end
                end,
            },
        },
    },
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 1
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Cacaroon'] =
            {
                onTrade = function(player, npc, trade)
                    if
                        npcUtil.tradeHasExactly(trade, { { 'gil', 1000 } }) or
                        npcUtil.tradeHasExactly(trade, xi.items.IMPERIAL_BRONZE_PIECE)
                    then
                        return mission:progressEvent(3022, { text_table = 0 })
                    end
                end,

                onTrigger = function(player, npc)
                    return mission:progressEvent(3036, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3022] = function(player, csid, option, npc)
                    player:confirmTrade()
                    mission:setVar(player, 'Prog', 2)
                end,
            },
        },
    },
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 2
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Cacaroon'] = mission:event(3023, { text_table = 0 }):replaceDefault(),

            onRegionEnter =
            {
                [4] = function(player, region)
                    return mission:progressEvent(3024, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3024] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 3)
                end,
            },
        },
    },
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 3
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nadeey'] = mission:event(3025, { text_table = 0 }),

            onRegionEnter =
            {
                [5] = function(player, region)
                    return mission:progressEvent(3026, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3026] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
