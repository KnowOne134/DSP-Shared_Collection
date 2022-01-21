-----------------------------------
-- Against All Odds - Leleroon's Sidequests

-- Leleroon: !pos -14.5 0 25 53
-- Door (Windurst): !pos -199 -5.4 -112 238
-- Door (Bastok): !pos 10 0 -16 234
-- Raqtibahl: !pos -59 -4 -39 232
-----------------------------------
require("scripts/globals/common")
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/hidden_quest')
-----------------------------------

local quest = HiddenQuest:new("COR_Quests")

quest.reward = {
}

quest.sections = {
    -- Section: Begin quest
    {
        check = function(player, questVars, vars)
            return player:getQuestStatus(AHT_URHGAN, AGAINST_ALL_ODDS) >= QUEST_ACCEPTED
        end,

        [dsp.zone.NASHMAU] = {
            ['Leleroon'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Stage') == 1 then
                        return quest:progressEvent(285) -- player is on green letter route
                    elseif quest:getVar(player, 'Stage') == 2 then
                        return quest:progressEvent(286) -- player is on blue letter route
                    elseif quest:getVar(player, 'Stage') == 3 then
                        return quest:progressEvent(287) -- player is on red letter route
                    else
                        local excludeFromMenu = quest:getVar(player, 'Aquired')

                        return quest:progressEvent(282, {[7] = excludeFromMenu})
                    end
                end,
            },

            onEventFinish = {
                [282] = function(player, csid, option, npc)
                    if option == 1 then
                        npcUtil.giveKeyItem(player, dsp.ki.LELEROONS_LETTER_GREEN)
                        quest:setVar(player, 'Stage', 1)
                        quest:setVar(player, 'Prog', 1)
                    elseif option == 2 then
                        npcUtil.giveKeyItem(player, dsp.ki.LELEROONS_LETTER_BLUE)
                        quest:setVar(player, 'Stage', 2)
                        quest:setVar(player, 'Prog', 1)
                    elseif option == 3 then
                        npcUtil.giveKeyItem(player, dsp.ki.LELEROONS_LETTER_RED)
                        quest:setVar(player, 'Stage', 3)
                        quest:setVar(player, 'Prog', 1)
                    end
                end,
            },
        },
    },

    {
        check = function(player, questVars, vars)
            return questVars.Stage == 1
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Door_House'] = {
                onTrigger = function(player, npc)
                    if npc:getID() == zones[player:getZoneID()].npc.LELEROON_GREEN_DOOR then
                        local progress = quest:getVar(player, 'Prog')
                        if player:hasKeyItem(dsp.ki.LELEROONS_LETTER_GREEN) then
                            return quest:progressEvent(941)
                        elseif progress == 2 then
                            return quest:progressEvent(942)
                        elseif progress == 3 then
                            return quest:progressEvent(954)
                        elseif progress == 4 then
                            if vanaDay() > quest:getVar(player, 'Option') then
                                return quest:progressEvent(944)
                            else
                                return quest:event(945)
                            end
                        end
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npc:getID() == zones[player:getZoneID()].npc.LELEROON_GREEN_DOOR then
                        local progress = quest:getVar(player, 'Prog')
                        if progress == 2 and npcUtil.tradeHasExactly(trade,
                            {
                                dsp.items.SPOOL_OF_GOLD_THREAD, dsp.items.SQUARE_OF_KARAKUL_LEATHER,
                                dsp.items.SQUARE_OF_RED_GRASS_CLOTH, dsp.items.SPOOL_OF_WAMOURA_SILK
                            }) then
                            return quest:progressEvent(943)
                        elseif progress == 3 and npcUtil.tradeHasExactly(trade, {{dsp.items.IMPERIAL_MYTHRIL_PIECE, 4}}) then
                            return quest:progressEvent(946)
                        end
                    end
                end,
            },

            onEventFinish = {
                [941] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:delKeyItem(dsp.ki.LELEROONS_LETTER_GREEN)
                end,

                [943] = function(player, csid,option, npc)
                    quest:setVar(player, 'Prog', 3)
                    player:confirmTrade()
                end,

                [944] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.CORSAIRS_GANTS) then
                        quest:setVarBit(player, 'Aquired', 1)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Stage', 0)
                        quest:setVar(player, 'Option', 0)
                    end
                end,

                [946] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    quest:setVar(player, 'Option', vanaDay())
                    player:confirmTrade()
                end,
            },
        },
    },

    {
        check = function(player, questVars, vars)
            return questVars.Stage == 2
        end,

        [dsp.zone.BASTOK_MINES] = {
            ['Door_House'] = {
                onTrigger = function(player, npc)
                    if npc:getID() == zones[player:getZoneID()].npc.LELEROON_BLUE_DOOR then
                        local progress = quest:getVar(player, 'Prog')
                        if player:hasKeyItem(dsp.ki.LELEROONS_LETTER_BLUE) then
                            return quest:progressEvent(519)
                        elseif progress == 2 then
                            return quest:progressEvent(520)
                        elseif progress == 3 then
                            return quest:progressEvent(535)
                        elseif progress == 4 then
                            if vanaDay() > quest:getVar(player, 'Option') then
                                return quest:progressEvent(522)
                            else
                                return quest:event(523)
                            end
                        end
                    end
                end,

                onTrade = function(player, npc, trade)
                    if npc:getID() == zones[player:getZoneID()].npc.LELEROON_BLUE_DOOR then
                        local progress = quest:getVar(player, 'Prog')
                        if progress == 2 and npcUtil.tradeHasExactly(trade,
                            {
                                dsp.items.MYTHRIL_SHEET, dsp.items.SQUARE_OF_KARAKUL_LEATHER,
                                dsp.items.SQUARE_OF_LAMINATED_BUFFALO_LEATHER, dsp.items.SQUARE_OF_WOLF_FELT
                            }) then
                            return quest:progressEvent(521)
                        elseif progress == 3 and npcUtil.tradeHasExactly(trade, {{dsp.items.IMPERIAL_MYTHRIL_PIECE, 4}}) then
                            return quest:progressEvent(524)
                        end
                    end
                end,
            },

            onEventFinish = {
                [519] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:delKeyItem(dsp.ki.LELEROONS_LETTER_BLUE)
                end,

                [521] = function(player, csid,option, npc)
                    quest:setVar(player, 'Prog', 3)
                    player:confirmTrade()
                end,

                [522] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.CORSAIRS_BOTTES) then
                        quest:setVarBit(player, 'Aquired', 2)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Stage', 0)
                        quest:setVar(player, 'Option', 0)
                    end
                end,

                [524] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    quest:setVar(player, 'Option', vanaDay())
                    player:confirmTrade()
                end,
            },
        },
    },

    {
        check = function(player, questVars, vars)
            return questVars.Stage == 3
        end,

        [dsp.zone.PORT_SAN_DORIA] = {
            ['Raqtibahl'] = {
                onTrigger = function(player, npc)
                    local progress = quest:getVar(player, 'Prog')
                    if player:hasKeyItem(dsp.ki.LELEROONS_LETTER_RED) then
                        return quest:progressEvent(753)
                    elseif progress == 2 then
                        return quest:progressEvent(754)
                    elseif progress == 3 then
                        return quest:progressEvent(761)
                    elseif progress == 4 then
                        if vanaDay() > quest:getVar(player, 'Option') then
                            return quest:progressEvent(756)
                        else
                            return quest:event(757)
                        end
                    elseif progress == 5 then
                        return quest:progressEvent(758)
                    end
                end,

                onTrade = function(player, npc, trade)
                    local progress = quest:getVar(player, 'Prog')
                    if progress == 2 and npcUtil.tradeHasExactly(trade,
                        {
                            dsp.items.GOLD_CHAIN, dsp.items.SQUARE_OF_VELVET_CLOTH,
                            dsp.items.SQUARE_OF_RED_GRASS_CLOTH, dsp.items.SQUARE_OF_SAILCLOTH
                        }) then
                        return quest:progressEvent(755)
                    -- imperial gold piece
                    elseif progress == 3 and npcUtil.tradeHasExactly(trade, 2187) then
                        return quest:progressEvent(760)
                    end
                end,
            },

            onEventFinish = {
                [753] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:delKeyItem(dsp.ki.LELEROONS_LETTER_RED)
                end,

                [755] = function(player, csid,option, npc)
                    quest:setVar(player, 'Prog', 3)
                    player:confirmTrade()
                end,

                [756] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, dsp.items.CORSAIRS_FRAC) then
                        quest:setVarBit(player, 'Aquired', 3)
                        quest:setVar(player, 'Prog', 0)
                        quest:setVar(player, 'Stage', 0)
                        quest:setVar(player, 'Option', 0)
                    end
                end,

                [760] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                    quest:setVar(player, 'Option', vanaDay())
                    player:confirmTrade()
                end,
            },
        },
    },
}

return quest
