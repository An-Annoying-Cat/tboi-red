local red_boss_clear = require("red_src.player.red_boss_clear.lua")
local unlocks = require("red_src.core.unlocks")
local reds_chest = require("red_src.items.pickups.red_chest")

local function MC_POST_PICKUP_INIT(_, pickup)
	red_boss_clear:PostPickupInit(pickup)
	unlocks:PostPickupInit(pickup)
	reds_chest:PostPickupInit(pickup)
end

return MC_POST_PICKUP_INIT
