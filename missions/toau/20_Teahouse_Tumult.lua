-----------------------------------
-- Teahouse Tumult
-- Aht Uhrgan Mission 20
-----------------------------------
-- !addmission 4 19
-- 16 : !pos -298 36 -38 68
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.TEAHOUSE_TUMULT)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.FINDERS_KEEPERS },
}

mission.sections =
{
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = mission:progressEvent(3106, { text_table = 0 }):oncePerZone(),
        },

        [xi.zone.AYDEEWA_SUBTERRANE] =
        {
             onZoneIn =
            {
                function(player, prevZone)
                    if mission:getVar(player, 'Prog') == 0 then
                        return 10
                    end
                end,
            },

            ['16'] =
            {
                onTrigger = function(player, npc)
                    if mission:getVar(player, 'Prog') == 1 then
                        return mission:progressCutscene(11)
                    end
                end,
            },

            onEventFinish =
            {
                [10] = function(player, csid, option, npc)
                    player:setPos(356.503, -0.364, -179.607, 122)
                    mission:setVar(player, 'Prog', 1)
                end,

                [11] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
