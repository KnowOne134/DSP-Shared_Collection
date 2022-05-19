-----------------------------------
--  MOB: Uriri Samariri
-- Area: Nyzul Isle
-- Info: Enemy Leader, Spams Water Bomb
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.enemyLeaderKill(mob)
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
