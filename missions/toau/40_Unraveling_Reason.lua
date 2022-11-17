-----------------------------------
-- Unraveling Reason
-- Aht Uhrgan Mission 40
-----------------------------------
-- !addmission 4 39
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-- Pherimociel   : !pos -31.627 1.002 67.956 243
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
require('scripts/globals/zone')
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.UNRAVELING_REASON)

mission.reward =
{
    title       = xi.title.ENDYMION_PARATROOPER,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.LIGHT_OF_JUDGMENT },
}

mission.sections =
{
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] = mission:progressEvent(3148, { text_table = 0 }),
        },

        [xi.zone.RULUDE_GARDENS] =
        {
            ['Pherimociel'] =
            {
                onTrigger = function(player, npc)
                    local questTimer = mission:getVar(player, 'Wait')

                    if questTimer == 0 then
                        return mission:progressEvent(10099)
                    elseif
                        vanaDay() > questTimer and
                        not player:needToZone()
                    then
                        return mission:progressEvent(10098)
                    end
                end,
            },

            onEventFinish =
            {
                [10098] = function(player, csid, option, npc)
                    if option == 1 then
                        -- Title can be obtained immediately following this event.  Since these are stringed
                        -- together, set it at the end for clarity in mission rewards.

                        -- NOTE: Setting absolute pos here in the past has caused issues, so we chuck to Wajaom
                        -- and then start moving things around.  This is probably something good to fix in the
                        -- future for all events.
                        mission:setVar(player, 'Prog', 1)
                        player:setPos(0, 0, 0, 0, xi.zone.WAJAOM_WOODLANDS)
                    else
                        player:needToZone(true)
                    end
                end,

                [10099] = function(player, csid, option, npc)
                    mission:setVar(player, 'wait', vanaDay())
                    player:needToZone(true)
                end,
            },
        },

        [xi.zone.WAJAOM_WOODLANDS] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    -- Each of these 3 cutscenes that follow Ru'Lude 10098 are onZone events.  It is possible
                    -- to not require this, but is retail accurate.

                    local missionStatus = mission:getVar(player, 'Prog')

                    if missionStatus == 1 then
                        return 11
                    elseif missionStatus == 2 then
                        return 21
                    else
                        return 22
                    end
                end,
            },

            onEventFinish =
            {
                [11] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 2)
                    player:setPos(-200.036, -10, 79.948, 254, xi.zone.WAJAOM_WOODLANDS, true)
                end,

                [21] = function(player, csid, option, npc)
                    mission:setVar(player, 'Prog', 3)
                    player:setPos(-200.036, -10, 79.948, 254, xi.zone.WAJAOM_WOODLANDS, true)
                end,

                [22] = function(player, csid, option, npc)
                    player:setPos(-200.036, -10, 79.948, 254)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
