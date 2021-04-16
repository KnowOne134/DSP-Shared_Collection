-----------------------------------
-- Area: Zhayolm Remnants
-- NPC: Slot
-- trade card to pop NM
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/items")
require("scripts/globals/npc_util")
require("scripts/globals/status")
-----------------------------------

function onTrade(player, npc, trade)
    if npcUtil.tradeHas(trade, dsp.items.SILVER_SEA_CARD) then
        local instance = npc:getInstance()
        SpawnMob(ID.mob[2].JAKKO, instance):updateClaim(player)
        player:confirmTrade()
        npc:setStatus(dsp.status.DISAPPEAR)
    end
end
