-----------------------------------
-- Heaven Cent
-- Ropunono !pos -51.8 -11 117
-- iron door !pos
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/titles")
require("scripts/globals/npc_util")
require("scripts/globals/utils")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.WINDURST, xi.quest.id.windurst.HEAVEN_CENT)
local ID = require("scripts/zones/Maze_of_Shakhrami/IDs")
local chest = {
[1] = {7064, 7065, 7066, 7071}, -- right
[2] = {7067, 7068, 7069, 7070} -- wrong
}

quest.reward = {
    fame = 30,
    gil = 4800,
    title = dsp.title.NIGHT_SKY_NAVIGATOR
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and
                player:getFameLevel(WINDURST) >= 5
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Ropunono'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(284)
                end,
            },

            onEventFinish = {
                [284] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 0
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Ropunono'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(285)
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.AHRIMAN_LENS) then
                        return quest:progressEvent(288,  {[1] = dsp.items.AHRIMAN_LENS, [2] = dsp.items.SHELLING_PIECE})
                    end
                end,
            },

            ['Mejina-Monjina'] = quest:progressEvent(286),
            ['Churano-Shurano'] = quest:progressEvent(287),

            onEventFinish = {
                [288] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player,'Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 1
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Ropunono'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Stage') == 1 then
                        return quest:progressEvent(297)
                    else
                        return quest:progressEvent(289, {[1] = dsp.items.AHRIMAN_LENS, [2] = dsp.items.SHELLING_PIECE})
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.SHELLING_PIECE) then
                        if quest:getVar(player, 'Option') == 2 and quest:getVar(player, 'Stage') == 0 then
                            return quest:progressEvent(296)
                        elseif quest:getVar(player, 'Option') == 1 then
                            return quest:progressEvent(292, 4800)
                        end
                    end
                end,
            },
            ['Mejina-Monjina'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Option') == 2 and quest:getVar(player, 'Stage') == 1 then
                        return quest:progressEvent(298)
                    else
                        return quest:progressEvent(290, 0, 0, dsp.items.SHELLING_PIECE)
                    end
                end,
            },
            ['Churano-Shurano'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Option') == 2 and quest:getVar(player, 'Stage') == 1 then
                        return quest:progressEvent(299)
                    else
                        return quest:progressEvent(291)
                    end
                end,
            },
            onEventFinish = {
                [292] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:complete(player)
                end,
                [296] = function(player, csid, option, npc)
                    player:tradeComplete()
                    quest:setVar(player,'Stage', 1)
                end,
            },
        },
        [dsp.zone.MAZE_OF_SHAKHRAMI] = {
            ['_5i0'] = {
                onTrigger = function(player, npc, trade)
                    if player:getXPos() < 247.0 then
                        return quest:messageSpecial(ID.text.MIGHT_OPEN)
                    else
                        return quest:progressEvent(42)
                    end
                end,
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.RUSTY_KEY) then
                        player:messageSpecial(ID.text.MIGHT_OPEN + 1, 0, dsp.items.RUSTY_KEY)
                        return quest:progressEvent(41)
                    end
                end,
            },
            ['_5i4'] = {
                onTrigger = function(player, npc)
                    local choice = math.random(46,47)
                    if player:hasItem(dsp.items.SHELLING_PIECE) then
                        return quest:messageSpecial(ID.text.ALREADY_HAVE_ITEM, dsp.items.SHELLING_PIECE)
                    end
                    if choice == 46 then
                        player:messageSpecial(utils.pickRandom(chest[1]))
                    else
                        player:messageSpecial(utils.pickRandom(chest[2]))
                    end
                    return quest:progressEvent(choice)
                end,
            },
            ['_5i5'] = {
                onTrigger = function(player, npc)
                    local choice = math.random(48,49)
                    if player:hasItem(dsp.items.SHELLING_PIECE) then
                        return quest:messageSpecial(ID.text.ALREADY_HAVE_ITEM, dsp.items.SHELLING_PIECE)
                    end
                    if choice == 48 then
                        player:messageSpecial(utils.pickRandom(chest[1]))
                    else
                        player:messageSpecial(utils.pickRandom(chest[2]))
                    end
                    return quest:progressEvent(choice)
                end,
            },
            ['_5i6'] = {
                onTrigger = function(player, npc)
                    local choice = math.random(50,51)
                    if player:hasItem(dsp.items.SHELLING_PIECE) then
                        return quest:messageSpecial(ID.text.ALREADY_HAVE_ITEM, dsp.items.SHELLING_PIECE)
                    end
                    if choice == 50 then
                        player:messageSpecial(utils.pickRandom(chest[1]))
                    else
                        player:messageSpecial(utils.pickRandom(chest[2]))
                    end
                    return quest:progressEvent(choice)
                end,
            },
            onEventFinish = {
                [41] = function(player, csid, option, npc)
                    player:tradeComplete()
                end,
                [46] = function(player, csid, option, npc)
                    if option > 0 then
                        quest:setVar(player,'Option', option)
                        npcUtil.giveItem(player, dsp.items.SHELLING_PIECE)
                    end
                end,
                [47] = function(player, csid, option, npc)
                    if option > 0 then
                        quest:setVar(player,'Option', option)
                        npcUtil.giveItem(player, dsp.items.SHELLING_PIECE)
                    end
                end,
                [48] = function(player, csid, option, npc)
                    if option > 0 then
                        quest:setVar(player,'Option', option)
                        npcUtil.giveItem(player, dsp.items.SHELLING_PIECE)
                    end
                end,
                [49] = function(player, csid, option, npc)
                    if option > 0 then
                        quest:setVar(player,'Option', option)
                        npcUtil.giveItem(player, dsp.items.SHELLING_PIECE)
                    end
                end,
                [50] = function(player, csid, option, npc)
                    if option > 0 then
                        quest:setVar(player,'Option', option)
                        npcUtil.giveItem(player, dsp.items.SHELLING_PIECE)
                    end
                end,
                [51] = function(player, csid, option, npc)
                    if option > 0 then
                        quest:setVar(player,'Option', option)
                        npcUtil.giveItem(player, dsp.items.SHELLING_PIECE)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.COMPLETED
        end,

        [dsp.zone.WINDURST_WATERS] = {
            -- should actually be "important til you zone" as it repeats this dialogue until you zone
            ['Ropunono'] = quest:progressEvent(293):importantOnce(),
            ['Mejina-Monjina'] = quest:progressEvent(294, {[2] = dsp.items.SHELLING_PIECE}):importantOnce(),
            ['Churano-Shurano'] = quest:progressEvent(295):importantOnce(),
        },
    },
}


return quest
