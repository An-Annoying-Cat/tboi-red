--TODO: FIX DELAY, FIX PLAYER RED KEY STUFF

--  REAL TODO
--
-- FIX RED'S KEY -- DONE!
-- MOVE ALKALI TO A SEPARATE LUA
-- DO CALDERA
-- FIX MINIMAPI
-- ADD POGS
-- FIX UNLOCKS 
-- DO STUFF


--η μάνα σου
local mod = RegisterMod("Red", 1)

local saveman = require("red_src.core.saveman")
saveman:init(mod)

local functions = require("red_src.core.functions")
functions:init(mod)

local red_room_load= require("red_src.player.red_room_load")
red_room_load:init(mod)

local use_card = require("red_src.callbacks.UseCard")
local use_item = require("red_src.callbacks.UseItem")
local pre_game_exit = require("red_src.callbacks.PreGameExit")
local post_new_room = require("red_src.callbacks.PostNewRoom")
local familiar_init = require("red_src.callbacks.FamiliarInit")
local post_new_level = require("red_src.callbacks.PostNewLevel")
local post_tear_init = require("red_src.callbacks.PostTearInit")
local post_fire_tear = require("red_src.callbacks.PostFireTear")
local evaluate_cache = require("red_src.callbacks.EvaluateCache")
local familiar_update = require("red_src.callbacks.FamiliarUpdate")
local post_tear_update = require("red_src.callbacks.PostTearUpdate")
local post_player_init = require("red_src.callbacks.PostPlayerInit")
local post_pickup_init = require("red_src.callbacks.PostPickupInit")
local post_game_started = require("red_src.callbacks.PostGameStarted")
local post_entity_remove = require("red_src.callbacks.PostEntityRemove")
local post_pickup_update = require("red_src.callbacks.PostPickupUpdate")
local post_effect_update = require("red_src.callbacks.PostEffectUpdate")
local post_peffect_update = require("red_src.callbacks.PostPeffectUpdate")
local pre_pickup_collision = require("red_src.callbacks.PrePickupCollision")
local pre_player_collision = require("red_src.callbacks.PrePlayerCollision")
local post_projectile_init = require("red_src.callbacks.PostProjectileInit")
local pre_room_entity_spawn = require("red_src.callbacks.PreRoomEntitySpawn")
local pre_spawn_clean_award = require("red_src.callbacks.PreSpawnCleanAward")

mod:AddCallback(ModCallbacks.MC_USE_CARD, use_card)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, use_item)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, pre_game_exit)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, post_new_room)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiar_init)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, post_new_level)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, post_tear_init)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, post_fire_tear)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluate_cache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiar_update)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, post_tear_update)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, post_pickup_init)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, post_player_init)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, post_game_started)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, post_entity_remove)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, post_pickup_update)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, post_effect_update)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, post_peffect_update)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, pre_pickup_collision)
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, pre_player_collision)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, post_projectile_init)
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, pre_room_entity_spawn)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, pre_spawn_clean_award)

require("red_src.compat.eid")
require("red_src.compat.encyclopedia")

--pog for good items--
--	if Poglite then
--local playerType = Isaac.GetPlayerTypeByName("Red")
--local pogCostume = Isaac.GetCostumeIdByPath("gfx/characters/RedPog.anm2")
--Poglite:AddPogCostume(RedPog,playerType,pogCostume)
--end

-- Minimap API --
--if MinimapAPI then
--	local Icons = Sprite()
--	Icons:Load("gfx/ui/ui_minimapi_icons.anm2", true)
--	
--	MinimapAPI:AddIcon("cheatcard", Icons, "cheatcard", 0)
--	MinimapAPI:AddPickup("cheatcard", "cheatcard", 5, 300, cheatcard, MinimapAPI.PickupNotCollected, "cards", 9050)
--
--	MinimapAPI:AddIcon("soulred", Icons, "soulred", 0)
--	MinimapAPI:AddPickup("soulred", "soulred", 5, 69, 590, soulred, MinimapAPI.PickupNotCollected, "runes", 9050)
--	
--end

--------------------------------------------------------
mod.PassiveAlkali = Isaac.GetItemIdByName("Alkali")
mod.PassiveCaldera = Isaac.GetItemIdByName("Caldera")
local game = Game()
--------------------------------------------------------
local TEAR_VARIANTS = TearVariant.COIN
local function tearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end

function mod:AlkaliPostTear(tear)
	for i=0, game:GetNumPlayers() - 1, 1 do
		local player = game:GetPlayer(i)
		if player:HasCollectible(mod.PassiveAlkali) then
			tear:ChangeVariant(TEAR_VARIANTS)
    		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE, false)
    		player:EvaluateItems()
		end
	end
end

function mod:AlkaliPostRoom()
    local room = game:GetRoom()
    local roomType = room:GetType()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(mod.PassiveAlkali) then
    	if room:GetType() == RoomType.ROOM_SHOP 
    	and room:IsFirstVisit() and not room:IsMirrorWorld() and #Isaac.FindByType(EntityType.ENTITY_GREED, -1, -1, false, true) == 0 then
    	    player:UseCard(81, 1)
			SFXManager():Stop(SoundEffect.SOUND_SOUL_OF_ISAAC)
			SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
		end
    end
end

--function mod.EvaluateCache(player, cacheFlag)
--	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
--		if player:HasCollectible(mod.PassiveAlkali) then
--			player.MaxFireDelay = tearsUp(player.MaxFireDelay + 0.5)
--		end
--	end	
--end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.AlkaliPostTear)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AlkaliPostRoom)
-- mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)

require("red_src/items/cards/monster_card.lua")
require("red_src/items/passive/edacitus.lua")
