-----------------------------------
-- Area: Aht Urhgan Whitegate
--  NPC: Sorrowful Sage
-- Type: Assault Mission Giver
-- !pos 134.096 0.161 -30.401 50
-----------------------------------
local ID = require("scripts/zones/Aht_Urhgan_Whitegate/IDs")
require("scripts/globals/besieged")
require("scripts/globals/keyitems")
require("scripts/globals/missions")
require("scripts/globals/utils")
-----------------------------------

local this = {}

this.onTrigger = function(player, npc)
    local rank = getMercenaryRank(player)
    local haveimperialIDtag = player:hasKeyItem(xi.ki.IMPERIAL_ARMY_ID_TAG) and 1 or 0
    local tokens = player:getCurrency("nyzul_isle_assault_point")
    local floorProgress = player:getVar("NyzulFloorProgress")
    local preferred = player:getVar("[Nyzul]preferredItems")

    if rank > 0 then
        player:startEvent(278, rank, haveimperialIDtag, tokens, player:getCurrentAssault(), floorProgress, 0, preferred)
    end
end

this.onEventUpdate = function(player, csid, option)
    local option1, option2 = utils.varSplit(option)
    local rank = getMercenaryRank(player)
    local haveimperialIDtag = player:hasKeyItem(xi.ki.IMPERIAL_ARMY_ID_TAG) and 1 or 0
    local tokens = player:getCurrency("nyzul_isle_assault_point")
    local floorProgress = player:getVar("NyzulFloorProgress")
    local preferred = player:getVar("[Nyzul]preferredItems")
    local pick = 0
    local items =
    {
        [1]  = {slot =  1},
        [2]  = {slot =  2},
        [3]  = {slot =  3},
        [4]  = {slot =  4},
        [5]  = {slot =  5},
        [6]  = {slot = 10},
        [7]  = {slot = 12},
        [8]  = {slot = 18},
        [9]  = {slot = 19},
        [10] = {slot = 20},
        [11] = {slot = 21},
        [12] = {slot = 26},

        [13] = {slot =  6},
        [14] = {slot =  7},
        [15] = {slot =  8},
        [16] = {slot =  9},
        [17] = {slot = 11},
        [18] = {slot = 13},
        [19] = {slot = 14},
        [20] = {slot = 16},
        [21] = {slot = 17},
        [22] = {slot = 22},
        [23] = {slot = 23},
        [24] = {slot = 24},

        [25] = {slot = 15},
    }

    if csid == 278 then
        if option1 == 3 then -- low grade item
            pick = bit.rshift(option2, 2)
        elseif option1 == 4 then -- medium grade item
            pick = bit.rshift(option2, 2) + 12
        elseif option1 == 5 then -- high grade item
            pick = bit.rshift(option2, 2) + 24
        end

        if utils.isBitSet(preferred, items[pick].slot) then
            player:setVar("[Nyzul]preferredItems", utils.setBit(preferred, items[pick].slot, 0))
        else
            player:setVar("[Nyzul]preferredItems", utils.setBit(preferred, items[pick].slot, 1))
        end

        player:updateEvent(rank, haveimperialIDtag, tokens, player:getCurrentAssault(), floorProgress, 0, player:getVar("[Nyzul]preferredItems"))
    end
end

this.onEventFinish = function(player, csid, option)
    local option1, option2 = utils.varSplit(option)

    if csid == 278 then
        if option1 == 817 then
            player:addAssault(bit.rshift(option1, 4))
            player:delKeyItem(xi.ki.IMPERIAL_ARMY_ID_TAG)
            npcUtil.giveKeyItem(player, xi.ki.NYZUL_ISLE_ASSAULT_ORDERS)
        elseif option1 == 833 then
            player:PrintToPlayer("This Assault is not implemented in this era")
        end
    end
end

return this
