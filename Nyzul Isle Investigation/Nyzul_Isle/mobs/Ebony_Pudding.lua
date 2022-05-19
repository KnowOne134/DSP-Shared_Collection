-----------------------------------
--  MOB: Ebony Pudding
-- Area: Nyzul Isle
-- Info: Specified Mob Group
-----------------------------------
mixins = {require("scripts/mixins/families/flan")}
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    mob:setMobMod(dsp.mobMod.CHECK_AS_NM, 1)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.specifiedGroupKill(mob)
        nyzul.specifiedEnemyKill(mob)
    end
end

return this
