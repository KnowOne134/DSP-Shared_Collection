-----------------------------------
-- Royal Puppeteer
-- Aht Uhrgan Mission 12
-----------------------------------
-- !addmission 4 11
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Pyopyoroon    : !pos 22.112 0 24.682 53
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.ROYAL_PUPPETEER)

mission.reward =
{
    keyItem     = xi.ki.VIAL_OF_SPECTRAL_SCENT,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.LOST_KINGDOM },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and not player:needToZone()
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3071, { text_table = 0 }),
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            mission:getVar(player, 'Wait') < vanaDay() and
            vars.Prog == 0
        end,

        [xi.zone.NASHMAU] =
        {
            ['Pyopyoroon'] = mission:progressEvent(277),

            onEventFinish =
            {
                [277] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 1)
                end,
            },
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 1
        end,

        [xi.zone.NASHMAU] =
        {
            ['Pyopyoroon'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, xi.items.VIAL_OF_JODYS_ACID) then
                        return mission:progressEvent(279)
                    end
                end,

                onTrigger = function(player, npc)
                    return mission:progressEvent(278)
                end,
            },

            onEventFinish =
            {
                [279] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:confirmTrade()
                    end
                end,
            },
        },
    },
}

return mission
