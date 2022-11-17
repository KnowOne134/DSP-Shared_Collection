-----------------------------------
-- Imperial Schemes
-- Aht Uhrgan Mission 11
-----------------------------------
-- !addmission 4 10
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Naja Region   : !pos 31.000 -8.000 -53.000 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.IMPERIAL_SCHEMES)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.ROYAL_PUPPETEER },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    local optionalVariable = mission:getLocalVar(player, 'Option') % 2 == 0 and 1 or 2

                    return mission:progressEvent(3053, { [7] = optionalVariable, text_table = 0 })
                end,
            },

            onRegionEnter =
            {
                [3] = function(player, region)
                    if not player:needToZone() and mission:getVar(player, 'Wait') < vanaDay() then
                        return mission:progressEvent(3070, { text_table = 0 })
                    end
                end,
            },

            onEventFinish =
            {
                [3053] = function(player, csid, option, npc)
                    mission:setLocalVar(player, 'Option', mission:getLocalVar(player, 'Option') + 1)
                end,

                [3070] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:needToZone(true)
                        player:setVar("M[4][11]Wait", vanaDay())
                    end
                end,
            },
        },
    },
}

return mission
