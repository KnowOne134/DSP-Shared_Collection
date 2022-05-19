-----------------------------------
--  MOB: Peryton
-- Area: Nyzul Isle
-----------------------------------
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
