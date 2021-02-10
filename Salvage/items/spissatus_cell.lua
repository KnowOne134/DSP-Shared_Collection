-----------------------------------------
-- Spissatus Cell
-- ID 5384
-- Removes MP Down effect
-----------------------------------------
require("scripts/globals/status")
require("scripts/globals/additional_effects")
-----------------------------------------

function onItemCheck(target)
    return itemUtil.onSalvageItemCheck(target, dsp.effect.DEBILITATION, 0x100)
end

function onItemUse(target)
    return itemUtil.onSalvageItemUse(target, dsp.effect.DEBILITATION, 0x100, 19)
end
