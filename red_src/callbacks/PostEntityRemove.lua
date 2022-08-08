local dementia = require("red_src.items.passive.dementia")

local function MC_POST_ENTITY_REMOVE(_, entity)
	dementia:PostEntityRemove(entity)
end

return MC_POST_ENTITY_REMOVE
