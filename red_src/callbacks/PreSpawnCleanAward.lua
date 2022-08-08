local unlocks = require("red_src.core.unlocks")
local red_birthright = require("red_src.player.red_birthright")
local red_lock = require("red_src.items.trinkets.red_lock")
local red_handle = require("red_src.items.trinkets.red_handle")

local function MC_PRE_SPAWN_CLEAN_AWARD(_, RNG, spawnpos)
	local returned = unlocks:PreSpawnCleanAward(RNG, spawnpos) 
	if returned then return returned end
	
	local returned = red_birthright:PreSpawnCleanAward(RNG, spawnpos)
	if returned then return returned end

	local returned = red_lock:PreSpawnCleanAward(RNG, spawnpos)
	if returned then return returned end
	
	local returned = red_handle:PreSpawnCleanAward(RNG, spawnpos)
	if returned then return returned end
end

return MC_PRE_SPAWN_CLEAN_AWARD
