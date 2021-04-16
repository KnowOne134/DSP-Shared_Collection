-----------------------------------
-- Area: Bhaflau Remnants
-- MOB: Flux Flan
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
mixins = {require("scripts/mixins/families/flan")}
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobSpawn(mob)
    local instance = mob:getInstance()
    instance:getEntity(bit.band(ID.npc[2].SOCKET, 0xFFF), dsp.objType.NPC):setStatus(dsp.status.DISAPPEAR)
end

function onMobDeath(mob, player, isKiller, firstCall)
	if firstCall then
	    salvageUtil.handleSocketCells(mob, player)
	end
end
