local item = {} 
---------------------------------------------------
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")
local global = require("red_src.core.global")
local enums = require("red_src.core.enums")
---------------------------------------------------
local level, rng = global.game:GetLevel(), global.rng
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.dementia
local VARIANT_STATS = {
	[PickupVariant.PICKUP_COIN] = {"Luck"},
	[PickupVariant.PICKUP_KEY] = {"MoveSpeed", "TearRange", "ShotSpeed"},
	[PickupVariant.PICKUP_BOMB] = {"Damage"},
	[PickupVariant.PICKUP_TRINKET] = {"Devil"},
	[PickupVariant.PICKUP_COLLECTIBLE] = {"MaxFireDelay", "Damage"},
}

--[[
local HEART_INTENSITY = {
	[1] = .05,
	[2] = .025,
	[3] = .1,
	[4] = .2,
	[5] = .1,
	[6] = .1,
	[7] = .15,
	[8] = .05,
	[9] = .1,
	[10] = .1,
	[11] = .2,
	[12] = .05,
}]]

local COIN_INTENSITY = {
	[1] = .05, --Penny
	[2] = .15, --Nicklel
	[3] = .2, --Dime
	[4] = .1, --Double
	[5] = 1.1, --Lucky
	[6] = .1, --Sticky Nickel
	[7] = 1.5, --Golden
}

local KEY_INTENSITY = {
	[1] = .05, --Single
	[2] = .2, --Golden
	[3] = .1, --Double
	[4] = .15, --Charged
}

local BOMB_INTENSITY = {
	[1] = .05, --Single
	[2] = .1, --Double
	[3] = nil, --Troll
	[4] = .2, --Golden
	[5] = nil, --Megatroll
	[6] = nil, --Golden troll
	[7] = .5, -- Giga
}

local VARIANT_POWER = {
	[PickupVariant.PICKUP_COIN] = COIN_INTENSITY,
	[PickupVariant.PICKUP_KEY] = KEY_INTENSITY,
	[PickupVariant.PICKUP_BOMB] = BOMB_INTENSITY,
	[PickupVariant.PICKUP_TRINKET] = 5,
	[PickupVariant.PICKUP_COLLECTIBLE] = 1,
}
local TEAR_MODIFIER = -.5
---------------------------------------------------
local STAT_TO_CACHE = {
	[CacheFlag.CACHE_SPEED] = "MoveSpeed",
	[CacheFlag.CACHE_RANGE] = "TearRange",
	[CacheFlag.CACHE_SHOTSPEED] = "ShotSpeed",
	[CacheFlag.CACHE_FIREDELAY] = "MaxFireDelay",
	[CacheFlag.CACHE_DAMAGE] = "Damage",
	[CacheFlag.CACHE_LUCK] = "Luck",
}
local TABLE_PRESET = {
	rooms = {},

	stats = {
		["MoveSpeed"] = 0,
		["TearRange"] = 0,
		["ShotSpeed"] = 0,
		["MaxFireDelay"] = 0,
		["Damage"] = 0,
		["Luck"] = 0
	},

	pickups = {},
}
--------------------------------------------------
local playerInitialized, previousRoom, currentRoom
---------------------------------------------------
---HANDLE PLAYER ENTER
function item:PostPlayerInit()
	playerInitialized = true
end
---COUNT PICKUPS (that are actually used)
local function CountPickups()
	local pickups = {}

	local entities = Isaac.FindByType(EntityType.ENTITY_PICKUP)
	for _, v in pairs(entities) do
		table.insert(pickups, (VARIANT_STATS[v.Variant] and not v:ToPickup():IsShopItem() and v:ToPickup()) or nil)
	end

	return pickups
end
---HANDLE ROOM ENTER
local function CalculateStatUps(rng, pickups)
	local save = saveman.save.data.dementia

	for _, v in pairs(pickups or {}) do
		local variantPower = VARIANT_POWER[v[1]]
		local addIntensity = type(variantPower) == "number" and variantPower or type(variantPower) == "table" and variantPower[v[2]]

		if addIntensity then
			local selectedStat = VARIANT_STATS[v[1]][rng:RandomInt(#VARIANT_STATS[v[1]]) + 1]
			if selectedStat == "Devil" then
			
			else
				save.stats[selectedStat] = save.stats[selectedStat] + addIntensity
			end
		end
	end
end
--
function item:PostNewRoom()
	previousRoom = currentRoom
	currentRoom = level:GetCurrentRoomIndex()

	saveman.save.data.dementia = saveman.save.data.dementia or TABLE_PRESET

	local player = functions:GetFirstPlayerWithCollectible(COLLECTIBLE)
	if not player or playerInitialized then 
		playerInitialized = false 
		saveman.save.data.dementia.pickups[previousRoom or 0] = nil 
		return 
	end
	
	local save = saveman.save.data.dementia
	local rng = player:GetCollectibleRNG(COLLECTIBLE)

	local roomIdx = level:GetCurrentRoomIndex()
	if save.rooms[roomIdx] and save.rooms[roomIdx].Exited then save.rooms[roomIdx].Exited = nil end
	
	CalculateStatUps(rng, save.pickups[previousRoom])
	save.pickups[previousRoom or 0] = {}

	for _, v in pairs(functions:GetPlayers()) do
		if v:HasCollectible(COLLECTIBLE) then 
			v:AddCacheFlags(CacheFlag.CACHE_ALL) 
			v:EvaluateItems()
		end
	end

	save.pickups = {}

	if not save.rooms[tostring(roomIdx)] then save.rooms[tostring(roomIdx)] = true return end

	for _, v in pairs(CountPickups()) do
		v:Remove()
	end
end
---HANDLE PICKUP INIT
function item:PostPickupUpdate(pickup)
	if not VARIANT_STATS[pickup.Variant] or pickup:IsShopItem() then return end

	saveman.save.data.dementia = saveman.save.data.dementia or TABLE_PRESET
	
	local save = saveman.save.data.dementia

	local currentRoom = level:GetCurrentRoomIndex()
	save.pickups[currentRoom] = save.pickups[currentRoom] or {}

	local hash = tostring(GetPtrHash(pickup))

	local isEmpty = pickup:GetSprite():GetAnimation() == "Empty"
	if save.pickups[currentRoom][hash] and not isEmpty then return end

	save.pickups[currentRoom][hash] = not isEmpty and {pickup.Variant, pickup.SubType} or nil
end
---HANDLE PICKUP DEATH
function item:PostEntityRemove(entity)
	saveman.save.data.dementia = saveman.save.data.dementia or TABLE_PRESET
	
	local save = saveman.save.data.dementia

	local currentRoom = level:GetCurrentRoomIndex()
	if not save.pickups[currentRoom] or not entity:ToPickup() then return end

	save.pickups[currentRoom][tostring(GetPtrHash(entity))] = {"AMONG", "US"}
end
---HANDLE STAT UPS
function item:EvaluateCache(player, cache)
	local stat = STAT_TO_CACHE[cache]

	saveman.save.data.dementia = saveman.save.data.dementia or TABLE_PRESET
	
	if not stat or not player:HasCollectible(COLLECTIBLE) then return end
	statBoost = saveman.save.data.dementia.stats[stat]
	statBoost = stat ~= "MaxFireDelay" and statBoost or statBoost * TEAR_MODIFIER 

	player[stat] = player[stat] + statBoost	
end
---HANDLE NEW LEVEL
function item:PostNewLevel()
	if not saveman.save.dementia then return end
	saveman.save.data.dementia.rooms = {}
end
---------------------------------------------------
return item
