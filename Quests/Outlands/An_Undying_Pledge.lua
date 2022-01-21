-----------------------------------
-- An Undying Pledge
-- Norg: Stray Cloud
-- qm5 sea serpent grotto
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.OUTLANDS, xi.quest.id.outlands.AN_UNDYING_PLEDGE)

quest.reward = {
    fame = 30,
    item = dsp.items.LIGHT_BUCKLER
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and player:getFameLevel(NORG) >= 4
        end,

        [dsp.zone.NORG] = {
            ['Stray_Cloud'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(225)
                end,
            },

            onEventFinish = {
                [225] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.NORG] = {
            onRegionEnter = {
                [1] = function(player, region)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(226)
                    end
                end,
            },

            ['Stray_Cloud'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:event(228)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:event(229)
                    elseif quest:getVar(player, 'Prog') == 3 and player:hasKeyItem(dsp.ki.CALIGINOUS_BLADE) then
                        return quest:progressEvent(227)
                    end
                end,
            },

            onEventFinish = {
                [226] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
                [227] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.CALIGINOUS_BLADE)
                    quest:complete(player)
                end,
            },
        },

        [dsp.zone.SEA_SERPENT_GROTTO] = {
            ['qm5'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        if npcUtil.popFromQM(player, npc, zones[player:getZoneID()].mob.GLYRYVILU, {hide = 0}) then
                            return quest:messageSpecial(zones[player:getZoneID()].text.BODY_NUMB)
                        end
                    elseif quest:getVar(player, 'Prog') == 2 then
                        return quest:progressEvent(18)
                    end
                end,
            },
            ['Glyryvilu'] = {
                onMobDeath = function(mob, player)
                    if quest:getVar(player, 'Prog') == 1 then
                        quest:setVar(player, 'Prog', 2)
                    end
                end,
            },

            onEventFinish = {
                [18] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    npcUtil.giveKeyItem(player, dsp.ki.CALIGINOUS_BLADE)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.COMPLETED
        end,

        [dsp.zone.NORG] = {
            ['Stray_Cloud'] = {
                onTrigger = function(player, npc)
                   return quest:event(230)
                end,
            },
        },
    },
}


return quest
