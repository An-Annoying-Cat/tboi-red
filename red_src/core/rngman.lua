local rngman = {}

local RECOMMENDED_SHIFT_IDX = 35

local saveman = require("red_src.core.saveman")
local global = require("red_src.core.global")

local game, rng = global.game, global.rng
local seeds = game:GetSeeds()

function rngman:PostGameStarted(returning)
	local index = returning and saveman.save.data.index or RECOMMENDED_SHIFT_IDX
	rng:SetSeed(seeds:GetStartSeed(), index)
end

return rngman
