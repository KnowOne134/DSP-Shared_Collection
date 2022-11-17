-----------------------------------
-- Easterly Winds
-- Aht Uhrgan Mission 6
-----------------------------------
-- !addmission 4 5
-- Halver   : !pos 2.000 0.100 00.100 233
-- Region 1 : !pos 0.000 1.500 48.000 243
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.EASTERLY_WINDS)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.WESTERLY_WINDS },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Halver'] = mission:event(565):oncePerZone(),
        },

        [xi.zone.RULUDE_GARDENS] =
        {
            onRegionEnter =
            {
                [1] = function(player, region)
                    if mission:getVar(player, 'Wait') <= os.time() then
                        return mission:progressEvent(10094)
                    end
                end,
            },

            onEventFinish =
            {
                [10094] = function(player, csid, option, npc)
                    -- NOTE: We don't want to fall through and complete if the player's inventory is full.
                    -- This is the reasoning for the two different mission:complete() calls.

                    if option == 1 then
                        if npcUtil.giveItem(player, { { xi.items.IMPERIAL_BRONZE_PIECE, 10 } }) then
                            mission:complete(player)
                        end
                    else
                        mission:complete(player)
                    end
                end,
            },
        },
    },
}

return mission
