-----------------------------------
-- Area: Bhaflau Remnants
--  MOB: Empathic Flan
-- Defeating all four in AnimationSub(2) will spawn Dormant Rampart
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/status")
-----------------------------------

function onMobSpawn(mob)
    mob:AnimationSub(1)

    if mob:getID() == ID.mob[2][0].STAGE_START.MAGICAL then
        mob:setMod(dsp.mod.DMGMAGIC, -25)
        mob:addMod(dsp.mod.DMGPHYS, 0)
        mob:addMod(dsp.mod.DMGRANGE, 0)
    else
        mob:setMod(dsp.mod.DMGPHYS, -25)
        mob:setMod(dsp.mod.DMGRANGE, -25)
        mob:setMod(dsp.mod.DMGMAGIC, 0)
    end

    mob:addListener("TAKE_DAMAGE", "FLAN_TAKE_DAMAGE", function(mob, damage, attacker, attackType, damageType)
        if (attackType == dsp.attackType.PHYSICAL or attackType == dsp.attackType.RANGED) and mob:getLocalVar("exitMode") == 0 then
            accumulated = mob:getLocalVar("physical")
            accumulated = accumulated + damage
            if accumulated > mob:getMaxHP() * 0.1 or damage > mob:getMaxHP() * 0.1 then
                mob:AnimationSub(2) -- Spike head
                mob:addMod(dsp.mod.DMGPHYS, -50)
                mob:addMod(dsp.mod.DMGRANGE, -50)
                mob:addMod(dsp.mod.DMGMAGIC, 50)
                mob:setLocalVar("Damage", 1)
                accumulated = 0
            end
            mob:setLocalVar("physical", accumulated)
        elseif (attackType == dsp.attackType.PHYSICAL or attackType == dsp.attackType.RANGED) and mob:getLocalVar("exitMode") == 1 then
            accumulated = mob:getLocalVar("physical")
            accumulated = accumulated + damage
            if accumulated > mob:getMaxHP() * 0.5 or damage > mob:getMaxHP() * 0.2 then
                mob:AnimationSub(2) -- Spike head
                mob:addMod(dsp.mod.DMGPHYS, -50)
                mob:addMod(dsp.mod.DMGRANGE, -50)
                mob:addMod(dsp.mod.DMGMAGIC, 50)
                mob:setLocalVar("Damage", 1)
                accumulated = 0
            end
            mob:setLocalVar("physical", accumulated)
        else
            accumulated = mob:getLocalVar("magical")
            accumulated = accumulated + damage
            if accumulated > mob:getMaxHP() * 0.1 or damage > mob:getMaxHP() * 0.1 then
                mob:AnimationSub(1) -- Smooth head
                mob:addMod(dsp.mod.DMGPHYS, 50)
                mob:addMod(dsp.mod.DMGRANGE, 50)
                mob:addMod(dsp.mod.DMGMAGIC, -50)
                mob:setLocalVar("Damage", 0)
                mob:setLocalVar("exitMode", 1)
                accumulated = 0
            end
            mob:setLocalVar("magical", accumulated)
        end
    end)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local dormant = instance:getEntity(bit.band(ID.npc[2].DORMANT, 0xFFF), dsp.objType.NPC)
        local spawn = dormant:getLocalVar("spawn")

        if mob:getLocalVar("Damage") == 1 then
            dormant:setLocalVar("spawn", spawn + 1)
            if dormant:getLocalVar("spawn") == 4 then
                dormant:setStatus(dsp.status.NORMAL)
                dormant:untargetable(false)
            end
        end
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
