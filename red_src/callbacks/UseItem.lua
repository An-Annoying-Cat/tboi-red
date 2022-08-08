local reds_key = require("red_src.items.active.reds_key")
local red_room_load = require("red_src.player.red_room_load")

local function MC_USE_ITEM(_, collectible, rng, player)
	local returned = reds_key:UseItem(collectible, rng, player)
	if returned then return returned end

	local returned = red_room_load:UseItem(collectible, rng, player)
	if returned then return returned end
end

return MC_USE_ITEM
