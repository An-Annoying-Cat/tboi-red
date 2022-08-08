local item = {} 
---------------------------------------------------
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")
local global = require("red_src.core.global")
local enums = require("red_src.core.enums")
----------------------------------------------------
local COLLECTIBLE = enums.collectibles.entropy
local MIN_ITEM_QUALITY = 1 
----------------------------------------------------
local MAX_TMTRAINER_ID = 2^30
local QUEST_TAG = ItemConfig.TAG_QUEST
----------------------------------------------------
local level, rng = global.game:GetLevel(), global.rng
local ItemConfig = Isaac.GetItemConfig()
---------------------------------------------------
--- HANDLE PICKUP
function item:PostPickupUpdate(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE or not functions:item_exists(COLLECTIBLE) then return end

	local itemID = pickup.SubType
	if itemID == 0 then return end

	local itemConfig = ItemConfig:GetCollectible(itemID)

	if itemID > MAX_TMTRAINER_ID 
	or itemConfig.Quality > MIN_ITEM_QUALITY 
	or itemConfig.Tags & QUEST_TAG == QUEST_TAG then return end
	
	pickup:AddEntityFlags(EntityFlag.FLAG_GLITCH)
end
--- HANDLE FLIGHT
function item:EvaluateCache(player, cache)
	if cache ~= CacheFlag.CACHE_FLYING or not player:HasCollectible(COLLECTIBLE) then return end
	
	player.CanFly = true
end
---------------------------------------------------
return item
