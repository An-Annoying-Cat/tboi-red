local pathos = require("red_src.items.passive.pathos")

local function MC_POST_PROJECTILE_INIT(_, projectile)
	pathos:PostProjectileInit(projectile)
end

return MC_POST_PROJECTILE_INIT
