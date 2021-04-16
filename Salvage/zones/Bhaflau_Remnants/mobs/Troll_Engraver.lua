-----------------------------------
-- Area: Bhaflau Remnants
--  MOB: Troll Engraver
-----------------------------------
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobSpawn(mob)
    local instance = mob:getInstance()
    local pet = instance:getEntity(bit.band(mob:getID() + 1, 0xFFF), dsp.objType.MOB)
    mob:setPet(pet)
    SpawnMob(mob:getID() + 1, instance)
end


function onMobDeath(mob, player, isKiller, firstCall)
	if firstCall then
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
