-----------------------------------
-- Cloak and Dagger
-- Jakoh_Wahcondalo !pos 101 -16 -115 250
-- qm1 !pos 52.8 -1 19.9 212
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/keyitems")
require("scripts/globals/quests")
require("scripts/globals/titles")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.OUTLANDS, xi.quest.id.outlands.YOU_CALL_THAT_A_KNIFE)

quest.reward = {
    fame = 30,
    gil = 7200,
    title = dsp.title.YA_DONE_GOOD
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and player:getFameLevel(WINDURST) >= 6
        end,

        [dsp.zone.KAZHAM] = {
            ['Mhebi_Juhbily'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.SANDFISH) then
                        return quest:progressCutscene(127, {[1] = dsp.items.SANDFISH, [2] = dsp.items.SANDFISH})
                    end
                end,

                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:event(318)
                    else
                        return quest:event(125) -- default
                    end
                end,
            },

            ['_6y9'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(128)
                    end
                end,
            },

            onEventFinish = {
                [127] = function(player, csid, option, npc)
                    player:tradeComplete()
                    if option == 511 then
                        quest:setVar(player, 'Prog', 1)
                    end
                end,
                [128] = function(player, csid, option, npc)
                    if option == 1 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.KAZHAM] = {
            ['Mhebi_Juhbily'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 or quest:getVar(player, 'Prog') == 2 then -- check var does it reset when quest begins
                        return quest:event(129)
                    elseif quest:getVar(player, 'Prog') == 3 and player:hasKeyItem(dsp.ki.NONBERRYS_KNIFE) then
                        return quest:progressEvent(133)
                    end
                end,
            },
            ['Vah_Keshura'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:event(130)
                    elseif quest:getVar(player, 'Prog') == 2 then
                        return quest:event(131)
                    elseif quest:getVar(player, 'Prog') == 3 then
                        return quest:event(132)
                    end
                end,
            },

            onEventFinish = {
                [130] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
                [133] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.TEMPLE_OF_UGGALEPIH] = {
            ['Chef_Nonberry'] = {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.TONBERRY_BOARD) then
                        return quest:event(27)
                    else
                        return quest:event(28)
                    end
                end,
            },
            onEventFinish = {
                [27] = function(player, csid, option, npc)
                    player:tradeComplete()
                    npcUtil.giveKeyItem(player, dsp.ki.NONBERRYS_KNIFE)
                    quest:setVar(player, 'Prog', 3)
                end,
                [28] = function(player, csid, option, npc)
                    player:tradeComplete()
                    if os.time() > npc:getLocalVar("Cue") then
                        if npcUtil.popFromQM(player, npc, {zones[player:getZoneID()].mob.COOK_SOLBERRY, zones[player:getZoneID()].mob.COOK_SOLBERRY + 1,
                        zones[player:getZoneID()].mob.COOK_SOLBERRY + 2, zones[player:getZoneID()].mob.COOK_SOLBERRY + 3}, {hide = 0}) then
                            npc:setLocalVar("Cue", os.time() + 900)
                        end
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.quest.status.COMPLETED
        end,

        [dsp.zone.KAZHAM] = {
            ['Mhebi_Juhbily'] = {
                onTrigger = function(player, npc)
                    return quest:event(134)
                end,
            },
        },
    },
}


return quest
