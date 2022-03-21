-----------------------------------
-- Area: Nyzul Isle
--  MOB: Imp
-----------------------------------
mixins = {require("scripts/mixins/families/imp")}
require("scripts/globals/utils/nyzul")
-----------------------------------

function onMobSpawn(mob)
    nyzul.specifiedEnemySet(mob)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.specifiedEnemyKill(mob)
    end
end
