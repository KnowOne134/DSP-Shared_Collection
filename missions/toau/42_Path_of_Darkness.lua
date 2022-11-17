-----------------------------------
-- Path of Darkness
-- Aht Uhrgan Mission 42
-----------------------------------
-- !addmission 4 40
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Rodin-Comidin : !pos 17.205 -5.999 51.161 50
-- 19            : !pos 206.55 -1.5 20.05 72
-- _1e1 (Door)   : !pos 23 -6 -63 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PATH_OF_DARKNESS)

mission.reward =
{
    title       = xi.title.NAJAS_COMRADE_IN_ARMS,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.FANGS_OF_THE_LION },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:event(3148, { text_table = 0 }),

            ['Rodin-Comidin'] =
            {
                onTrigger = function(player, npc)
                    if not player:hasKeyItem(xi.ki.NYZUL_ISLE_ROUTE) then
                        if mission:getVar(player, 'Wait') < os.time() then
                            return mission:progressEvent(3142, { text_table = 0 })
                        else
                            return mission:progressEvent(3141, { text_table = 0 })
                        end
                    end
                end,
            },

            onRegionEnter =
            {
                [12] = function(player, region)
                    -- Naja Salaheem interactions require the 9th argument set to 0.
                    -- This is because Aht Uhrgan Whitegate uses 2 different dats.
                    if mission:getVar(player, 'Prog') > 0 then
                        local blockedDialog = mission:getLocalVar(player, 'blockedDialog')

                        return mission:progressEvent(3143, { [6] = blockedDialog, text_table = 0 })
                    end
                end,
            },

            onEventFinish =
            {
                [3142] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.NYZUL_ISLE_ROUTE)
                    mission:setVar(player, 'Wait', getMidnight())
                end,

                [3143] = function(player, csid, option, npc)
                    mission:setLocalVar(player, 'blockedDialog', 1)
                    player:setPos(23.978, -6, -64.624, 63)
                end,
            },
        },

        [xi.zone.ALZADAAL_UNDERSEA_RUINS] =
        {
            ['19'] =
            {
                onTrigger = function(player, npc)
                    if mission:getVar(player, 'Prog') == 0 then
                        return mission:progressEvent(6)
                    end
                end,
            },

            onZoneIn =
            {
                function(player, prevZone)
                    if  mission:getVar(player, 'Prog') == 2 then
                        return 7
                    end
                end,
            },

            onEventFinish =
            {
                [6] = function(player, csid, option, npc)
                    if option == 0 then
                         mission:setVar(player, 'Prog', 1)
                    end
                end,

                [7] = function(player, csid, option, npc)
                    player:setPos(153, 0, 20, 0)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
