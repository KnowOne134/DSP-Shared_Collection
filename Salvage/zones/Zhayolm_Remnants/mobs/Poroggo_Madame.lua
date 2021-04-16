-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Poroggo Madame
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
require("scripts/globals/weather")
-----------------------------------

function onMobSpawn(mob)
    local instance = mob:getInstance()
    local mods = {[1] = dsp.mod.FIRE_ABSORB, [2] = dsp.mod.EARTH_ABSORB, [3] = dsp.mod.WATER_ABSORB, [4] = dsp.mod.WIND_ABSORB, [5] = dsp.mod.ICE_ABSORB, [6] = dsp.mod.LTNG_ABSORB, [7] = dsp.mod.LIGHT_ABSORB, [8] = dsp.mod.DARK_ABSORB}
    local enteringDay = instance:getLocalVar("dayElement") - 1

    mob:addMod(mods[enteringDay], 100)
    if enteringDay == dsp.day.DARKSDAY then -- takes double dmg on Darksday
        mob:addMod(dsp.mod.UDMGPHYS, 100)
        mob:addMod(dsp.mod.UDMGBREATH, 100)
        mob:addMod(dsp.mod.UDMGMAGIC, 100)
        mob:addMod(dsp.mod.UDMGRANGE, 100)
    end
    mob:addMod(dsp.mod.SPELLINTERRUPT, -20)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local stage = instance:getStage()

        instance:setLocalVar("killedNMs", instance:getLocalVar("killedNMs") + 1)

        if stage == 2 then
            salvageUtil.handleSocketCells(mob, player)
        end
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
