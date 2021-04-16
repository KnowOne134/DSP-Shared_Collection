-----------------------------------
-- Area: Zhayolm Remnants
-- NPC: Socket
-- Trade Salvage Cells to pop Poroggo Madame
-- Poroggo Madame drops 2x the Cells traded
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/items")
require("scripts/globals/status")
-----------------------------------

function onTrade(player, npc, trade)
    local instance = npc:getInstance()
    local mob = instance:getEntity(bit.band(ID.mob[2].POROGGO_MADAME, 0xFFF), dsp.objType.MOB)
    local COUNT = trade:getItemCount()

    for i = dsp.items.INCUS_CELL, dsp.items.SPISSATUS_CELL do
        if COUNT <= 5 and trade:hasItemQty(i, COUNT) then
            SpawnMob(ID.mob[2].POROGGO_MADAME, instance):updateClaim(player)
            player:tradeComplete()
            mob:setLocalVar("Cell", i)
            mob:setLocalVar("Qnt", COUNT)
            npc:setStatus(dsp.status.DISAPPEAR)
        end
    end
end
