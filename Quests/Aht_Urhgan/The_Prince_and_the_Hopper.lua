-----------------------------------
-- The Prince and The Hopper
-- Qutiba !pos 92 -7.5 -130 50
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, THE_PRINCE_AND_THE_HOPPER)

quest.reward = {
    item = dsp.items.CHANOIXS_GORGET
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Maudaal'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(889)
                end,
            },
            onEventFinish = {
                [889] = function(player, csid, option, npc)
                    if option == 2 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Maudaal'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 6 then
                        return quest:progressEvent(890)
                    end
                end,
            },
            onEventFinish = {
                [890] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },

        },

        [dsp.zone.MAMOOK] = {
            ['Toad_s_Footprint'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 4 then
                        return quest:progressEvent(223)
                    elseif quest:getVar(player, 'Prog') == 5 then 
                        if quest:getVar(player, 'Option') == 0 then
                            -- missing special spawn animation, cannot find in packet capture.
                            local ID = zones[player:getZoneID()]
                            npcUtil.popFromQM(player, npc, {ID.mob.CASANOVA_OFFSET, ID.mob.CASANOVA_OFFSET + 1, ID.mob.CASANOVA_OFFSET + 2,
                            ID.mob.CASANOVA_OFFSET + 3, ID.mob.CASANOVA_OFFSET + 4, ID.mob.CASANOVA_OFFSET + 5}, {hide = 0})
                            player:messageSpecial(ID.text.IMPENDING_BATTLE)
                        elseif quest:getVar(player, 'Option') == 1 then
                            return quest:progressEvent(225)
                        end
                    end
                end,
            },            
        
            ['Toad_s_Footprint2'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(222)
                    end -- need default text
                end,
            },
        
            ['Poroggo_Casanova'] = {
                onMobDeath = function(mob, player, isKiller, firstCall)
                    for i = 1,5 do
                        if GetMobByID(mob:getID() + i):isAlive() then
                            DespawnMob(mob:getID() + i)
                        end
                    end
                    if quest:getVar(player, 'Prog') == 5 then
                       quest:setVar(player, 'Option', 1)
                    end
                end,
            },               
        
            onZoneIn = {
                function(player, prevZone)
                    if quest:getVar(player, 'Prog') == 3 then
                        return 227
                    end
                end,
            },            
        
            onEventFinish = {
                [222] = function(player, csid, option, npc) -- end of zone in cutscene
                    quest:setVar(player, 'Prog', 2)
                    -- zone the person to wajoam for second part of cs
                    player:setPos(610.542,-28.547,356.247,0,51) -- wajoam woodlands (anywhere)
                end,

                [227] = function(player, csid, option, npc) -- end of 2nd zone in cutscene
                    quest:setVar(player, 'Prog', 4)
                end,

                [223] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 5)
                end,

                [225] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 6)
                end,
            },            
        },

        [dsp.zone.WAJAOM_WOODLANDS] = {
            onZoneIn = {
                function(player, prevZone)
                    local xPos = player:getXPos()
                    local yPos = player:getYPos()
                    local zPos = player:getZPos()
                    if xPos >= 680.0 and yPos >= -19.0 and zPos >= 218.0 and 
                    xPos <= 691.0 and yPos <= -14.0 and zPos <= 221.0 and quest:getVar(player, 'Prog') == 0 then
                        return 513
                    elseif quest:getVar(player, 'Prog') == 2 then
                        return 20
                    end
                end,
            },
            onEventFinish = {
                [20] = function(player, csid, option, npc) -- end of zone in cutscene
                    quest:setVar(player, 'Prog', 3)
                    -- zone the person back to mamook
                    player:setPos(216.100,-23.818,-102.464, 0, 65) 
                end,
                [513] = function(player, csid, option, npc) -- end of zone in cutscene
                    quest:setVar(player, 'Prog', 1)
                end,
            },            
        },
    },
}

return quest
