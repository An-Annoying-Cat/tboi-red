local trance = require("red_src.items.passive.trance")
local dementia = require("red_src.items.passive.dementia")
local zenith = require("red_src.items.passive.zenith")
local pathos = require("red_src.items.passive.pathos")
local lil_melissa = require("red_src.items.familiars.lil_melissa")
local lil_warlock = require("red_src.items.familiars.lil_warlock")
local red_moonlight = require("red_src.player.red_moonlight")
local gray = require("red_src.player.gray")
local entropy = require("red_src.items.passive.entropy")

local function MC_EVALUATE_CACHE(_, player, cacheflag)
	trance:EvaluateCache(player, cacheflag)
	dementia:EvaluateCache(player, cacheflag)
	zenith:EvaluateCache(player, cacheflag)
	pathos:EvaluateCache(player, cacheflag)
	lil_melissa:EvaluateCache(player, cacheflag)
	lil_warlock:EvaluateCache(player, cacheflag)
	red_moonlight:EvaluateCache(player, cacheflag)
	gray:EvaluateCache(player, cacheflag)
	entropy:EvaluateCache(player, cacheflag)
end

return MC_EVALUATE_CACHE
