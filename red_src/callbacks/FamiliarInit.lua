local lil_melissa = require("red_src.items.familiars.lil_melissa")
local lil_warlock = require("red_src.items.familiars.lil_warlock")

local function MC_FAMILIAR_INIT(_, familiar)
	lil_melissa:FamiliarInit(familiar)
	lil_warlock:FamiliarInit(familiar)
end

return MC_FAMILIAR_INIT
