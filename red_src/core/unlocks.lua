local unlocks = {}
local enums = require("red_src.core.enums") 
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")

local game = global.game

function unlocks:PostPickupInit(pickup)
	local isCollectible = pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE 

	if not isCollectible
	and pickup.SubType <= enums.collectibles.reds_key 
	and pickup.SubType >= enums.collectibles.lil_warlock 

	and pickup.Variant ~= PickupVariant.PICKUP_TRINKET 
	and pikcup.SubType <= enums.trinkets.red_lock 
	and pickup.SubType >= enums.trinkets.red_handle then return end
	
	for i, v in pairs(isCollectible and enums.collectibles or enums.trinkets) do
		if v == pickup.SubType and not saveman.save.unlocks[i] then
			pickup:Morph(EntityType.ENTITY_PICKUP, pickup.Variant, 0, false, true)
		end
	end
end

-------------

local unlocks_red = {
	--[08] = tba
	--[25] = tba
	[39] = "pathos",
	[40] = "extus",
	[24] = "zenith",
	[54] = "trance",
	[55] = "entropy",
	[70] = "reds_key",
	[62] = "crystal_key_start", --haha fuck you retards ultra greedier ftw!!!!!
	[63] = "dementia",
	--[88] = tba
	--["beast"] = tba
	["bossrush"] = "lil_warlock"
}

local unlocks_stage = {
	--[08] = LevelStage.STAGE4_2
	--[25] = LevelStage.STAGE4_2
	[39] = LevelStage.STAGE5,
	[40] = LevelStage.STAGE6,
	[24] = LevelStage.STAGE5,
	[54] = LevelStage.STAGE6,
	[55] = LevelStage.STAGE6,
	[70] = LevelStage.STAGE7,
	[62] = LevelStage.STAGE7_GREED,
	[63] = LevelStage.STAGE4_3,
	--[88] = LevelStage.STAGE4_2,	
}

local unlocks_gray

function unlocks:PreSpawnCleanAward(RNG)
	if not functions:red_exists() then return end

	local room = game:GetRoom()
	local type, bossid, backdrop = room:GetType(), room:GetBossID(), room:GetBackdropType()

	if type == RoomType.ROOM_BOSS and game:GetLevel():GetStage() == unlocks_stage[bossid] and unlocks_red[bossid] then
		print("unlocked " .. unlocks_red[bossid])
		saveman.save.unlocks[unlocks_red[bossid]] = true
	elseif type == RoomType.ROOM_BOSSRUSH then
		print("unlocked bossrush")
		saveman.save.unlocks[unlocks_red["bossrush"]] = true
	elseif type == RoomType.ROOM_DUNGEON and backdrop == BackdropType.DUNGEON_BEAST then
		print("unlocked beast")
		--saveman.save.unlocks[unlocks_red["beast"]] = true
	end
end

return unlocks
