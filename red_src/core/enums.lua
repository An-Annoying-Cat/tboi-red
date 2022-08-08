local enums = {}

enums.players = {
	red = Isaac.GetPlayerTypeByName("Red"),
	gray = Isaac.GetPlayerTypeByName("Red", true),
}

enums.collectibles = {
	reds_key = Isaac.GetItemIdByName("Red's Key"),
	pathos 	= Isaac.GetItemIdByName("Pathos"), --είμαι έλληνας και αγαπάω τους ξένους!!!!!!!!!!!
	dementia = Isaac.GetItemIdByName("Dementia"),
	trance	= Isaac.GetItemIdByName("Trance"),
	entropy	= Isaac.GetItemIdByName("Entropy"),
	extus = Isaac.GetItemIdByName("Extus"),
	zenith = Isaac.GetItemIdByName("Zenith"),
	lil_warlock = Isaac.GetItemIdByName("Lil Warlock"),
	lil_melissa = Isaac.GetItemIdByName("Lil Melissa"),
}

enums.trinkets = {
	red_lock = Isaac.GetTrinketIdByName("Red Lock"),
	red_handle = Isaac.GetTrinketIdByName("Red Handle"),
}

enums.familiars = {
	lil_melissa = Isaac.GetEntityVariantByName("Lil' Melissa"),
	lil_warlock = Isaac.GetEntityVariantByName("Lil' Warlock"),
}

enums.costumes = {
	red_head = Isaac.GetCostumeIdByPath("gfx/characters/costume.red_head.anm2"),
	red_body = Isaac.GetCostumeIdByPath("gfx/characters/costume.red_body.anm2"),
}

enums.cards = {
	cheat_card = Isaac.GetCardIdByName("Cheat Card"),
	soul_of_red = Isaac.GetCardIdByName("Soul of Red"),
}

enums.pickups = {
	red_chest = Isaac.GetEntityVariantByName("Red's Chest"),
	red_chest_opened = Isaac.GetEntityVariantByName("Red's Chest (Opened)"),
}

return enums
