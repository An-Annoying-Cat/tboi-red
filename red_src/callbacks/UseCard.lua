local cheat_card = require("red_src.items.cards.cheat_card")
local soul_of_red = require("red_src.items.cards.soul_of_red")
local monster_card = require("red_src.items.cards.monster_card")

local function MC_USE_CARD(_, card, player, useflags)
	cheat_card:UseCard(card, player, useflags)
	soul_of_red:UseCard(card, player, useflags)
end

return MC_USE_CARD
