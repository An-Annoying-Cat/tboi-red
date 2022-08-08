local gray = require("red_src.player.gray")
local dementia = require("red_src.items.passive.dementia")

local function MC_POST_PLAYER_INIT(_, player)
	gray:PostPlayerInit(player)
	dementia:PostPlayerInit(player)
end

return MC_POST_PLAYER_INIT
