local red_room_load = require("red_src.player.red_room_load")
local saveman = require("red_src.core.saveman")
local rngman = require("red_src.core.rngman")
local gray = require("red_src.player.gray")

local function MC_POST_GAME_STARTED(_, returning)
	saveman:PostGameStarted(returning)
	red_room_load:PostGameStarted(returning)
	rngman:PostGameStarted(returning)
	gray:PostGameStarted(returning)
end

return MC_POST_GAME_STARTED
