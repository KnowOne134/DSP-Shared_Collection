-----------------------------------
-- Imperial Coronation
-- Aht Uhrgan Mission 46
-----------------------------------
-- !addmission 4 45
-- Abquhbah           : !pos 35.500 -6.600 -58.000 50
-- Imperial Whitegate : !pos 152 -2 0 50
-----------------------------------
require('scripts/globals/interaction/mission')
require('scripts/globals/items')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
require("scripts/zones/Aht_Urhgan_Whitegate/Shared")
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.IMPERIAL_CORONATION)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.THE_EMPRESS_CROWNED },
}

mission.sections =
{
    {
        check = function(player, currentMission, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = mission:progressEvent(3153, { text_table = 0 }):oncePerZone(),
            ['Naja_Salaheem'] = mission:progressEvent(3150, { text_table = 0 }),

            ['Imperial_Whitegate'] =
            {
                onTrigger = function(player, npc)
                    if
                        doRoyalPalaceArmorCheck(player) and
                        player:getEquipID(xi.slot.MAIN) == 0 and
                        player:getEquipID(xi.slot.SUB) == 0
                    then
                        return mission:progressEvent(3140, { [0] = getMercenaryRank(player), [1] = player:getTitle(), text_table = 0 })
                    end
                end,
            },

            onEventUpdate =
            {
                [3140] = function(player, csid, option)
                    if option > 0 and option < 4 then
                        mission:setLocalVar(player, 'Option', xi.items.CELESTIAL_RING + option)
                    elseif option == 99 then
                        player:updateEvent({ [0] = xi.items.BALRAHNS_RING, [1] = xi.items.ULTHALAMS_RING, [2] = xi.items.JALZAHNS_RING })
                    end
                end,
            },

            onEventFinish =
            {
                [3140] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        local ring = mission:getLocalVar(player 'Option')
                        if not player:hasItem(xi.items.IMPERIAL_STANDARD) then
                            npcUtil.giveItem(player, xi.items.IMPERIAL_STANDARD)
                        end

                        if ring > 0 then
                            if npcUtil.giveItem(player, ring) then
                                player:setVar("TOAU_RINGTIME", os.time())
                            end
                        end
                    end
                end,
            },
        },
    },
}

return mission
