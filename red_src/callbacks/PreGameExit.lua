local saveman = require("red_src.core.saveman")

local function MC_PRE_GAME_EXIT(_, shouldsave)
	saveman:PreGameExit(shouldsave)
end

return MC_PRE_GAME_EXIT
