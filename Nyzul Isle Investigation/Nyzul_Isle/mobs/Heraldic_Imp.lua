-----------------------------------
--  MOB: Heraldic Imp
-- Area: Nyzul Isle
-- Info: Specified Mob Group
-----------------------------------

local this = {}

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.specifiedGroupKill(mob)
    end
end

return this
