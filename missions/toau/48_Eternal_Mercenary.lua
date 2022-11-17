-----------------------------------
-- Eternal Mercenary
-- Aht Uhrgan Mission 48
-----------------------------------
-- !addmission 4 48
-- Abquhbah      : !pos 35.500 -6.600 -58.000 50
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/besieged')
require('scripts/globals/missions')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.ETERNAL_MERCENARY)

mission.reward =
{
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = mission:progressEvent(3154, { text_table = 0 }):oncePerZone(),
            
            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    return mission:progressEvent(3151, { [0] = getMercenaryRank(player), text_table = 0 })
                end,
            },
        },
    },
}

return mission
