
-----------------------------------
-- Area: Bhaflau Remnants
-- NPC: Slot
-- trade card to pop NM
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/items")
require("scripts/globals/npc_util")
-----------------------------------

function onTrade(player,npc,trade)
    if npcUtil.tradeHasExactly(trade, dsp.items.ARRAPAGO_CARD) then
        local instance = npc:getInstance()
        SpawnMob(ID.mob[3].JALAWAA, instance):updateClaim(player)
        player:confirmTrade()
    end
end
