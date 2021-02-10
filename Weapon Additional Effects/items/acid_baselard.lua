-----------------------------------------
-- ID: 16459
-- Item: Acid Baselard
-- Additional Effect: Weakens defense
-----------------------------------------
require("scripts/globals/additional_effects")
require("scripts/globals/status")
-----------------------------------------
function onAdditionalEffect(player,target,damage)
    local params = {}
    params.chance = 10
    params.power = 12
    params.tick = 0
    params.duration = 60
    params.resist = 0.5
    params.effect = dsp.effect.DEFENSE_DOWN

    return effectUtil.weaponStatusEffect(player, target, damage, params)
end
