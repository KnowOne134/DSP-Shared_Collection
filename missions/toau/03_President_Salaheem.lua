-----------------------------------
-- President Salaheem
-- Aht Uhrgan Mission 3
-----------------------------------
-- !addmission 4 2
-- Rytaal        : !pos 112.002 -0.315 -45.038 50
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
require('scripts/globals/interaction/mission')
require("scripts/globals/besieged")
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PRESIDENT_SALAHEEM)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.KNIGHT_OF_GOLD },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and vars.Prog == 0
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Rytaal'] = mission:progressEvent(269, { text_table = 0 }),

            onEventFinish =
            {
                [269] = function(player, csid, option, npc)
                    mission:setVar(player, "Prog", 1)
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
            ['Naja_Salaheem'] = mission:progressEvent(73, { text_table = 0 }),

            onEventFinish =
            {
                [73] = function(player, csid, option, npc)
                    mission:setVar(player, "Wait", getMidnight())
                    mission:setVar(player, "Prog", 2)
                    player:needToZone(true)
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
            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    if not player:needToZone() and mission:getVar(player, "Wait") <= os.time() then
                        return mission:progressEvent(3020, { text_table = 0 })
                    else
                        return mission:event(3003, { [0] = getMercenaryRank(player), text_table = 0 }) -- Default Dialog.
                    end
                end,
            },

            onEventFinish =
            {
                [3020] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
