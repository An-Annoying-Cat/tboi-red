if not Encyclopedia then return end
local enums = require("red_src.core.enums")
local descs = require("red_src.compat.descriptions")

Encyclopedia.AddItem({
	ID = enums.collectibles.pathos,
	WikiDsec = Encyclopedia.EIDtoWiki(descs[enums.collectibles.pathos])
})
Encyclopedia.AddItem({
	ID = enums.collectibles.trance,
	WikiDsec = Encyclopedia.EIDtoWiki(descs[enums.collectibles.trance])
})
Encyclopedia.AddItem({
	ID = enums.collectibles.dementia,
	WikiDsec = Encyclopedia.EIDtoWiki(descs[enums.collectibles.dementia])
})
Encyclopedia.AddItem({
	ID = enums.collectibles.entropy,
	WikiDsec = Encyclopedia.EIDtoWiki(descs[enums.collectibles.entropy])
})
Encyclopedia.AddItem({
	ID = enums.collectibles.extus,
	WikiDsec = Encyclopedia.EIDtoWiki(descs[enums.collectibles.extus])
})
Encyclopedia.AddItem({
	ID = enums.collectibles.zenith,
	WikiDsec = Encyclopedia.EIDtoWiki(descs[enums.collectibles.zenith])
})
