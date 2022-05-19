-----------------------------------
--  MOB: Poroggo Gent
-- Area: Nyzul Isle
-- Info: Specified Mob Group
-----------------------------------
require("scripts/globals/status")
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
        local instance = mob:getInstance()
        local chars = instance:getChars()
        for _, entity in ipairs(chars) do
            if player:hasStatusEffect(dsp.effect.COSTUME) then
                player:delStatusEffect(dsp.effect.COSTUME)
            end
        end
    end
end

return this
