local newrng = {}

local game, rng = Game(), RNG()

local saveman = require("red_src.core.saveman")
local seeds = game:GetSeeds()
------------
function newrng:RandomInt(Max)	
	local new_num = rng:RandomInt(Max)
	
	local savedata = saveman.save.data
	savedata.index = savedata.index + 1

	return new_num
end

function newrng:SetSeed(seed, index)
	rng:SetSeed(seed, index)	
	saveman.save.data.index = index
end

return newrng
