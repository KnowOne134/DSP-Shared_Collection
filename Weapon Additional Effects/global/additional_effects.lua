-----------------------------------
-- Additional Effects
-- desc:
-----------------------------------
require("scripts/globals/magic")
require("scripts/globals/status")
require("scripts/globals/utils")
require("scripts/globals/msg")
require("scripts/globals/weather")
require("scripts/globals/zone")
-----------------------------------
effectUtil = {}
-----------------------------------

local elementTable =
{
    [dsp.magic.ele.FIRE]      = {day = dsp.day.FIRESDAY,     subEle = dsp.subEffect.FIRE_DAMAGE},
    [dsp.magic.ele.EARTH]     = {day = dsp.day.EARTHSDAY,    subEle = dsp.subEffect.EARTH_DAMAGE},
    [dsp.magic.ele.WATER]     = {day = dsp.day.WATERSDAY,    subEle = dsp.subEffect.WATER_DAMAGE},
    [dsp.magic.ele.WIND]      = {day = dsp.day.WINDSDAY,     subEle = dsp.subEffect.WIND_DAMAGE},
    [dsp.magic.ele.ICE]       = {day = dsp.day.ICEDAY,       subEle = dsp.subEffect.ICE_DAMAGE},
    [dsp.magic.ele.LIGHTNING] = {day = dsp.day.LIGHTNINGDAY, subEle = dsp.subEffect.LIGHTNING_DAMAGE},
    [dsp.magic.ele.LIGHT]     = {day = dsp.day.LIGHTSDAY,    subEle = dsp.subEffect.LIGHT_DAMAGE},
    [dsp.magic.ele.DARK]      = {day = dsp.day.DARKSDAY,     subEle = dsp.subEffect.DARK_DAMAGE},
}

local effectTable =
{
    [dsp.effect.STUN]         = {element = dsp.magic.ele.LIGHTNING, subE = dsp.subEffect.STUN,          immune = dsp.immunity.STUN},
    [dsp.effect.POISON]       = {element = dsp.magic.ele.WATER,     subE = dsp.subEffect.POISON,        immune = dsp.immunity.POISON},
    [dsp.effect.BLINDNESS]    = {element = dsp.magic.ele.DARK,      subE = dsp.subEffect.BLIND,         immune = dsp.immunity.BLIND},
    [dsp.effect.SLEEP_I]      = {element = dsp.magic.ele.DARK,      subE = dsp.subEffect.SLEEP,         immune = dsp.immunity.DARKSLEEP},
    [dsp.effect.SLOW]         = {element = dsp.magic.ele.EARTH,     subE = dsp.subEffect.EARTH_DAMAGE,  immune = dsp.immunity.SLOW},
    [dsp.effect.SILENCE]      = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.SILENCE,       immune = dsp.immunity.SILENCE},
    [dsp.effect.PARALYSIS]    = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.PARALYSIS,     immune = dsp.immunity.PARALYZE},
    [dsp.effect.BIND]         = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.PARALYSIS,     immune = dsp.immunity.BIND},
    [dsp.effect.WEIGHT]       = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.WIND_DAMAGE,   immune = dsp.immunity.WEIGHT},
    [dsp.effect.CURSE_I]      = {element = dsp.magic.ele.DARK,      subE = dsp.subEffect.CURSE},
    [dsp.effect.CHOKE]        = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.CHOKE},
    [dsp.effect.DEFENSE_DOWN] = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.DEFENSE_DOWN, remove = dsp.effect.DEFENSE_BOOST},
    [dsp.effect.EVASION_DOWN] = {element = dsp.magic.ele.WIND,      subE = dsp.subEffect.EVASION_DOWN, remove = dsp.effect.EVASION_BOOST},
    [dsp.effect.ATTACK_DOWN]  = {element = dsp.magic.ele.WATER,     subE = dsp.subEffect.ATTACK_DOWN,  remove = dsp.effect.ATTACK_BOOST},
}

