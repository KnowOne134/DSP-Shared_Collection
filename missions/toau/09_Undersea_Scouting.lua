-----------------------------------
-- Undersea Scouting
-- Aht Uhrgan Mission 9
-----------------------------------
-- !addmission 4 8
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Region 23     : !pos 382.000 -1.000 -582.000 72
-----------------------------------
require('scripts/globals/interaction/mission')
require("scripts/globals/besieged")
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.UNDERSEA_SCOUTING)

mission.reward =
{
    keyItem     = xi.ki.ASTRAL_COMPASS,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.ASTRAL_WAVES },
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
                    local optionalVariable = mission:getLocalVar(player, 'Option') % 2 == 0 and 1 or 0

                    return mission:progressEvent(3051, { [7] = optionalVariable, text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3051] = function(player, csid, option, npc)
                    mission:setLocalVar(player, 'Option', mission:getLocalVar(player, 'Option') + 1)
                end,
            },
        },

        [xi.zone.ALZADAAL_UNDERSEA_RUINS] =
        {
            onRegionEnter =
            {
                [23] = function(player, region)
                    if player:getLocalVar('Prog') == 0 then
                        return mission:progressEvent(1, getMercenaryRank(player))
                    end
                end,
            },

            onEventUpdate =
            {
                [1] = function(player, csid, option, npc)
                    player:setLocalVar('Prog', 1)
                    if option == 10 then -- start
                        player:updateEvent(0,0,0,0,0,0,0,0)
                    elseif option <= 3 then
                        mission:setVarBit(player, 'Option', option - 1)
                        player:updateEvent(mission:getVar(player, 'Option'),0,0,0,0,0,0,0)
                    end
                end,
            },

            onEventFinish =
            {
                [1] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
