local red = require("red_src.player.red")

local function MC_POST_TEAR_INIT(_, tear)
	red:PostTearInit(tear)
end

return MC_POST_TEAR_INIT