function effectUtil.weaponElementalEffect(player, target, damage, params)
    local chance = params.percent
    local element = params.element
    local chargeItem = params.charge
    local tableUse = elementTable[element]
    local rank = 0

    if VanadielDayElement() == tableUse.day then
        chance = chance + params.bonusPercent
    end

    if chargeItem ~= nil then
        local ammoPower =
        {
            [dsp.magic.ele.WATER]     = {18232, 18233, 18234},
            [dsp.magic.ele.WIND]      = {18236, 18237, 18238},
            [dsp.magic.ele.LIGHTNING] = {18228, 18229, 18230},
        }
        local ammoCheck = false
        for k,v in pairs(ammoPower[element]) do
            if player:getEquipID(dsp.slot.AMMO) == v then
                ammoCheck = true
                rank = k
            end
        end
        if ammoCheck == false then
            return 0, 0, 0
        end
    end

    if math.random(0, 99) >= chance then
        return 0, 0, 0
    else
        local dmg = math.random(params.damageLow, params.damageHigh) + (rank * 10)

        dmg = addBonusesAbility(player, element, target, dmg, params)
        dmg = dmg * applyResistanceAddEffect(player, target, element, 0)
        dmg = adjustForTarget(target, dmg, element)
        dmg = finalMagicNonSpellAdjustments(player, target, element, dmg)

        local message = dsp.msg.basic.ADD_EFFECT_DMG
        if dmg < 0 then
            message = dsp.msg.basic.ADD_EFFECT_HEAL
        end

        if chargeItem ~= nil then
            player:removeAmmo()
        end

        return tableUse.subEle, message, dmg
    end
end

function effectUtil.weaponStatusEffect(player, target, damage, params)
    local effect = params.effect
    local chance = params.chance
    local immune = effectTable[effect].immune
    local element = effectTable[effect].element
    if (immune ~= nil and target:hasImmunity(immune)) or target:hasStatusEffect(effect) then
        return 0, 0, 0
    end

    if math.random(0, 99) <= chance and applyResistanceAddEffect(player, target, element, effect) > params.resist then

        if immune ~= nil and not target:hasImmunity(immune) then
            local removable = effectTable[effect].remove
            if removable ~= nil then
                target:delStatusEffect(removable)
            end
        end
        target:addStatusEffect(effect, params.power, params.tick or 0, params.duration, 0, params.subPower or 0)
        return effectTable[effect].subE, dsp.msg.basic.ADD_EFFECT_STATUS, effect
    end
    return 0, 0, 0
end

function effectUtil.weaponDrainEffect(player, target, damage, params)
    local chance = params.chance

    if params.dayBonus == true then
        if VanadielDayElement() == dsp.day.DARKSDAY then
            chance = chance + 250 -- +25%
        end

        local weather = player:getWeather()

        if weather == dsp.weather.GLOOM then
            chance = chance + 50 -- +5%
        elseif weather == dsp.weather.DARKNESS then
            chance = chance + 100 -- +10%
        end
    end

if (target:isUndead() and params.effect == dsp.subEffect.HP_DRAIN) or (target:isUndead() and params.effect == dsp.subEffect.MP_DRAIN)
    or (params.effect == dsp.subEffect.MP_DRAIN and target:getMP() == 0)  then
        return 0, 0, 0
    elseif math.random(0,999) >= chance then
        return 0, 0, 0
    else
        local drain = math.random(params.damageLow, params.damageHigh)

        drain = addBonusesAbility(player, dsp.magic.ele.DARK, target, drain, params)
        drain = drain * applyResistanceAddEffect(player, target, dsp.magic.ele.DARK, 0)
        drain = adjustForTarget(target, drain, dsp.magic.ele.DARK)
        if drain < 0 then
            drain = 0
        end
        drain = finalMagicNonSpellAdjustments(player, target, dsp.magic.ele.DARK, drain)

        if params.effect == dsp.subEffect.HP_DRAIN then
            target:addHP(-drain)
            return dsp.subEffect.HP_DRAIN, dsp.msg.basic.ADD_EFFECT_HP_DRAIN, player:addHP(drain)
        elseif params.effect == dsp.subEffect.MP_DRAIN then
            target:addMP(-drain)
            return dsp.subEffect.MP_DRAIN, dsp.msg.basic.ADD_EFFECT_MP_DRAIN, player:addMP(drain)
        end
    end
end
