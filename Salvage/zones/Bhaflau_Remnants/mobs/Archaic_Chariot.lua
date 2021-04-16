-----------------------------------
-- Area: Bhaflau Remnants
--  MOB: Archaic Chariot
-----------------------------------
mixins = {require("scripts/mixins/families/chariot")}
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
	if firstCall then
        local instance = mob:getInstance()

        if instance:getStage() == 4 then
            instance:setLocalVar("bossModifier", instance:getProgress())
        end

        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
