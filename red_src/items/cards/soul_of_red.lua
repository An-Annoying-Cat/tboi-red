local SoulofRed = {}
---------------------------------------------------
local global = require("red_src.core.global")
local enums = require("red_src.core.enums")
---------------------------------------------------
local game = global.game
---------------------------------------------------
function SoulofRed:UseCard(card, player)
	if card ~= enums.cards.soul_of_red then return end

	player:UseCard(Card.CARD_ACE_OF_SPADES, UseFlag.USE_NOANNOUNCER)
	
	local entities = game:GetRoom():GetEntities()
	for i = 1, #entities do
		local entity = entities:Get(i)
		if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_KEY then
			entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 78, -1)	
		end
	end
end
---------------------------------------------------
return SoulofRed
