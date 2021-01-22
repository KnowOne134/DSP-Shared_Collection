-----------------------------------
-- Olduum
-- Dkhaaya !pos -73 -1 -6 50
-- Excavation Site !pos 390 1 349 68
-- Leypoint !pos -200 -8.5 80 51
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require('scripts/globals/npc/quest')
require("scripts/globals/npc_util")
-----------------------------------

local quest = Quest:new(AHT_URHGAN, OLDUUM)

quest.reward = {
    item = dsp.items.LIGHTNING_BAND,
}

local keyItems =
    {
        dsp.ki.ELECTROCELL,
        dsp.ki.ELECTROPOT,
        dsp.ki.ELECTROLOCOMOTIVE,
    }

quest.hasKeyItem = function(player)
    for i, v in pairs(keyItems) do
        if player:hasKeyItem(v) then
            return true
        end
    end
    return false
end

quest.sections = {
    -- Section: Begin quest
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Dkhaaya'] = {
                onTrigger = function(player, npc)
                    return quest:checkStartEvent(player, 4)
                end
            },

            onEventFinish = {
                [4] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, dsp.ki.DKHAAYAS_RESEARCH_JOURNAL)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Dkhaaya'] = {
                onTrigger = function(player, npc)
                    if quest.hasKeyItem(player) then
                        return quest:progressEvent(6)
                    else
                        return quest:event(5)
                    end
                end
            },

            onEventFinish = {
                [6] = function(player, csid, option, npc)
                    player:delKeyItem(keyItems[quest:getVar(player, 'Prog')])
                    player:delKeyItem(dsp.ki.DKHAAYAS_RESEARCH_JOURNAL)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.AYDEEWA_SUBTERRANE] = {
            ['Excavation_Site'] = {
                onTrade = function(player, npc, trade)
                    if not player:hasItem(dsp.items.OLDUUM_RING) and not quest.hasKeyItem(player) and npcUtil.tradeHasExactly(trade, dsp.items.PICKAXE) then
                        if math.random(1,10) > 5 then
                            quest:setVar(player, 'Prog', math.random(1,3))

                            return quest:progressEvent(0, {[0] = keyItems[quest:getVar(player, 'Prog')]})
                        else
                            player:setLocalVar("mineFail", 1)
                            return quest:progressEvent(0, {[1] = 1})
                        end
                    end
                end,
            },

            onEventFinish = {
                [0] = function(player, npc, trade)
                    if player:getLocalVar("mineFail") == 1 then
                        player:setLocalVar("mineFail", 0)
                        player:confirmTrade()
                    else
                        player:addKeyItem(keyItems[quest:getVar(player, 'Prog')])
                        player:confirmTrade()
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Dkhaaya'] = {
                onTrigger = function(player, npc)
                    if quest.hasKeyItem(player) then
                        return quest:progressEvent(8)
                    elseif player:hasItem(dsp.items.OLDUUM_RING) or player:hasItem(dsp.items.LIGHTNING_BAND) then
                        return quest:event(7)
                    else
                        local newRingCS = player:getLocalVar("RingCS")
                        player:setLocalVar("RingCS", newRingCS + 1)
                        if newRingCS > 1 then
                            newRingCS = 1
                        end
                        return quest:event(7, {[7] = newRingCS + 1})
                    end
                end,
            },

            onEventFinish = {
                [8] = function(player, csid, option, npc)
                    npcUtil.giveItem(player,dsp.items.LIGHTNING_BAND)
                    player:delKeyItem(keyItems[quest:getVar(player, 'Prog')])
                    quest:setVar(player, 'Prog', 0)
                end,
            },
        },

        [dsp.zone.WAJAOM_WOODLANDS] = {
            ['Leypoint'] = {
                onTrigger = function(player, npc)
                    if player:hasItem(dsp.items.LIGHTNING_BAND) then
                        return quest:messageSpecial(zones[player:getZoneID()].text.LEYPOINT + 1, dsp.items.LIGHTNING_BAND)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.LIGHTNING_BAND) then
                        if player:getFreeSlotsCount() == 0 then
                            return quest:messageSpecial(zones[player:getZoneID()].ITEM_CANNOT_BE_OBTAINED)
                        else
                            return quest:progressEvent(2)
                        end
                    end
                end,
            },

            onEventFinish = {
                [2] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.OLDUUM_RING) then
                        player:confirmTrade()
                    end
                end,
            },
        },

        [dsp.zone.AYDEEWA_SUBTERRANE] = {
            ['Excavation_Site'] = {
                onTrade = function(player, npc, trade)
                    if not player:hasItem(dsp.items.OLDUUM_RING) and not quest.hasKeyItem(player) and npcUtil.tradeHasExactly(trade, dsp.items.PICKAXE) then
                        if math.random(1,10) > 5 then
                            quest:setVar(player, 'Prog', math.random(1,3))

                            return quest:progressEvent(0, {[0] = keyItems[quest:getVar(player, 'Prog')]})
                        else
                            player:setLocalVar("mineFail", 1)
                            return quest:progressEvent(0, {[1] = 1})
                        end
                    end
                end,
            },

            onEventFinish = {
                [0] = function(player, npc, trade)
                    if player:getLocalVar("mineFail") == 1 then
                        player:setLocalVar("mineFail", 0)
                        player:confirmTrade()
                    else
                        player:addKeyItem(keyItems[quest:getVar(player, 'Prog')])
                        player:confirmTrade()
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status >= QUEST_AVAILABLE
        end,

        [dsp.zone.AYDEEWA_SUBTERRANE] = {
            ['Excavation_Site'] = {
                onTrigger = function(player, npc)
                    return quest:message(zones[player:getZoneID()].text.NOTHING_HAPPENS)
                end,
            },
        },
    },
}

return quest
