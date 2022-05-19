-----------------------------------
-- Area: Nyzul Isle
--  MOB: Imp
-----------------------------------
mixins = {require("scripts/mixins/families/imp")}
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    nyzul.specifiedEnemySet(mob)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.specifiedEnemyKill(mob)
    end
end

return this
