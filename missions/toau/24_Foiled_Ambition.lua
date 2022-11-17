-----------------------------------
-- Foiled Ambition
-- Aht Uhrgan Mission 24
-----------------------------------
-- !addmission 4 23
-- Abquhbah             : !pos 35.524 -6.60 -58.237 50
-- Naja Salaheem        : !pos 22.700 -7.805 -45.591 50
-- Salaheem's Sentinels : !pos 36.000 -6.600 -51.900 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/items')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.FOILED_AMBITION)

mission.reward =
{
    item        = { { xi.items.IMPERIAL_GOLD_PIECE, 5 } },
    title       = xi.title.KARABABAS_SECRET_AGENT,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.PLAYING_THE_PART },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = mission:progressEvent(3108, { text_table = 0 }):oncePerZone(),
            ['Naja_Salaheem'] = mission:progressEvent(3096, { text_table = 0 }),

            onRegionEnter =
            {
                [3] = function(player, region)
                    if not player:needToZone() and vanaDay() > mission:getVar(player, 'Wait') then
                        return mission:progressEvent(3097, { text_table = 0 })
                    end
                end,
            },

            onEventFinish =
            {
                [3097] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:needToZone(true)
                        player:setVar('M[4][24]Wait', vanaDay())
                        player:setPos(13, 0, 0, 0)
                    end
                end,
            },
        },
    },
}

return mission
