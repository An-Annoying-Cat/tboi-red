local gray = require("red_src.player.gray")

local function MC_PRE_PLAYER_COLLISION(_, player, collider, bool)
	gray:PrePlayerCollision(player, collider, bool)
end

return MC_PRE_PLAYER_COLLISION
