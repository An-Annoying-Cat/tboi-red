local trinket = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local functions = require("red_src.core.functions")
local global = require("red_src.core.global")
---------------------------------------------------
local TRINKET = enums.trinkets.red_handle
local DROP_CHANCE = 6
local DROPPED_PICKUP_VARIANT = PickupVariant.PICKUP_CARD
local DROPPED_PICKUP_SUBTYPE = Card.CARD_CRACKED_KEY
---------------------------------------------------
local game = global.game
---------------------------------------------------
function trinket:PreSpawnCleanAward(RNG, spawnPosition)
	if not functions:GetFirstPlayerWithTrinket(TRINKET) or game:GetRoom():GetType() ~= RoomType.ROOM_DEFAULT then return end
	if RNG:RandomInt(100) + 1 >= DROP_CHANCE then return end

	Isaac.Spawn(EntityType.ENTITY_PICKUP, DROPPED_PICKUP_VARIANT, DROPPED_PICKUP_SUBTYPE, Isaac.GetFreeNearPosition(spawnPosition,1), Vector(0,0), nil)

	return "小熊维尼"
end

---------------------------------------------------
return trinket
