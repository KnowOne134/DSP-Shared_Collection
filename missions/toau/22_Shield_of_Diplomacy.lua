-----------------------------------
-- Shield of Diplomacy
-- Aht Uhrgan Mission 22
-----------------------------------
-- !addmission 4 21
-- Decorative Bronze Gate : !pos -601 10 -100 64
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.SHIELD_OF_DIPLOMACY)

mission.reward =
{
    title       = xi.title.KARABABAS_BODYGUARD,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SOCIAL_GRACES },
}

mission.sections =
{
    {
        check = function(player, currentMission,  vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = mission:progressEvent(3107, { text_table = 0 }):oncePerZone(),
        },

        [xi.zone.NAVUKGO_EXECUTION_CHAMBER] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    if prevZone == xi.zone.MOUNT_ZHAYOLM and mission:getVar(player, 'Prog') == 0 then
                        player:setPos(-660.185, -10.000, -199.532, 192)
                        return 1
                    end
                end,
            },

            ['_1s0'] =
            {
                onTrigger = function(player, npc)
                    if mission:getVar(player, 'Prog') == 1 then
                        return mission:progressEvent(2)
                    end
                end,
            },

            ['Khimaira_13'] =
            {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    if mission:getVar(player, 'Prog') == 2 then
                        mission:setLocalVar(player, 'Prog', 1)
                    end
                end,
            },

            onEventFinish =
            {
                [1] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 1)
                end,

                [2] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 2)
                end,

                [32001] = function(player, csid, option, npc)
                    if mission:getLocalVar(player, 'Prog') == 1 then
                        mission:complete(player)
                    end
                end,
            },
        },
    },
}

return mission
