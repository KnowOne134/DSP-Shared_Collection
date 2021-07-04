-----------------------------------
-- Crimson Orb Mini Quest
-- HQuest[Crimson_Orb]Prog
-- Wall of banishing !pos 181 0.1 -218 149
-- Sedal-Godjal !pos 185 -3 -116 149
-- Ponds:
-- !pos -219 0.1 -101 149
-- !pos 380 0.1 -181 149
-- !pos 21 0.1 -258 149
-- !pos 101 0.1 60 149
-----------------------------------
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/hidden_quest')
-----------------------------------

local quest = HiddenQuest:new("Crimson_Orb")

quest.reward = {
    keyItem = dsp.ki.CRIMSON_ORB,
}

quest.orbCheck = function(player, npc)
    if player:hasKeyItem(dsp.ki.WHITE_ORB) then
        if npcUtil.giveKeyItem(player, dsp.ki.PINK_ORB) then
            player:delKeyItem(dsp.ki.WHITE_ORB)
        end
    elseif player:hasKeyItem(dsp.ki.PINK_ORB) then
        if npcUtil.giveKeyItem(player, dsp.ki.RED_ORB) then
            player:delKeyItem(dsp.ki.PINK_ORB)
        end
    elseif player:hasKeyItem(dsp.ki.RED_ORB) then
        if npcUtil.giveKeyItem(player, dsp.ki.BLOOD_ORB) then
            player:delKeyItem(dsp.ki.RED_ORB)
        end
    elseif player:hasKeyItem(dsp.ki.BLOOD_ORB) then
        if npcUtil.giveKeyItem(player, dsp.ki.CURSED_ORB) then
            player:delKeyItem(dsp.ki.BLOOD_ORB)
            player:addStatusEffect(dsp.effect.CURSE_I, 50, 0, 900)
        end
    end
end

quest.sections = {
    {
        check = function(player, questVars, vars)
            return not player:hasKeyItem(dsp.ki.CRIMSON_ORB)
                and questVars.Prog == 0
        end,

        [dsp.zone.DAVOI] = {
            ['_45d'] = {
                onTrigger = function(player, npc)
                    player:messageSpecial(zones[player:getZoneID()].text.CAVE_HAS_BEEN_SEALED_OFF)
                    player:messageSpecial(zones[player:getZoneID()].text.MAY_BE_SOME_WAY_TO_BREAK)
                    return quest:setVar(player, 'Prog', 32)
                end,
            },
        },
    },
    {
        check = function(player, questVars, vars)
            return questVars.Prog > 0
        end,

        [dsp.zone.DAVOI] = {
            ['_45d'] = {
                onTrigger = function(player, npc)
                    player:messageSpecial(zones[player:getZoneID()].text.CAVE_HAS_BEEN_SEALED_OFF)
                    return quest:messageSpecial(zones[player:getZoneID()].text.MAY_BE_SOME_WAY_TO_BREAK)
                end,
            },
            ['Sedal-Godjal'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 32 then
                        return quest:progressEvent(22)
                    elseif player:hasKeyItem(dsp.ki.CURSED_ORB) then
                        return quest:progressEvent(25, {[3] = dsp.ki.CRIMSON_ORB})
                    else
                        return quest:event(21)
                    end
                end,
            },
            ['_45g'] = {
                onTrigger = function(player, npc)
                    if not quest:isVarBitsSet(player, 'Prog', 1) then
                        return quest:progressCutscene(50)
                    end
                end,
            },
            ['_45h'] = {
                onTrigger = function(player, npc)
                    if not quest:isVarBitsSet(player, 'Prog', 2) then
                        return quest:progressCutscene(51)
                    end
                end,
            },
            ['_45i'] = {
                onTrigger = function(player, npc)
                    if not quest:isVarBitsSet(player, 'Prog', 3) then
                        return quest:progressCutscene(52)
                    end
                end,
            },
            ['_45j'] = {
                onTrigger = function(player, npc)
                    if not quest:isVarBitsSet(player, 'Prog', 4) then
                        return quest:progressCutscene(53)
                    end
                end,
            },

            onEventFinish = {
                [22] = function(player, csid, option, npc)
                    if option == 1 then
                        npcUtil.giveKeyItem(player, dsp.ki.WHITE_ORB)
                        quest:setVar(player, 'Prog', 1)
                    end
                end,
                [25] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(dsp.ki.CURSED_ORB)
                        quest:setVar(player, 'Prog', 0)
                    end
                end,
                [50] = function(player, csid, option, npc)
                    quest.orbCheck(player, npc)
                    quest:setVarBit(player, 'Prog', 1)
                end,
                [51] = function(player, csid, option, npc)
                    quest.orbCheck(player, npc)
                    quest:setVarBit(player, 'Prog', 2)
                end,
                [52] = function(player, csid, option, npc)
                    quest.orbCheck(player, npc)
                    quest:setVarBit(player, 'Prog', 3)
                end,
                [53] = function(player, csid, option, npc)
                    quest.orbCheck(player, npc)
                    quest:setVarBit(player, 'Prog', 4)
                end,
            },
        },
    },
}

return quest
