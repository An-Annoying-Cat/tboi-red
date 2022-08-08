local trance = require("red_src.items.passive.trance")

local function MC_POST_TEAR_UPDATE(_, tear)
	trance:PostTearUpdate(tear)
end

return MC_POST_TEAR_UPDATE
