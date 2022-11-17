-----------------------------------
-- The Empress Crowned
-- Aht Uhrgan Mission 47
-----------------------------------
-- !addmission 4 47
-- Imperial Whitegate : !pos 152 -2 0 50
-- Nadeey             :
-- Region 12          :
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/common')
require('scripts/globals/items')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
require("scripts/zones/Aht_Urhgan_Whitegate/Shared")
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.THE_EMPRESS_CROWNED)

local ringCheck = function(player)
    for ring = 1, 3 do
        if player:hasItem(xi.items.CELESTIAL_RING + ring) then
            return true
        end
    end
    return false
end

mission.reward =
{
    item = xi.items.GLORY_CROWN,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.ETERNAL_MERCENARY },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Imperial_Whitegate'] =
            {
                onTrigger = function(player, npc)
                    if
                        doRoyalPalaceArmorCheck(player) and
                        player:getEquipID(xi.slot.MAIN) == 0 and
                        player:getEquipID(xi.slot.SUB) == 0 and
                        (player:getVar("TOAU_RINGTIME") == 0 or not player:hasItem(xi.items.IMPERIAL_STANDARD))
                    then
                        local ringParam = player:getVar("TOAU_RINGTIME") == 0 and 1 or 0
                        local standardParam = player:hasItem(xi.items.IMPERIAL_STANDARD) and 0 or 1

                        return mission:progressEvent(3155, { [0] = standardParam, [1] = ringParam, text_table = 0 })
                    end
                end,
            },

            ['Nadeey'] =
            {
                onTrigger = function(player, npc)
                    if not ringCheck(player) and player:getVar("TOAU_RINGTIME") < os.time() then
                        return progressEvent(961, { text_table = 0 })
                    end
                end,
            },

            onRegionEnter =
            {
                [12] = function(player, region)
                    return mission:progressEvent(3144, { [0] = getMercenaryRank(player), text_table = 0 })
                end,
            },

            onEventUpdate =
            {
                [961] = function(player, csid, option)
                    if option == 99 then
                        player:updateEvent({ [0] = xi.items.BALRAHNS_RING, [1] = xi.items.ULTHALAMS_RING, [2] = xi.items.JALZAHNS_RING })
                    end
                end,

                [3155] = function(player, csid, option)
                    if option > 0 and option < 4 then
                        mission:setLocalVar(player, 'Option', xi.items.CELESTIAL_RING + option)
                    elseif option == 99 then
                        player:updateEvent({ [0] = xi.items.BALRAHNS_RING, [1] = xi.items.ULTHALAMS_RING, [2] = xi.items.JALZAHNS_RING })
                    end
                end,
            },

            onEventFinish =
            {
                [3144] = function(player, csid, option, npc)
                    mission:complete(player)
                end,

                [961] = function(player, csid, option, npc)
                    if option > 0 and option < 4 and npcUtil.giveItem(player, xi.items.CELESTIAL_RING + option) then
                        player:setVar("TOAU_RINGTIME", getConquestTally())
                    end
                end,

                [3155] = function(player, csid, option, npc)
                    local ring = mission:getLocalVar(player, 'Option')
                    if not player:hasItem(xi.items.IMPERIAL_STANDARD) then
                        npcUtil.giveItem(player, xi.items.IMPERIAL_STANDARD)
                    end

                    if ring > 0 then
                        if npcUtil.giveItem(player, ring) then
                            player:setVar("TOAU_RINGTIME", os.time())
                        end
                    end
                end,
            },
        },
    },
}

return mission
