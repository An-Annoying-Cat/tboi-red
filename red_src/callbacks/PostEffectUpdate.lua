local red_chest = require("red_src.items.pickups.red_chest")

local function MC_POST_EFFECT_UPDATE(_, effect)
	red_chest:PostEffectUpdate(effect)
end

return MC_POST_EFFECT_UPDATE
