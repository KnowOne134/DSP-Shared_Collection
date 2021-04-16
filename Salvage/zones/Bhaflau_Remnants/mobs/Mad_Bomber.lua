-----------------------------------
-- Area: Bhaflau Remnants
--  MOB: Mad Bomber
--  Self-Destructs after about 75 seconds
--  Spawns Rampart if it dies before self-destruct
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/status")
-----------------------------------

function onMobSpawn(mob)
    mob:AnimationSub(0)
end

function onMobEngaged(mob, target)
    mob:setLocalVar("shifttime", 15)
end

function onMobFight(mob, target)
    local size = mob:AnimationSub()
    local shifttime = mob:getLocalVar("shifttime")

    if mob:getBattleTime() > shifttime then
        if size == 3 then
            mob:useMobAbility(511)
            mob:getLocalVar("timeUp", 1)
        else
            mob:setLocalVar("shifttime", shifttime + 20)
            mob:AnimationSub(size + 1)
        end
    end
end

function onMobDeath(mob, player, isKiller, firstCall)
	if firstCall then
        local instance = mob:getInstance()

        if mob:getLocalVar("timeUp") == 0 then
            local dormant = instance:getEntity(bit.band(ID.npc[1].DORMANT, 0xFFF), dsp.objType.NPC)
            dormant:setStatus(dsp.status.NORMAL)
            dormant:untargetable(false)
        end
    end
end
