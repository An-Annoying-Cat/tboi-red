local red_chest = require("red_src.items.pickups.red_chest")

local function MC_PRE_PICKUP_COLLISION(_, pickup, collider, bool)
	red_chest:PrePickupCollision(pickup, collider, bool)
end

return MC_PRE_PICKUP_COLLISION
