local red = require("red_src.player.red")
local trance = require("red_src.items.passive.trance")

local function MC_POST_PEFFECT_UPDATE(_, player)
	red:PostPeffectUpdate(player)
	trance:PostPeffectUpdate(player)
end

return MC_POST_PEFFECT_UPDATE
