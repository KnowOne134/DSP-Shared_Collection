-----------------------------------
-- Go! Go! Gobmuffin
-- tav safehold: Epinoille !pos -102.219 -27.25 58.77
-- riverne b01: displacement !pos 389.32 52.4 692.68
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
-----------------------------------

local quest = Quest:new(OTHER_AREAS_LOG, GO_GO_GOBMUFFIN)

quest.reward = {
    keyItem = dsp.ki.MAP_OF_CAPE_RIVERNE, -- no xp or gil reward in era
}

quest.sections = {
     {
        check = function(player, status, vars)
            return player:getCurrentMission(COP) >= THE_SAVAGE
            and status == QUEST_AVAILABLE
        end,

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Epinolle'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(232)
                end,
            },
            onEventFinish = {
                [232] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [dsp.zone.RIVERNE_SITE_B01] = {
            ['Spatial_Displacement'] = {
                onTrigger = function(player, npc)
                end,                
            },
            onEventFinish = {
                [17] = function(player, csid, option, npc)
                    local Option = quest:getVar(player, 'Option')                
                    if quest:getVar(player, 'Prog') == 0 and option == 0 and Option < 3 and npc:getLocalVar("Cue") <= os.time() then
                        local mobid = zones[player:getZoneID()].mob.SPELL_SPLITTER_OFFSET
                        if (not GetMobByID(mobid):isSpawned() and not GetMobByID(mobid + 1):isSpawned() and not GetMobByID(mobid + 2):isSpawned()) then
                            SpawnMob(mobid):updateClaim(player)
                            SpawnMob(mobid + 1):updateClaim(player)
                            SpawnMob(mobid + 2):updateClaim(player)
                            npc:setLocalVar("Cue",os.time() + 300)
                        end
                    end
                end,
            },

            ['Spell_Spitter_Spilospok'] = {
                onMobDeath = function(mob, player, isKiller)
                    quest:setVar(player, 'Option', quest:getVar(player, 'Option') + 1)
                    if quest:getVar(player, 'Option') >= 3 then
                        quest:setVar(player, 'Prog', 1)
                    end
                end,
            },

            ['Book_Browser_Bokabraq'] = {
                onMobDeath = function(mob, player, isKiller)
                    quest:setVar(player, 'Option', quest:getVar(player, 'Option') + 1)
                    if quest:getVar(player, 'Option') >= 3 then
                        quest:setVar(player, 'Prog', 1)
                    end
                end,
            },
            ['Chemical_Cook_Chemachiq'] = {
                onMobDeath = function(mob, player, isKiller)
                    quest:setVar(player, 'Option', quest:getVar(player, 'Option') + 1)
                    if quest:getVar(player, 'Option') >= 3 then
                        quest:setVar(player, 'Prog', 1)
                    end
                end,
            },            
        },

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Epinolle'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 0 then
                        return quest:progressEvent(233)
                    elseif quest:getVar(player, 'Prog') == 1 then
                        return quest:progressEvent(234)
                    end                
                end,
            },
            onEventFinish = {
                [234] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED
        end,

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Epinolle'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(235)
                end,
            },
        },
    },
}

return quest
