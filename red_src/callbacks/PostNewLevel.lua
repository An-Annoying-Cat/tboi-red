local saveman = require("red_src.core.saveman")
local dementia = require("red_src.items.passive.dementia")
local red_birthright = require("red_src.player.red_birthright")

local function MC_POST_NEW_LEVEL()
--	red_birthright:PostNewLevel()
	dementia:PostNewLevel()
	saveman:PostNewLevel()
end

return MC_POST_NEW_LEVEL
