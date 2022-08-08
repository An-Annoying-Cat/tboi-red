local dementia = require("red_src.items.passive.dementia")
local red_boss_scaling = require("red_src.player.red_boss_hpscaling")
local red_room_load = require("red_src.player.red_room_load")
local red_moonlight = require("red_src.player.red_moonlight")
local update_doors = require("red_src.player.red_update_doors") --because apparently item rooms are more important than boss rooms
local reds_key = require("red_src.items.active.reds_key")
local red = require("red_src.player.red")
local gray = require("red_src.player.gray")

local function MC_POST_NEW_ROOM()
	dementia:PostNewRoom()
	red_boss_scaling:PostNewRoom()
	red_room_load:PostNewRoom()
	red_moonlight:PostNewRoom()
	update_doors:PostNewRoom()
	reds_key:PostNewRoom()
	red:PostNewRoom()
	gray:PostNewRoom()
end

return MC_POST_NEW_ROOM
