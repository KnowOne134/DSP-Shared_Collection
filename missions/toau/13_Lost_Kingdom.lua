-----------------------------------
-- Lost Kingdom
-- Aht Uhrgan Mission 13
-----------------------------------
-- !addmission 4 12
-- Pyopyoroon           : !pos 22.112 0.000 24.682 53
-- Jazaraat's Headstone : !pos -389.000 6.000 -570.000 79
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------
local caedarvaID = require("scripts/zones/Caedarva_Mire/IDs")
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.LOST_KINGDOM)

mission.reward =
{
    keyItem     = xi.ki.EPHRAMADIAN_GOLD_COIN,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.THE_DOLPHIN_CREST },
}

mission.sections =
{

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 0
        end,

        [xi.zone.CAEDARVA_MIRE] =
        {
            ['Jazaraat_s_Headstone'] = mission:progressEvent(8),

            onEventFinish =
            {
                [8] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 1)
                    player:delKeyItem(xi.ki.VIAL_OF_SPECTRAL_SCENT)
                end,
            },
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 1
        end,

        [xi.zone.CAEDARVA_MIRE] =
        {
            ['Jazaraat_s_Headstone'] =
            {
                onTrigger = function(player, npc)
                    if npcUtil.popFromQM(player, npc, caedarvaID.mob.JAZARAAT, { hide = 0 }) then
                        return mission:noAction()
                    end
                end,
            },

            ['Jazaraat'] =
            {
                onMobDeath = function(mob, player, isKiller, noKiller)
                    mission:setVar(player, 'Prog', 2)
                end,
            },
        },
    },

    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId and
            vars.Prog == 2
        end,

        [xi.zone.CAEDARVA_MIRE] =
        {
            ['Jazaraat_s_Headstone'] = mission:progressEvent(9),

            onEventFinish =
            {
                [9] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },

    {
        check = function(player, currentMission, vars)
            return player:hasCompletedMission(mission.areaId, mission.missionId) and
            not player:hasKeyItem(xi.ki.EPHRAMADIAN_GOLD_COIN)
        end,

        [xi.zone.CAEDARVA_MIRE] =
        {
            ['Jazaraat_s_Headstone'] = mission:keyItem(xi.ki.EPHRAMADIAN_GOLD_COIN),
        },
    },
}

return mission
