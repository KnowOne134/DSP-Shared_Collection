-----------------------------------
-- Shades of Vengeance
-- Aht Uhrgan Mission 31
-----------------------------------
-- !addmission 4 30
-- Naja Salaheem : !pos 22.700 -7.805 -45.591 50
-- Runic Seal    : !pos -353.880 -2.799 -20.000 79
-- Nashib        : !pos -274.334 -9.287 -64.255 79
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/keyitems')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.SHADES_OF_VENGEANCE)

mission.reward =
{
    title       = xi.title.NASHMEIRAS_MERCENARY,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.IN_THE_BLOOD },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3119, { text_table = 0 }),
        },

        [xi.zone.CAEDARVA_MIRE] =
        {
            ['Nashib'] =
            {
                onTrigger = function(player, npc)
                    if not player:hasKeyItem(xi.ki.PERIQIA_ASSAULT_AREA_ENTRY_PERMIT) then
                        if vanaDay() > mission:getVar(player, 'Wait') then
                            return mission:progressEvent(22)
                        else
                            return mission:event(23)
                        end
                    end
                end,
            },

            onZoneIn =
            {
                function(player, prevZone)
                    if prevZone == xi.zone.PERIQIA and mission:getVar(player, 'Prog') == 1 then
                        return 21
                    end
                end,
            },

            onEventFinish =
            {
                [21] = function(player, csid, option, npc)
                    mission:complete(player)
                    player:setPos(-252.715, -7.666, -30.64, 128)
                end,

                [22] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.PERIQIA_ASSAULT_AREA_ENTRY_PERMIT)
                end,
            },
        },
    },
}

return mission
