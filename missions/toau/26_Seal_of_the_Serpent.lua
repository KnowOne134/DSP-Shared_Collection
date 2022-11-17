-----------------------------------
-- Seal of the Serpent
-- Aht Uhrgan Mission 26
-----------------------------------
-- !addmission 4 25
-- Imperial Whitegate : !pos 152 -2 0 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
require("scripts/zones/Aht_Urhgan_Whitegate/Shared")
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.SEAL_OF_THE_SERPENT)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.MISPLACED_NOBILITY },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3115, { text_table = 0 }),

            ['Imperial_Whitegate'] =
            {
                onTrigger = function(player, npc)
                    if
                        player:getEquipID(xi.slot.MAIN) == 0 and
                        player:getEquipID(xi.slot.SUB) == 0 and
                        doRoyalPalaceArmorCheck(player)
                    then
                        return mission:progressEvent(3111)
                    end
                end,
            },

            onEventFinish =
            {
                [3111] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
