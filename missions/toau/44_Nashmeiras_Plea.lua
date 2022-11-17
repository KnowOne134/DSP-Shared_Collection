-----------------------------------
-- Nashmeira's Plea
-- Aht Uhrgan Mission 44
-----------------------------------
-- !addmission 4 43
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- 19            : !pos 206.55 -1.5 20.05 72
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.NASHMEIRAS_PLEA)

mission.reward =
{
    title       = xi.title.PREVENTER_OF_RAGNAROK,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.RAGNAROK },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = mission:progressEvent(3152, { text_table = 0 }):importantOnce(),

            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    if mission:getVar(player, 'Wait') < os.time() then
                        if not player:hasKeyItem(xi.ki.MYTHRIL_MIRROR) then
                            return mission:progressEvent(3156, { text_table = 0 })
                        else
                            return mission:progressEvent(3149, { text_table = 0 })
                        end
                    end
                end,
            },

            onEventFinish =
            {
                [3156] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.MYTHRIL_MIRROR)
                end,
            },
        },

        [xi.zone.ALZADAAL_UNDERSEA_RUINS] =
        {
            ['19'] =
            {
                onTrigger = function(player, npc)
                    if mission:getVar(player, 'Prog') == 0 then
                        return mission:progressEvent(8)
                    end
                end,
            },

            onZoneIn =
            {
                function(player, prevZone)
                    if mission:getVar(player, 'Prog') == 2 then
                        return 10
                    end
                end,
            },

            onEventFinish =
            {
                [8] = function(player, csid, option, npc)
                    if option == 0 then
                        mission:setVar(player, 'Prog', 1)
                    end
                end,

                [10] = function(player, csid, option, npc)
                    player:setPos(153, 0, 20, 0)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
