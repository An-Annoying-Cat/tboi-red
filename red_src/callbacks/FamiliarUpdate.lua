local lil_melissa = require("red_src.items.familiars.lil_melissa")
local lil_warlock = require("red_src.items.familiars.lil_warlock")

local function MC_FAMILIAR_UPDATE(_, familiar)
	lil_melissa:FamiliarUpdate(familiar)
	lil_warlock:FamiliarUpdate(familiar)
end

return MC_FAMILIAR_UPDATE
