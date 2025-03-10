-----------------------------------
-- Area: Lebros Cavern
-----------------------------------
local ID = require("scripts/zones/Lebros_Cavern/IDs")
require("scripts/globals/items")
require("scripts/globals/status")
-----------------------------------

local assaultFood =
{
    [1] = dsp.items.SERVING_OF_BISON_STEAK,
    [2] = dsp.items.COEURL_SUB,
    [3] = dsp.items.STRIP_OF_BISON_JERKY,
    [4] = dsp.items.BOWL_OF_PEA_SOUP,
    [5] = dsp.items.LOAF_OF_WHITE_BREAD,
}


function onTrigger(player, npc)
    local instance = npc:getInstance()
    local entity = instance:getEntity(bit.band(npc:getID(), 0xFFF), dsp.objType.NPC)
    local message_offset = ID.text.RATIONS
    local progress = instance:getProgress()

    if player:getLocalVar("foodGiven") == 0 then
        player:setLocalVar("foodGiven", math.random(1,5))
    end
    local food = assaultFood[player:getLocalVar("foodGiven")]
    if not player:hasItem(food, dsp.inventoryLocation.TEMPITEMS) then
        player:addTempItem(food)
        player:messageText(npc, ID.text.DEPENDING_ON)
        player:timer(3000, function(player) player:messageSpecial(ID.text.TEMP_ITEM, food) end)            
        if progress > 5 and progress < 9 then
            message_offset = message_offset + 1
        elseif progress > 8 and progress < 10 then
            message_offset = message_offset + 2
        elseif progress == 11 then
            message_offset = message_offset + 3
        end
        player:timer(6000, function(player) player:showText(entity, message_offset) end)
    else
        player:messageText(npc, ID.text.HAVE_RATIONS)
        player:timer(3000, function(player) player:showText(entity, message_offset) end)
    end
end
