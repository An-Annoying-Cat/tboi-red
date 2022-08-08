local zenith = require("red_src.items.passive.zenith")
local pathos = require("red_src.items.passive.pathos")

local function MC_POST_FIRE_TEAR(_, tear)
	zenith:PostFireTear(tear)
	pathos:PostFireTear(tear)
end

return MC_POST_FIRE_TEAR
