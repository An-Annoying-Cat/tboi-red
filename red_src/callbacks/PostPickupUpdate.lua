local unlocks = require("red_src.core.unlocks")
local dementia = require("red_src.items.passive.dementia")
local entropy = require("red_src.items.passive.entropy")

local function MC_POST_PICKUP_UPDATE(_, pickup)
	dementia:PostPickupUpdate(pickup)
	entropy:PostPickupUpdate(pickup)
end

return MC_POST_PICKUP_UPDATE
